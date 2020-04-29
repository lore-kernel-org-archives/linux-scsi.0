Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66236C83008
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4318220775
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 09:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="hyTRPEOz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgD2Jpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:45:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39830 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbgD2Jpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 05:45:30 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 67F474C850;
        Wed, 29 Apr 2020 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1588153526; x=1589967927; bh=bpdN6C8I3xQWAWD4smMS5RJ818xQZtfFiQ6
        2YjWDlA0=; b=hyTRPEOzGNhiOdFRXOjYx2CPfhxCM7QrxVvxRHW49OZIKICopqh
        wf3ZJeSC7mah2FI3g9tpcmXoEWTmuO/RPv8I4XUwJzOeHvTrj9m0gOjjfnxzqZmz
        06p1rar68YOPwe/5+h0HUcxxAmrEkOqtXHp0twC5xzZYf0veYqR1drpo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Dp4S7_C1Ev5y; Wed, 29 Apr 2020 12:45:26 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 76D854C84C;
        Wed, 29 Apr 2020 12:45:25 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 29
 Apr 2020 12:45:26 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>,
        Mike Christie <mchristi@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Vinogradov <k.vinogradov@yadro.com>,
        Ivan Efremov <i.efremov@yadro.com>
Subject: [RFC PATCH 02/11] scsi: target/core: Set MULTIP bit for se_device with multiple ports
Date:   Wed, 29 Apr 2020 12:44:35 +0300
Message-ID: <20200429094443.43937-3-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SAM-5 4.8.3 (SCSI target device with multiple SCSI ports structure)
obligates to set MULTIP bit when there's multiple SCSI target ports:

> Each device server shall indicate the presence of multiple SCSI target
> ports by setting the MULTIP bit to one in its standard INQUIRY data
> (see SPC-4).

The change sets MULTIP bit automatically to indicate the presence of
multiple SCSI target ports within standard inquiry response data if
there are multiple target ports in all target port groups of the
se_device.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Konstantin Vinogradov <k.vinogradov@yadro.com>
Signed-off-by: Ivan Efremov <i.efremov@yadro.com>
---
 drivers/target/target_core_spc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..633dee9ac877 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -53,6 +53,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
+	struct t10_alua_tg_pt_gp *tg_pt_gp;
+	u64 dev_ports = 0;
 
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
@@ -93,6 +95,21 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 			buf[5] |= 0x1;
 	}
 
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
+			    tg_pt_gp_list) {
+		dev_ports += tg_pt_gp->tg_pt_gp_members;
+		/* Exact number of ports does not matter for MULTIP bit */
+		if (dev_ports > 1)
+			break;
+	}
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+	/*
+	 * Set MULTIP bit to indicate presence of multiple SCSI target ports
+	 */
+	if (dev_ports > 1)
+		buf[6] |= 0x10;
+
 	buf[7] = 0x2; /* CmdQue=1 */
 
 	/*
-- 
2.26.1

