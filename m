Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2843FC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 19:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F203D21BE5
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 19:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407741AbgLLTdg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:33:36 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:37496 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404498AbgLLTdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Dec 2020 14:33:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2DE9C1280862;
        Sat, 12 Dec 2020 11:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607801576;
        bh=ySLxiaULiztpp+29NfcC4MnDIuxzi3G/V8W5xOLkf2A=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rAN79vKowMb1Ut1iHYA03ED/PNk3iK4xHVYVhntJG853cPTPTyOdOjqbV6g+uOTxl
         0YXUCQuYZIJDv4/x0VCyAAk9iacydBsYwVBJ8DQr1aHWplfXHaPhONYce0cwi0bwM1
         JSR6exo38dOSyllaqkHXkwlGsoCor1RtuzPHhlNw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HbFaAmR6yZTN; Sat, 12 Dec 2020 11:32:56 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C25671280817;
        Sat, 12 Dec 2020 11:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1607801576;
        bh=ySLxiaULiztpp+29NfcC4MnDIuxzi3G/V8W5xOLkf2A=;
        h=Message-ID:Subject:From:To:Date:From;
        b=rAN79vKowMb1Ut1iHYA03ED/PNk3iK4xHVYVhntJG853cPTPTyOdOjqbV6g+uOTxl
         0YXUCQuYZIJDv4/x0VCyAAk9iacydBsYwVBJ8DQr1aHWplfXHaPhONYce0cwi0bwM1
         JSR6exo38dOSyllaqkHXkwlGsoCor1RtuzPHhlNw=
Message-ID: <a66d77104855fe9cec651d3c51aef288c2676dc2.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.10-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 12 Dec 2020 11:32:54 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five small fixes: four in drivers: hisi_sas: fix internal queue
timeout, be2iscsi: revert a prior fix causing problems, bnx2i: add
missing dependency, storvsc: late arriving revert of a problem fix, and
one in the core.  The core one is a minor change to stop paying
attention to the busy count when returning out of resources because
there's a race window where the queue might not restart due to missing
returning I/O.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Andrea Parri (Microsoft) (1):
      Revert "scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()"

Dan Carpenter (1):
      scsi: be2iscsi: Revert "Fix a theoretical leak in beiscsi_create_eqs()"

Ming Lei (1):
      scsi: core: Fix race between handling STS_RESOURCE and completion

Randy Dunlap (1):
      scsi: bnx2i: Requires MMU

Xiang Chen (1):
      scsi: hisi_sas: Select a suitable queue for internal I/Os

And the diffstat:

 drivers/scsi/be2iscsi/be_main.c        | 4 ++--
 drivers/scsi/bnx2i/Kconfig             | 1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++++
 drivers/scsi/scsi_lib.c                | 3 +--
 drivers/scsi/storvsc_drv.c             | 5 -----
 6 files changed, 15 insertions(+), 9 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 202ba925c494..5c3513a4b450 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3020,7 +3020,6 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
-		mem->dma = paddr;
 		mem->va = eq_vaddress;
 		ret = be_fill_queue(eq, phba->params.num_eq_entries,
 				    sizeof(struct be_eq_entry), eq_vaddress);
@@ -3030,6 +3029,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 			goto create_eq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_eq_create(&phba->ctrl, eq,
 					    BEISCSI_EQ_DELAY_DEF);
 		if (ret) {
@@ -3086,7 +3086,6 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
-		mem->dma = paddr;
 		ret = be_fill_queue(cq, phba->params.num_cq_entries,
 				    sizeof(struct sol_cqe), cq_vaddress);
 		if (ret) {
@@ -3096,6 +3095,7 @@ static int beiscsi_create_cqs(struct beiscsi_hba *phba,
 			goto create_cq_error;
 		}
 
+		mem->dma = paddr;
 		ret = beiscsi_cmd_cq_create(&phba->ctrl, cq, eq, false,
 					    false, 0);
 		if (ret) {
diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
index 75ace2302fed..0cc06c2ce0b8 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_BNX2_ISCSI
 	depends on NET
 	depends on PCI
 	depends on (IPV6 || IPV6=n)
+	depends on MMU
 	select SCSI_ISCSI_ATTRS
 	select NETDEVICES
 	select ETHERNET
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c8dd8588f800..274ccf18ce2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -452,6 +452,12 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		blk_tag = blk_mq_unique_tag(scmd->request);
 		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 		*dq_pointer = dq = &hisi_hba->dq[dq_index];
+	} else if (hisi_hba->shost->nr_hw_queues)  {
+		struct Scsi_Host *shost = hisi_hba->shost;
+		struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+		int queue = qmap->mq_map[raw_smp_processor_id()];
+
+		*dq_pointer = dq = &hisi_hba->dq[queue];
 	} else {
 		*dq_pointer = dq = sas_dev->dq;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7133ca859b5e..960de375ce69 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2452,6 +2452,11 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto free_irq_vectors;
 		}
+		cq->irq_mask = pci_irq_get_affinity(pdev, i + BASE_VECTORS_V3_HW);
+		if (!cq->irq_mask) {
+			dev_err(dev, "could not get cq%d irq affinity!\n", i);
+			return -ENOENT;
+		}
 	}
 
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 60c7a7d74852..03c6d0620bfd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1703,8 +1703,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	case BLK_STS_RESOURCE:
 	case BLK_STS_ZONE_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
-		    scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 99c8ff81de74..ded00a89bfc4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1246,11 +1246,6 @@ static void storvsc_on_channel_callback(void *context)
 		request = (struct storvsc_cmd_request *)
 			((unsigned long)desc->trans_id);
 
-		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) - vmscsi_size_delta) {
-			dev_err(&device->device, "Invalid packet len\n");
-			continue;
-		}
-
 		if (request == &stor_device->init_request ||
 		    request == &stor_device->reset_request) {
 			memcpy(&request->vstor_packet, packet,

