Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781C8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354089AbiBKWdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351935AbiBKWdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:07 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DE2D52
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:05 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id z17so5763836plb.9
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HEFLCrsQk3OeBNfYh3K6FY5jqJf/f2weV6Bf1jwM0K4=;
        b=zlOU+0cqJwkgCM8pLgIQYXZJkjUpbVByUBQXKGQoHyqwiW8rQ9yT2mkEzM1F2I8Qgc
         lQdNn8C7cF1DCdvrkD+sDdc1aFq6ewAzosOxM/kqYdgrDABBIUNv2UF+7cljek8PkNgn
         yW090zCPWG4wpl2B47MUo/xXU4EG5tEd5X1U0NfRk6lkQWd3yItYChFMmjKNLGKR7cbh
         8wnkNyzn3y02s3ZO1GWHJ7L7/e+KcURZ4skbvK7Al0kJd73F/TiOZvr8QLzuAn+bj1iJ
         YjOgR4iGQZVDBr6VZs/rNqP/KXQQ8KXydeFl8+V/zxUqmkjKh3Ke4NeUhMUfR8qyGlZz
         18bQ==
X-Gm-Message-State: AOAM530cSNk0TAuUQUHd16IZ3XoM9v5MFvWqk/4trfN7kFn3ijA6dKMa
        Y++8CKe5AJ331eVUinOl4qJCJyrgJGexiw==
X-Google-Smtp-Source: ABdhPJyKG3FhPAWf4ZAjMAJNpScd4lkuqM5Ua1VNkyUyDbsYLthQhL1h0GqBmtP6Do+wWucM+z+86Q==
X-Received: by 2002:a17:903:192:: with SMTP id z18mr1834417plg.113.1644618784682;
        Fri, 11 Feb 2022 14:33:04 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 02/48] scsi: ips: Change the return type of ips_release() into 'void'
Date:   Fri, 11 Feb 2022 14:32:01 -0800
Message-Id: <20220211223247.14369-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ips_release() has one caller and that caller ignores the value returned by
ips_release(). Hence change the return type of that function into 'void'.

Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 0db35e97ce8f..59664e92ec8a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -638,8 +638,7 @@ ips_setup_funclist(ips_ha_t * ha)
 /*   Remove a driver                                                        */
 /*                                                                          */
 /****************************************************************************/
-static int
-ips_release(struct Scsi_Host *sh)
+static void ips_release(struct Scsi_Host *sh)
 {
 	ips_scb_t *scb;
 	ips_ha_t *ha;
@@ -660,7 +659,7 @@ ips_release(struct Scsi_Host *sh)
 	ha = IPS_HA(sh);
 
 	if (!ha)
-		return (FALSE);
+		return;
 
 	/* flush the cache on the controller */
 	scb = &ha->scbs[ha->max_cmds - 1];
@@ -698,8 +697,6 @@ ips_release(struct Scsi_Host *sh)
 	scsi_host_put(sh);
 
 	ips_released_controllers++;
-
-	return (FALSE);
 }
 
 /****************************************************************************/
