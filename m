From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [ PATCH 3/4 ] mpt fusion prevent DV deadlock
Date: Thu, 30 Oct 2008 23:28:31 +0530
Message-ID: <B73941C4DE6A3D4EA1AE128E9565E244238A270570@inbmail01.lsi.com>
References: <200809231527.38105.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43424 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbYJ3R6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 13:58:46 -0400
In-Reply-To: <200809231527.38105.bs@q-leap.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Bernd,
This looks OK for me, but I am not sure whether we should take this work-around to the upstream driver. As this is a workaround to avoid the deadlock and not the actual fix. I hope you can retain this with your in-house driver.

May be James can comment whether we can take this into MPT driver or not?

Thanks
Sathya

-----Original Message-----
From: Bernd Schubert [mailto:bs@q-leap.de]
Sent: Tuesday, September 23, 2008 6:58 PM
To: Linux SCSI Mailing List
Cc: Moore, Eric; Prakash, Sathya; James Bottomley; DL-MPT Fusion Linux
Subject: [ PATCH 3/4 ] mpt fusion prevent DV deadlock

The mpt fusion driver will do a domain revalidation on an ioc reset, but this DV might cause a live deadlock. The problem has been entirely analyzed in this thread http://marc.info/?t=118039577800004, but so far none of the suggested solutions has been implemented.
This patch simply disables the domain revalidation, if it does know it will run into the deadlock.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

 drivers/message/fusion/mptspi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.26/drivers/message/fusion/mptspi.c
===================================================================
--- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.26/drivers/message/fusion/mptspi.c
@@ -672,12 +672,24 @@ static void mptspi_dv_device(struct _MPT  {
        VirtTarget *vtarget = scsi_target(sdev)->hostdata;
        MPT_ADAPTER *ioc = hd->ioc;
+       unsigned long nr_requests = sdev->request_queue->nr_requests;
+       struct request_list *rl = &sdev->request_queue->rq;

        /* no DV on RAID devices */
        if (sdev->channel == 0 &&
            mptspi_is_raid(hd, sdev->id))
                return;

+       if (rl->count[0] + 1 >= nr_requests
+       ||  rl->count[1] + 1 >= nr_requests) {
+               /* we must NOT do a DV after an error recovery, when we
+                * don't have left a space in the request list, since
+                * this will cause a live dead lock */
+               starget_printk(KERN_INFO, scsi_target(sdev), MYIOC_s_FMT
+                   "Skipping DV, to prevent dead lock!\n", ioc->name);
+               return;
+       }
+
        /* If this is a piece of a RAID, then quiesce first */
        if (sdev->channel == 1 &&
            mptscsih_quiesce_raid(hd, 1, vtarget->channel, vtarget->id) < 0) {



--
Bernd Schubert
Q-Leap Networks GmbH
