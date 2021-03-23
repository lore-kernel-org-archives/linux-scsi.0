Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CD2C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2603619A5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCWEo3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:44:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33380 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229592AbhCWEoN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:44:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4gTD7012329
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:44:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=WIqAJjVKU7VkVONLtu8NvN1gCatQ49LD0J2QNUjo0eM=;
 b=RlzruETYTMwMzb+Zh48KvKgwW5SqzdMhFNmpYWE0EnI66JAYFLudH9QFyTfYXHq8q37+
 mGwpX0FHspx5Vn9Tg8Ayvn44uUiKHhuuK028Tt+1oZ4o4/0I7S6ogi3VbYGee0clRF3j
 /SNtFXxeBC6fX5Tv9tBmBV92b5M4dbjey0VGzR3XnylfJ5CGhhU9oez8qGaGM0xIjrfG
 x1gZmYqSWAX9j678z+NlyCyMD1ikiJxxAYiqzVxX9q2eAdBP88Yw0AIx5JbGs3mivj6Z
 agLPBugMi2x4Hla8+/1fSnUbnipvt/JpvYKdBYwzOPo+p+G+Xm5ZFOUsk8prdbbVDmt4 DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnygun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:44:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:44:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:44:10 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 64F073F703F;
        Mon, 22 Mar 2021 21:44:10 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4iAQt026715;
        Mon, 22 Mar 2021 21:44:10 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4iAxV026706;
        Mon, 22 Mar 2021 21:44:10 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/11] qla2xxx: Add H:C:T info in the log message for fc ports
Date:   Mon, 22 Mar 2021 21:42:48 -0700
Message-ID: <20210323044257.26664-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

The host:channel:scsi_target_id information is helpful in matching
an fc port with a scsi device, so add it. For initiator fc ports,
a -1 would be displayed for "target" part.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f01f07116bd3..af237c485389 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5512,13 +5512,14 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (fcport->port_type & FCT_NVME_DISCOVERY)
 		rport_ids.roles |= FC_PORT_ROLE_NVME_DISCOVERY;
 
+	fc_remote_port_rolechg(rport, rport_ids.roles);
+
 	ql_dbg(ql_dbg_disc, vha, 0x20ee,
-	    "%s %8phN. rport %p is %s mode\n",
-	    __func__, fcport->port_name, rport,
+	    "%s: %8phN. rport %ld:0:%d (%p) is %s mode\n",
+	    __func__, fcport->port_name, vha->host_no,
+	    rport->scsi_target_id, rport,
 	    (fcport->port_type == FCT_TARGET) ? "tgt" :
 	    ((fcport->port_type & FCT_NVME) ? "nvme" : "ini"));
-
-	fc_remote_port_rolechg(rport, rport_ids.roles);
 }
 
 /*
-- 
2.19.0.rc0

