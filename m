From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Fri, 16 Dec 2011 15:47:24 +0100
Message-ID: <20111216144724.GC19563@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111215211201.GA6482@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

* Sarah Sharp | 2011-12-15 13:12:01 [-0800]:

>You're rearranging the code a lot there, but it looks like the only behavioral
>change you made was to free the status URB if the command couldn't be found.
Yup. Since we don't have a reference, we can't free it.

>Or are you also trying to skip setting tag to a big negative number in the
>untagged case?  tag is not used in the rest of the function if
>sdev->current_cmnd is non-NULL, so I don't think it matters much.

If it is untagged, the tag number should be always 1 and ->current_cmnd
set. There can be only one untagged command at a time so therefore I
look first for current_cmnd then look at the tag.

>I'm not sure what you're trying to fix with this bit of code:
>
>@@ -449,7 +452,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
>
>        BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
>
>-       if (!cmdinfo->status_urb && sdev->current_cmnd)
>+       if (sdev->current_cmnd)
>                return SCSI_MLQUEUE_DEVICE_BUSY;
>
>        if (blk_rq_tagged(cmnd->request)) {
>
>Was that supposed to be part of the second patch?
Didn't I remove status_urb? Plus there can be only one default command
at a time so looking at current_cmd seems wrong (unless we set
->current_cmnd and drop the reqeust due to -ENOMEM).

>So I think you could replace your patch #1 with my patches #2 and #3,
>and then redo your patch #2.
okay will do.

>> >Matthew was just mentioning to me that it might be good to just have one
>> >status URB per USB 2.0 UAS device, and just keep re-submitting it.  USB
>> >2.0 devices don't have streams, so there can't be multiple status URBs
>> >being processed at the same time, so I think it would work.  The only
>> Oh. That sounds great. I've been thinking how to avoid multiple
>> allocation/allocation of them.
>>
>> >For USB 3.0 UAS, I think the status URB should stay in the cmnd_info
>> >structure, since we know that when a status URB completes for a
>> >particular stream ID, it is directly associated with that command, and
>> >not a different command.  So I'd like to address the sense URB failure
>> >issue you tried to fix in the second patch, but I think we should go
>> >about it in a different way.
>> 
>> Fine by me. You want me to redo #2 with one status urb/uas device or do
>> you do it yourself?
>
>If you want to take a stab at redoing your patch #2 to use only one
>status URB for USB 2.0 devices, I would appreciate it.  Then I can build
>the abort/reset synchronization on top of it.
Okay.

>Can you test the USB 3.0 side as well, or are you just testing USB 2.0
>with your device?

I made usb3.0 and stream support just work the other day but those
patches were made before that. The usb3 test worked without problem but
I don't have any error recovery/handling yet.

>Sarah Sharp

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
