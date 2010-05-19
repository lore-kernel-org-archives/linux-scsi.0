From: Leif Sawyer <ak.hepcat+scsi@gmail.com>
Subject: Re: Fwd: high volume of disk-writes causes disk to 'disappear'
Date: Wed, 19 May 2010 05:23:54 -0800
Message-ID: <AANLkTin0XcxnGmyOXdpwW0ow-I61fJkOhWiYNIZ2soX2@mail.gmail.com>
References: <y2wd4bc8f581004191138ldab84bect8670755200e2c413@mail.gmail.com>
	 <w2od4bc8f581004271446md75f0dcbt537956a2e3f9abb7@mail.gmail.com>
	 <4BD99BFD.9090202@suse.de>
	 <q2md4bc8f581004291011k43d5c03cpb7361473f6de4350@mail.gmail.com>
	 <4BDAE41D.6030707@suse.de>
	 <m2gd4bc8f581004301627jea793d0ax1e63bc3796458662@mail.gmail.com>
	 <i2yd4bc8f581005031143r638b8037ra3778f97e6d2e25d@mail.gmail.com>
	 <AANLkTik8917n0yNfc9Y6V9rbG7OOltt_SLcxEu8bzu20@mail.gmail.com>
	 <AANLkTimjTiA9wIY_8ES_6hzowXKMVkNQOhg5VBxVu-ty@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48061 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0ESNX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2010 09:23:56 -0400
Received: by gwaa20 with SMTP id a20so1740402gwa.19
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2010 06:23:55 -0700 (PDT)
In-Reply-To: <AANLkTimjTiA9wIY_8ES_6hzowXKMVkNQOhg5VBxVu-ty@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, Hannes Reinecke <hare@suse.de>

looks like the 75% mark might have been too high of an estimate.
Whipped up a quick logger to show me when i was failing:

<user.info<14>>May 18 17:08:01 websniff-6036a5 logger: disk: /data at
59% utilization
<user.info<14>>May 18 17:09:01 websniff-6036a5 logger: disk: /data at
59% utilization
<user.info<14>>May 18 17:10:01 websniff-6036a5 logger: disk: /data at
60% utilization
<user.info<14>>May 18 17:11:01 websniff-6036a5 logger: disk: /data at
60% utilization
[22563.204037] INFO: task flush-8:16:2430 blocked for more than 120 seconds.
[22563.224392] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[22563.248117] INFO: task dumpcap:4004 blocked for more than 120 seconds.
[22563.267662] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[22563.291359] INFO: task df:14714 blocked for more than 120 seconds.
[22563.309874] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[22563.333593] INFO: task websniff.cgi:14717 blocked for more than 120 seconds.
[22563.354690] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[22682.229526] end_request: I/O error, dev sdb, sector 169922743
[22682.247345] Buffer I/O error on device sdb1, logical block 21240335
[22682.266781] end_request: I/O error, dev sdb, sector 170131519
[22682.284445] Buffer I/O error on device sdb1, logical block 21266432
[....... repeats until......]
[22682.782577] sd 3:0:1:0: rejecting I/O to offline device
[22682.798907] sd 3:0:1:0: rejecting I/O to offline device

And from here on out, the device is no longer recognized by the system
until a reboot.

I need some help with scsi debugging in order to provide more useful
information.

I do have a 512mb logfile (text)  with lots of scsi dump card state
logs and such, though.

-- 
"It's pronounced Layf...you know, like Leif Garrett? Don't you watch
 'I Love the 70's'? What kind of retro lover are you, anyway?"
