From: Praveen Murali <pmurali@logicube.com>
Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Wed, 16 Oct 2013 15:17:23 -0700
Message-ID: <525F1073.2080506@logicube.com>
References: <1340044537.3712.23.camel@praveen-debian.lg.local>  <CAA9_cmeo=2Jjyp2DSwBDM=toTydMbLHJ+J7h2UXQYb2YmV+tzg@mail.gmail.com>  <1340296918.3712.54.camel@praveen-debian.lg.local>  <CABE8wwtUE7ZvR=zYGc+HCL8tUi3QE2N+-k1UP+8ow9MYk-kWGg@mail.gmail.com>  <1340298338.3712.55.camel@praveen-debian.lg.local>  <CAA9_cmf5PwhE7XizaTwx8TdbEBYKsLyES-Gc75n-VoUXhKTtgg@mail.gmail.com>  <7B4019BE-6198-47EF-804B-A7EF9889A22D@logicube.com> <1381959958.1864.26.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040207040207040801010303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:50196 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3JPWRQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 18:17:16 -0400
In-Reply-To: <1381959958.1864.26.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yuxiangl@marvell.com
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

This is a multi-part message in MIME format.
--------------040207040207040801010303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xiang, Can you please take a look at the attached patch and ack it?

Thanks,
Praveen

On 10/16/2013 02:45 PM, James Bottomley wrote:
> On Tue, 2013-10-15 at 19:40 -0700, Praveen Murali wrote:
>> Yes, I checked that today and was meaning to ask you about it. :)
> Ideally, I need someone from Marvell to ack it ... can you prod them?
>
> Thanks,
>
> James
>
>


--------------040207040207040801010303
Content-Type: text/x-diff;
 name="Fix-mvsas-disk-detection-issues.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Fix-mvsas-disk-detection-issues.patch"

>From 6ad9cf691f9d11e8c6de332efc35bd945c0f2840 Mon Sep 17 00:00:00 2001
From: Praveen Murali <pmurali@logicube.com>
Date: Thu, 21 Jun 2012 09:57:03 -0700
Subject: [PATCH v2] Fix mvsas SATA disk detection issues

 I am using the Marvell SAS HBA (MV64460/64461/64462 System Controller,
Revision B (rev 01)), on a system running Ubuntu 12.04 stock kernel. And
i am seeing some drive detection issues with SATA drives, mostly during
hotplugging the drives; the issue gets exaggerated when we keep removing
and plugging in drives.

>From dmesg, after starting the LibATA debugs, it looks like the
ata_eh_revalidate_and_attach fails because ata_dev_read_id fails to get
the IDENTIFY command response. I see "both IDENTIFYs aborted, assuming
NODEV" for all these drives that go undetected. At this point, if I
unload and reload the mvsas driver, these drives detect fine. So, I
hooked up a SATA analyzer between the HBA and one of the drives, and
restarted the test. From what I can see, even though the drive responds
to the IDENTIFY command, the upper layer detects an error and discards
the response. On further debugging it was evident that the error was
being detected in the FIS.

 After going thru the mvsas driver, I see that during init the driver 
allocates a DMA area for an FIS pool (for as many as 33 FIS's) and initializes 
it to 0. And each ATA command is allocated a FIS area from this pool during
the command prep; but its never cleared.

The fix is to cleanup and prepare the FIS index before issuing the ATA
command (during prep: mvs_task_prep_ata).
---
 drivers/scsi/mvsas/mv_sas.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..73d9816 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -458,6 +458,11 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 			mvi_dev->device_id);
 		return -EBUSY;
 	}
+
+	/* cleanup and prepare the allocated FIS index */
+	memset( SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset), 0, 
+				sizeof(struct dev_to_host_fis) );
+
 	slot = &mvi->slot_info[tag];
 	slot->tx = mvi->tx_prod;
 	del_q = TXQ_MODE_I | tag |
-- 
1.7.10


--------------040207040207040801010303--
