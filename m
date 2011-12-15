From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Thu, 15 Dec 2011 13:12:01 -0800
Message-ID: <20111215211201.GA6482@xanatos>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EE9B375.4020606-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 15, 2011 at 09:44:37AM +0100, Sebastian Andrzej Siewior wrote:
> On 12/14/2011 11:53 PM, Sarah Sharp wrote:
> >Thanks for testing!  Are these patches on top of the patches I sent out
> >a week ago?  Or just on top of Greg's tree?
> 
> They are ontop of Greg's tree. I know that you sent a patch to fix the
> same issue I did on my #1 patch. I remember that something did not work
> out. It might be the thing for which I need #2. So if you want me to
> rebase those two or redo something please let me know.

Yes, I need to probably completely revisit the patchset because there
are still race conditions in there.  I was actually planning on
completely ripping out the workqueue, since having a global workqueue
means the UAS pre-reset function can't be guaranteed to sync with the
workqueue that might be used by a different UAS device.  But that means
making sure that we have error paths in the URB submission code in case
submission fails.  Probably the status URB changes for USB 2.0 should
get in place before that.

To fix the issue with HS devices, I think we might need my patch #2 and
#3.  Then I don't think you'll need this ending bit in your patch #1,
since my patch #2 took care of making sure not to use cmdinfo->stream
for USB 2.0 commands:

@@ -476,10 +479,8 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
                break;
        }

-       if (!devinfo->use_streams) {
+       if (!devinfo->use_streams)
                cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
-               cmdinfo->stream = 0;
-       }

        err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
        if (err) {

I also think this bit:

@@ -232,13 +232,16 @@ static void uas_stat_cmplt(struct urb *urb)
                return;
        }

-       tag = be16_to_cpup(&iu->tag) - 1;
-       if (sdev->current_cmnd)
-               cmnd = sdev->current_cmnd;
-       else
-               cmnd = scsi_find_tag(sdev, tag);
-       if (!cmnd)
+       cmnd = sdev->current_cmnd;
+       if (!cmnd) {
+               tag = be16_to_cpup(&iu->tag);
+               cmnd = scsi_find_tag(sdev, tag - 1);
+       }
+       if (!cmnd) {
+               dev_err(&urb->dev->dev, "Missing cmd for status URB\n");
+               usb_free_urb(urb);
                return;
+       }

Is equivalent to my patch #3:

@@ -246,8 +246,10 @@ static void uas_stat_cmplt(struct urb *urb)
                cmnd = sdev->current_cmnd;
        else
                cmnd = scsi_find_tag(sdev, tag);
-       if (!cmnd)
+       if (!cmnd) {
+               usb_free_urb(urb);
                return;
+       }

        switch (iu->iu_id) {
        case IU_ID_STATUS:

You're rearranging the code a lot there, but it looks like the only behavioral
change you made was to free the status URB if the command couldn't be found.
Or are you also trying to skip setting tag to a big negative number in the
untagged case?  tag is not used in the rest of the function if
sdev->current_cmnd is non-NULL, so I don't think it matters much.

I'm not sure what you're trying to fix with this bit of code:

@@ -449,7 +452,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,

        BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));

-       if (!cmdinfo->status_urb && sdev->current_cmnd)
+       if (sdev->current_cmnd)
                return SCSI_MLQUEUE_DEVICE_BUSY;

        if (blk_rq_tagged(cmnd->request)) {

Was that supposed to be part of the second patch?

So I think you could replace your patch #1 with my patches #2 and #3,
and then redo your patch #2.

> >Matthew was just mentioning to me that it might be good to just have one
> >status URB per USB 2.0 UAS device, and just keep re-submitting it.  USB
> >2.0 devices don't have streams, so there can't be multiple status URBs
> >being processed at the same time, so I think it would work.  The only
> Oh. That sounds great. I've been thinking how to avoid multiple
> allocation/allocation of them.
>
> >For USB 3.0 UAS, I think the status URB should stay in the cmnd_info
> >structure, since we know that when a status URB completes for a
> >particular stream ID, it is directly associated with that command, and
> >not a different command.  So I'd like to address the sense URB failure
> >issue you tried to fix in the second patch, but I think we should go
> >about it in a different way.
> 
> Fine by me. You want me to redo #2 with one status urb/uas device or do
> you do it yourself?

If you want to take a stab at redoing your patch #2 to use only one
status URB for USB 2.0 devices, I would appreciate it.  Then I can build
the abort/reset synchronization on top of it.

Can you test the USB 3.0 side as well, or are you just testing USB 2.0
with your device?

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
