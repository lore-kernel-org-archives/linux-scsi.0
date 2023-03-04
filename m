Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5CEC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjCDAfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCDAed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:33 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC8F65471
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:05 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id ky4so4559768plb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZgEqZv012LUY7T6LHCDKEctFV0D//J8gA9RwCm+Bl8=;
        b=Efsp0oQAAvk6RJHAnjVR5STbZQVwltTneZ7pHTGiJoievh3MBiRi2I+fPt6YuTXOdW
         ITmN6wBzDQSMpF39ys9nynRatGSuZ3n2F+GcVSjSwAu/IPUUhvTN2qumv7z6pfngNXAM
         b/F9s4NxwZ2Y8ckLGJNXWXhrKxvsUF//P8vipFuSV1i/XeGhWYnVVPn27pRP7s9p6dJK
         WR1g/zPCYXVc8tGxH8bVL5LG/bPKbA14gCUhXSlxLECqcWXOy21JJztyYoLqiT87NftF
         Ts8CJkFDRmEe7/oqp0zHd0O2bmu1BmafyOmabdx46zRsN1qShqV4misdb23TJIEiSFfr
         J4TQ==
X-Gm-Message-State: AO0yUKWQEcGsS0r5nXnNv5/iDNh5/U3OZTM9heqmayCUXSF10vXNCAoJ
        S8pz+ln6NVVfHs6q803nZoM=
X-Google-Smtp-Source: AK7set8KN+0/CKXVfr/iYjFrUmM+wQx/Nu6Bdiubka/765eLWMWfqqQAh6Q2uouYBRvbEI0Bymgz4w==
X-Received: by 2002:a17:902:e809:b0:19a:9890:eac6 with SMTP id u9-20020a170902e80900b0019a9890eac6mr4287388plg.24.1677890036953;
        Fri, 03 Mar 2023 16:33:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Alexey Galakhov <agalakhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 56/81] scsi: mvsas: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:38 -0800
Message-Id: <20230304003103.2572793-57-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/mv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cfe84473a515..49e2a5e7ce54 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -29,7 +29,7 @@ static const struct attribute_group *mvst_host_groups[];
 
 #define SOC_SAS_NUM 2
 
-static struct scsi_host_template mvs_sht = {
+static const struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
