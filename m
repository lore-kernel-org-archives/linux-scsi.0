Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4915C433E7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E52C2225B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 09:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bBQvfY08"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgJIJig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 05:38:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13110 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733137AbgJIJif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 05:38:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0999OY77015645
        for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2020 02:38:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BBapVtsn+bIOjEVlkwg6wGMt5wpUumqmWL/CMQAu2lY=;
 b=bBQvfY08XT1SPgK7QN8UeOcSYcYxopwBwR1hNpOtIlAre0Zii7gjeRgpOasxMZyyK8L1
 zbcdHrblL49r8WDCqWZ/KCY9n9Fjulxa/s54JyEH1Eupn3Od0zOo94cYHv2bnFprvcQl
 sUUxhU58ymsRs7Fw83xWFCbGNrSAD1G/YU0/aiK+n8Ephtvo3Zg6KCg3au71QAQXiF79
 DMIr9AaOYyryzMITNJzpv66SpztezQ3nGDakq0ZAxK1yF10JzXBFwDrfdlnu00M/U5dy
 MYd9bzSDx3lRWfOuzUR5ILyIHr3VsZVkX0fP3GBwnrYHrijdGSduDVTxz7SiquBkCnPi rQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh248q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 02:38:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 02:38:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 02:38:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7758A3F703F;
        Fri,  9 Oct 2020 02:38:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0999cWWF004250;
        Fri, 9 Oct 2020 02:38:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0999cW5w004249;
        Fri, 9 Oct 2020 02:38:32 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 4/4] scsi:qedf: Added attributes for RHBA and RPA
Date:   Fri, 9 Oct 2020 02:36:31 -0700
Message-ID: <20201009093631.4182-5-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201009093631.4182-1-jhasan@marvell.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_05:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add attributes for RHBA and RPA.

Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 46d185cb9ea8..e4d800cf9db7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1715,6 +1715,17 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
 	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
 	    FW_ENGINEERING_VERSION);
 
+	snprintf(fc_host_vendor_identifier(lport->host),
+	    FC_VENDOR_IDENTIFIER, "%s", "Marvell");
+
+	fc_host_num_discovered_ports(lport->host) = DISCOVERED_PORTS;
+	fc_host_port_state(lport->host) = FC_PORTSTATE_ONLINE;
+	fc_host_max_ct_payload(lport->host) = MAX_CT_PAYLOAD;
+	fc_host_num_ports(lport->host) = NUMBER_OF_PORTS;
+	fc_host_bootbios_state(lport->host) = 0X00000000;
+	snprintf(fc_host_bootbios_version(lport->host),
+	     FC_SYMBOLIC_NAME_SIZE, "%s", "Unknown");
+
 }
 
 static int qedf_lport_setup(struct qedf_ctx *qedf)
-- 
2.18.2

