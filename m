Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846D0C2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D8EE2168B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502802AbgLNUWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503120AbgLNUVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:46 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FDCC0617A6;
        Mon, 14 Dec 2020 12:20:32 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id u19so18596286edx.2;
        Mon, 14 Dec 2020 12:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kX6w9TQPV6DAnVZ3iF7tdAXWv6mADHAIKZfdziB6tUo=;
        b=HqXhEHnR2e/Ii/YgdJOSC0gxgYAkOL9KIlICpKjGTc7wQ5lr2wk+MDpN71Srtj61y8
         HRcTynhx3VvbDzAMFdurm61DaMyTlMeZWZQuTkXEOfhtdutgFIzIqWM+lS4Zv5lR1lkI
         nQ6wSVdl7hPeI5G9OFt8p2ws9Xysd45KDHzY7KJkZ+g2Mly6m3J4WSWb5EEr8yNdCkRB
         sH+LCM/ilV8XdAugPY4K/XzPQJA7STUvho7ejYQaz1Sltpa0XW2aOdPH3/5BB5to9TnZ
         H2xYGv2+HNiCdEih/0npa4y2l8/UU+Es+6NmcavSv9XeYvm1+aYPosursjQuYQPYXdLS
         QQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kX6w9TQPV6DAnVZ3iF7tdAXWv6mADHAIKZfdziB6tUo=;
        b=U+pN/jFqz9WdD9Y5E23U0V3GsfsMlMx3431iXoVu0TcqYz8Ez9vcjaYyvnWAIDL1aI
         zWoiyOxXq6KWtHDNv8UQ/G949Mmovs1ZoiHQf4k0vTUEBNLYW+9fILRJLAEW7b61HRLH
         l2p5+jTUtPpVCsHlJnkEVdqr5MULWeLX4mL1AW4gvN0uZMUblNdEGN4lc5Gc0/tWbm67
         +bHS2mjiOXGRlDnhJatz3sDEFJoYJISDHHrefEEmiqO+FVWZrFV4q6m25Jb17BMnZ4As
         0NXw3M3xX/NoccSD5GDmGqsXJuke2RdjvN9luCUrDOj8DI+ik7CpbLN4OYfsaYrRW90E
         Rcng==
X-Gm-Message-State: AOAM531Ksj9mkAdcBorVo9b3+iba5r4/YI2V9NEhfjgjQ0RLcDnnHdC+
        oQ9AxXX9TnbldpdbKzyUyJ8=
X-Google-Smtp-Source: ABdhPJyzH7GycWDpxinG3+VSSjCPzkdzbReUN/eZOVtxu/U8lYeYo5ygKkcubR455rk7jZ1a5mmrqw==
X-Received: by 2002:aa7:db56:: with SMTP id n22mr11674142edt.4.1607977230974;
        Mon, 14 Dec 2020 12:20:30 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:30 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/6] scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
Date:   Mon, 14 Dec 2020 21:20:13 +0100
Message-Id: <20201214202014.13835-6-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
for the TM response, let TM UPIU trace print its TM response UPIU.

Acked-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d0b054aa0a3c..2cf983b3de1a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -341,8 +341,12 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
-			&descp->input_param1);
+	if (str_t == UFS_TM_SEND)
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
+				  &descp->input_param1);
+	else
+		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
+				  &descp->output_param1);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
-- 
2.17.1

