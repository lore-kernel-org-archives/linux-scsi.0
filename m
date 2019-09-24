Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0354C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09B7214D9
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfIXH3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:29:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:40132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbfIXH3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 03:29:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF37DAFBD;
        Tue, 24 Sep 2019 07:29:07 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     QLogic-Storage-Upstream@cavium.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2] scsi: qedf: Add port_id getter
Date:   Tue, 24 Sep 2019 09:29:06 +0200
Message-Id: <20190924072906.23737-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
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

changes v2:
  - place closing brace on new line, fix whitespace damage

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

