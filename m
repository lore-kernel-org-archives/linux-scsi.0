From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 18:38:35 -0400
Message-ID: <435D626B.30909@adaptec.com>
References: <20051023013618.GA18201@havoc.gtf.org>	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com>	 <1130172627.3325.57.camel@mulgrave>  <435D176E.5000201@adaptec.com>	 <1130185688.3325.88.camel@mulgrave>  <435D46DD.9030009@adaptec.com> <1130188353.3325.123.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:20181 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751232AbVJXWim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:38:42 -0400
In-Reply-To: <1130188353.3325.123.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On 10/24/05 17:12, James Bottomley wrote:
> 
> I consider scsi_transport_spi.c to be a file name.  Try lines 38-1219.

This started when I said that LU scanning and bookeeping is done
easily when you have struct scsi_domain_deivice representing
a domain device which the transport discovered but other than
that knows nothing about it.  And then I pointed to my code
where and how it is done: drivers/scsi/sas/sas_discover.c.

But you decided to spin-doctor it and quote over 1200 lines
in source code.

You have to be more specific. For example:
drivers/scsi/sas/sas_discover.c, line 1083:

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


>>Again, domain devices should stay only in the transport layer.  There
>>is no _need_ to represent them with "generic device" as they have
>>no _meaning_ outisde the transport (layer).
> 
> 
> Um, that's not what you said here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112887522221936&w=2
> 
> You said:
> 
> 
>>struct scsi_domain_device { ... }; (to be created) is your friend.
>>
>>The only way that that design
>>	"should be capable of representing any 
>>	 SCSI domain (FC/SPI/SBP etc ..)"
>>
>>Is if it _does not_ have any knowlege about the underlying
>>physical domain -- just as it is shown in SAM (and that is the whole point).
>>Else you get in this neverending cat-and-mouse game.  If you have the
>>abstraction right, then whatever new transport comes along, it would
>>be properly represented.

I don't see any contradiction.  Did you mean to imply that I'm
contradicting myself?  Did you mean to imply that I'm all of a sudden
changing what I think? (and thus, subsequently code I've written?)

I'd like to point you to the source code at the 1st link
of my sig.  It speaks of itself.

> So that's precisely a generic domain device.

This is *your conclusion*.

What I said is that if you want to get rid of HCIL and if you want
to embrace the future _quickly_ (which sadly seems to have passed
by Linux SCSI), you need to actually _represent_ the objects which
you want to ... well control and represent.

The proper layering is that the transport sitting _below_
SCSI Core (not as an "appendage" on the side as in your "transport attributes")
finds transport devices and how it represents them is its own business.
E.g. in the SAS Transport Layer/Stack it is "struct domain_devices",
USB does it differently and SBP does it differently.

It is best if SCSI Core, has a "struct scsi_domain_device" in order
to do LU scanning properly and when it does so, this is what
is passes to Execute Command SCSI RPC, so that the transport layer/LLDD
knows how to map this: WWN, HCIL, etc, to whatever is the underlying
device and transport.

> But my point is that what's in include/device.h which the kernel calls a
> generic device is simply an abstraction that has certain useful
> properties; properties which we make use of.  Identical to the way a
> kobject has a more limited set of useful properties.

You do not need to export that as "generic device".  I know that
you would like to have your hands in everything, but it is best
to keep layers separated (for many reasons).

As to kobject: as I've explained many times: the discover
process discovers the domain and represents it internally as it
was discovered it in the physical world.  A _natural_ extension
was to tack a struct kobject to each internal struct/object
and show the result in sysfs.  This is exactly what you see
here: http://marc.theaimsgroup.com/?l=linux-scsi&m=112629509826900&w=2

>>>>>scsi_target contains a variable space for
>>>>>the transport classes to use for their transport specific pieces (which
>>>>>is where you could have put all the sas specific bits).
>>>>
>>>>Absolutely NOT.  Those "transport specific pieces" should be completely
>>>>OPAQUE to SCSI Core -- as you saw in my previous email, the
>>>>"transport specific pieces" as you called them were 
>>>>"void *domain_device;  /* opaque to SCSI Core */".
>>>
>>>
>>>They *are* opaque to the scsi mid-layer.  Refer to the code in the
>>>vanilla kernel.
>>
>>The vanilla kernel has nothing, not even remotely similar to what
>>I have in the SAS Stack.  Other than the USB and SBP code.
> 
> 
> You've changed the grounds.  Your original claim was that the added
> properties weren't opaque, which they are.

You seem to be very successfull at twisting my words around, or
telling other people that I've "changed grounds".

I've _always_ contended that things should be kept separated
and that LLDD/Transport Layer representations should be opaque
to the layer above.  I even wrote code to show this.

See the whole infrastructure and code in the 1st link in my sig
for proof of this.

Let's for example take file include/scsi/sas/sas_class.h:

1. Look at the phy representation, and the void *lldd_phy at
the bottom -- opaque!

struct sas_phy {
/* private: */
	struct kobject phy_kobj;

	/* protected by ha->event_lock */
	struct list_head   port_event_list;
	struct list_head   phy_event_list;
	struct sas_event   port_events[PORT_NUM_EVENTS];
	struct sas_event   phy_events[PHY_NUM_EVENTS];

	int error;

/* public: */
	/* The following are class:RO, driver:R/W */
	int            enabled;	  /* must be set */

	int            id;	  /* must be set */
	enum sas_class class;
	enum sas_proto iproto;
	enum sas_proto tproto;

	enum sas_phy_type  type;
	enum sas_phy_role  role;
	enum sas_oob_mode  oob_mode;
	enum sas_phy_linkrate linkrate;

	u8   *sas_addr;		  /* must be set */
	u8   attached_sas_addr[SAS_ADDR_SIZE]; /* class:RO, driver: R/W */

	spinlock_t     frame_rcvd_lock;
	u8             *frame_rcvd; /* must be set */
	int            frame_rcvd_size;

	spinlock_t     sas_prim_lock;
	u32            sas_prim;

	struct list_head port_phy_el; /* driver:RO */
	struct sas_port      *port; /* Class:RW, driver: RO */

	struct sas_ha_struct *ha; /* may be set; the class sets it anyway */

	void *lldd_phy;		  /* not touched by the sas_class_code */
};

2. Now look at the port representation and the void *lldd_port
at the bottom -- opaque:

struct sas_port {
/* private: */
	struct kobject port_kobj;
	struct kset    phy_kset;
	struct kset    dev_kset;

	struct completion port_gone_completion;

	struct sas_discovery disc;
	struct domain_device *port_dev;
	struct list_head dev_list;
	enum   sas_phy_linkrate linkrate;

	struct scsi_id_map id_map;

/* public: */
	int id;

	enum sas_class   class;
	u8               sas_addr[SAS_ADDR_SIZE];
	u8               attached_sas_addr[SAS_ADDR_SIZE];
	enum sas_proto   iproto;
	enum sas_proto   tproto;

	enum sas_oob_mode oob_mode;

	spinlock_t       phy_list_lock;
	struct list_head phy_list;
	int              num_phys;
	u32              phy_mask;

	struct sas_ha_struct *ha;

	void *lldd_port;	  /* not touched by the sas class code */
};

3. Now look at the HA representation and the void *lldd_ha at the
bottom -- opaque:

struct sas_ha_struct {
/* private: */
	struct kset      ha_kset; /* "this" */
	struct kset      phy_kset;
	struct kset      port_kset;

	struct semaphore event_sema;
	int              event_thread_kill;

	spinlock_t       event_lock;
	struct list_head ha_event_list;
	struct sas_event ha_events[HA_NUM_EVENTS];
	u32              porte_mask; /* mask of phys for port events */
	u32              phye_mask; /* mask of phys for phy events */

	struct scsi_core core;

/* public: */
	char *sas_ha_name;
	struct pci_dev *pcidev;	  /* should be set */
	struct module *lldd_module; /* should be set */
	struct sas_ha_hw_profile hw_profile;

	u8 *sas_addr;		  /* must be set */
	u8 hashed_sas_addr[HASHED_SAS_ADDR_SIZE];

	spinlock_t      phy_port_lock;
	struct sas_phy  **sas_phy; /* array of valid pointers, must be set */
	struct sas_port **sas_port; /* array of valid pointers, must be set */
	int             num_phys; /* must be set, gt 0, static */

	/* LLDD calls these to notify the class of an event. */
	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
	void (*notify_port_event)(struct sas_phy *, enum port_event);
	void (*notify_phy_event)(struct sas_phy *, enum phy_event);

	/* The class calls these to notify the LLDD of an event. */
	void (*lldd_port_formed)(struct sas_phy *);
	void (*lldd_port_deformed)(struct sas_phy *);

	/* The class calls these when a device is found or gone. */
	int  (*lldd_dev_found)(struct domain_device *);
	void (*lldd_dev_gone)(struct domain_device *);

	/* The class calls this to send a task for execution. */
	int lldd_max_execute_num;
	int lldd_queue_size;
	int (*lldd_execute_task)(struct sas_task *, int num,
				 unsigned long gfp_flags);

	/* Task Management Functions. Must be called from process context. */
	int (*lldd_abort_task)(struct sas_task *);
	int (*lldd_abort_task_set)(struct domain_device *, u8 *lun);
	int (*lldd_clear_aca)(struct domain_device *, u8 *lun);
	int (*lldd_clear_task_set)(struct domain_device *, u8 *lun);
	int (*lldd_I_T_nexus_reset)(struct domain_device *);
	int (*lldd_lu_reset)(struct domain_device *, u8 *lun);
	int (*lldd_query_task)(struct sas_task *);

	/* Port and Adapter management */
	int (*lldd_clear_nexus_port)(struct sas_port *);
	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);

	/* Phy management */
	int (*lldd_control_phy)(struct sas_phy *, enum phy_func);

	void *lldd_ha;		  /* not touched by sas class code */
};

Let's look at include/scsi/sas/sas_discover.h file:

4. Now let's take a look at struct domain_device, bottom of structure,
see void *lldd_dev?  Opaque:

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

Now let's look at the UPPER Layer opaque representations.

5. Here is the LU struct, see the void *uldd_dev at the bottom?
Opaque!

struct LU {
	struct kobject   lu_obj;
	struct list_head list;

	struct domain_device *parent;

	u8     LUN[8];
	int    inquiry_valid_data_len;
	u8     inquiry_data[SAS_INQUIRY_DATA_LEN];
	struct scsi_core_mapping map;

	enum task_management_type tm_type;

	void  *uldd_dev;
};

Now let's take an example of both UPPER and LOWER opaque
representations:

6. File include/scsi/sas/sas_task.h, struct sas_task,
at the bottom: both uldd_task and lldd_task are OPAQUE!

struct sas_task {
	struct domain_device *dev;
	struct list_head      list;

	spinlock_t   task_state_lock;
	unsigned     task_state_flags;

	enum   sas_proto      task_proto;

	/* Used by the discovery code. */
	struct timer_list     timer;
	struct completion     completion;

	union {
		struct sas_ata_task ata_task;
		struct sas_smp_task smp_task;
		struct sas_ssp_task ssp_task;
	};

	struct scatterlist *scatter;
	int    num_scatter;
	u32    total_xfer_len;
	u8     data_dir:2;	  /* Use PCI_DMA_... */

	struct task_status_struct task_status;
	void   (*task_done)(struct sas_task *task);

	void   *lldd_task;	  /* for use by LLDDs */
	void   *uldd_task;
};

>>>>>The only real difference is that under the current infrastructure scsi
>>>>>targets aren't designed to stack.  Realistically, the way you have it
>>>>>implemented, you have several different devices lumped into your domain
>>>>>device (end, edge, fanout, sata) with different initialisations and
>>>>
>>>>1. How this is implemented is Layer dependent (USB/SBP/FC/SAS/iSCSI/etc).
>>>>2. A struct domain_device can be _only_ one of end/edge/fanout/sata/etc,
>>>>  and only one of those.
>>>>Only devices which _make_sense_ to SCSI Core are registered with SCSI Core,
>>>>i.e. end devices.  Other type of devices (e.g. expanders) that are
>>>>NOT SCSI devices are not registered with SCSI Core, neither should they
>>>>be visible anywhere outside of the respective Layer (SAS in this case).
>>>
>>>
>>>That *is* how the transport classes work.  The obvious example being a
>>
>>It *is not*.  What your "transport attribute classes" are is a work around
>>SDI.  The template they stem off of, transport_class, is just exporting
>>_attributes_.
> 
> 
> No, that's what you keep trying to claim they are.  In fact they're
> attributes coupled with library functions.  A good example being

Which is nothing but *SDI*.

> spi_dv_device(struct scsi_device *sdev) which performs Domain Validation
> (an SPI specific function) on a given SCSI device.  That is contained
> within the SPI transport class and definitely isn't an attribute, it's a
> service used by SPI specific drivers.

1. It is an "appendage".
2. Your "transport attributes" were never _designed_ as a management
   infrastructe because of, amongst other things, see 1.
How many "iterations" did it take to get there?

I tell you again: SCSI Core needs to get slimmer, more straightforward
without those appendages and "transport everything" being everywhere
like octopus' hands...

Layering, in Linux SCSI would do miracles.

BTW, just take a look at USB Storage and SBP code.  The infra is exactly
the same as the SAS Transport Stack.

>>For example take a look at the event management in the SAS Stack.  Take
>>a look at all other things it implements.  Such concepts belong to
>>a separate layer, which doesn't yield to generalization as you've tried
>>to do.
> 
> 
> In the transport classes, layer specific code is confined, that's what
> the spi_ functions do in the spi transport class.  There's no equivalent
> in the generic code, it's just a template builder for the transport
> specific code.

It is one "appendage" next to another "appendage".  What you need
is a _clean_ design and infrastructure, e.g. USB Storage, SBP,
SAS Transport Stack/Layer.

What you fail to admit is that it was not designed as such in the first
place.

> Ah, so you accept that the FC transport class does do this but you just

Ah, so that's what you do: wait for me to say something to hook on and
then spin-doctor words around?

No, I don't accept that.  You basically fail to understand how
the SCSI stack works in SAM, and insist on _your_ solution as per
SCSI Core, just because you have the power to block things from
going in through SCSI Core.

Sad, very sad.  You have to keep a more open mind: USB Storage,
SBP, SAS, ...

> don't want it to be admitted as a valid example because the class grew
> organically?  As Jeff has tried to explain, that's how linux development
> goes.

So what you're suggesting is that no other company out there can
submit code to Linux?

Or if it does, it needs to justify code to the James-Bottomleys
and Christoph-Hellwigs of the list?

How knowlegable are you of SAS?

Just because you put things like this:

	"that's how linux development goes."

companies are discouraged to develop good, quality code in-house
for Linux and then submit good code.  Why?  Because the overhead
of the process of _conficing you_ of x, y and z is way too
expensive in just letting "the community" go hog-wild and then
telling customers: "It is not officially supported.  It is supported
by the community."

So, what those companies do instead is _hire_you_ to write the code
for them.  Isn't that fun?  Hey, what a way to secure a future.

Now the question remains: what about the _quality_ of the
code when written like that?  What about the costs?  Testing?
Deployment?

I refer you to the current, broken, sas transport _attributes_
which you included in the kernel, and the idea of enumerating
all phys on the domain...  So much about quality.

How about logistics?  How about technical knowlege?  How about
*customer satisfaction*?

As you seem to work for a company which has a Linux product,
you should know how well customers want to hear "We sell it,
but we don't support it -- it is supported by ``the community''."

Have a good day,
	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
