From: Amaury Pouly <amaury.pouly@gmail.com>
Subject: Medium change detection
Date: Tue, 12 Nov 2013 14:41:00 +0000
Message-ID: <CAEJ3XJyXktJ541c3W=QuyggHoLiQ9T3qdC_xs+mpvzix-1k-bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40301 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3KLOlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 09:41:21 -0500
Received: by mail-vb0-f41.google.com with SMTP id w8so4438319vbj.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2013 06:41:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,
I am a developer of the Rockbox project and I am facing an issue
related to how medium are handled in SCSI. I don't know if this is a
Rockbox and/or kernel issue, or just a mistunderstanding of the
specification. I tried with many kernel version between 2.6.38 and
3.11.

I have a device with a micro-sd port and which get reported as a
removable LUN. If the micro-sd is initially inserted, TEST UNIT READY
will report Good and the kernel will probe capacity and everything
works.
If I remove the micro-sd (without ejecting on the host before),
nothing happen until the host tries to read/write at which point it
will:
- on old kernel versions: error out and mark the medium as not present
- on recent kernel versions: error out, notify capacity change to 0
and mark medium as not present

Here is my first question: the old kernel versions used to send TEST
UNIT READY all the time, so why isn't the media change notified until
I actually try to read/write it ? On newer kernel versions, TEST UNIT
READY is only sent before read/write, why was this behaviour changed
(and when ?) and has the kernel any way to get notified immediately on
eject ?

At that point, if I insert my micro-sd again, nothing happen on the
host side, both on old and recent kernels, no capacity change, no
medium change. If I try to read/write, I always get a "No medium
present" error even though the medium is present. This is puzzling for
two reasons:
- on old kernel versions: since the kernel sends TEST UNIT READY all
the time, is has the capacity to detect insertion when LUN becomes
Good again ?
- on recent kernel versions: since TEST UNIT READY is not sent and the
scsi layer somehow caches the medium state, is there any way for the
kernel to actually detect that the medium is back ?

Finally I should note that this behaviour is not Rockbox specific,
even with the vendor implementation of Mass Storage, this problem
arises. I am thus wondering if this the expected behaviour, because
the device reports the LUN as removable so I assumed that removable
meant both remove and insert !

Thanks for your time

Amaury Pouly
