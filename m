Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF73386C1C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403882; cv=none; b=pAn+OzfieUpndy4YnjXaR3ZG7g/+Rcja43iEFgeQHKrgvUOhW0GmUJPXp6SMpOSNdoIQtDkV60yOgQdBfH1PuxK5k0lyF+TQMMYM0tIItNxOQ/7zFJl9XUAEDFgd01OZgTUxo2PD55wkZJ3Iw5xqAIBqm2Q4yJNw4KmZ4H9IF8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403882; c=relaxed/simple;
	bh=wIlD60VZr/Y44KWOZwDSd5kcShBPQp+iEYrshtPAA8w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vc7v/CH8ufJR7i9vc/9SixCWW+HpanxGfZmyZtqwZruIOgQfXf0R/BieOVERtkgxNgZiWk5v0DQdfmQo8UTfJfSsODhHEbzHrR3f80D0wkVnQTdjK+bz6NemdEJ4mzXPvkZs3PcwhGp8WbRr2wF4aEMwqtDtu+Gk7gGAJmdzbyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Fzzf0Nev; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Fzzf0Nev"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748fQJ1656206;
	Mon, 6 Jul 2026 22:57:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	uxC1wcniacArVS+Bkg1eyuFTpp3FW8AqWy8/YWRQTA=; b=Fzzf0Nevo1YQq0kOY
	P8c3LbaMWXrs4I4rmVE2iDSVjM93x5C0LXoBVFPK+LcA5QYTNwDtG4KMCa7wkA69
	ZZkzHzx0Oxj97RRq2eUMrVPbLDv6tIVM9bBA6bf+Yw6LfryJ0YQHpKc6EPWsSGzP
	ZEBzVEe2HCOuTzw8LpMgmVSlvZryJV13Q4QXa/l9AgKoqbNEY7Ftrlf03Sm5ks69
	Y4BPg/qcofqAsIwyXjXU2ZXNlPkeeop0+P3CHc/oPxb8oAejZIY+B9ynLvIhLeU4
	+PoI9HAsA/L4VBi9pwuOC/DFDTvqeq2bn/hoZdTM+GrYykfADGdeWvU5wijD+iQ5
	VYzrg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:58 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:57 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2948F3F7066;
	Mon,  6 Jul 2026 22:57:54 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 61/88] scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
Date: Tue, 7 Jul 2026 11:24:08 +0530
Message-ID: <20260707055435.2680300-62-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 94Y9Hi4toEFp-CIHSu-Zsa6FVOHm4h_Z
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9566 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=ad4WSI_q5LBR8ROCVKoA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 94Y9Hi4toEFp-CIHSu-Zsa6FVOHm4h_Z
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzW3xWpISPNKf
 I/K1oRlG2rIwiXJx614zVCJ/k2qzFXvhAMUf1jXKIWYfEqEwaheaMHu3DM2XebDeO13gZ7S/gHe
 Ztf6I+HtRpmpljM+o9ZFiV4BqGuaQR0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX2tDk8aJ7ct3w
 2Ng6JXAbDGRFC8TPRl0wDH0uWyOHglNZUzt+XsAWZ1q8bKoDLu6u31BFJMdIIvXWjj6+kBR7+O/
 QA+72aeM504e7xQUtrXukYCDpEXYPIxCo+3hdI/E62+ni64uzunTR080bDtWbTV+Muyrcj8RM+V
 MlqDLhQ2Y+kVCHnmrcrjazBWQ/uFCHxSe8nNKYUveKz+64tSKrmIntIgWD4UT1FkoqcGPLxi3lV
 zQw81KR95kEqzkUg6mfmYYDE8UbbaW5nbMe46Dv4cEXwwjKtsXJvxhRd+ihvI/vuuBeEmEmaqsj
 u3lXQueX53EFU0F9EVe95LMUXT9w8HmyQLDM2n7UzeQj7BBx1VVxXc8mthB/5+k62OuyVTD9wyY
 ILt3W5MFB8i5PsV5ziK7T0S4EzRc4m0EmQJoXM2ovvrTgJYFCcosEj657JSmtIXPvpH1E32erI4
 +/RWH4YWX4aHNwOloLQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla84xx_put_chip() drops the last reference to ha->cs84xx and frees it via
__qla84xx_chip_release() without clearing ha->cs84xx. During teardown it ran
before scsi_remove_host(), which is what removes the 84xx_fw_version host
sysfs attribute. A concurrent read of that attribute in the window between
the two calls executes qla24xx_84xx_fw_version_show(), which dereferences
the freed ha->cs84xx, resulting in a use-after-free.

Move qla84xx_put_chip() to after scsi_remove_host() in both
qla2x00_remove_one() and qla2x00_disable_board_on_pci_error(). Once
scsi_remove_host() returns, the sysfs attribute is gone and kernfs has
drained any in-flight show(), so no reader can touch cs84xx; the put still
runs before the host and ha are freed.

Fixes: fe1b806f4f71 ("[SCSI] qla2xxx: Refactor shutdown code so some functionality can be reused.")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 62c9bd0fe06d..4f485e4acf4a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4048,8 +4048,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -4074,6 +4072,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	qla2x00_free_device(base_vha);
 
 	qla2x00_clear_drv_active(ha);
@@ -6995,8 +6995,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 
@@ -7014,6 +7012,8 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
 	qla2x00_free_fcports(base_vha);
-- 
2.47.3

