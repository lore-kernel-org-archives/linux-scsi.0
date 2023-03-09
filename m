Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6E5C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCIT31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCIT2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:46 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA455A0
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:45 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id p6so1743883pga.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ksKFgRH4rYvlBG1yS/w98H9HGUxvKE6kRBa+hfKL1B0=;
        b=aD3NPOLqK4rM3+1jJJIs2QcJfpuFe1T/pDxpkzpSPnnoZQGmAoT0z1+hx5WGIVsDl5
         cZf9TnLEIeH3NLXYxaPaFcOqONj0x+UF25gqbo1ZECxV5aVMNyxFTNs+G2ZPTChZ6t5q
         TcaYlF2gIYuzzMXIrAbPZXHLxBwxZYJftvpJlgeAVV/35mZED09Gj5LGGPKAUBEhKqMS
         aRib0Fnexf3PBrMlcbyIVazxajfhmgjSdiINzDwe8/6h+jFjBm1q/mu5fVfwOzlGGK/e
         Zjav3cpVV9AcHOVGgAVLyNHV3h/rHZo2nyhd15Zbk+3Rc3Dl2wRlE0iJ9a4X+/Rm48K8
         sbnQ==
X-Gm-Message-State: AO0yUKV82vyC/pndqRqbQbt1G7nXGl5P17OdhhcDLiUb7V3WSutHPkKE
        MA5q++/gCvFWNybs7+2zEDk=
X-Google-Smtp-Source: AK7set+moxnUAiyExP8Qy1sLoZmVgDuBIbxWTdY6gPEZWMwTX5RraDFxYhZg1TQdUuIGHGOJhtf5/Q==
X-Received: by 2002:a62:6490:0:b0:5a8:beb3:d55f with SMTP id y138-20020a626490000000b005a8beb3d55fmr18441516pfb.32.1678390125230;
        Thu, 09 Mar 2023 11:28:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 45/82] scsi: imm: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:37 -0800
Message-Id: <20230309192614.2240602-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/imm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 7a499d621c25..07db98161a03 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1096,7 +1096,7 @@ static int imm_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template imm_template = {
+static const struct scsi_host_template imm_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "imm",
 	.show_info		= imm_show_info,
