From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Fri, 07 Oct 2005 17:36:12 -0400
Message-ID: <4346EA4C.3020602@adaptec.com>
References: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com> <1128647235.4623.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25805 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932676AbVJGVgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 17:36:22 -0400
In-Reply-To: <1128647235.4623.28.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On 10/06/05 21:07, James Bottomley wrote:
> 1. The domain device as you have implemented it requires a lot of

The domain device as I've implemented it, is exactly a SAS domain
device, supporting expanders, SAS, SATA, SATA PM, etc. devices.  It
doesn't add any cruft, it is the minimum of what it should be.

struct domain_device {
	struct kobject    dev_obj;
	enum sas_dev_type dev_type;

	enum sas_phy_linkrate linkrate;
	enum sas_phy_linkrate min_linkrate;
	enum sas_phy_linkrate max_linkrate;

	int  pathways;

	struct domain_device *parent;
	struct list_head siblings; /* devices on the same level */
	struct sas_port *port;	  /* shortcut to root of the tree */

	struct list_head dev_list_node;

	enum sas_proto    iproto;
	enum sas_proto    tproto;

	u8  sas_addr[SAS_ADDR_SIZE];
	u8  hashed_sas_addr[HASHED_SAS_ADDR_SIZE];

	u8  frame_rcvd[32];

	union {
		struct expander_device ex_dev;
		struct end_device      end_dev;
		struct sata_device     sata_dev; /* STP & directly attached */
	};

	void *lldd_dev;
};

> infrastructure support.  I'd like to see this refined in the transport

I'm not sure that you can "refine" (take stuff out) from
struct domain_device.

You're better off creating struct scsi_domain_device { ... }; and starting
from there.

In effect struct scsi_domain_device { ... }; (non existant yet)
would be a superclass (in OO sense) of the SAS struct domain_device, shown
above.

In contrast to "templates", the OO sense can be kept _by design_,
by _SCSI_ design, not by code enforcement (i.e. struct template_abcd...).

> 2. sas_do_lu_discovery() duplicates a lot of existing functionality, but
> also lacks a lot of quirk processing.  I know the argument is that SAS

It doesn't duplicate a lot of functionality.  While the code
in SCSI Core does do LU discovery, the infrastructure is very broken
in that
  1) there is no native "target" (i.e. SCSI Device with Target port)
     support (struct domain_device), and
  2) that code uses HCIL, by scsi_scan_target definition and from
     seeing things like:

	if (shost->this_id == id)
		/*
		 * Don't scan the host adapter
		 */
		return;

As to SAS, the comment is about the size of the function:

/**
 * sas_do_lu_discovery -- Discover LUs of a SCSI device
 * @dev: pointer to a domain device of interest
 *
 * Discover logical units present in the SCSI device.  I'd like this
 * to be moved to SCSI Core, but SCSI Core has no concept of a "SCSI
 * device with a SCSI Target port".  A SCSI device with a SCSI Target
 * port is a device which the _transport_ found, but other than that,
 * the transport has little or _no_ knowledge about the device.
 * Ideally, a LLDD would register a "SCSI device with a SCSI Target
 * port" with SCSI Core and then SCSI Core would do LU discovery of
 * that device.
 *
 * REPORT LUNS is mandatory.  If a device doesn't support it,
 * it is broken and you should return it.  Nevertheless, we
 * assume (optimistically) that the link hasn't been severed and
 * that maybe we can get to the device anyhow.
 */
static int sas_do_lu_discovery(struct domain_device *dev)
{
	int  res;
	u8  *buffer;
	int  size;

	res = sas_get_report_luns(dev, &buffer, &size);
	if (res) {
		SAS_DPRINTK("dev %llx didn't reply to REPORT LUNS, trying "
			    "LUN 0 anyway\n",
			    SAS_ADDR(dev->sas_addr));
		size = 16;
		buffer = kzalloc(size, GFP_KERNEL);
	}

	res = sas_register_lu(dev, buffer, size);
	if (res) {
		SAS_DPRINTK("dev %llx didn't report any LUs\n",
			    SAS_ADDR(dev->sas_addr));
		res = 0;
	}

	kfree(buffer);
	return res;
}

> won't have any quirks, but I'd like to have this proven in the field
> before I take it as read.

Indeed, it doesn't have quirks (because there are none yet out there).

Let's include it _without_ quirks, and add them as new devices come
to the market, instead of crudding the code unnecessarily.  This gives
more freedom of future "patching" and future "design".

The reason is that if all you have is the SAS/SATA chip, then you do not
need all the legacy quirks, code bloat, bigger binary.

> I'm sure you're aware that not responding on either LUN 0 or the report
> luns WLUN is a violation of SAM  ... however, if we really already have

I am. I've repeated this about 100 million times on this list,
and it is in the SAS code comments at sas_do_lu_discovery().

> broken SAS devices with this problem, then you're welcome to expand
> scsi_scan_target() to cope.

I don't have a problem working on scsi_scan_target().
But I have a problem with it using _HCIL_.

What do you suggest?

> WLUN support is really the only piece that scsi_scan_target() doesn't
> currently possess and, as has been discussed before, that only really

-------------------------------------------------------------------------
> matters if we get a target that's not going to respond to an INQUIRY on
> LUN0 (I expect most of them, even if they have no LUN0 will respond with
> PQ 3 to the inquiry and thus be caught by scsi_scan_target() anyway).
-------------------------------------------------------------------------

I think you clarify your point below but as far as SAM-4 and
thus SAS devices are concerned:

REPORT LUNS is sent first, to figure out what LUs are contained
in the SCSI device, and then for each LU, send an INQUIRY to the LU.
>From the code:

static int sas_register_lu(struct domain_device *dev, u8 *buf, int size)
{
	int res;

	for (buf = buf+8, size -= 8; size > 0; size -= 8, buf += 8) {
		struct LU *lu = sas_alloc_lu();

		SAS_DPRINTK("%016llx probing LUN:%016llx\n",
			    SAS_ADDR(dev->sas_addr),
			    be64_to_cpu(*(__be64 *)buf));
		if (lu) {
			lu->parent = dev;
			memcpy(lu->LUN, buf, 8);
			res = sas_get_inquiry(lu);
			if (res) {
				SAS_DPRINTK("dev %llx LUN %016llx didn't reply"
					    " to INQUIRY, forgotten\n",
					    SAS_ADDR(dev->sas_addr),
					    SAS_ADDR(lu->LUN));
				kfree(lu);
				continue;
			}
			lu->lu_obj.kset = &dev->end_dev.LU_kset;
			kobject_set_name(&lu->lu_obj, "%016llx",
					 SAS_ADDR(lu->LUN));
			lu->lu_obj.ktype = dev->end_dev.LU_kset.ktype;
			list_add_tail(&lu->list, &dev->end_dev.LU_list);
		}
	}

	return list_empty(&dev->end_dev.LU_list) ? -ENODEV : 0;
}

> However, to add WLUN support to scsi_scan_target() looks pretty simple:
> If the transport supports > 256 LUNs and the initial INQUIRY comes back
> SCSI_SCAN_NO_RESPONSE then fire off a WLUN report lun scan anyway.  By
> all means, submit a patch to do this.

I did take a look and can see "transport" calls right in SCSI Core.
Firthermore the "transport" calls are HCIL, for example:
	shost->transportt->target_parent(shost, channel, id);

"If the transport supports > 256 LUNs" -- as James S hints,
it maybe the case that the transport does, but the device doesn't
or vice versa.  Add to this the shaky REPORT LUN support for legacy
devices.

Also the order of operations... "initial INQUIRY comes back
SCSI_SCAN_NO_RESPONSE then fire off a WLUN report lun scan anyway".

When in fact REPORT LUNS should be the first thing sent, then if that
fails we assume that LUN 0 is present anyway as you can see I've done
in sas_do_lu_discovery() above.

So it gets really messy if you can see what I mean.

>>P.S. REPORT LUNS is Mandatory as per SPC, so newer devices
>>(SAS) support it.  Furthermore if their LUs are sparse they
>>(really) support REPORT LUNS.
> 
> 
> Actually, it's optional per SPC; it's mandatory in SPC-2 but *only* if
> your device is multi-LUN; and it finally became mandatory for everything
> in SPC-3 (or I should say "becomes" since SPC-3 isn't ratified yet).

"Actually" when I say SPC, I mean SPC-latest.  When I say SAM, I mean
SAM-latest, when I say SCSI, I mean SCSI-3 which T10 says means SCSI.

I don't see your point in "correcting" me, while SCSI Core uses
HCIL extensively.

	Luben
http://linux.adaptec.com/sas/
Disclaimer: Opinions stated in this email are my own, not of my employer.

