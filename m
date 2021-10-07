Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637ECC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D7A610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhJGVVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:55 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:41645 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbhJGVVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:54 -0400
Received: by mail-pj1-f54.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6249149pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GBk7F5v/DTW0X2Hks3jWI0V82MApL0eXANA8Nxw+P90=;
        b=rAuRmGZWOte8/6UDvWx616naGLnRC+c9GvwKwdPQAGSn98fU3lZHFOHudQHIusxcBL
         FZvQrT9VQz2mtjW9T4QpBLfYHNz62rx18LeSTSfInu6sN9vV1HKtsmMu+nwtHM9uRwYo
         3vyt5JfeRojFA4ULuN3LBhNgRJG0Fy5AOTa1pOJy48XYTk17aMNMNMVKbQ8+iuznE2gA
         ki7IrxY4p3C29YZWehzXRHMOX12LwWzAda39np08zy5Vhq1cW/k3caPL/nYyUdWyht6d
         49D6VdHC50Q2zf0O/2oOoPBzsM0vt+QHDq/7RU7CNeAM9eFb8fvpDOR/IvqU1vhnXfbJ
         fHLg==
X-Gm-Message-State: AOAM531ZsjETfgjCOWVuBgirq32PJdlGQ9/qUUumYiryosCScfj2/mvg
        SFvGbx/RcL41iqUlpUzyju0=
X-Google-Smtp-Source: ABdhPJzgpx/vAAvFKxA3p27guZO+oYfRLYeLZ6lsWtAoUoJP5etbS8JEaXHfsFojliVavsGUoLo4kQ==
X-Received: by 2002:a17:902:dacf:b0:13e:ab53:87dc with SMTP id q15-20020a170902dacf00b0013eab5387dcmr5994690plx.78.1633641600325;
        Thu, 07 Oct 2021 14:20:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 24/46] scsi: ibmvfc: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:30 -0700
Message-Id: <20211007211852.256007-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..d4509b043d86 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3588,15 +3588,24 @@ static struct bin_attribute ibmvfc_trace_attr = {
 };
 #endif
 
-static struct device_attribute *ibmvfc_attrs[] = {
-	&dev_attr_partition_name,
-	&dev_attr_device_name,
-	&dev_attr_port_loc_code,
-	&dev_attr_drc_name,
-	&dev_attr_npiv_version,
-	&dev_attr_capabilities,
-	&dev_attr_log_level,
-	&dev_attr_nr_scsi_channels,
+static struct attribute *ibmvfc_attrs[] = {
+	&dev_attr_partition_name.attr,
+	&dev_attr_device_name.attr,
+	&dev_attr_port_loc_code.attr,
+	&dev_attr_drc_name.attr,
+	&dev_attr_npiv_version.attr,
+	&dev_attr_capabilities.attr,
+	&dev_attr_log_level.attr,
+	&dev_attr_nr_scsi_channels.attr,
+	NULL
+};
+
+static const struct attribute_group ibmvfc_attr_group = {
+	.attrs = ibmvfc_attrs
+};
+
+static const struct attribute_group *ibmvfc_attr_groups[] = {
+	&ibmvfc_attr_group,
 	NULL
 };
 
@@ -3620,7 +3629,7 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
 	.max_sectors = IBMVFC_MAX_SECTORS,
-	.shost_attrs = ibmvfc_attrs,
+	.shost_groups = ibmvfc_attr_groups,
 	.track_queue_depth = 1,
 	.host_tagset = 1,
 };
