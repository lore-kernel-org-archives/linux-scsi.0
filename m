Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7861C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 10:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjEKKKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 May 2023 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbjEKKKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2023 06:10:13 -0400
X-Greylist: delayed 487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 May 2023 03:10:10 PDT
Received: from forward205c.mail.yandex.net (forward205c.mail.yandex.net [178.154.239.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29D66E9D
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 03:10:10 -0700 (PDT)
Received: from forward100a.mail.yandex.net (forward100a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d100])
        by forward205c.mail.yandex.net (Yandex) with ESMTP id 424144D322
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 13:02:03 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2a:210:0:640:45a:0])
        by forward100a.mail.yandex.net (Yandex) with ESMTP id E6738463CC
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2023 13:01:59 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id x1TnbGqDfCg0-vopUR7Vj;
        Thu, 11 May 2023 13:01:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scst.dev; s=mail; t=1683799319;
        bh=JjxnK6IrmJ8ybZqL0CBMYujCK1ZS/E+3BK8/5493khY=;
        h=Subject:From:To:Date:Message-ID;
        b=dIpdOH9YI5iEBeSBQPMF8jdB8T+RpLCpASECeJfJIsNb8jFDvOb9V8ZOcsRFkqo0H
         6u3Qaju9g6kfBLiYP50Aql40JApiT77m4YSF0r/SmN9B2NHZtAo6N4PX1fDYFbcR5f
         ERVyPSfH2r7Zn1EXdVnqqLon/Y6J2mRcLSudYn3I=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@scst.dev
Message-ID: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
Date:   Thu, 11 May 2023 13:02:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     linux-scsi@vger.kernel.org
From:   Gleb Chesnokov <gleb.chesnokov@scst.dev>
Subject: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
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

Fixes: 1d201c81d4cc ("scsi: qla2xxx: Select qpair depending on which CPU 
post_cmd() gets called")

Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
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
+    bool cpu_mapped;
      struct qla_fw_resources fwres ____cacheline_aligned;
      struct  qla_buf_pool buf_pool;
      u32    cmd_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_init.c 
b/drivers/scsi/qla2xxx/qla_init.c
index ec0423ec6681..1a955c3ff3d6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9426,6 +9426,9 @@ struct qla_qpair *qla2xxx_create_qpair(struct 
scsi_qla_host *vha, int qos,
          qpair->rsp->req = qpair->req;
          qpair->rsp->qpair = qpair;

+        if (!qpair->cpu_mapped)
+            qla_cpu_update(qpair, raw_smp_processor_id());
+
          if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
              if (ha->fw_attributes & BIT_4)
                  qpair->difdix_supported = 1;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h 
b/drivers/scsi/qla2xxx/qla_inline.h
index cce6e425c121..a6e2c7d4ff87 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -538,12 +538,18 @@ qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,

      if (!ha->qp_cpu_map)
          return;
+
      mask = pci_irq_get_affinity(ha->pdev, msix->vector_base0);
+    if (!mask)
+        return;
+
      qpair->cpuid = cpumask_first(mask);
      for_each_cpu(cpu, mask) {
          ha->qp_cpu_map[cpu] = qpair;
      }
      msix->cpuid = qpair->cpuid;
+
+    qpair->cpu_mapped = true;
  }

  static inline void
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 71feda2cdb63..245e3a5d81fd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3770,6 +3770,9 @@ void qla24xx_process_response_queue(struct 
scsi_qla_host *vha,

      if (rsp->qpair->cpuid != smp_processor_id() || 
!rsp->qpair->rcv_intr) {
          rsp->qpair->rcv_intr = 1;
+
+        if (!rsp->qpair->cpu_mapped)
+            qla_cpu_update(rsp->qpair, raw_smp_processor_id());
      }

  #define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)            \
-- 
2.40.1
