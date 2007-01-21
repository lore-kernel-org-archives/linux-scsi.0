From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Sun, 21 Jan 2007 12:24:21 +0100
Message-ID: <45B34D65.6040005@s5r6.in-berlin.de>
References: <45ACA765.3030701@aboo.org> <45AD80F3.6020100@torque.net> <45ADE01F.3020708@s5r6.in-berlin.de> <45ADF979.7090003@aboo.org> <45AEA118.5030608@torque.net> <45B336D3.5010106@aboo.org> <45B337FD.1050501@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXAULYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jan 2007 06:24:52 -0500
In-Reply-To: <45B337FD.1050501@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> I actually uses the "openers" field in scsi_disk to find out if anyone
> has the scsi_device open or not.

There are several issues with this approach.
  - It will fail eventually because some day there may be other users of
a LU than sd. How would sg, sr, st be accommodated?
  - The type struct scsi_disk is defined locally in sd.c (not somewhere
in linux/include/scsi/) and you have to copy the struct definition in
your hba.c. That's because struct scsi_disk is not part of any in-kernel
API and you shouldn't use it in an LLD. If you really need to extend the
LLD API, then do it explicitly by patching the SCSI core and its
linux/include/scsi/ files, and do it as cleanly as possible.
  - You copied the comment "protected by BKL for now, yuck" on struct
scsi_disk.openers, but you forgot to access openers under actual
protection by BKL. I bet though that there are several more concurrency
issues when poking in dev_get_drvdata(&sdev->sdev_gendev).

(Is it actually still true that the BKL is taken when device files are
opened and closed?)

BTW, the comment on shost_for_each_device() in
linux/include/scsi/scsi_device.h says "This loop takes a reference on
each device and releases it at the end.  If you break out of the loop,
you must call scsi_device_put(sdev)." You forgot to do so.

> Aboo Valappil wrote:
>> I tried the sdparms and it failed not due to lack of sense code and
>> status. What happened was that the user space SCSI target died due
>> to a unsupported SCSI command (bug in user space target). When it
>> crashed, the SCSI disk served by that user space target was opened
>> by sdparms. The driver removed the scsi_host which was attached to
>> user space target, thinking that the last registered user space part
>> died.

When the userspace server vanished, it is as if hot-pluggable hardware
was removed. Your queuecommand hook, and probably the eh hooks and the
shutdown paths too, should be aware of such hot removals and act
accordingly. I haven't checked your code in detail but it seems you
already take some precautions. More may be necessary or at least
convenient, e.g. dequeuing and finishing all outstanding commands when a
hot removal was detected.

I can tell you that it is not exactly trivial to make Linux SCSI LLDs
handle hot removal correctly. You probably should look at some other
LLDs which have to deal with hot removal but (a) I don't guarantee you
find elegant solutions and (b) each type of transport or interconnect
has its own special requirements.

On the bright side, if you get the hot removal handling right, you may
be able to *completely avoid LLD API extensions* of the kind discussed
above.

Another more general note: You mentioned earlier that you suggest
vscsihba for inclusion into mainline. Read the following texts in
linux/Documentation: CodingStyle, SubmittingDrivers, SubmitChecklist.
BTW, you could also write a minimalist version of the userspace
counterpart to vscsihba and submit it as a file in
linux/Documentation/scsi/ as a programming example along with the patch
which adds vscsihba.
-- 
Stefan Richter
-=====-=-=== ---= =-=-=
http://arcgraph.de/sr/
