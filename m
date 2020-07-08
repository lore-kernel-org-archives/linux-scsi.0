Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B89C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB479207DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LdN2LCty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGHMDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbgGHMDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C52C08E763
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so40612825wrs.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g3n7m55npDtDZS6ysg5UOur5QEJUSKE4xUdCSnXfF9I=;
        b=LdN2LCtyGTzzQ+qlGdQvFqe+2zPotqSI9Imp8iDHZFNi/oyIhiVCezyF+yih5fiXay
         A/klLsVhEKRZbPDNWDywrbfBE8CDLi8fS9P6dR0aWlzRH/cNKr7H+KHD1kUGKWCAddpL
         EUNPqMf0EjIpSibosimkcdqLLGZKRN43OMT3YASWzcZ6aXGL5MG8yxS+fcn5TjBTgvf/
         VLs7o/Nc9WIz8moWJMc9F2QkEp5/JrWr2Tt48FvzDgduRMy3rSQZoqr5rlYAbqVGKLb9
         YcOEnf0YWXK1q8a3jhwdBcGl8/3ghj0+j90TDSbUxnuzoj1VZlfOsxeXfn1RuJKIL4in
         8QRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g3n7m55npDtDZS6ysg5UOur5QEJUSKE4xUdCSnXfF9I=;
        b=Rht9qbiXE3xWGyOY3zBK5VPqUeNZOr6uCwmEGpDzzEBk/UG6bUKdRD08n+ALy8XRcN
         amvyiHacpWatO4tbTEHYivgAoYJu1X7juFXYDVvYmjT71lq+JVM7ojlzkoHjt7e3AqQ2
         hm6+hhnNM/K0jpoGlqeL2FmJehu34DikNlFbwNCKnGF1hdD/0SrVgZBx/WoIgt8fp92K
         PEvYZOtHXCqEk+Xp5gKYzZkCinigembJ15M+mBn+Oe9ZdoT/o+/ttWDmFtDfNxXLnk80
         7V97ziaA1q/X3Pme6q6PW7WUSoesbXWuHaxiuNpemIDtOED1qtPfSJAjoVm4eEdSvmzb
         ahiw==
X-Gm-Message-State: AOAM53157mSJczctADwOzNcHiAbSJJE/in4oQBcly536oup/ya2EeSi8
        2AW5WMfvIZEE9ODmLMEbVsz5xA==
X-Google-Smtp-Source: ABdhPJyJeKaM/57Fr+Eq5QRy28Y3Git8JNtamFxzD6xH0ADsZksp3OmxVWOkjxgbV0mq32FaBVDgKA==
X-Received: by 2002:adf:e948:: with SMTP id m8mr59729897wrn.398.1594209785629;
        Wed, 08 Jul 2020 05:03:05 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:03:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>,
        Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Subject: [PATCH 27/30] scsi: pm8001: pm8001_init: Demote obvious misuse of kerneldoc and update others
Date:   Wed,  8 Jul 2020 13:02:18 +0100
Message-Id: <20200708120221.3386672-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
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

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>
Cc: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
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

