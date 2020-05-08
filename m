Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196C2C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE96216FD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="a3M4eQ+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgEHIw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgEHIw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:52:58 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03C6C05BD09
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:52:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r26so9772665wmh.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=XHtY22wdqoD6kwX3h4YQdHgh33drKh8dmMkZ3FUswro=;
        b=a3M4eQ+WWaAMgC3KWWxjz92/gjVJbQg54xYUI2IMUPV8vbLXBByqWMB616+NYou7hB
         g0MfI5H3o1UxEtWkyOp7WJ/p0V92jf/07aCuzVW6zZclHr8hlc4js0grL/UvLee76ET7
         RKfEuIW0zS1x2pvxPGG/xk04NnL/eP5M7PX0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XHtY22wdqoD6kwX3h4YQdHgh33drKh8dmMkZ3FUswro=;
        b=BcvyJgrRE02JFQpu58sSxyggcfV+RYqiXPJi/C+MGL8CUeunOYRrNErBs98KgZ8EI5
         LC0A6lgIb8/41pBjrSIoNCFcfEaRLDSVMzQ20YSF0ULnhgTS0gmyz/9A9dRpaKVjbjZ0
         DykHZhZPpL/lmrdGj0MxpzMbYmXu77KnSUa2+p7j2rrJYZbBs+fJlw1yjDTlN3eycERU
         NTuuwRQZW2Js7v7W5tmmrl4G5RDfvppAxnpdlx3neU99yfcjxIiN0JZumgDJ0ASu3tph
         uJCGWaFlpH76sKWM1WCoEPsnlMRy+wQ8iMh/EwU6W/rjZz3t9yPxrnfyaO2lrdJZit3l
         68gQ==
X-Gm-Message-State: AGi0PuYQupj+oXoZy8/yn96kPGAcZfiBUR5iBIs3erSfhh3vLAwvNpDs
        K0FF7QNlSiq6HRdiZRqt7WoGYEMyulqbUcHcJIdLxBhAhZ+1YU4j8dqrnjJjuNbkeMnmbmUsXAr
        n78SlK0pTEf/IiVCt7PZCv0Qcmz5WJlab6h6HEFt33DirPDwqvBToxbcHLWh2wbKA5ENFu3lmsc
        xswLsX2057d+O9
X-Google-Smtp-Source: APiQypKdriRs4YmjXWuUXd6zMQwRpYcVQtLFOq8GnpNc/A1T2Ibe50kATp5BITp4mlzmVAS0oN2d/w==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr854070wmb.65.1588927976290;
        Fri, 08 May 2020 01:52:56 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f26sm12132333wmj.11.2020.05.08.01.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:52:55 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/5] megaraid_sas: TM command refire leads to controller firmware crash
Date:   Fri,  8 May 2020 14:22:42 +0530
Message-Id: <20200508085242.23406-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Issue: When TM command times-out driver invokes the controller
reset. Post reset, driver re-fires pended TM commands which leads
to firmware crash.

Fix: Post controller reset, return pended TM commands back to OS.

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 87f91a38..319f241 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4180,6 +4180,7 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
 	u16 smid;
 	bool refire_cmd = false;
 	u8 result;
@@ -4247,6 +4248,11 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 			result = COMPLETE_CMD;
 		}
 
+		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
+				cmd_fusion->io_request;
+		if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_TASK_MGMT)
+			result = RETURN_CMD;
+
 		switch (result) {
 		case REFIRE_CMD:
 			megasas_fire_cmd_fusion(instance, req_desc);
@@ -4475,7 +4481,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 	if (!timeleft) {
 		dev_err(&instance->pdev->dev,
 			"task mgmt type 0x%x timed out\n", type);
-		cmd_mfi->flags |= DRV_DCMD_SKIP_REFIRE;
 		mutex_unlock(&instance->reset_mutex);
 		rc = megasas_reset_fusion(instance->host, MFI_IO_TIMEOUT_OCR);
 		mutex_lock(&instance->reset_mutex);
-- 
2.9.5

