From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: 14 Feb 2003 16:20:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045257640.1726.23.camel@mulgrave>
References: <3E495862.3050709@splentec.com>
	<20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com>
	<20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com>
	<20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com>
	<20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com>
	<20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com>
	 <3E4D44EB.1090402@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA11365
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2003 13:20:43 -0800
In-Reply-To: <3E4D44EB.1090402@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-02-14 at 14:35, Luben Tuikov wrote:

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

I don't like this on several grounds:

1. You have a really complex locking hierarchy.  It may be
philosophical, but I regard locking heirarchies as evil.  The only good
they can possibly serve is if you give a clear demonstration that they
avoid hot lock contention.  Otherwise, they tend to create more problems
than they solve.

2. The data structures you propose don't match reality.  The reality is
that we will have to cope with SPI for a while yet, and it doesn't have
scsi_portal.

3. I don't see where the mid-layer has a use for the data.  By and
large, we queue at the LUN level and we control parameters at the host
level.  The only current times we need to even associate puns and luns
is for error handling (reset non-locality) and for certain times when
the host is negotiating transfer parameters.  The current sibling list
may be a bit ugly, but it serves its purpose.

> Points:
> 
> 1) If an object of type struct scsi_core exists, then this means
> that SCSI Core is loaded, thus its representation in sysfs (and SCSI
> Core itself, i.e. it represents itself... :-) ).
> ... this was the reason I wanted scsi_core in current-scsi-core,
> alas, no one saw it...

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


