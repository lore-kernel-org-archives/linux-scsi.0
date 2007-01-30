From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/12] sas_ata: Don't copy aic94xx's sactive to ata_port
Date: Tue, 30 Jan 2007 01:18:44 -0800
Message-ID: <20070130091844.31530.10111.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48788 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965453AbXA3JQM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:12 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9GBsY022994
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:11 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GBuT299088
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:11 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GAK8030904
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:10 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Since the aic94xx sequencer assigns its own NCQ tags to ATA commands, it
no longer makes any sense to copy the sactive field in the STP response
to ata_port->sactive, as that will confuse libata.  Also, libata seems
to be capable of managing sactive on its own.

The attached patch gets rid of one of the causes of the BUG messages in
ata_qc_new, and seems to work without problems on an IBM x206m.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index c8af884..16c3e5a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -106,7 +106,6 @@ static void sas_ata_task_done(struct sas
 		dev->sata_dev.sstatus = resp->sstatus;
 		dev->sata_dev.serror = resp->serror;
 		dev->sata_dev.scontrol = resp->scontrol;
-		dev->sata_dev.ap->sactive = resp->sactive;
 	} else if (stat->stat != SAM_STAT_GOOD) {
 		ac = sas_to_ata_err(stat);
 		if (ac) {
