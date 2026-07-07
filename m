Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA34127466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403886; cv=none; b=C6R84kKGc4cZLfSVsYfXqBKatO3U36NlX0om2npVFY0Y+RxEBNgaV/aWp8/YsyPwYhnuGNuqdv5a4HyzqR3vSfRGemS5E6kg0oRaUfVS9xhvl/4WW7AXaxkcHZ/c4UoIlXHRM5fsVxwFG1VcJxfsREXFzeaZ/VQ3kkNlCjG1FWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403886; c=relaxed/simple;
	bh=IjsI/8gDF0QiReEyAlotmM+GjjYIur0KUPzgd7sJfGY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cv/5p5YfSsSw1XPyHT5pT6B1q8zIUGy7IXKoS5tpFDv/4na8jR46bkUWRWFD/4o/vFyF1TQOuiG8BybMoTHjVJ0W65eDzCYRclDOfdApGJ0Cfsv+xkmPbXMcCiTJea56XUAHsS6KmkbLkNfqdozUmuoTEA5NVV2sxYK2W1PP5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=L94QChno; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="L94QChno"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748ki41656454;
	Mon, 6 Jul 2026 22:58:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=q
	l2gjHx2RwNKKnbMp9wIIIJ9NSNVqBw9PL4eDH+f4sM=; b=L94QChnovFLt3A8PB
	EfHe37lWxN8K9jdywW124HgstX5SCyr2lEB+BYkKXjlv/ZL+H1ILSOD5Ty9BvcF5
	0WL7g25EODNA6l6dUuYNrKHQpup3Nny1NprFgspVRwEbySxLg7arm/jEldJbjdDx
	WWhCZc5PPqlKo8NgoXpo00s3/dLcVyg5AHDmx7QgUo2eqtfA3IDzz7YMeWeLVZxI
	KLvqI7VroWdY8X5TagRQNDskLOOnbC2CgEWT/EF8vbOV06lx8ZJdT+/cxCPhk2wT
	fy31fyIoUY80wUUZdonwSMhjn0LAAOG9y6fbK2OZoiayRTRuXJLTqdXGFACvfZR7
	9WO4A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:02 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 037503F7066;
	Mon,  6 Jul 2026 22:57:57 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 62/88] scsi: qla2xxx: Don't query firmware state while chip is down
Date: Tue, 7 Jul 2026 11:24:09 +0530
Message-ID: <20260707055435.2680300-63-njavali@marvell.com>
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
X-Proofpoint-GUID: EI03AYysmtZRlS56dN-yiMpvvakyjq_P
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c956a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=GH5Fyl_BdH68vyij-MQA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: EI03AYysmtZRlS56dN-yiMpvvakyjq_P
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0PTGUDvQvU1k
 R0JvjxcTqG5BLpUeloi5pv/VxujPgXRm/QtsYFdWMhXeunjczaerjrm7x4pX7JntYjfGh1nbTRH
 j5umFedP4qrQby+UA6VKiG6LSTEsnzI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXy4w4eXTrkmu2
 wnbhITsYVGIRQxd/5f1FHNLTrbAoIXFqC3ts5UzPLAyLtcrn72hM36IwZVWgApxynMFvapjJVcJ
 P6QdwJ6YFRNgE/ohQsHx0sjPbwrOLoCDu2IyCMDjSyzpYBB8nGzVq4xzCWbpBlxcd57GDgvneym
 pQ1Coa9UMvb7PRa3GlNrF/E3PCuq0SYIPCxsleLKBF0Y8um7+uCmFfBCKmjk/U9fBVW8rcIaK0W
 fPj36uZc+D4sfutgNDyL0Q6Yp22ClPwZyb276MKcI5MM+HCGRW0h0XVoGjPX2aaTcjTnCaZJagB
 XWwZ6m0Ke6EjSLlOR/nKr+bYWegQT9Ij8UXo8DPmcmPcCNv/ENxRzKjBDrA55+4TlgPqfJUvxkw
 WcYuFKwJsUCfHs5+I8SWXwrse0tS8NrObaoGBgQaoFRR8B5OYcW4/s4J07mOjQikB8/CQ3YHzUY
 Lh3vNnc4W+zwPw2rMRQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2x00_fw_state_show() initializes rval to QLA_FUNCTION_FAILED and jumps
to the out: label when the chip is down or EEH is busy. The out: block
then re-issued qla2x00_get_firmware_state() because rval != QLA_SUCCESS,
defeating the chip-down/EEH-busy guards and issuing a mailbox command
(outside optrom_mutex) during ISP reset or PCI error recovery, which can
hang the adapter. It also turned a normal in-lock mailbox failure into a
second unsynchronized mailbox attempt.

Make the out: fallback only mark the firmware state as unknown. The
mailbox is now issued at most once, inside optrom_mutex, and only when
the chip is up and not EEH-busy.

Fixes: b6faaaf796d7 ("scsi: qla2xxx: Serialize mailbox request")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 6a87d3bb0b0e..a4ca22024ede 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1678,10 +1678,8 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 	rval = qla2x00_get_firmware_state(vha, state);
 	mutex_unlock(&vha->hw->optrom_mutex);
 out:
-	if (rval != QLA_SUCCESS) {
+	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
-		rval = qla2x00_get_firmware_state(vha, state);
-	}
 
 	return scnprintf(buf, PAGE_SIZE, "0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
 	    state[0], state[1], state[2], state[3], state[4], state[5]);
-- 
2.47.3

