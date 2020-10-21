Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77504C4363A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C29422249
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 09:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KAXv9AZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437898AbgJUJ3l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 05:29:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437883AbgJUJ3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 05:29:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L9P4KT006797
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:29:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/uyNtO7UWmTPKLWmhO93S4dul7HBSm4++kcYU22EHIM=;
 b=KAXv9AZ6EjAjF4PLqFZIF/u5/wwTXKdnlhDp1Vuk1TizpdPXBDLbuc4sr0lRW9UHacSb
 WVqDx88SX1rESAP5E6iFrdYgCaA0nXKMy2Gg5N0ZjX4XXljnGMEgwKXU5GUKv/bg/poH
 3SGV5oFeJXHJR6MKBDsYx9iYOFa0bJVPWn4YYD6Xtoo6YNDgByQ2/eWONGS8kmnjO4GD
 h2LVETDKj3+z3aPT6WwQ/GD7IL2WlvCdnlJxLj1ToX/myXWbH16v32F8GRuEVjJ3xxZ3
 c0MCo8NINpYiUpCuqwIZAlervcuy1Os0azefW13Ek4KaBTDMB3k5fIov6SrVkP1xV+p3 bg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 347wyqcmhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 02:29:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct
 2020 02:29:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Oct 2020 02:29:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 21D4E3F7040;
        Wed, 21 Oct 2020 02:29:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 09L9TdTa022741;
        Wed, 21 Oct 2020 02:29:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 09L9Td7k022740;
        Wed, 21 Oct 2020 02:29:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 5/5] scsi: fc: Update documentation of sysfs nodes for FPIN stats
Date:   Wed, 21 Oct 2020 02:27:15 -0700
Message-ID: <20201021092715.22669-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201021092715.22669-1-njavali@marvell.com>
References: <20201021092715.22669-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_03:2020-10-20,2020-10-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Update documentation for sysfs nodes within,
       /sys/class/fc_host
       /sys/class/fc_remote_ports

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: James Smart <james.smart@broadcom.com>
---
 Documentation/ABI/testing/sysfs-class-fc_host | 23 +++++++++++++++++++
 .../ABI/testing/sysfs-class-fc_remote_ports   | 23 +++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports

diff --git a/Documentation/ABI/testing/sysfs-class-fc_host b/Documentation/ABI/testing/sysfs-class-fc_host
new file mode 100644
index 000000000000..0a696cbd8232
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fc_host
@@ -0,0 +1,23 @@
+What:		/sys/class/fc_host/hostX/statistics/fpin_cn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of congestion notification
+		events recorded by the F_Port, reported using fabric
+		performance impact notification (FPIN) event.
+
+What:		/sys/class/fc_host/hostX/statistics/fpin_li_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of link integrity error
+		events recorded by the F_Port/Nx_Port, reported using fabric
+		performance impact notification (FPIN) event.
+
+What:		/sys/class/fc_host/hostX/statistics/fpin_dn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of delivery related errors
+		recorded by the F_Port/Nx_Port, reported using fabric
+		performance impact notification (FPIN) event.
diff --git a/Documentation/ABI/testing/sysfs-class-fc_remote_ports b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
new file mode 100644
index 000000000000..55a951529e03
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
@@ -0,0 +1,23 @@
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_cn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of congestion notification
+		events recorded by the F_Port/Nx_Port, reported using fabric
+		performance impact notification (FPIN) event.
+
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_li_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of link integrity error
+		events recorded by the F_Port/Nx_Port, reported using fabric
+		performance impact notification (FPIN) event.
+
+What:		/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_dn_yyy
+Date:		July 2020
+Contact:	Shyam Sundar <ssundar@marvell.com>
+Description:
+		These files contain the number of delivery related errors
+		recorded by the F_Port/Nx_Port, reported using fabric
+		performance impact notification (FPIN) event.
-- 
2.19.0.rc0

