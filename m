Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1725C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiBPVDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbiBPVDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:00 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ADB207556
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:47 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id l9so2999239plg.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/tyf6xX9BmyWKtKTQi812+2T5RV6GzN1mDcL3nDAAM=;
        b=6hAR82hAWZd4PNHrfMLzd1iAfLzWoFR552jrELklKBBbEy3VW6VIAeYBukFBDE5qtv
         +B4bk5orNYGtc3yDK9ChQFimb3+bGsukzLmxlCEKijcQKlR5+VNmjipO+MvuTsK2XZWY
         DhS/Yzat8TCdMF64YcnNbe/XlSNe/N52OQWWIa7dkhknODzLl0NEQlHl+HAUv8C2gn99
         cvYK0zNKmyU8f8nvemhJhFBVIj3ZPGi2Ch194EwI0lIptzrO/XpmjOdi5iK7LQUcWb63
         Eh2YmyeZR+HQZ++nwkXklk55vbbKjdAliCo0bKa9durkOqkk32pgX5smH/NMGutPHR2h
         8UQQ==
X-Gm-Message-State: AOAM533Z30MmEaD/OMdMq/nIA5Na86DVMevf3xpFYPBfizvG8upkPzqa
        3pJ1kVZf/ecY6TQgUjH4re8=
X-Google-Smtp-Source: ABdhPJzYQd4SxqbrT7IWt3cHaLb4wVWAWIp1Sjc3FSRtn8DGqEPljCh8Hg70J7xlkDLQG/DHsUEQdQ==
X-Received: by 2002:a17:902:e80f:b0:14d:c482:66a3 with SMTP id u15-20020a170902e80f00b0014dc48266a3mr4269657plg.41.1645045366703;
        Wed, 16 Feb 2022 13:02:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:02:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 02/50] scsi: ips: Change the return type of ips_release() into 'void'
Date:   Wed, 16 Feb 2022 13:01:45 -0800
Message-Id: <20220216210233.28774-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ips_release() has one caller and that caller ignores the value returned by
ips_release(). Hence change the return type of that function into 'void'.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
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
