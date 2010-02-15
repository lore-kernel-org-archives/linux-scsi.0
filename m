From: Douglas Gilbert <dgilbert@interlog.com>
Subject: SYNCHRONIZE CACHE command from sd on close
Date: Mon, 15 Feb 2010 14:03:06 +0100
Message-ID: <4B79460A.7040207@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51159 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0BONDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2010 08:03:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by elrond.infotech.no (Postfix) with ESMTP id 3979130DBD
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 14:03:07 +0100 (CET)
Received: from elrond.infotech.no ([127.0.0.1])
	by localhost (elrond.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TdrXZehTnnrS for <linux-scsi@vger.kernel.org>;
	Mon, 15 Feb 2010 14:03:07 +0100 (CET)
Received: from [82.134.31.176] (unknown [82.134.31.176])
	by elrond.infotech.no (Postfix) with ESMTPA id 1F44F30B38
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 14:03:07 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Recently, judging from error reports reaching me
from smartmontools, sdparm and sg_start, something
changed in the sd driver associated with the
SYNCHRONIZE CACHE command it issues when a device
is closed.

That only seems to happen when the device is opened
RW and it exposes a nasty difference between the
semantics of spinning up and down ATA disks compared
to SCSI disks.

If you send SYNCHRONIZE CACHE to a SATL then the ATA
disk behind it will be spun up if it happened to be
spun down. Send that command to a SCSI disk and you
will get an error message (sense) indicating that
you need to do START_STOP_UNIT(start) first.

One manifestation of this problem is that:
     sdparm -C stop <ata_disk_via_sd>
doesn't work. Being a SCSI utility it opens the sd
device RW reflecting that the START_STOP_UNIT to
a SCSI disk is potentially state changing (in the
sense that subsequent READs and WRITEs may fail).
But since we have a ATA disk then the SYNCHRONIZE
CACHE on close spins up the disk, defeating the
attempt to spin it down.

Now I'm playing lots of tricks in sdparm to get
around this but I think the correct solution is
for the sd driver to only send the SYNCHRONIZE
CACHE command to a device on close if something
has been written to it.

Doug Gilbert
