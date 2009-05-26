From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
	variable before it get used
Date: Tue, 26 May 2009 16:06:05 +0000
Message-ID: <1243353966.2815.41.camel@localhost.localdomain>
References: <1243351161.31783.5.camel@localhost.localdomain>
	 <1243351709.2815.33.camel@localhost.localdomain>
	 <1243353605.31783.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756571AbZEZQGU@vger.kernel.org>
In-Reply-To: <1243353605.31783.25.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-05-26 at 21:30 +0530, Jaswinder Singh Rajput wrote:
> Hello James,
> 
> On Tue, 2009-05-26 at 10:28 -0500, James Bottomley wrote:
> > On Tue, 2009-05-26 at 20:49 +0530, Jaswinder Singh Rajput wrote:
> > > I am watching this problem from long time in -tip.
> > > 
> > > Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable before it get used
> > > 
> > > In some cases, err will be used uninitialized.
> > 
> > What cases?  A simple theoretical analysis shows that this variable is
> > always set.
> > 
> 
> Ok lets takes your tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=blob;f=drivers/scsi/scsi_transport_iscsi.c;hb=10eb0f013c63c71c82ede77945a5f390c10cfda6
> 
> 
> 672 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
> 673 {
> 674         struct Scsi_Host *shost = iscsi_session_to_shost(session);
> 675         struct iscsi_cls_host *ihost;
> 676         unsigned long flags;
> 677         unsigned int id = target_id;
> 678         int err;
> 679
> 680         ihost = shost->shost_data;
> 681         session->sid = atomic_add_return(1, &iscsi_session_nr);
> 682
> 683         if (id == ISCSI_MAX_TARGET) {
> 684                 for (id = 0; id < ISCSI_MAX_TARGET; id++) {
> 685                         err = device_for_each_child(&shost->shost_gendev, &id,
> 686                                                     iscsi_get_next_target_id);
> 687                         if (!err)
> 688                                 break;
> 689                 }
> 690
> 691                 if (id == ISCSI_MAX_TARGET) {
> 692                         iscsi_cls_session_printk(KERN_ERR, session,
> 693                                                  "Too many iscsi targets. Max "
> 694                                                  "number of targets is %d.\n",
> 695                                                  ISCSI_MAX_TARGET - 1);
> 696                         goto release_host;
> 697                 }
> 698         }
> 699         session->target_id = id;
> 700
> 701         dev_set_name(&session->dev, "session%u", session->sid);
> 702         err = device_add(&session->dev);
> 703         if (err) {
> 704                 iscsi_cls_session_printk(KERN_ERR, session,
> 705                                          "could not register session's dev\n");
> 706                 goto release_host;
> 707         }
> 708         transport_register_device(&session->dev);
> 709
> 710         spin_lock_irqsave(&sesslock, flags);
> 711         list_add(&session->sess_list, &sesslist);
> 712         spin_unlock_irqrestore(&sesslock, flags);
> 713
> 714         iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
> 715         return 0;
> 716
> 717 release_host:
> 718         scsi_host_put(shost);
> 719         return err;
> 720 }
> 
> You are right but compiler is confused and giving warning like this :
> 
> 1. do not go inside :
> 684                 for (id = 0; id < ISCSI_MAX_TARGET; id++) {

How? id is an unsigned int and ISCSI_MAX_TARGET is defined to be -1 in
include/scsi/scsi_transport_iscsi.h (might be better if it were
UINT_MAX, but -1 is just as good).

James
