Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A241C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BAEB610A1
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 12:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFCMS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:18:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229765AbhFCMS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 08:18:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153CB28H011295
        for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2021 05:17:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3+HsN8/pVILzoYPJ9OOFx+UL7c5E5acPiqULhzQJyQU=;
 b=fVf/LmrWkq2CmgkSWp7TNd4yNoZMPv7aMAoLX8uWyZaxSUqiYolzLgQXtZDEbnua09dV
 ns1jDtFV5S7TsLgE2kkVLD464fXt5fs3nqrrqpdeS88dNFCU7aGBms+Tvqv+f7FE8MHE
 oFqCnmVBUuZhLUA9Wc/lWnhFCLuSzYK/g6ZVwiww+y+P4T0CzR4r+VKTHRIxQ3K7O3QW
 FSzG+LfGWTdjiGbRMaCpnz25DLruOfmu7W3nDNy/8uFGYzvm5g/XCprl6onPZ0rmR2A+
 o6zjAal3+Xs8qBVOXxWmIhz8zTGm8+mF1BH35NC2F8Uw+Ajn8LijPNsXIlNuo6+akweI Bw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38xe7xuhc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jun 2021 05:17:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 05:17:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Jun 2021 05:17:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0E2CA3F7040;
        Thu,  3 Jun 2021 05:17:12 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 153CHB4e010132;
        Thu, 3 Jun 2021 05:17:11 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 153CHBO8010122;
        Thu, 3 Jun 2021 05:17:11 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/5] libfc: initialisation of RHBA and RPA attributes
Date:   Thu, 3 Jun 2021 05:16:19 -0700
Message-ID: <20210603121623.10084-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210603121623.10084-1-jhasan@marvell.com>
References: <20210603121623.10084-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wfI37ZfFhmp5CXxHeLvkL1kofuWmbzWZ
X-Proofpoint-GUID: wfI37ZfFhmp5CXxHeLvkL1kofuWmbzWZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_08:2021-06-02,2021-06-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -initialisation of RHBA and RPA attributes

Signed-off-by: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/libfc/fc_lport.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index cf36c8cb5493..72d13a2a4691 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -93,7 +93,10 @@
 #define FC_LOCAL_PTP_FID_LO   0x010101
 #define FC_LOCAL_PTP_FID_HI   0x010102
 
-#define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/
+#define	DNS_DELAY	3 /* Discovery delay after RSCN (in seconds)*/
+#define MAX_CT_PAYLOAD	2048
+#define DISCOVERED_PORTS	4
+#define NUMBER_OF_PORTS	1
 
 static void fc_lport_error(struct fc_lport *, struct fc_frame *);
 
@@ -1859,8 +1862,27 @@ int fc_lport_init(struct fc_lport *lport)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_1GBIT;
 	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_40GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_40GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_100GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_100GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_25GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_25GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_50GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_50GBIT;
+	if (lport->link_supported_speeds & FC_PORTSPEED_100GBIT)
+		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_100GBIT;
+
 	fc_fc4_add_lport(lport);
 
+	fc_host_num_discovered_ports(lport->host) = DISCOVERED_PORTS;
+	fc_host_port_state(lport->host) = FC_PORTSTATE_ONLINE;
+	fc_host_max_ct_payload(lport->host) = MAX_CT_PAYLOAD;
+	fc_host_num_ports(lport->host) = NUMBER_OF_PORTS;
+	fc_host_bootbios_state(lport->host) = 0X00000000;
+	snprintf(fc_host_bootbios_version(lport->host),
+		FC_SYMBOLIC_NAME_SIZE, "%s", "Unknown");
+
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_init);
-- 
2.26.2

