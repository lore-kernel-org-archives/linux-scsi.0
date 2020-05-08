Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A94C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101B8208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NYlvi7A+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEHLHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 07:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgEHLHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 07:07:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2D1C05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 04:07:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f7so762844pfa.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 04:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ky+Yb/yQi/GkFAcU14+OIVZhF3BRfV18Lxul7icEhrQ=;
        b=NYlvi7A+rDezrIELSDZKv8rkV6o3jR8pny1zjistwKQ+1GNIVhIY4EM7GJM0yMu7fT
         DLcugesbARfilvRrVUdOvSuCHqVGPs3PtTsKnailh+r1dTiFa4HlLJrSR65yQJatujkm
         iCWnG0UBpXXYCpbQKGQBVSqyqNT9GZ+UrBquQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ky+Yb/yQi/GkFAcU14+OIVZhF3BRfV18Lxul7icEhrQ=;
        b=ZzHOS+RXxewtNz0jN4ZqyO2yaQmcy4vpohlXDSLSfzC1guEKxa+Bjy2koT1q6aR9tM
         deVbr46PVRslFsrcjEgzQFOX1bTnUsO8cHtiSotR5c1KL0jzaQgiElYlwkOxQsrUSOZU
         xQZlFj5FTUjMfE3SU865ppjPZdkFLdQF2cGqSdWh3N9FW47AVWF7CwCSm2mzwAPxq6x9
         mLuhVfReLibW9uvdzZXjCDwinubD243af2JDacM9r4o7R/TAI2Uxn2lbbkYQkcPMlw4/
         RfTP6BbXJdcE+6CYEXJ6s++mR/yg5sRm6pVDa+957VAJ+RdrJCRLjjWsTBJXhOl+2Oh8
         8zNg==
X-Gm-Message-State: AGi0PuZDxyB4Rpd5olcj14muD2ycy8EabsCJtMrnOI5uAz+ORbPFOu1r
        yjBTAuM7MbtUUW6cU54NOA3XN1A9KnLObwUIM9rL/RKDwQPa8DrPnfljk4fCzkKIpwH+sJJNm4k
        MQclx4WzpMwdp/HJ+iJBDMKJUENOdpAOJf6ux1Ax4YlpgpcIj9dJB2ixeZQEUkbvKMwd8mNHsj9
        yKKOqJRyLk74xb91FMzM3P
X-Google-Smtp-Source: APiQypLacMhMlvas0GISqq8fZt24OLUwZYAVCkVg/bMbHsI4V5L6J7/kOequPjNpiU5xFu6YVCM79Q==
X-Received: by 2002:a63:6546:: with SMTP id z67mr1689186pgb.10.1588936072260;
        Fri, 08 May 2020 04:07:52 -0700 (PDT)
Received: from dhcp-10-123-20-28.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id gn20sm2234345pjb.24.2020.05.08.04.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 04:07:51 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     dan.carpenter@oracle.com, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, Johannes.Thumshirn@wdc.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v1] mpt3sas: Fix double free warnings
Date:   Fri,  8 May 2020 07:07:38 -0400
Message-Id: <20200508110738.30732-1-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings from Smatch static analyser:

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->hpr_lookup' double freed

drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
warn: 'ioc->internal_lookup' double freed

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
v1 Change:
Removed checks before kfree().

 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7fa3bdb..dc260fe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4899,7 +4899,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	kfree(ioc->hpr_lookup);
+	ioc->hpr_lookup = NULL;
 	kfree(ioc->internal_lookup);
+	ioc->internal_lookup = NULL;
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			for (j = ioc->chains_per_prp_buffer;
-- 
2.18.4

