Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45213C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 163F420720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JAI1K0VT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgGMHrq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbgGMHrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2F3C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:16 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j4so14665429wrp.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n+FlrssXUyf+27P3zqpNeadQUF1GbyakCHuF+5DpqII=;
        b=JAI1K0VTERudzk6GJ1ZmjdlChl5VoIE7Y7GxSc4kx/Mp7jK189qmRbjTzXPPWyPtBY
         b2/xN3dpP92Euf1dKwauNt1jek56KN1dDgEcjAFt6koBMEkdeyYYhasSyUc6OiwfhhlU
         2aIOjw0mTVor6dH/45+rkWwB8qo9wJg5/u4iyHNZYpuHLXob8gFIULGhEJZmi4EGIb6e
         WD+71pgeSs+GchHyaqU0D4YKXqq2kWIsgxayA7MGvA65ANYLwCBaMEuEf7R6fvikYQmU
         DMp1IiEoR9NdwYpw6sR6XLUx6f1i8V4IpWqUtGmEtJqQ+hBr6MD9da6y1PJjRLkwQKUr
         1QQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+FlrssXUyf+27P3zqpNeadQUF1GbyakCHuF+5DpqII=;
        b=mYbAqsQLgNDbDA8ylpe5abpP2XgYRAQWxDP/D9MSF8hLqbpLc7XcmunbU4Rr8HJZAR
         rVYA4MSbssJO/pqLR8ZWDJ9AhZZuLdYQbU+6Ja2loCQZIEwpSlvGG/ZQckuMKPiF+Iph
         Khi6E/PcJK3tcKlx0J0Y4FLM8lnCs2nNK/BMZSD56iihRuu+wJWx0xHBZKF74qez1cpq
         GY1OD4wBx16OeArW8w7Wgu3ws17Ix+IsydEwNZq3qAZqi1p7VJCV04FhY/zRci6eZjsG
         uJD8+md/BTEhrukzHmq7Izy/+RQNYy4trY6TxiqdjLWXMlk99gqfgN564iEaidB6PxKe
         poUQ==
X-Gm-Message-State: AOAM533PEHV3Ks/2L5SoVzAxM2A/ubZfFNzbIvVSOdnMLkl5D9t1QSam
        UEJNgB8Fy/1tR8fhAqjwMnKm6A==
X-Google-Smtp-Source: ABdhPJxY/puDN7AjiJdu7oEeFlKR/U/nu85jzFcw+vDAll5/rYagejuABbOtGf4N+Wuh8Nm1BWl6tQ==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr78271778wrw.19.1594626435718;
        Mon, 13 Jul 2020 00:47:15 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>,
        Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 26/29] scsi: pm8001: pm8001_init: Demote obvious misuse of kerneldoc and update others
Date:   Mon, 13 Jul 2020 08:46:42 +0100
Message-Id: <20200713074645.126138-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

More bitrot issues with function documentation not keeping up with API changes.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_init.c:64: warning: cannot understand function prototype: 'const struct pm8001_chip_info pm8001_chips[] = '
 drivers/scsi/pm8001/pm8001_init.c:86: warning: cannot understand function prototype: 'struct scsi_host_template pm8001_sht = '
 drivers/scsi/pm8001/pm8001_init.c:115: warning: cannot understand function prototype: 'struct sas_domain_function_template pm8001_transport_ops = '
 drivers/scsi/pm8001/pm8001_init.c:212: warning: Function parameter or member 'irq' not described in 'pm8001_interrupt_handler_msix'
 drivers/scsi/pm8001/pm8001_init.c:237: warning: Function parameter or member 'irq' not described in 'pm8001_interrupt_handler_intx'
 drivers/scsi/pm8001/pm8001_init.c:265: warning: Function parameter or member 'ent' not described in 'pm8001_alloc'
 drivers/scsi/pm8001/pm8001_init.c:624: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_init_sas_add'
 drivers/scsi/pm8001/pm8001_init.c:624: warning: Excess function parameter 'chip_info' description in 'pm8001_init_sas_add'
 drivers/scsi/pm8001/pm8001_init.c:900: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_setup_msix'
 drivers/scsi/pm8001/pm8001_init.c:900: warning: Excess function parameter 'chip_info' description in 'pm8001_setup_msix'
 drivers/scsi/pm8001/pm8001_init.c:900: warning: Excess function parameter 'irq_handler' description in 'pm8001_setup_msix'
 drivers/scsi/pm8001/pm8001_init.c:981: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_request_irq'
 drivers/scsi/pm8001/pm8001_init.c:981: warning: Excess function parameter 'chip_info' description in 'pm8001_request_irq'

Cc: Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9e99262a2b9dd..20fa96cbc9d3d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 
 static struct scsi_transport_template *pm8001_stt;
 
-/**
+/*
  * chip info structure to identify chip key functionality as
  * encryption available/not, no of ports, hw specific function ref
  */
@@ -80,7 +80,7 @@ LIST_HEAD(hba_list);
 
 struct workqueue_struct *pm8001_wq;
 
-/**
+/*
  * The main structure which LLDD must register for scsi core.
  */
 static struct scsi_host_template pm8001_sht = {
@@ -109,7 +109,7 @@ static struct scsi_host_template pm8001_sht = {
 	.track_queue_depth	= 1,
 };
 
-/**
+/*
  * Sas layer call this function to execute specific task.
  */
 static struct sas_domain_function_template pm8001_transport_ops = {
@@ -129,9 +129,9 @@ static struct sas_domain_function_template pm8001_transport_ops = {
 };
 
 /**
- *pm8001_phy_init - initiate our adapter phys
- *@pm8001_ha: our hba structure.
- *@phy_id: phy id.
+ * pm8001_phy_init - initiate our adapter phys
+ * @pm8001_ha: our hba structure.
+ * @phy_id: phy id.
  */
 static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
 {
@@ -155,9 +155,8 @@ static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha, int phy_id)
 }
 
 /**
- *pm8001_free - free hba
- *@pm8001_ha:	our hba structure.
- *
+ * pm8001_free - free hba
+ * @pm8001_ha:	our hba structure.
  */
 static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 {
@@ -205,6 +204,7 @@ static void pm8001_tasklet(unsigned long opaque)
  * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
  * It obtains the vector number and calls the equivalent bottom
  * half or services directly.
+ * @irq: interrupt number
  * @opaque: the passed outbound queue/vector. Host structure is
  * retrieved from the same.
  */
@@ -230,6 +230,7 @@ static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 
 /**
  * pm8001_interrupt_handler_intx - main INTx interrupt handler.
+ * @irq: interrupt number
  * @dev_id: sas_ha structure. The HBA is retrieved from sas_has structure.
  */
 
@@ -257,8 +258,8 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
 
 /**
  * pm8001_alloc - initiate our hba structure and 6 DMAs area.
- * @pm8001_ha:our hba structure.
- *
+ * @pm8001_ha: our hba structure.
+ * @ent: PCI device ID structure to match on
  */
 static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 			const struct pci_device_id *ent)
@@ -615,7 +616,7 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
 
 /**
  * pm8001_init_sas_add - initialize sas address
- * @chip_info: our ha struct.
+ * @pm8001_ha: our ha struct.
  *
  * Currently we just set the fixed SAS address to our HBA,for manufacture,
  * it should read from the EEPROM
@@ -893,8 +894,7 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
 #ifdef PM8001_USE_MSIX
 /**
  * pm8001_setup_msix - enable MSI-X interrupt
- * @chip_info: our ha struct.
- * @irq_handler: irq_handler
+ * @pm8001_ha: our ha struct.
  */
 static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 {
@@ -975,7 +975,7 @@ static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
 
 /**
  * pm8001_request_irq - register interrupt
- * @chip_info: our ha struct.
+ * @pm8001_ha: our ha struct.
  */
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
-- 
2.25.1

