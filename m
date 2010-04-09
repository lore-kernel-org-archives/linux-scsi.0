From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Still havind major MVSAS issues.
Date: Fri, 9 Apr 2010 17:52:07 +0200 (CEST)
Message-ID: <1228.77.248.79.78.1270828327.squirrel@ketsers.dhs.org>
References: <53271.87.210.74.220.1270040583.squirrel@ketsers.dhs.org>   
    <7BF8FE1BFB7440B29ECD3D15FB0A4E8C@usish.com.cn>   
    <1068.77.248.79.78.1270102668.squirrel@ketsers.dhs.org>   
    <CDBC7B5488B245E689B39330542DC434@usish.com.cn>   
    <1543.77.248.79.78.1270108509.squirrel@ketsers.dhs.org>   
    <4BB50A92.3030205@gmx.net> <4BB53983.5050309@cisco.com>   
    <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:48625 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0DIPwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2010 11:52:45 -0400
In-Reply-To: <43193.87.210.74.220.1270217681.squirrel@ketsers.dhs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: linux-scsi@vger.kernel.org

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
