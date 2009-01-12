From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Mon, 12 Jan 2009 16:09:25 -0500
Message-ID: <496BB185.7080008@cybernetics.com>
References: <49625A67.3000304@cybernetics.com> <20090111022525I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1354 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZALVJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 16:09:27 -0500
In-Reply-To: <20090111022525I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
>
>> test #1
>>
>> open /dev/sgX
>> send a command that takes a long time (e.g. any tape drive seek
>> command)
>> before command completes, echo 1 >
>> /sys/class/scsi_generic/sgX/device/delete
>>
>> without patch:
>> oops
>>
>> with patch:
>> test program gets ENODEV immediately
>> keventd sleeps until the cmd is complete
>> this is suboptimal since it starves other users of keventd while
>> waiting for the command to complete, but it is better than an oops
>>     
>
> As you said, we can do better. It's not correct to make
> class_interface's remove_dev hook, sg_remove wait for the completion
> of all the commands.
>
> The main problem is about the lifetime of sg_dev and sg_fd. I think
> that we can fix it in a simpler and better way.
>
> You use kref for sg_dev. We can use kref for sg_fd too. I think that
> that's all we need to do.
>
>   
Thanks for the review.  Your patch behaves very similarly to my patch
with the wait_event() removed from sg_remove().  With my patch, it was
not strictly necessary for sg_remove() to wait until all commands had
gone through sg_rq_end_io() - the refcounting, locking, and other checks
in my patch would have taken care of freeing sdp, sfp, and related
resources at the right time, even if sg_remove() didn't wait.  The
reason I added the wait is because without it keventd would still sleep
(outside of sg_remove()) waiting for the command to complete anyway,
except that when the command did complete, the kernel would spew some
scary-looking error messages:

mptscsih: ioc1: ERROR - Received a mf that was already freed
mptscsih: ioc1: ERROR - req_idx=beaf req_idx_MR=beaf mf=ce504b00
mr=00000000 sc=00000000

So I figured it would be better to wait in sg_remove() and avoid the
error above, instead of waiting somewhere else for the same amount of
time and getting an error.  With your patch, I get the above error
again, and keventd blocks for the same amount of time, so initially it
did not look like an improvement.  However, since this issue has
surfaced again, I went ahead and analyzed why keventd is waiting outside
of sg_remove(), and discovered that it is a bug in mptscsih (*).  When I
retested with sym53c8xx or open-iscsi, keventd did not block waiting for
the command to complete.  I will send a patch for mptscsih later.

So we can accomplish the same effect with my patch just by removing the
wait_event() in sg_remove() and the other code associated with it.  Now
the question is - do we still want to use krefs for the sg_fd?  I had
considered it when coming up with my patch, but I decided not to add the
overhead of two extra atomic ops per command.  Atomic ops for opening
and closing fds are OK, but I didn't want to slow down the command
processing critical paths.  I haven't measured the overhead, so maybe it
isn't too bad, but it is something to consider.

Also, I spent a lot of time analyzing locks and potential races with my
patch, and your patch reverts some of the fixes that I incorporated in
my patch.  Just to point out one example that I spotted quickly:
sg_rq_end_io() needs to check srp->orphan and set srp->done = 1 while
holding sfp->rq_list_lock to avoid races with sg_ioctl(SG_IO) (see my
[PATCH 2/2] sg: fix races with ioctl(SG_IO)).  But if you really want to
go with a kref on sg_fd and get/put on every command, let me know and I
will check and test everything again in detail.  If not, I will resubmit
my patch with the wait_event and associated code removed.

As a side note, scsi_remove_device() is called from keventd when using
the /sys interface to delete a device, but may be called from a
different process when using a different interface to delete a device. 
So under different circumstances the sleep may block rmmod, iscsi_wq,
etc., instead of keventd.

(*) Here is why mptscsih causes keventd to sleep:

scsi_remove_device() -> __scsi_remove_device() -> mptscsih_slave_destroy()
First, mptscsih_search_running_cmds() calls sc->scsi_done()
(sg_rq_end_io()) on all outstanding commands.
Then, mptscsih_synchronize_cache() is called.  It has the following check:

if (vdevice->vtarget->type != TYPE_DISK || vdevice->vtarget->deleted ||
    !vdevice->configured_lun)
    return;

However, this check is buggy.  My test is using a tape drive, so the
type != TYPE_DISK check should make the function return without doing
anything.  However, vtarget->type appears not to be set.  Also, you
might hope that the vtarget->deleted check might make the function
return, but it does not.  So it ends up sending a synchronize cache disk
command to a tape drive being deleted, and waits for it to complete. 
Since the tape drive does not do command queueing, this forces it to
wait for the tape drive seek command previously sent by my test program
to finish.  But when the seek command does finish, the message frame was
already freed by mptscsih_search_running_cmds(), so it gives the error
message above.

Tony

