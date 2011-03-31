From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Wed, 30 Mar 2011 17:20:24 -0700
Message-ID: <AANLkTikg4MdRriURN22ztCS7vEpXnQT79pybnCDnyQKo@mail.gmail.com>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
	<20110327223256.GB7487@infradead.org>
	<1301448150.31206.15.camel@dwillia2-linux>
	<20110330072348.GA17919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45144 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1CaAU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2011 20:20:26 -0400
Received: by fxm17 with SMTP id 17so1462172fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2011 17:20:25 -0700 (PDT)
In-Reply-To: <20110330072348.GA17919@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>

On Wed, Mar 30, 2011 at 12:23 AM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Tue, Mar 29, 2011 at 06:22:30PM -0700, Dan Williams wrote:
>> The expectation is that the lldd need not understand core internals
>> outside of a set of interface functions.
>
> I think you need to get rid of that stupid core/wrapper split ASAP,
> as it's the root of a lot of the crap in this driver. =A0Removing all
> the stupid indirections and duplicate structures it causes will
> make the driver a lot smaller, and actually look like a normal Linux
> driver and thus actually maintainable.

I think we were already on this path, but now just need to formally
acknowledge and accelerate in this direction.  Let me outline where I
think we are and a rough outline of how to get to the removal of the
wrapper.

1/ Complete the removal of all OS agnostic indirections in the core.
We have done quite a bit here to call kernel and lldd facilities
directly, but still need to get rid of intel_{sas|sata|scsi}.h and
duplicated utilities before this step is complete.

2/ Make the core data structures member position independent (so we
can start adding / removing fields at will).  That means getting rid
of unnecessary casting (already started), the base_ structures (you
started this) and the _{get|set}_association macros.

3/ Unify the data structures so they have the same lifetimes.  Where
the lldd has a member that duplicates a core member teach it to use
the core version.  Quick example isci_phy.aif and
scic_sds_phy.sas.identify_address_frame_buffer.

4/ Remove the lldd/core data structure distinction.

Probably missing some sub-steps between three and four, but that is
the general idea.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
