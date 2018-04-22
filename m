From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bsg referencing bus driver module
Date: Sun, 22 Apr 2018 08:47:59 +0100
Message-ID: <1524383279.3389.7.camel@HansenPartnership.com>
References: <CANFzKepsGq0EHX4GPtC0RZOWqVf2fTJ6uA2WH-SZNsBuwMJ5KA@mail.gmail.com>
         <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
         <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
         <1524218126.3321.6.camel@HansenPartnership.com>
         <20180420224404.GC32372@xldev-tmpl.dev.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420224404.GC32372@xldev-tmpl.dev.purestorage.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com, jthumshirn@suse.de, hare@suse.com, bblock@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-04-20 at 16:44 -0600, Anatoliy Glagolev wrote:
>  
> > This patch isn't applyable because your mailer has changed all the
> > tabs to spaces.
> > 
> > I also think there's no need to do it this way.  I think what we
> > need is for fc_bsg_remove() to wait until the bsg queue is
> > drained.  It does look like the author thought this happened
> > otherwise the code wouldn't have the note.  If we fix it that way
> > we can do the same thing in all the other transport classes that
> > use bsg (which all have a similar issue).
> > 
> > James
> > 
> 
> Thanks, James. Sorry about the tabs; re-sending.
> 
> On fc_bsg_remove()...: are you suggesting to implement the whole fix
> in scsi_transport_fc.c?

Yes, but it's not just scsi_transport_fc, scsi_transport_sas has the
same issue.  I think it's probably just the one liner addition of
blk_drain_queue() that fixes this.  There should probably be a block
primitive that does the correct queue reference dance and calls
blk_cleanup_queue() and blk_drain_queue() in order.

>  That would be nice, but I do not see how that
> is possible. Even with the queue drained bsg still holds a reference
> to the Scsi_Host via bsg_class_device; bsg_class_device itself is
> referenced on bsg_open and kept around while a user-mode process
> keeps a handle to bsg.

Once you've called bsg_unregister_queue(), the queue will be destroyed
and the reference released once the last job is drained, meaning the
user can keep the bsg device open, but it will just return errors
because of the lack of queue.  This scenario allows removal to proceed
without being held hostage by open devices.

> Even if we somehow implement the waiting the call may be stuck
> forever if the user-mode process keeps the handle.

No it won't: after blk_cleanup_queue(), the queue is in bypass mode: no
requests queued after this do anything other than complete with error,
so they never make it into SCSI.

> I think handling it via a rererence to the module is more consistent
> with the way things are done in Linux. You suggested the approach
> youself back in "Waiting for scsi_host_template release" discussion.

That was before I analyzed the code paths.  Module release is tricky,
because the module exit won't be called until the references drop to
zero, so you have to be careful about not creating a situation where
module exit never gets called and module exit code should force stuff
to detach and wait for the forcing to complete to make up for the
reference circularity problem.  If you do it purely by refcounting, the
module actually may never release (that's why scsi_remove_host works
the way it does, for instance).

James
