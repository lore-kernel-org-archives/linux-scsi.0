From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Sat, 15 Feb 2003 20:23:54 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10302152015230.13440-100000@master.linux-ide.org>
References: <3E4D44EB.1090402@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E4D44EB.1090402@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org


What are trying to achieve, a split n-way mid-layer to provide fastpath(N)
for fail-over?  Or are you attempting to provide path(N) for some type of
load balance or flow control schedule?  Regardless, you can not do
multi-path on a given HBA, real or virtual.

Unless you have a special HPA that allows queue stalls and each
port/spindle has its own host queue.  This sounds very much like FPDMA
with DPIO for raw FIS creation and loading, aka SAS.

I have such HBA's but are cleverly coded as to not need path(N).
They fake the mid-layer to report each port as a restanding HBA, yet share
a common hostdata to allow command migration or redirection.  This yeilds
the same effect with out fudging the current driver mid-layer.

My Nickle --

Andre Hedrick
LAD Storage Consulting Group


On Fri, 14 Feb 2003, Luben Tuikov wrote:

> Doug Ledford [dledford@redhat.com] wrote:
> >
> > On Thu, Feb 13, 2003 at 01:55:15PM -0500, Luben Tuikov wrote:
>  >
> >	::same_target_siblings -- this shouldn't exist by design.
>  >
> > Yes!  That one most certainly should exist!  There are lots of operations 
> 
> Sorry, I had my mind in new-scsi-core, while looking at the structs
> of current-scsi-core.
> 
> I.e. I was assuming that struct scsi_target existed, while
> it *only* exists in new-scsi-core... :-(
> 
> Now let's get back to theme:
> 
> Mike Anderson on Feb 14, 2003, wrote:
> >
> > The need is there for per target data, but if we talk about future
> > directions it would appear a cleaner interface would be to have luns as
> > children of the targets (? ports ?) vs having a list of luns and post linking
> > relationships.
> 
> And Patrick Mansfield on Feb. 14, 2003, wrote:
>  >
>  > And it would be nice if each scsi_device pointed to a parent struct
>  > scsi_target that grouped all per-target information - like (as you
>  > mentioned) active_cmd_count_target, *lld_target_data, and other target
>  > specific data that is now stored in scsi_device.
>  >
>  > This might aid in probe/scanning for transports (like FCP) that can figure
>  > out a target is there without scanning: a representation of the target can
>  > show up without any scsi_device, and then we scan those targets.
>  >
>  > It also gives a better representation (under sysfs) of the physical layout
>  > of the devices.
> 
> Abosolutely correct!
> 
> And this is quite evident from my Feb 11, 2003 message:
> 
> 	E.g. scsi_core <- portal <- target <- lun <- command,
> 	where each level to the right is 0/1:N.
> 
> I was going to talk about this, but no time yesterday.
> 
> Now, we have:
> 
> struct scsi_core {
> 	struct list_head entry;
> 
> 	struct list_head portal_list;
> 	spinlock_t       portal_list_lock;
> 	atomic_t         portal_list_count;
> 	...
> };
> 
> struct scsi_portal {
> 	struct list_head entry;
> 
> 	struct list_head target_list;
> 	spinlock_t       target_list_lock;
> 	atomic_t         target_list_count;
> 	...
> };
> 
> struct scsi_target {
> 	struct list_head entry;
> 
> 	struct list_head lun_list;
> 	spinlock_t       lun_list_lock;
> 	atomic_t         lun_list_count;
> 	...
> };
> 
> struct scsi_lun {
> 	struct list_head entry;
> 	
> 	/* pending execution status by the device server */
> 	struct list_head pending_cmd_q;
> 	spinlock_t       pending_cmd_q_lock;
> 	atomic_t         pending_cmd_q_count;
> 	...
> };
> 
> struct scsi_command {
> 	struct list_head entry;
> 	...
> };
> 
> Where each predecessor can contain 0/1:N of its successor.
> 
> Points:
> 
> 1) If an object of type struct scsi_core exists, then this means
> that SCSI Core is loaded, thus its representation in sysfs (and SCSI
> Core itself, i.e. it represents itself... :-) ).
> ... this was the reason I wanted scsi_core in current-scsi-core,
> alas, no one saw it...
> 
> ((Is anyone dreaming of multiple scsi_core's, say on a NUMA machine...?))
> 
> 2) struct scsi_portal represents a service delivery subsystem type,
> e.g. SPI, USB, FC, iSCSI, SAS, etc.  Nitty-gritty of the *actual*
> delivery subsystem should have their own sub-sub structure, since
> struct scsi_portal unifies them all for scsi_core and scsi_target's
> sake.
> 
> 3) struct scsi_target: this is an *important* point: those appear
> and dissapear asynchronously at the scsi_portal's request!  That is,
> once a scsi_portal is registered with scsi_core and operational,
> it will do something like:
> 	/* async: new device appeared ... */
> 	struct scsi_target *t = NULL;
> 	t = scsi_get_target(this_portal); /* get a struct from scsi_core */
> 	if (t) {
> 		this_portal_conf_target(portal_target_representation, t);
> 		scsi_register_target(t);
> 	}
> 
> The reason for this is that the service delivery subsystem *knows*
> how to discover targets, scsi_core does not -- SCSI architecture.
> New_scsi_core will discover luns present on targets.
> 
> This also means that a scsi_portal will have an interface exported
> via sysfs so that one can control how/when/where/etc targets are
> discovered -- this is important for FC and iSCSI ppl.
> 
> 4) struct scsi_lun: this is the actual device, and can be any
> kind of device at all.  It will have more command queues than this.
> But, the only queue where commands will actually ``pend'' is
> the pending device queue.  A done_q will most likely exist
> in scsi_core.  An incoming_q will exist in either the lun
> struct or the target struct, and will represent a command
> which is being worked upon, i.e. someone is currently setting
> the cdb, and other members; as soon as this is done, it will
> go on the pending_q and *then* void queuecommand() called,
> this fixes some races (been there, done that).
> 
> The locks could be a macro so that they could be either
> a spinlock or rw_lock, as I have it for my own mini-scsi-core.
> 
> Furthermore using this layout there's no ether-pointers
> on which SCSI Core structurally depends.
> 
> The drawback is that LLDD are not compatible with this
> new-scsi-core structure.
> 
> There's a few more quirks in scsi_command, but I'll leave those
> out for now, until I hear any kudos, comments and flames
> regarding this layout.
> 
> BTW, if you like it, please say so, *NOT* privately to me,
> but here publicly on this list -- this will not make you any
> less of a man! :-)
> 
> Happy Valentine's everyone,
> -- 
> Luben
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

