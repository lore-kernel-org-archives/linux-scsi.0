From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH v2] usb/uas: one only one status URB/host on
 stream-less connection
Date: Thu, 22 Dec 2011 15:15:25 +0100
Message-ID: <20111222141525.GA19406@linutronix.de>
References: <20111220150126.GA29286@linutronix.de>
 <Pine.LNX.4.44L0.1112201035240.1690-100000@iolanthe.rowland.org>
 <20111220171621.GC29286@linutronix.de>
 <20111221192543.GA15279@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34798 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1LVOP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2011 09:15:28 -0500
Content-Disposition: inline
In-Reply-To: <20111221192543.GA15279@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

* Sarah Sharp | 2011-12-21 11:25:43 [-0800]:

>Hi Sebastian,
Hi Sarah,

>The patch looks good (although I haven't tested it).  However, I think
>you should move this chunk from one of your previous patches:
>
>@@ -449,7 +452,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
>
>        BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
>
>-       if (!cmdinfo->status_urb && sdev->current_cmnd)
>+       if (sdev->current_cmnd)
>                return SCSI_MLQUEUE_DEVICE_BUSY;
>
>into this patch, to keep the change to the status URB in one patch.

This isn't completely the chunk I have, it is:

-       if (!cmdinfo->status_urb && sdev->current_cmnd)
+       if (devinfo->cmnd)
                return SCSI_MLQUEUE_DEVICE_BUSY;

So I replace sdev with devinfo. Not sure why status_urb is considered
here at all since it has to be NULL because it is a new command. We
should look at "default command pointer" to check if we have a untagged
command pending.

>Also, do you have a git branch up for the UAS work somewhere?  We need
>to figure out how to merge your bug fix patches with my bug fix patches
>into one patchset.  It's probably easier if you send your current
>patchset, or a pointer to your branch.

I did as you asked and applied your patches 1-3 and added my stuff on
top. You can pull from:

git pull git://linutronix.de/users/bigeasy/linux for_sarah

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://linutronix.de/users/bigeasy/linux for_sarah

Sarah Sharp (3):
      UAS: Re-add workqueue items if submission fails.
      UAS: Use unique tags on non-streams devices.
      UAS: Free status URB when we can't find the SCSI tag.

Sebastian Andrzej Siewior (3):
      usb/uas: use unique tags for all LUNs
      usb/uas: use scsi_host_find_tag() to find command from a tag
      usb/uas: one only one status URB/host on stream-less connection

 drivers/usb/storage/uas.c |  157 +++++++++++++++++++++++++++++++++------------
 1 files changed, 117 insertions(+), 40 deletions(-)

which is -rc4 based which is almost what I had for testing (a bunch of
target patches are missing). I also prepared a gpg signed tag for you so
if you have a recent version git you should be able to pull it via
   git pull git://linutronix.de/users/bigeasy/linux uas_for_sarah

:)

>Sarah Sharp

Sebastian
