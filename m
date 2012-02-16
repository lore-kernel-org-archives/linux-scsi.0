From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: need help solving mpt2sas target unplug can hang worker thread
Date: Thu, 16 Feb 2012 10:42:07 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E49FF7F@inbmail02.lsi.com>
References: <20120214131541.GA28005@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47970 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab2BPFMP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 00:12:15 -0500
In-Reply-To: <20120214131541.GA28005@crust.elkhashab.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ayman El-Khashab <ayman@elkhashab.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Please provide the mpt2sas driver version that you are also using. 

Please set the driver logging level to 0x421F8 (echo 0x421F8 > /sys/module/mpt2sas/parameters/logging_level) and the scsi logging level to 0x180000F1 (echo 0x180000F1 > /proc/sys/dev/scsi/logging_level) and recreate the issue and provide the var/log/message.

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ayman El-Khashab
Sent: Tuesday, February 14, 2012 6:46 PM
To: linux-scsi@vger.kernel.org
Subject: need help solving mpt2sas target unplug can hang worker thread 

I'm doing this on powerpc/4xx (if that matters).  Basically
I can normally hot-plug or hot-remove disks from the mpt2sas
just fine.  It is easy to replicate on my system if I unplug
the drive during the enumeration process.  Based on what I
see, I gather it is in the scsi layer rather than the
mpt2sas driver, but I don't have that much experience in the
scsi driver to be certain.

There are 2 cases that cause this ...

1) Device never finishes the initial enumerate sequence
because there is something wrong with the drive, firmware on
the drive, etc.  

2) The drive was unplugged before the enumeration completes.

*MAYBE* this is addressed by the null pointer dereference
patches I've seen posted.  In any case, I get the thread
dumping every 120s, I cannot remove the driver module from
the kernel.  My only option is to reboot.  It would be great
if it didn't happen at all, but even if I can reset the
controller and get things back to a happier time, that would
be perfect.  Any tips for how I might accomplish that or is
there a particular patch I should take a look at / apply?

Thanks
Ayman
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
