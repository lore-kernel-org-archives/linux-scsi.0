From: John Hughes <john@Calva.COM>
Subject: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 14:00:03 +0100
Message-ID: <4AF17AD3.6060909@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:64560 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZKDNFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 08:05:07 -0500
Received: from f.olympic (olympic.CalvaEDI.COM [192.168.6.67])
	(authenticated (0 bits))
	by oceanic.CalvaEDI.COM (8.11.1-20030923/8.11.1/6.32) with ESMTP id nA4D03b28421
	(using TLSv1/SSLv3 with cipher RC4-MD5 (128 bits) verified NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Nov 2009 14:00:04 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Like Lars T=E4uber last year I have a Promise Vtrak J610S "just a bunch=
 of=20
disks" cabinet, and like him I find that the ses enclosure services=20
don't seem to be working right.

If I look in the /sys/class/enclosure hierarchy I don't see the links I=
=20
should for the devices:

# lsscsi | grep PROMISE
[3:0:14:0]   enclosu PROMISE  3U-SAS-16-D BP   0107  -         /dev/sg1=
7
[4:0:14:0]   enclosu PROMISE  3U-SAS-16-D BP   0107  -         /dev/sg3=
2


(Note that's one device with two connections)

# ls -R /sys/class/enclosure/4\:0\:14\:0/
/sys/class/enclosure/4:0:14:0/:
0  10  12  14  2  4  6	8  components  power	  uevent
1  11  13  15  3  5  7	9  device      subsystem

/sys/class/enclosure/4:0:14:0/0:
active	fault  locate  power  status  type  uevent

/sys/class/enclosure/4:0:14:0/0/power:
wakeup

/sys/class/enclosure/4:0:14:0/1:
active	fault  locate  power  status  type  uevent
[...]

No sign of any "device" links in the "bay" directories.

Also the "fault" and "locate" files seem to do nothing, writing to them=
=20
doesn't make any lights flash.

If I try looking from the device side:

# ls /sys/block/sdaa/device
block:sdaa	evt_media_change  modalias     rev		     subsystem
bsg:4:0:11:0	generic		  model        scsi_device:4:0:11:0  timeout
bus		iocounterbits	  power        scsi_disk:4:0:11:0    type
delete		iodone_cnt	  queue_depth  scsi_generic:sg29     uevent
device_blocked	ioerr_cnt	  queue_type   scsi_level	     vendor
driver		iorequest_cnt	  rescan       state

No sign of an enclosure.

I've tried with a Debian  2.6.26-2-xen-amd64 kernel, and a 2.6.31 I=20
build myself.

Any clues about what I should to to diagnose this problem?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
