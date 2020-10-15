Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C44FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 11:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59C1212CC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 11:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="OEogEsYE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgJOLYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgJOLYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2020 07:24:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BFCC0613D2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 04:24:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so1814919pfp.13
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 04:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=+SMSmOjqLeOGTKKum05qnKuvd7Q9+0WPozSVKp+7TKk=;
        b=OEogEsYEm8fIVHz/dIQwcLZvAQlX+f/oQj6IUPviGjL3Vf16AO4AfmB4EBMZ0bQkw8
         wl3ZAaAUrtpdB2TiFlqflES4lddYyG3opakwYOxWbMNW964Vq7xroj0G7hLBsDrF3y5j
         1LAOk6YZag+Irs7ycSmB99iyBRjvx/a/wLF/HXSPg4wnLK52oh0jJUr0j7Jv5CYkYAGa
         SSqd6BVq+7fuaGEi4LColhNlmox4aYgZo8B2t2+W1L3z+R5tzhuOIPNQYNTiq3IgPMsV
         lCAQl6KQUuYV7SFArFNyedH/E3SY+FtBwsxBceaF6mcETWJyVr5x0M5SUBBW0aKZsTip
         oTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=+SMSmOjqLeOGTKKum05qnKuvd7Q9+0WPozSVKp+7TKk=;
        b=GrkftnHeK/mmiB275TlAN42Qq1ImA+w1USihBIMhmQlY5G58/rJaYlUZ7TYOOCifNv
         5+R23rRbzXh1rZoSVQzuC9EXD/mOhOSTDbSL14QqsJrIhXF8BW9XhFFjDI8IbUUwOo33
         5n2SQJdYAUP1ZO2LpWPPDe3yxWj4SL8CEgLFA9ATD8Suw3CCev6H9JBXu64iOnnW/3K+
         3YaqoIRuXdQzma7tSHyiT7kq7GEcE+6cIQKl90XQ9ZwUlEjkqhstfnl4xU4mR1KrCiAO
         ryyRjth5CWk7PB3PBQRpoENIIiCmAqaobtCIfpjxGZxCxjUwYMQnWOPFHuYTW1ElBnjn
         ScJw==
X-Gm-Message-State: AOAM530dA0a0aesCo5D+l7v6DkkgiefGoBCFZYNG6pppwcUkQPqRHtzO
        cnaWgraSO6zsMHKLWxhapk6kHtTLka8ecQ==
X-Google-Smtp-Source: ABdhPJxigQ1GlW/jOOkuZXTwRSWqIHmnzNOrt4zdlnaJ1LEUOgEAbkE1EKElmJQixhw/NHEwu9oxJQ==
X-Received: by 2002:a62:870a:0:b029:156:641e:c6c7 with SMTP id i10-20020a62870a0000b0290156641ec6c7mr3761187pfe.78.1602761062429;
        Thu, 15 Oct 2020 04:24:22 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id j37sm2955201pgi.20.2020.10.15.04.24.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 04:24:21 -0700 (PDT)
Message-ID: <06ee8b1a3c14f855c6dc2a2c0dc996d33ca41f50.camel@areca.com.tw>
Subject: [PATCH 1/1] scsi: arcmsr: Configure the default SCSI device command
 timeout value
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 16 Oct 2020 03:24:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

Configure the default SCSI device command timeout value.

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 5d054d5..0f6abd2 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -83,6 +83,7 @@ struct device_attribute;
 #define PCI_DEVICE_ID_ARECA_1886	0x188A
 #define	ARCMSR_HOURS			(1000 * 60 * 60 * 4)
 #define	ARCMSR_MINUTES			(1000 * 60 * 60)
+#define ARCMSR_DEFAULT_TIMEOUT		90
 /*
 **********************************************************************************
 **
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 1e358d9..555f55f 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -99,6 +99,10 @@ static int set_date_time = 0;
 module_param(set_date_time, int, S_IRUGO);
 MODULE_PARM_DESC(set_date_time, " send date, time to iop(0 ~ 1), set_date_time=1(enable), default(=0) is disable");
 
+static int cmd_timeout = ARCMSR_DEFAULT_TIMEOUT;
+module_param(cmd_timeout, int, S_IRUGO);
+MODULE_PARM_DESC(cmd_timeout, " scsi cmd timeout(0 ~ 120 sec.), default is 90");
+
 #define	ARCMSR_SLEEPTIME	10
 #define	ARCMSR_RETRYCOUNT	12
 
@@ -140,6 +144,7 @@ static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
 static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb);
 static void arcmsr_set_iop_datetime(struct timer_list *);
+static int arcmsr_slave_config(struct scsi_device *sdev);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
@@ -155,6 +160,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.eh_abort_handler	= arcmsr_abort,
 	.eh_bus_reset_handler	= arcmsr_bus_reset,
 	.bios_param		= arcmsr_bios_param,
+	.slave_configure	= arcmsr_slave_config,
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
 	.can_queue		= ARCMSR_DEFAULT_OUTSTANDING_CMD,
 	.this_id		= ARCMSR_SCSI_INITIATOR_ID,
@@ -3156,10 +3162,12 @@ message_out:
 
 static struct CommandControlBlock *arcmsr_get_freeccb(struct AdapterControlBlock *acb)
 {
-	struct list_head *head = &acb->ccb_free_list;
+	struct list_head *head;
 	struct CommandControlBlock *ccb = NULL;
 	unsigned long flags;
+
 	spin_lock_irqsave(&acb->ccblist_lock, flags);
+	head = &acb->ccb_free_list;
 	if (!list_empty(head)) {
 		ccb = list_entry(head->next, struct CommandControlBlock, list);
 		list_del_init(&ccb->list);
@@ -3256,6 +3264,16 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 
 static DEF_SCSI_QCMD(arcmsr_queue_command)
 
+static int arcmsr_slave_config(struct scsi_device *sdev)
+{
+	unsigned int	dev_timeout;
+
+	dev_timeout = sdev->request_queue->rq_timeout;
+	if ((cmd_timeout > 0) && ((cmd_timeout * HZ) > dev_timeout))
+		blk_queue_rq_timeout(sdev->request_queue, cmd_timeout * HZ);
+	return 0;
+}
+
 static void arcmsr_get_adapter_config(struct AdapterControlBlock *pACB, uint32_t *rwbuffer)
 {
 	int count;

