From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 09:52:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF33C61840.B0D589F0-ONC1256BC3.0029F105@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org



James,

I think we are talking about two different things.
If I am not mistaken, __scsi_insert_special is only called for character
devices or ioctl (at least that is what it states in the description).
My problem occurs during normal IO to a disk. I believe it is something of
this sort:
scsi_dispatch_command is called, host->can_queue is 4096 so the if
statement is true.
Then, the low-level driver's queuecommand returns with FAILED. The command
is put into the mlqueue to be resent when a command completes.
Due to the design of the zSeries FCP adapter, it is however possible that
temporarily, no command can be accepted at all.
Thus it is possible for queuecommand to fail on the one and only active
command, which will be put into the mlqueue.
There it will sit, waiting for the return of an outstanding command, but
there are non. Hence the system will hang.

I would think, that your problem only appears when using ioctls (e.g.
fdisk) or going out to character device (st, sg). Am I correct or am I
missing something?
Aron

> Alas, there does not seem to be a timeout handler to restart IO when
> queuecommand returned non 0. The only way to retrigger IO seems to be
> a completion of an outstanding command. I have seen a lot of hangs in
> the FCP driver I am contributing to because of this. We finally
> decided never to let queuecommand fail and queue failed requests
> internally while there might still be a chance to send them. This is
> not too nice though, so it would probably be a good idea to use a
> timeout as an alternative trigger to resend commands in the mlqueue.
> Maybe a function to be called by the low-level driver would also be an
> option.

I've seen it too occasionally, but I can't reproduce it consistently
enough.
I think the culprit may be our use of _elv_add_request with a no-plug
argument.  Can you just change the last argument from 0 to 1 and see if
this
helps (in scsi_lib.c:__scsi_insert_special at about line 90)?

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




