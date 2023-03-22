Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D5AC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCVUAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjCVT7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:55 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB61A5BDA1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:22 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so20258363pjz.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtXkLpjqkzEtUpPCfZWQmuI25j02ukzVqxS1meSBiZY=;
        b=vLz2sRUHCPJRyLpDmk8YwYfKYtTbot8Epc5H93v0cAcP0Jyb/ks8xND5M+kexwSNPr
         l2l1j9ipw9hJsmNMkcWN514Eq7SKY481SRy8yIk7lfwr7bcKi4S9HV7wIwnzmsXvaIyC
         1mqIrWLgdTgD2c+yyalNEf9vqIjr1XffpsObSqclMxrUIytuX7fIzgDmvfOvAW4bK8FC
         gGc2ltnGoQqHTaK8ex0FK9RRgwmJDIsJYX14ug2YFhVEeNAXjVGc0mbTd9QZpG9TQjiR
         8IGyS/JLZve6URK+Bwkmp+VlesvehHVcPXvtdrylC5TYJCa5GfrSn/TEwy7ceXSUbOjv
         KGWQ==
X-Gm-Message-State: AO0yUKXfy1wRlbQdFi3sKToCgQhYZKwfP359a8KApC2pOdOvuohmZ7ZM
        MK0kb70XO3YbX3jckxNqdRI=
X-Google-Smtp-Source: AK7set+Wj4EhiXoaFmM7xzLusQjak5Fkn3XtQqWjOhKRzO8ajUi1U08HzkDXeUJ8OCntijMPVH70WA==
X-Received: by 2002:a17:90b:1e0f:b0:23f:a810:c077 with SMTP id pg15-20020a17090b1e0f00b0023fa810c077mr4592510pjb.40.1679515101777;
        Wed, 22 Mar 2023 12:58:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 58/80] scsi: myrb: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:53 -0700
Message-Id: <20230322195515.1267197-59-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index e885c1dbf61f..ca2e932dd9b7 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2203,7 +2203,7 @@ static struct attribute *myrb_shost_attrs[] = {
 
 ATTRIBUTE_GROUPS(myrb_shost);
 
-static struct scsi_host_template myrb_template = {
+static const struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrb",
