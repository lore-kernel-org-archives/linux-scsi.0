Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86927C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 08:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjEQIV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 04:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjEQIV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 04:21:57 -0400
Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC8B358B
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 01:21:54 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2007:0:640:bf5a:0])
        by forward502b.mail.yandex.net (Yandex) with ESMTP id D1E415F5ED;
        Wed, 17 May 2023 11:21:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id pLX6eJAWn0U0-BzUi45sl;
        Wed, 17 May 2023 11:21:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scst.dev; s=mail; t=1684311712;
        bh=Hc7Ct6IFJnjDbYyF/0SWWP9trwad6fyprnowYmZrI7c=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=BaRT7bNLO+HwjDhixNFHGWBnVbw4KOlGZo/F2cQg/MA1Huhmqhe2mQb1QR3JLHEPL
         A9S2MOXCFy3TZGI52sNviinF8rA/g4Vx4J8wvk/P914jre0Sn6k8F/TQL6WdBMHaxH
         w/vfl8tar+Oeda2wPXlHdthFM6pq2Omze5DvBIu4=
Authentication-Results: mail-nwsmtp-smtp-production-main-85.iva.yp-c.yandex.net; dkim=pass header.i=@scst.dev
Message-ID: <56b416f2-4e0f-b6cf-d6d5-b7c372e3c6a2@scst.dev>
Date:   Wed, 17 May 2023 11:22:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
 <yq1h6sbvjne.fsf@ca-mkp.ca.oracle.com>
From:   Gleb Chesnokov <gleb.chesnokov@scst.dev>
In-Reply-To: <yq1h6sbvjne.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When target mode is enabled, the pci_irq_get_affinity() function may return
a NULL value in qla_mapq_init_qp_cpu_map() due to the qla24xx_enable_msix()
code that handles IRQ settings for target mode. This leads to a crash due
to a NULL pointer dereference.

This patch fixes the issue by adding a check for the NULL value returned
by pci_irq_get_affinity() and introducing a 'cpu_mapped' boolean flag to
the qla_qpair structure, ensuring that the qpair's CPU affinity is updated
when it has not been mapped to a CPU.

Fixes: 1d201c81d4cc ("scsi: qla2xxx: Select qpair depending on which CPU post_cmd() gets called")

Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
  drivers/scsi/qla2xxx/qla_def.h    | 1 +
  drivers/scsi/qla2xxx/qla_init.c   | 3 +++
  drivers/scsi/qla2xxx/qla_inline.h | 6 ++++++
  drivers/scsi/qla2xxx/qla_isr.c    | 3 +++
  4 files changed, 13 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index df5e5b7fdcfe..84aa3571be6d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3796,6 +3796,7 @@ struct qla_qpair {
      uint64_t retry_term_jiff;
      struct qla_tgt_counters tgt_counters;
      uint16_t cpuid;
+    bool cpu_mapped;
      struct qla_fw_resources fwres ____cacheline_aligned;
      struct  qla_buf_pool buf_pool;
      u32    cmd_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ec0423ec6681..1a955c3ff3d6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9426,6 +9426,9 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
          qpair->rsp->req = qpair->req;
          qpair->rsp->qpair = qpair;

+        if (!qpair->cpu_mapped)
+            qla_cpu_update(qpair, raw_smp_processor_id());
+
          if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
              if (ha->fw_attributes & BIT_4)
                  qpair->difdix_supported = 1;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index cce6e425c121..a6e2c7d4ff87 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -538,12 +538,18 @@ qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,

      if (!ha->qp_cpu_map)
          return;
+
      mask = pci_irq_get_affinity(ha->pdev, msix->vector_base0);
+    if (!mask)
+        return;
+
      qpair->cpuid = cpumask_first(mask);
      for_each_cpu(cpu, mask) {
          ha->qp_cpu_map[cpu] = qpair;
      }
      msix->cpuid = qpair->cpuid;
+
+    qpair->cpu_mapped = true;
  }

  static inline void
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 71feda2cdb63..245e3a5d81fd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3770,6 +3770,9 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,

      if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
          rsp->qpair->rcv_intr = 1;
+
+        if (!rsp->qpair->cpu_mapped)
+            qla_cpu_update(rsp->qpair, raw_smp_processor_id());
      }

  #define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)            \
-- 
2.40.1

