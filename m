From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: RE: Still havind major MVSAS issues.
Date: Thu, 6 May 2010 11:31:50 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF7F36EFEE0C@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>
       <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>
       <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>
       <CDBC7B5488B245E689B39330542DC434@usish.com.cn>
       <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>
       <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>
       <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org>
 <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:60122 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0EFGB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2010 02:01:56 -0400
In-Reply-To: <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>, "jelledejong@powercraft.nl" <jelledejong@powercraft.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yugendranath R Singh - ERS, HCL Tech" <yugendranath.s@hcl.in>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.in>, "Mohan Kumar TG, ERS,HCLTech" <mohankumartg@hcl.in>

Hi Caspar/Jelle,

Please provide me the following details.

1. Is this is the problem with only WD SATA drives? (I don't have WD SATA drives to reproduce this issue.)
2. Whether the problem is with direct attached SATA drives or drives connected in expanders also?
3. Could you please provide me the "dmesg" log or "/var/log/messages" log.  
4. How much the capacity of SATA drives connected to controller?
5. Your HBA is having 6440 chipset? 

--Srini.

-----Original Message-----
From: Caspar Smit [mailto:c.smit@truebit.nl] 
Sent: Friday, April 09, 2010 9:22 PM
To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
Cc: linux-scsi@vger.kernel.org
Subject: Still havind major MVSAS issues.

Hi Srinivas (and others),

I'm still having troubles with SATA disks using the mvsas driver. Maybe
you read my previous posts about the WD disks.

The problem is easyly recreated:

1) Create a software raidset (i used a 5 disk raid6 as a test)

2) Create an XFS filesystem on it. (mkfs.xfs -f /dev/md0)

I used the 2.6.32 kernel source using your patch.
I get these messages:

[ 5855.816019] drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc= 5 [
5857.820002] mvsas 0000:04:00.0: Phy7 : No sig fis
[ 5858.024006] drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for
device[4]:rc= 0
[ 5858.024014] ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ
0xb/00/00
[ 5858.028001] ata12.00: device reported invalid CHS sector 0
[ 5858.028001] ata12: status=0x01 { Error }
[ 5858.028001] ata12: error=0x04 { DriveStatusError }
[ 7201.988017] ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ
0xb/00/00
[ 7201.988114] ata18: status=0x01 { Error }
[ 7201.988276] ata18: error=0x04 { DriveStatusError }

Especially the latest 3 messages I got loads more of those on another set
of disks. The creation of an XFS filesystem can take up to 15 minutes in
stead of the normal 15 seconds!

When I use the stock 2.6.32 kernel driver without your patch i get these
errors:

[ 6384.816015]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
[ 6384.816020]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
[ 6415.804016]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
[ 6415.804021]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
[ 6445.816017]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
[ 6445.816022]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5
[ 6476.804015]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1669:mvs_abort_task:rc= 5
[ 6476.804020]
/tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/drivers/scsi/mvsas/mv_sas.c
1608:mvs_query_task:rc= 5

So there has definatly changed something with the patch.

Further more during the detection of disks during boot I get these
messages for almost any SATA disk:

Mar 31 14:34:17 test ata_id[3752]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-112'
Mar 31 14:34:17 test ata_id[3765]: main: HDIO_GET_IDENTITY failed for
'/dev/.tmp-8-128'

If you need more info let me know.

Kind regards,
Caspar Smit

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
