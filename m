Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9483101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403894; cv=none; b=qOH9k6MxANgyfYwoLHgPMaVuyVSaKk99TisLdVb4zryZgv0MmsCUHKC3QTwABRUMDRqG5APoMPdb8IjSHYVyBg0X+juDBVP9A6vWjHxh0KvDdXNwmvgaRof/y+bW8rgkFXwzETCHn6WiWctTf0IAEAeNxNZeTp4b5DRqcWzrOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403894; c=relaxed/simple;
	bh=zO34yNXqZ4BzZR8koVjVMlm3whNHbU8icNGT90bElzQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crhPjCGN8mllh3WLRmPfo/xqW/vZc7juZdi9RjPA1yHCZDN/xqaYUJqAQYB12v2CgWmcSvPt+jZtSlfsmLL/N4wAoYetEdmVKNoIgFKdsWqUlMR3+Rib1Ki6eO9z3oaX+WbpG7BAaZL9OBsZPLDQsv+EGTvU1tmC9VI5XnKvvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=H8aY+o05; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="H8aY+o05"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748jSN1619393;
	Mon, 6 Jul 2026 22:58:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	aeyGjtrdMqIJtzU2wZYSgIIc5LOrbjobAy2vFT6PTU=; b=H8aY+o05vLcU1EFGG
	u6aZJR/JSYcx2qUrNKCQJmccvfRz3daajCF5EkB6hyVcUa9N3EuCw3lUHcXFT023
	luMyHnrGQaAVvxEBvXvWpawe62e7hKyhB2gov+H8B/v7nIPu0kJRLnSIujGhdkER
	3Y44tAP6Jty94dw1QXIl9l5UifIcuVrrTtx5Cslr66wQnnGev95FdbzbOZbB7Ohg
	MYTRfkQI33/odMc0m7kwfFqivbcKN3HdVmI+qXDHpq3yvWtoBSJQYc3wZvLwutLf
	TwQJQ9MgRmJZnU816+UiK8WTLaNM16nOZJJhApVODPHSs5rD8vVV6KsPzoObRa9b
	5lCRw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:09 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 905F73F7066;
	Mon,  6 Jul 2026 22:58:06 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 65/88] scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
Date: Tue, 7 Jul 2026 11:24:12 +0530
Message-ID: <20260707055435.2680300-66-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX/Rg+TlD9SG0o
 8YPFbU8DfU3fVyaqrLaC32+/Cr4wTlDgf/Zirdp5qKHJPPd1RZKo5BlHZhVcEgndwglj9tyOvfk
 riJhOP3VXuZZZU5KMFfnxFuTOF3dlyI=
X-Proofpoint-GUID: E9ofXNcW2Qt55mst95PxkPcgMeaPdgBt
X-Proofpoint-ORIG-GUID: E9ofXNcW2Qt55mst95PxkPcgMeaPdgBt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXzqSkZtvHTctr
 UIhCJQLhQYW529SwWPHSjXy9cz50yDp/IMwQN24FCkAX3vNxfEqOFs70TIdQ9qrfNMm6TUQ+gIi
 BH6fLt9Wvt5TVANB3VZX6GHcHaJiKXH/QFz7GZqh11V0u2NB09fojwbONKXHHMXNn6geD/Wa8Nc
 4c10+lyIwn9iWKs+Ek5DGlA+50xv1HFWle0yq5OR27A9UHw5Wdvjd6qLz3S7RxyPH+KDrgBvjKS
 QytojKAtEE67f9MdGIPKxxXaS+puUlh+HbkukjSLhpqN1ooOAdzMXuxILpADHyJPlZnzqe6GfoW
 MDK6zORAUVUHxwvrVrqEdoeBVZjKaQe2B7COkS6hbTFE6PD72Z1WLXlFeD0ifeosCK7v7FiylLv
 RhVvroYifcxkyBmcyCEeNOq3BfrZjEbpKRm4KRcblA9mhf0fvlQf8UgtFJk2Ds5asxnGv18d1A2
 uaNYlWOAO9j5LD0wKFg==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c9571 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=bAolQom50hykzV7YMrMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2x00_free_fce_trace() freed and cleared ha->fce while holding only
fce_mutex. The firmware-dump consumers qla27xx_fwdt_entry_t264() and
qla25xx_copy_fce() read ha->fce (NULL check followed by a copy of the
buffer) under hardware_lock and never take fce_mutex. A debugfs FCE
disable could therefore free the DMA buffer between a dump's NULL check
and its copy, resulting in a use-after-free.

Unpublish ha->fce under hardware_lock, then release the lock and free
the DMA buffer (dma_free_coherent() may sleep). A concurrent dump either
completes its check and copy with the buffer still valid, or observes
ha->fce == NULL and skips it.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9d6b229bd352..76b7ed501b04 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3752,11 +3752,27 @@ int qla2x00_alloc_fce_trace(scsi_qla_host_t *vha)
 
 void qla2x00_free_fce_trace(struct qla_hw_data *ha)
 {
-	if (!ha->fce)
+	void *fce;
+	dma_addr_t fce_dma;
+	unsigned long flags;
+
+	/*
+	 * Unpublish ha->fce under hardware_lock so a firmware dump in
+	 * progress (which reads ha->fce under the same lock) cannot race
+	 * with the buffer being freed.
+	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (!ha->fce) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return;
-	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce, ha->fce_dma);
+	}
+	fce = ha->fce;
+	fce_dma = ha->fce_dma;
 	ha->fce = NULL;
 	ha->fce_dma = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, fce, fce_dma);
 }
 
 static void
-- 
2.47.3

