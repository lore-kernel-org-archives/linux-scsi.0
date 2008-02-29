From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] mvsas: fix default can_queue
Date: Fri, 29 Feb 2008 12:01:53 -0600
Message-ID: <1204308113.4003.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40371 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbYB2SCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 13:02:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I noticed that the current marvell sas driver wasn't performing very
well.  It turns out that it's setting can_queue not in the SCSI host,
but in its own internal data structure, meaning it's always operating
with a global queue depth of one.  This patch raises it to what the code
seemed to be intending ... although I think can_queue should be
MVS_CHIP_SLOT_SZ - 1 (without the divide by two)?

The good news is that with this change, I'm getting a respectable
throughput on the fio hammer test; plus zapping random phy resets across
the disk triggers error handler recovery correctly (so far).

I'm having less happy results with a SATAPI DVD ... it looks like the
initial IDENTIFY goes across just fine, but that we stall on the other
SCSI commands ... I'm still investigating this one.

James

---

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 5ec0665..a128f67 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -618,7 +618,6 @@ struct mvs_info {
 	struct mvs_phy		phy[MVS_MAX_PHYS];
 	struct mvs_port		port[MVS_MAX_PHYS];
 
-	u32			can_queue;	/* per adapter */
 	u32			tag_out;	/*Get*/
 	u32			tag_in;		/*Give*/
 };
@@ -2150,7 +2149,7 @@ static struct mvs_info *__devinit mvs_alloc(struct pci_dev *pdev,
 	mvi->sas.num_phys = chip->n_phy;
 	mvi->sas.lldd_max_execute_num = MVS_CHIP_SLOT_SZ - 1;
 	mvi->sas.lldd_queue_size = MVS_QUEUE_SIZE;
-	mvi->can_queue = (MVS_CHIP_SLOT_SZ >> 1) - 1;
+	mvi->shost->can_queue = (MVS_CHIP_SLOT_SZ >> 1) - 1;
 	mvi->sas.lldd_ha = mvi;
 	mvi->sas.core.shost = mvi->shost;
 


