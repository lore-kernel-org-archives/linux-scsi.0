Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A1C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B908B21835
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 01:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="as//1I4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfLRBw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:52:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45159 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLRBw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 20:52:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id 59so325657otp.12;
        Tue, 17 Dec 2019 17:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5JPROeomugbS9mLeFJJ5jabbve8scXzl7BwrEThoADw=;
        b=as//1I4Ta7JpUaGIQEI+vtdK3ny4nBtnqsLDS7yKqxrn+9titvy7b45FCzeQ4OIadE
         fkM32IcZp/Ri5kznzY16uv5H353AowD1NXl3VAP/K6hAHx0JukAnDaMT8oXlz4O0O70k
         L5YZhvRK39OLMlTmBXxhy5TSFBy6q2cW59bn7+dYHjOVxYH9opwPlWiP0QXVoAoS+FR+
         zmdzrjVjGORwqMwIA3aF4scib3Oi/dEP0V3C6OvU8jMJS1TX7MlCfv7M6rS5Gcukdlrl
         /PsEyFck6se/4Yq7ZX7cgRhQtGfno47Yt1Ww87hxuEffTPSGi9azAz06OiaJkU+RTw79
         o0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5JPROeomugbS9mLeFJJ5jabbve8scXzl7BwrEThoADw=;
        b=Hfoxe2yDTBWTY78ocDqg0ilbhvOlhSidAtUEosrrS8nR5E0P+nDbIV1oBVBuR/GMDS
         URgagsrNVay6bmP88L0cWo8NiM4gd/RLMk+5wfBOHxYwBuKLh30DnDrtyb0nA8acVa7n
         b0N591TN70KbT80/qKmHozJHRYyR/9oAjjOJuz5zq5KgWoFlxT3AKQHRiqqd0VWa8e7P
         MwDMVObs8KJmqJmPFizSMZ7EMbSA9hsTyegJLiPBcjAFRJSESTle/+2s3Qm9q3D2z2o1
         Z69VoZYNC3cQYIPzAHM/+lI8kOa2tFwJZocGqzeMX7qHjCEzA4pLD/OEEgMeRyr00z9+
         kPYQ==
X-Gm-Message-State: APjAAAUUBuKhbw0ELJtfAUikvcju4FgQTZXebm784otjEOHOq8esr2iO
        I/OCQQxt70aVGjNdrFbrxvdTtx/Z
X-Google-Smtp-Source: APXvYqy1dnjjHAYTKRAwou3Za6zOmAVJg/VMZ/bbBOObvgBVPmDoOogJZ5cK0DRAKl91q+q5w8pXwQ==
X-Received: by 2002:a9d:7b50:: with SMTP id f16mr364425oto.18.1576633977191;
        Tue, 17 Dec 2019 17:52:57 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id r205sm269702oih.54.2019.12.17.17.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:52:56 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     QLogic-Storage-Upstream@qlogic.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
Date:   Tue, 17 Dec 2019 18:52:52 -0700
Message-Id: <20191218015252.20890-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

../drivers/scsi/qla4xxx/ql4_os.c:4148:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         if (ha->fw_dump)
         ^
../drivers/scsi/qla4xxx/ql4_os.c:4144:2: note: previous statement is
here
        if (ha->queues)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 068237c87c64 ("[SCSI] qla4xxx: Capture minidump for ISP82XX on firmware failure")
Link: https://github.com/ClangBuiltLinux/linux/issues/819
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2323432a0edb..5504ab11decc 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4145,7 +4145,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
-	 if (ha->fw_dump)
+	if (ha->fw_dump)
 		vfree(ha->fw_dump);
 
 	ha->queues_len = 0;
-- 
2.24.1

