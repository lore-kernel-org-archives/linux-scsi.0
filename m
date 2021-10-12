Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC249C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32E160F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhJLXiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:54 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:34745 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbhJLXix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:53 -0400
Received: by mail-pl1-f181.google.com with SMTP id g5so588340plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kE5LxnwFISAmV7U8eafLq9RYsn5crmFkr10V2Fc9Pow=;
        b=lpP7iZSzrpHnQ0wuWMAG2883j/aRjOweLux2A3HjaqfaItwXHGMElyf8SKYBbpksUW
         9rdxIgJnDIMCvfGWcUjReFG061p3WX0je+Sq7EoG4VXyfDjRC8qqmftxXgC8YSmHMCTM
         8EsrtY5C9IFyc85QU/ZkiT9VdMWa4mBzDOPAb+eBXqbXJMEkM4+8vBMI6DcMRuoanJvR
         7tqf8E+td893G8mJe8OfbHGLDzdloehY5pipBNxb9f/sQwliR0KrnfHxd1pMCE1W4GeK
         E6ElWIrZJaVhKeuKh6MwqzaqpJoG5wfA5NmgNyg8xkGETfB9A/Qeanpx0FA6CvpFFKEi
         Hr4Q==
X-Gm-Message-State: AOAM532C+sLqbQZSVY9VygFH751/nxtQhSe02+vF0gfJCvvgT10fp/eC
        Vn3F/3bSHYLEwihBaS0SyFc=
X-Google-Smtp-Source: ABdhPJw1YgmwYpdYKoHHXid/kJrT/G3cmN9s+huFQteIzqjlz5eGO61gcxVyexCMZznGslacVbXSRQ==
X-Received: by 2002:a17:90a:39c5:: with SMTP id k5mr9556376pjf.211.1634081811259;
        Tue, 12 Oct 2021 16:36:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 23/46] scsi: ibmvscsi: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:35 -0700
Message-Id: <20211012233558.4066756-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50df7dd9cb91..053ca437d2a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2064,18 +2064,20 @@ static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
 	return 0;
 }
 
-static struct device_attribute *ibmvscsi_attrs[] = {
-	&ibmvscsi_host_vhost_loc,
-	&ibmvscsi_host_vhost_name,
-	&ibmvscsi_host_srp_version,
-	&ibmvscsi_host_partition_name,
-	&ibmvscsi_host_partition_number,
-	&ibmvscsi_host_mad_version,
-	&ibmvscsi_host_os_type,
-	&ibmvscsi_host_config,
+static struct attribute *ibmvscsi_host_attrs[] = {
+	&ibmvscsi_host_vhost_loc.attr,
+	&ibmvscsi_host_vhost_name.attr,
+	&ibmvscsi_host_srp_version.attr,
+	&ibmvscsi_host_partition_name.attr,
+	&ibmvscsi_host_partition_number.attr,
+	&ibmvscsi_host_mad_version.attr,
+	&ibmvscsi_host_os_type.attr,
+	&ibmvscsi_host_config.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(ibmvscsi_host);
+
 /* ------------------------------------------------------------
  * SCSI driver registration
  */
@@ -2095,7 +2097,7 @@ static struct scsi_host_template driver_template = {
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
-	.shost_attrs = ibmvscsi_attrs,
+	.shost_groups = ibmvscsi_host_groups,
 };
 
 /**
