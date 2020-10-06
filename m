Return-Path: <SRS0=xWhZ=DN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD36C41604
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF8520796
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Oct 2020 06:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="i5cYCA4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgJFGSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 02:18:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24634 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726795AbgJFGSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 02:18:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09666Ffo016736
        for <linux-scsi@vger.kernel.org>; Mon, 5 Oct 2020 23:18:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=31NCMPmiddvqvW3PD4OjEsHEkWzzCZgMpHa8ZYEUl/s=;
 b=i5cYCA4zQenERia3IhkiNtTwc4pNna5WyReQrm+tEpnS1eyjWHMzi4WL8vmwmeHt/YcS
 dXJ4kVZ5vnN8wHrvgSQUO08II45SGTMCif7Cp8SNeDk2kZjxSIiiBO3PMzOorJpnOwNt
 qtsPYu/W1xf9iEZI6qVsSgptxVHyG2zfMrYkXuyveRqWSDLERXR3WxULJ/XgXlNNMHZB
 vhRZFG0SMiYeG8DB7KIyyqQI8oPC2IMneE4uxybV4v/of5ihC40mcR1pnS2qGoJWGiws
 PxPix8r7BXhUIkNVJVlZuIER8vQf1b6KY/MXxj1cpLx3iBJj0snW4y0g+AWYxlUi1MPa 1g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33xpnpr0af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 23:18:41 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:18:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 5 Oct
 2020 23:18:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 5 Oct 2020 23:18:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A383C3F703F;
        Mon,  5 Oct 2020 23:18:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0966IeV6028753;
        Mon, 5 Oct 2020 23:18:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0966Ie8U028744;
        Mon, 5 Oct 2020 23:18:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 5/5] scsi: fc: Update documentation of sysfs nodes for FPIN stats
Date:   Mon, 5 Oct 2020 23:16:15 -0700
Message-ID: <20201006061615.28674-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201006061615.28674-1-njavali@marvell.com>
References: <20201006061615.28674-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_02:2020-10-06,2020-10-06 signatures=0
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

