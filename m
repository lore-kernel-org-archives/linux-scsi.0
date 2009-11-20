From: "SRINIVAS NAGA VENKATASATYA PASAGADUGULA - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: LIBSAS/MVSAS: Issues with hot-plug Out/In of disks from cascading
 expanders while IO is going on
Date: Fri, 20 Nov 2009 18:51:35 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF3C2B1356B4@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:34214 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZKTNVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 08:21:44 -0500
Received: from gws07.hcl.in (unknown [127.0.0.1])
	by IMSA (Postfix) with ESMTP id 3C6C420F09E
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 18:51:59 +0530 (IST)
Received: from chn-hclin-ht01.CORP.HCL.IN (unknown [10.249.64.35])
	by gws07.hcl.in (Postfix) with ESMTP id 30D0720F0A0
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 18:51:59 +0530 (IST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I have some issues with hot-plug Out/In of disks from cascading expanders while IO is going on.
I'm using Adaptec ASC-1045/1405 which uses the Marvell 88SE6440 chip.

Test Set Up:
------------
    Cascading of edge expanders.
    Diskstress IO test tool.

Description:
--------------
1. For SATA: After freeing the slot info in mvs_abort_task ( ) function (same as in mvsas driver latest patch), its working as expected.
2. For SAS drives, still problem exists with hot-plugging of disks in expander while IO is going on.

Need Clarification:
----------------------
1. After hot plug out of disks from expanders, why we need to wait for timeout to happen then calling abort_task TMF to freeing the device info?

2. Once the broad cast signal is received why don't we freeing the entire device resources instead of waiting for timeout to happen?
      - Because it is taking long time to come out from IO Application and
        from fdisk -l.

3. In case of SAS why we are sending abort TMF to target which is already disconnected?
    (Note: Assumed there is no IT-Nexus support for both SAS and SATA)

Any inputs are highly appreciated.

Thanks
Srini


DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
