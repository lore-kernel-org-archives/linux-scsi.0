Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8288B22EFB
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2024 07:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713166627; cv=none; b=Q47HgpGbYRQXGsm+N1lagUDfXMf84peHiqSruevt/+LC6kPRrqSp9FiAnMdh4l1UgoDn/Ez5Jcwhq55R2uIWcU3Rgz7+ZrbT3z1bCO5LxWEREhihWUSHmz8RVpH1QweLM6GEcHCpESKwb1WAtZWT9kuRkLhDrl8t6c8UVoyNpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713166627; c=relaxed/simple;
	bh=ibWcRCVCYVlKYAzuKDlgU7jKnQpeojkQvcPR28/ZxZ0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GeYxf6mh3YOys0FGeHYmWgCJTqYk7Ru/1eWGRFrKP2DazLXrpZl6V0z64q+0GWdiGRPxL3zE7n2hCFd+xZlXFysFVYYdlnWWPracMEBJmU7vu0WDK9r1neWGi94rxKFVNQ9gWP1nwE4BzM8WskXdTmT5i+LpDxQ4MJcej9WA1LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=PCdlYNK7; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PCdlYNK7"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 43ELwg2M007746;
	Mon, 15 Apr 2024 00:37:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=JY+ArcEp
	m/xaUFePhNjV8cLkXT/T8gT4KAREu7ILsgo=; b=PCdlYNK73OM9ccwkW9zruwvI
	S4cMXDDzMy53rxxkSkF3W3/H+FsART0UbHB46pDtHgzAKnNry8SKOOeWXrQd2ORf
	cf55YQacjb7DJrbODDc/1V0Hex3GmcqSOf9DLxwvmoRreLHWY6dctJQEg9UqofCS
	+IqtDNnf6JLEBl9F5FO2mJYUXmfkkwj1gni1NLhtu6/tRDKrXSuWNgkYUaBYsN2p
	4eTZrekFzf8/J9IWkytsAKx6c2qO2zr/w2KVC5SsuhCPJjonbmBToFpvtjNsZtex
	7s8xFohNE8OAYzYFTY1StEH6nBBhR3zsKtxrRTK1jce8R82nnWfaWtb8Zg4weA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3xfsjg3q74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 00:37:02 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 15 Apr 2024 00:37:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 15 Apr 2024 00:37:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 44FE63F7069;
	Mon, 15 Apr 2024 00:36:59 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] qedf: Fix uninitalize warning from kernel test robot.
Date: Mon, 15 Apr 2024 13:06:54 +0530
Message-ID: <20240415073654.31859-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: GAqf-WUpX0KzECEoFrjDgOjRBxEdXyc1
X-Proofpoint-ORIG-GUID: GAqf-WUpX0KzECEoFrjDgOjRBxEdXyc1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_06,2024-04-09_01,2023-05-22_02

Fixes uininitalize qedf warning.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403160959.uNobO4UE-lkp@intel.com/
---
 drivers/scsi/qedf/qedf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d4563d28d98f..b97a8712d3f6 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -919,14 +919,14 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qedf_ctx *qedf;
 	struct qed_link_output if_link;
 
+	qedf = lport_priv(lport);
+
 	if (lport->vport) {
 		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
-	qedf = lport_priv(lport);
-
 	qedf->flogi_pending = 0;
 	/* For host reset, essentially do a soft link up/down */
 	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
-- 
2.23.1

