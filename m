Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB8C171AF
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674344; cv=none; b=db0wMg5PLz+i+qJa4cg1f0DXO5qWqLZ1Ji2jleJrsCOCAur7OlWfdjt0IWBoHgpA9BLfadaD5iqhWOKxo0ky527o7qIcAahV4ssSoufTHrL5o8T4+k85+umMntE4FIIy0oGco+8YmSdViBaSKN+wPymrhzYfpKA3RuvgdMX1lmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674344; c=relaxed/simple;
	bh=jTOUfgMzx0VEIJ8R9UlqzSVNGFF//mM3cAdxspuNWY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pK7o7JWWgtM7cZdqEI0QWEs70OpYgOYd+5HkeqjaT2LUf1Z7nntBVHz3RxpAJYuO+00Xpz6e7pfMsW0guKekMsuuo1fbpNTh0Oaye+XZBa/k83Qqeby4PtxLi3H0BDnIzhiywzNm+KHFMHdgnZ8YDegVZ/4In5rS2vtYdTJ1Vgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gsS7pna4; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gsS7pna4"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML9hf3004537;
	Thu, 22 Feb 2024 23:45:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=l2oFTj1TZU5njvu91BqjoaOBsm8fnFxQKZ1x0OTK6pI=; b=gsS
	7pna4RVu4VVnWcApqh764DGR8KbIqJ6KlyxRkUNjC+sQRsGJSrLd/CJnRgBjyXef
	WpBta0Y2TW4Cwt5+3L1g0gqzz5FgwaLiYIx2L1Vyp9YVYktK8+fYuu4/kmDtCqkF
	0TsyxETr7cNN1arh+tYiaQbHRBZ4muLSbnsN4KkewV/Ev5JcxOa8zeomGgH/tLS5
	/q/BBoa2hMxTXElAjmut7Ypca5SIcDq+OiWwYQkPerJOIPNCT5tZbruxC7iXP/rv
	XLyVfoZjx3uf2FIaAwr7w0p7xD2cefgykgJGy4IoJp30F3wOn/1/mwWjtRV1Cckn
	h0ntywpevdntH8MB/Jg==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:39 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 22 Feb
 2024 23:45:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:37 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 40C443F714A;
	Thu, 22 Feb 2024 23:45:34 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 04/11] qla2xxx: Update manufacturer detail
Date: Fri, 23 Feb 2024 13:15:07 +0530
Message-ID: <20240223074514.8472-5-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: XI18HkvjKa1czfQ1aYm6YfFdTPC9qKv3
X-Proofpoint-ORIG-GUID: XI18HkvjKa1czfQ1aYm6YfFdTPC9qKv3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Bikash Hazarika <bhazarika@marvell.com>

Update manufacturer detail from "Marvell Semiconductor, Inc."
to "Marvell".

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index deb642607deb..2f49baf131e2 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -82,7 +82,7 @@ typedef union {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
+#define QLA2XXX_MANUFACTURER	"Marvell"
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
-- 
2.23.1

