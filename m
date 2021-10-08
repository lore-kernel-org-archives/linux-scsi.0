Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3333FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1958661019
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbhJHU0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:30 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:44645 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhJHU01 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:27 -0400
Received: by mail-pf1-f171.google.com with SMTP id 145so9085732pfz.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0oytqwBYbr35Z6MtPz7HCBDp8jm+jqZ/k5dsTUcnRlA=;
        b=1kxnpsTd2MwRoJur35+bvpgPmGKdu+CQB3aFcSWefPD6ptZh7fVv2N1eMxo/lnvDM8
         jnwcmpH8+Yfbml53BR80/YygK4n/wBOfrk6Q0inoG114koxutExwtM7Fkzhs9NthSa+j
         fsv2/LwnqEyU4yOFOgubaBe+jHQigbF6bjRr/ObFwIyRR04hz0YC5udDaJiVGQrwChBD
         zAaa9JpGfFeAV/HrT6cbYUR43T6k9PPQVfTMj61XAakhShVrZ3zsmx3r59f1ropDhvfy
         QJv5/ETI+J2wGsxNDeaCAnLAeVz4O5lHedEw3gfLhrOBWLSltDbI/kaO+uRS59SPtLpK
         8CZA==
X-Gm-Message-State: AOAM533NyHcNrnKepFczYu15afKPynPv4pjqeMSMdVsgfeUAXqXxLqRL
        uRZpD4qUN2wkz9Q6VhIziTLAaEnwP4xFUA==
X-Google-Smtp-Source: ABdhPJzksCOY0cFJ4B61tYcZl1It5AyMIuAl780fcK5MY7zbc74X0ZKEwYrIBXQuDbkXiaxOo6RUCw==
X-Received: by 2002:a63:9d4c:: with SMTP id i73mr6367607pgd.216.1633724670901;
        Fri, 08 Oct 2021 13:24:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 13/46] scsi: be2iscsi: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:20 -0700
Message-Id: <20211008202353.1448570-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/be2iscsi/be_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..ab55681145f8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -163,17 +163,20 @@ DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
 	     beiscsi_active_session_disp, NULL);
 DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
 	     beiscsi_free_session_disp, NULL);
-static struct device_attribute *beiscsi_attrs[] = {
-	&dev_attr_beiscsi_log_enable,
-	&dev_attr_beiscsi_drvr_ver,
-	&dev_attr_beiscsi_adapter_family,
-	&dev_attr_beiscsi_fw_ver,
-	&dev_attr_beiscsi_active_session_count,
-	&dev_attr_beiscsi_free_session_count,
-	&dev_attr_beiscsi_phys_port,
+
+static struct attribute *beiscsi_attrs[] = {
+	&dev_attr_beiscsi_log_enable.attr,
+	&dev_attr_beiscsi_drvr_ver.attr,
+	&dev_attr_beiscsi_adapter_family.attr,
+	&dev_attr_beiscsi_fw_ver.attr,
+	&dev_attr_beiscsi_active_session_count.attr,
+	&dev_attr_beiscsi_free_session_count.attr,
+	&dev_attr_beiscsi_phys_port.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(beiscsi);
+
 static char const *cqe_desc[] = {
 	"RESERVED_DESC",
 	"SOL_CMD_COMPLETE",
@@ -391,7 +394,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
-	.shost_attrs = beiscsi_attrs,
+	.shost_groups = beiscsi_groups,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
 	.this_id = -1,
