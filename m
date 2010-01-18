From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: scsi device is not available in enclosure any more after hot
 plugging
Date: Mon, 18 Jan 2010 10:29:39 +0100
Message-ID: <20100118102939.d1104b22.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:37562 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0ARJrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2010 04:47:12 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 862524A8071
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 10:29:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 8CB01937FD
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 10:29:39 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 025E8937B4
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 10:29:39 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there!

One of my servers contains two scsi enclosures.
After hot removing a disk and hot adding another in the same slot the n=
ew disk gets assigned a device file but the enclosure (in sysfs) doesn'=
t want to see it.

How can I force the enclosure to recognise the hot added disk.

Situation in sysfs:
# ls -l "/sys/class/enclosure/10:0:24:0/SLOT 010"
insgesamt 0
-rw-r--r-- 1 root root 4096 2010-01-15 14:30 active
lrwxrwxrwx 1 root root 0 2010-01-15 12:56 device -> ../../../../../../.=
=2E/port-10:0:11/end_device-10:0:11/target10:0:10/10:0:10:0
-rw-r--r-- 1 root root 4096 2010-01-15 14:31 fault
-rw-r--r-- 1 root root 4096 2010-01-15 14:40 locate
drwxr-xr-x 2 root root 0 2010-01-15 14:01 power
-rw-r--r-- 1 root root 4096 2010-01-15 14:01 status
-r--r--r-- 1 root root 4096 2010-01-15 14:01 type
-rw-r--r-- 1 root root 4096 2010-01-15 14:01 uevent

The link =C2=ABdevice=C2=BB is dead after hot removing the device and k=
eeps vanished after hot adding the new device.
The hot added device gets assigned a device file and it is reachable.
Even
# echo 1 > /sys/bus/scsi/devices/10\:0\:24\:0/rescan
doesn't change anything.

How can I force the link to be updated towards
-> ../../../../../../../port-10:0:26/end_device-10:0:26/target10:0:25/1=
0:0:25:0
???


Is there a detailed description of the sysfs regarding scsi on the web?

Thanks
Lars

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
