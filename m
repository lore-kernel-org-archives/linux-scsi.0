From: Roland Dreier <roland@kernel.org>
Subject: Handling multiple paths to enclosure devices?
Date: Thu, 28 Jul 2011 10:05:30 -0700
Message-ID: <1311872730-4863-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:37815 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755643Ab1G1RFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2011 13:05:36 -0400
Received: by pzk37 with SMTP id 37so4918599pzk.29
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2011 10:05:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, eric@purestorage.com

Hi,

I'm seeing an issue with the current design of our enclosure
handling.  In a system with a bunch of drives in an enclosure, it's
definitely helpful to have a way to go from sdXX to which slot in the
enclosure that drive is in, and that's what the symlink
/sys/block/sdXX/device/enclosure_device:NN provides.

However, in a system with multiple paths to the enclosure, eg an HBA
with two external SAS ports, both connected to a SAS expander in a
JBOD, ie in lame ASCII graphics, something like:

     +-----+                 /-- drv1
     |     |       +-----+  /---  .
     |     |==SAS==|     |-/----  .
     | HBA |       | exp |------  .
     |     |==SAS==|     |-\----  .
     |     |       +-----+  \---  .
     +-----+                 \-- drvN

we have two paths to each drive, so each gets two names, sdXX and
sdYY.  However, in drivers/misc/enclosure.c, the code only allows one
device in each component and so what happens is that sdXX gets
discovered, then gets an enclosure_device:NN link, then sdYY is
discovered, so sdXX's enclosure_device:NN link is removed and one is
added for sdYY.  And so if I want to figure out which enclosure slot
sdXX is in, I'm in for a hard time.

It would be a simple matter of writing code to allow all the block
devices in a slot to link back to that slot -- we would have to be a
bit more careful of keeping track of what links exist, but it should
be doable.

The wrinkle is that there are also /sys/class/enclosure/ZZZ/NN/device
symlinks that allow going the other way.  And it's harder to see how
to express multiple block devices in one enclosure slot.

Thoughts on how to improve our enclosure handling?

Thanks!
  Roland
