Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F172343F4AB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427170; cv=none; b=f59I8M5aLGTCZLC+UVruL6YhkkWpc7mksa/G8WNi2k3rEnehl4auARoPLCXLfqr01JF3SPozJKrdES5AzihzJIQah6vLuyALVbgQLyGgm1AUDryXKIcKtbKOdgdsocEA0ZBoTXRYvrQEJnHdUYfatbkXP46fQ35rGBs3v89N2+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427170; c=relaxed/simple;
	bh=N7D2kozbXTbUgzlOCIdXYQ3cfnsPQw5cF2/WGVhGDJc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwj1DT8y2u8KXX7ZtDwbn5MA08liHrFCkiTNMLJiPWrFm0Og9tf2Zv+kz/3jOrj2tqkseuN+auEFoaWpLGyjSHc6pQ6Qn21bmNaye47WoSUqSvhxESFb61lHFOoEXMGOlWwAp5lcd3SMWFFj6wNY9TwBLbs4EOnsD8UMAIoqsUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TvT+hKdR; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TvT+hKdR"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWI7C1321632;
	Thu, 30 Jul 2026 08:59:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	jZNlWNv34zV+2MPbq3AHHyFyg5QxXRCImIjcWPpsko=; b=TvT+hKdRi8vvXUwzV
	uOxCRBIlnwQuV/+tE1gFiJiWoo9Z233Ib9wjmDoJZe6vXUOhGtd1ei6Fg6yQaYQg
	DYhuOY6s84ud2zetMg7vajkmy6QwacrcsjTfiX1/TWWmvt5tKtXjc2zSZMBuMKJE
	qim23cr95ok7kHANwafjyqmaJLeeBTsYgLXkaF/Bw8YLRw0OHw8EkUTBKEthDMTb
	7dhWe3p0bxtj0y2wVp3szf6Qr14/KUdVmiQ7lpRrdPv/+ivLEsTWUvBk5CyHyAHG
	Ud9wM6HkTYe0Q7n9M5+U97qXd5A675h4UmAlqRKNZH+88RCs04bUK0KPuwtbXjiM
	GPKoQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:24 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AEA203F704A;
	Thu, 30 Jul 2026 08:59:21 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 07/33] scsi: qla2xxx: Don't query firmware state while chip is down
Date: Thu, 30 Jul 2026 21:28:12 +0530
Message-ID: <20260730155838.2119230-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: B6Tnqy9XXcNo3rxW6HCuBEhY1CMTMG2I
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX1pSStqOJ9a3x
 eW/NT9Zlwaqp6eczWuJb2Z8twW25xTgowwr6vQDnDhK6iwO0SRT3oke4ar3VSvnmvVSsWkP9wv5
 x2u1SzmoJs+dUT6HoOmM4F6tLtQk60o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8GwCwobZK219
 irY0WcE6wY3OdyKE5NVOtoSpyUNpoqfXsQ1K6D+VhFpE8RtCWwdZchdo7ogsDzN3A4WuMCyN2fk
 peK9JSQLTuDM+xDAcjweIxOq8bYG8QLg6q0lL8EWW+lLEeMAtcfEpNTzsbpA4IQSSnRhp1zVn0v
 DZ5ti7sYM6sOp0HtmXcH/zehB2vHI+MvlWUEziIimms+XNZlL/7eqW3diGycigxWXa8fqMZpelA
 Yv2h3a40yUoniyXHxJDSkbactGWg1Q48k6zQIoPvi40XuNO3xJl5hSEC/n/X+qcclGFGy0k/HYE
 A1mUeBGKtf9dJJSJGOup0y8hlpnSqumQjYjzDIppJKSsQ9nRrG6CLEdeXzxUyZoeTeidAakHcnP
 I0APj2ndL8t/eck8fNw+bnX05Cb9ZIMVu6jrO3EY8DBovYHa1riq/2Gr2aOeg8MezBS6CnbS3lT
 Ifw/IhuIUw6ExbhjgIg==
X-Proofpoint-ORIG-GUID: B6Tnqy9XXcNo3rxW6HCuBEhY1CMTMG2I
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74dd cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=GH5Fyl_BdH68vyij-MQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
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

