From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v2 02/12] iscsi-target: Add primary iSCSI
	request/response state machine logic
Date: Tue, 15 Mar 2011 11:15:00 +0100
Message-ID: <20110315101500.GA23623@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org> <1300103829-10337-3-git-send-email-nab@linux-iscsi.org> <20110314153300.GC28480@lst.de> <1300148232.28255.238.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35178 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab1COKPB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2011 06:15:01 -0400
Content-Disposition: inline
In-Reply-To: <1300148232.28255.238.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>

On Mon, Mar 14, 2011 at 05:17:12PM -0700, Nicholas A. Bellinger wrote:
> > > +#include <linux/version.h>
> > > +#include <generated/utsrelease.h>
> > > +#include <linux/utsname.h>
> > 
> > You keep including these headers a lot, and I still don't understand why.  Even
> > if we need to expose data from it it should be done once in the core and not
> > all over the code.
> > 
> 
> OK, moved into a single iscsi_target_core.h include.

That's not what I meant.

 - for linux/version.h:

	neither LINUX_VERSION_CODE nor KERNEL_VERSION is used anywhere in
	the target code, so it can't possibly required at all.

 - for linux/utsname.h and <generated/utsrelease.h>:

	please either remove the attributes printing this information
	into common code.  or better off just remove it all all.  You can
	get the kernel version and release from the utsname system call,
	there is absolutely no need to duplicate it in a different attribute in
	every target frontend.
	Also printing it during initialization is completely pointless, too.

> > > +void core_put_tiqn_for_login(struct iscsi_tiqn *tiqn)
> > > +{
> > > +	spin_lock(&tiqn->tiqn_state_lock);
> > > +	atomic_dec(&tiqn->tiqn_access_count);
> > > +	spin_unlock(&tiqn->tiqn_state_lock);
> > > +	return;
> > 
> > no need for the return here.  Also what's the point of making tiqn_access_count
> > if you take a spinlock around all it's modifications?
> > 
> 
> Removed the unnecessary return here..  I was behind paranoid here..

Also please make tiqn_access_count a normal integer type, it is always
protected by tiqn_state_lock.

> Indeed..  Ok, I am going to go ahead an rename everything using core_ to
> iscsi_

Looks like none of the initiator code currently uses iscsi_, but I'd still
feel better about iscsit_ to make sure we're not conflicting with other
initiator side code.

> > Can't you just use the core idr code for generating indices?
> > 
> 
> Mmmm, not sure what you mean here..

Take a look at include/linux/idr.h.

Note that the uses for np_index, tpg_np_index and conn_index can be
removed entirely as they are unused.

> Ok, there are a quite a few struct semaphores that need to be converted
> into a struct mutex or struct completion..  I will get all of these
> converted over..

or sometimes spinlocks.  Or often removed at all, as they just implement weird
semantics for the threads - no need to have startup/shutdown synchronization
as the kthread semantics are synchronous, and for a wakeup after queueing
up work a simple wake_up_process on the task_struct pointer is enough.

If you have question on how to avoid certain uses feel free to ask.

> 
> Ok, this is where I have previously run into some issues after doing a
> kthread conversion for the RX/TX pairs using sock_recvmsg() some time a
> while back.  That said, I will go ahead will get the ulgiest pieces for
> the NP thread converted first and then have another look where the RX
> path code was (I think) having an issue to successfully perform iSCSI
> Logout Request -> Response processing..

Note that you might get away with less copies using the sk_data_ready,
sk_state_change callbacks and tcp_read_sock() and totally dropping the
traditional recvmsg path.  As this remove the blocking behaviour it
will as a side effect also remove any issues with thread startup/stop.

Take a look at drivers/scsi/iscsi_tcp.c for an implementation.

> > > +#define CONN(cmd)		((struct iscsi_conn *)(cmd)->conn)
> > > +#define CONN_OPS(conn)		((struct iscsi_conn_ops *)(conn)->conn_ops)
> > 
> > There really shouldn't be any need for these macros.
> > 
> > 
> > > +#define SESS(conn)		((struct iscsi_session *)(conn)->sess)
> > > +#define SESS_OPS(sess)		((struct iscsi_sess_ops *)(sess)->sess_ops)
> > > +#define SESS_OPS_C(conn)	((struct iscsi_sess_ops *)(conn)->sess->sess_ops)
> > > +#define SESS_NODE_ACL(sess)	((struct se_node_acl *)(sess)->se_sess->se_node_acl)
> > 
> > Same here.
> > 
> 
> Ok, I will drop the unnecessary casts here, and I will look at thinning
> -> removing these out these handful of macros.

It's not just the casts - macros just for dereferencing a field just obsfucate
the code.

