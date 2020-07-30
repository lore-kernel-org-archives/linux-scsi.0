Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A985C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 06:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56D9220829
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 06:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="CkSsTouM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgG3GMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 02:12:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31944 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgG3GMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 02:12:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06U66bkf030677
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 23:12:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qO1PCsxeHPCJjKib9vkKYagJo9+4MBmMuDzPkXu1p7E=;
 b=CkSsTouM0h07liyEAcfwMR1HxEdc0wOe6/tyhvhpAS/zTMde8WD+VsMjChwD2/s7LlDo
 2uy0YSWM7tNgKuFNNoPbiAomXPldFGVB1YZmK4DcRx6MsLBISaHgEMZkNQ3Gx2pgxf4m
 XXfu5tTFIympR3JlP5rBroXCMyjCQvGcf8NdphgRtHIyzzOQDNJ5hdRhjTXJllDXKQgg
 keF8PmnGHN4jBuzY0xQ8G1547Iy5sGoD439F2B6kWK8/U+qZO3GmbAmOit07tMouaAF9
 yEafvKbmGD+mc4OrQWf6IbkCYBukmSqB37tLqYaeyFV3R9L/uQrv4gLIUBEx3TUDXKZb gQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32jt0sxtvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2020 23:12:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 23:12:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 23:12:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CE6E23F703F;
        Wed, 29 Jul 2020 23:12:28 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 06U6CSNB020162;
        Wed, 29 Jul 2020 23:12:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 06U6CSxX020161;
        Wed, 29 Jul 2020 23:12:28 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/2] scsi: fc: Update documentation of sysfs nodes for FPIN stats
Date:   Wed, 29 Jul 2020 23:11:16 -0700
Message-ID: <20200730061116.20111-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200730061116.20111-1-njavali@marvell.com>
References: <20200730061116.20111-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_04:2020-07-29,2020-07-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Update documentation for sysfs nodes within,
       /sys/class/fc_host
       /sys/class/fc_remote_ports

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 Documentation/ABI/testing/sysfs-class-fc_host | 23 +++++++++++++++++++
 .../ABI/testing/sysfs-class-fc_remote_ports   | 23 +++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports

diff --git a/Documentation/ABI/testing/sysfs-class-fc_host b/Documentation/ABI/testing/sysfs-class-fc_host
new file mode 100644
index 000000000000..a1e6ab89b86f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fc_host
@@ -0,0 +1,23 @@
+What:		/sys/class/fc_host/hostX/statistics/fpin_cn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		congestion detected on this host.
+
+What:		/sys/class/fc_host/hostX/statistics/fpin_li_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		Link Integrity errors between the fabric and this host.
+
+What:		/sys/class/fc_host/hostX/statistics/fpin_dn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		Delivery related errors between the fabric and this host.
diff --git a/Documentation/ABI/testing/sysfs-class-fc_remote_ports b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
new file mode 100644
index 000000000000..185db8ec6c05
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
@@ -0,0 +1,23 @@
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_cn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		congestion detected on this rport.
+
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_li_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		Link Integrity errors between the fabric and this rport.
+
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_dn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of Fabric Performance Impact
+		Notification (FPIN) events generated by the fabric, to indicate
+		Delivery related errors between the fabric and this rport.
-- 
2.19.0.rc0

