Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C35C04EBF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 10:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 328D620882
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 10:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439412AbfIWKhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 06:37:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:36922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729662AbfIWKhl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 06:37:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4972B152;
        Mon, 23 Sep 2019 10:37:39 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     QLogic-Storage-Upstream@cavium.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] scsi: qedf: Add port_id getter
Date:   Mon, 23 Sep 2019 12:37:38 +0200
Message-Id: <20190923103738.67749-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add qedf_get_host_port_id() to the transport template.

The fc_transport_template initializes the port_id member to the
default value of -1. The new getter ensures that the sysfs entry shows
the current value and not the default one, e.g by using 'lsscsi -H -t'

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qedf/qedf_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9c24f3834d70..8fe8c3fdde1b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1926,6 +1926,13 @@ static int qedf_fcoe_reset(struct Scsi_Host *shost)
 	return 0;
 }
 
+static void qedf_get_host_port_id(struct Scsi_Host *shost)
+{
+	struct fc_lport *lport = shost_priv(shost);
+
+	fc_host_port_id(shost) = lport->port_id;
+}
+
 static struct fc_host_statistics *qedf_fc_get_host_stats(struct Scsi_Host
 	*shost)
 {
@@ -1996,6 +2003,7 @@ static struct fc_function_template qedf_fc_transport_fn = {
 	.show_host_active_fc4s = 1,
 	.show_host_maxframe_size = 1,
 
+	.get_host_port_id = qedf_get_host_port_id,
 	.show_host_port_id = 1,
 	.show_host_supported_speeds = 1,
 	.get_host_speed = fc_get_host_speed,
-- 
2.16.4

