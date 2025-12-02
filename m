Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F582FCC1B
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654389; cv=none; b=I8RCo3eKCCsPcYzcNB9CChBjeOEkvHWk1raz825/vzbTInt4iiV1bbbIIkIICNf6W1DZdJ6MjQ7yBbmeHUzk2nxiZNUjtsh9UrZeiRdDBrhDQ830tCMxdzJmTcZHwZaRIkyMyKMQp+kxtUwNYAdalOfRT+aG3XQL6tp/VnQXKZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654389; c=relaxed/simple;
	bh=3F78nHKMV76R9MJhZEBpM/YZl5Ojd+Eey6Y2jXjgTTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPgdeN5EcULjCVfhfFodIlCjQiRuRKaA6uEaIANOfA/iiqK4fNw5vVIwPVNspjfjkMc8ALKFnSFAA1DcHLQavOkK4Xz7js07IkVCqfIATWokiq2bQvrIjgPtKelT6tY6M47I5mUVi3uWyYVxFoe4TIjDQQFUjK5ZdrCmPi4kLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Ykt84Lcz; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ykt84Lcz"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B23HHjg1217699;
	Mon, 1 Dec 2025 21:46:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	eNmYBPB85u7Dp4dsJl223PvoJKdwRv9WxjZzOKuYYA=; b=Ykt84Lcztaqmk9SB8
	3r+J5kt9eHx8ecbHoLxNf2MKFHUkISrM45IFCyCUpO7bUhcI11FY5D/98CjAEqOZ
	/Kqc3BLGXvXCreHBoNDrSRCWqdXCNCUSvUPT8I7uv/LixwEySGkdAhHBUGl1JhT+
	cjsh1wcia7Iz9nI3DO/k93ssLJ1G0jB756hgI2uMZrGpw/XwXAl+Idmj3qY3tDfq
	TZyNW7DaVYVO+5h/+c3DHTDiRUo5+kTCwmgYuEXHy1z96obnvebLXMGqyMb8YFH1
	LsP4fsmc59Bwv1IjgzoFwgQM4JyXy3gxrjk1uxQ+balFC+tpL+qV41hk671BwepO
	cMpuQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4as99ca9k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:23 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:35 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8BF765B6972;
	Mon,  1 Dec 2025 21:46:20 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 12/12] qla2xxx: Update version to 10.02.10.100-k
Date: Tue, 2 Dec 2025 11:14:44 +0530
Message-ID: <20251202054444.1711778-13-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: S1EYJudmLOW-GT5MhmP4sCfKnJmOJ-s9
X-Proofpoint-ORIG-GUID: S1EYJudmLOW-GT5MhmP4sCfKnJmOJ-s9
X-Authority-Analysis: v=2.4 cv=U+6fzOru c=1 sm=1 tr=0 ts=692e7d2f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=HJKeYLzhmGgdqKWla5EA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfXw9aknqQzsGZD
 HGSoXS4WPIexIzDyfDbaTKdwL0ovYR5EPUiFGGi04yuglJxiagIK/oCTO9b1awEllGPawFeqNB0
 x7YJT9ZEUk3PPey7QWqg8ZMi9bzp2HmIRcfvCO64GDThFSEHdxvzre4u/HYYgJ2/iU/y9TYbZdn
 xflsjHP5endJ/cpXZBkJaA8knNDNa1LqIMJ5kMg5r6cIk+cKZc+iXcHgpU7IpdcVv99wXxBPH7Y
 7298lg3uk65zXx+6JDk3RsNL5IdxIqa+sPVF8QY2YuxZeV4+1u1LBC1WbKhG/RuK6/enmgy3UH0
 +SmYZjw+Ct9qOUv2ApeG30uXGlFCy43DSGaB3nFa8uOU5V8vQQyQFMdsTfsrKD4jPUhjAHHlqqc
 LQC6og2nbi33dvjOFvJviHuDH4xZiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index a491d6ee5c94..9564beafdab7 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.09.400-k"
+#define QLA2XXX_VERSION      "10.02.10.100-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
-#define QLA_DRIVER_MINOR_VER	2
-#define QLA_DRIVER_PATCH_VER	9
-#define QLA_DRIVER_BETA_VER	400
+#define QLA_DRIVER_MINOR_VER	02
+#define QLA_DRIVER_PATCH_VER	10
+#define QLA_DRIVER_BETA_VER	100
-- 
2.23.1

