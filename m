From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [RESEND][PATCH 0/4] scsi_dh: Fix for handler attach and code clean up
Date: Thu, 3 Nov 2011 11:51:06 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DBE60@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:29701 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab1KCPvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 11:51:16 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

Resubmitting the patches after the comments.  Added the TPGS check in emc and
rdac handlers. Rest is same as before..

These series of patches handles following things..
1. Fixes handler attach issue.
2. Introduces match function for all the handlers
3. cleans up the scsi_dh code 

I have noticed the first problem during our multipath testing. We found that during
the lun discovery there were lots of error messages like below..

Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]  Sense Key : Illegal
Request [current]
Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]  <<vendor>> ASC=0x94
ASCQ=0x1ASC=0x94 ASCQ=0x1
Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav] CDB: Read(10): 28 00 00
00 00 00 00 00 80 00
Oct 25 08:24:43 kswm-mihosi kernel: end_request: I/O error, dev sdav, sector 0

These messages were coming in spite of having scsi_dh_rdac in initrd.  Reason
for these errors are due to device handler not being attached properly. If the
device handler was attached then the I/O's should not go to passive paths.

Investigating further we found that there errors started with the introduction
of these patches below.

http://www.spinics.net/lists/linux-scsi/msg54284.html
or
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=6c3633d08acf514e2e89aa95d2346ce9d64d719a

This patch introduces the match function for device handlers. But the match function
was added only to scsi_dh_alua handler.

Reason for the failure is, if the match function is not available then scsi_dh calls
scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model, SCSI_DEVINFO_DH)
which compares the exact vendor and product strings from sdev(which comes from inquiry).

While setting up the scsi_dev_info, handlers use the short strings(example below).
Look at scsi_register_device_handler code. If  you look closely the handlers have
only first few characters of the model string. So, scsi_get_device_flags_keyed
fails and handler will not be attached. This applies to all the handlers.

Example :

        Strings in scsi_dh_rdac handler..
                    {"IBM", "1746"},

        Actual string..
                     "IBM", "1746      FAStT"

Couple of ways we can fix this problem.
1. List the complete model strings in handlers for all the products.
2. Introduce match function for all the handler and remove the call to scsi_get_device_flags_keyed.

I think the option 2 is the best way to fix this problem. This removes lot of code in scsi_dh and 
simplifies the things..

TESTED the patches on NetApp E series storage.


