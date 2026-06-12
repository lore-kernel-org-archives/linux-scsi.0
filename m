Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8798339844
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258116; cv=none; b=AH0vdV3iz5FYz4IcXE7ychJXyMYBjC5S4lovyv0F2VhhKhuq2MaqxRLNb9prn31ksw8K1oi9lPKm75wXmjd5aacANB2PLSWRsEjaH5ZeVXrjFrvU1ITMDVKHnuaIXqKVvWvW+lvUpeObcfTRt5oe8eJm16kq6U/36VAEF4uDtbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258116; c=relaxed/simple;
	bh=MPemoCZco2wmv+fMjQ4I0hju7AVFA2FW6Y9cOivSXjw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4BDcjY0HnUmnXUcIJ5xHRn/1jNoCj212JAtLF0mwY1h0P/0o0ibrij6wNioe6AQH2tPcyMSKXWbk9QSbsU0qx/6StMF/NCgVIiyasxTLOr40LZYanhE3EoKOAlAC+meazKEeC5+9yHdtvtOaff9II+prAAu1J03Tp0VsiaMNVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hOFjsQfC; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hOFjsQfC"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C5FYEa273217;
	Fri, 12 Jun 2026 02:55:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=N
	QXpIz7cfebNedYFCDwRTRzGNQWgv+AX4hnqpGICFZg=; b=hOFjsQfCME89bGTbg
	+xhVQVJgWLtdtQEgkjawGEExTE/uqEaCugraRH/FvYn5XfIaqiVrvIuH+as8v4KZ
	JWwWbOT45FGlNPRL5xLO3GfvFmw53T2U7sNu/I8jFv0MT/7JJ1WBFTdiHOKqPyfz
	dR/zLuiVG7Qxa7F5wkbltI2fPJsk5UzxqqRKaE2sj53WdI5ghCJKmcsJHiFWcvJk
	15B0kVaWAAj4/AjyODy7nLNWUok28yjUvi4JjuupeE1ZV94C6tEEfEjjSDY4j0SJ
	K+vHNLd6OkkMf0Ct/R4UF+Rejjm5SnnyiXH0Tsa+J50ohzV+160CimK3/OWdTigr
	tEx5w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5r6ruj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:11 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 68E723F7040;
	Fri, 12 Jun 2026 02:55:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 24/60] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
Date: Fri, 12 Jun 2026 15:22:57 +0530
Message-ID: <20260612095333.1666592-25-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3zuPR4a0KVsJ
 QndI7By1I8tTjfsUkM55HmsXqwzbCqxUwIBXG6CIyHr2BGKRCEM2LbctI/YDa1NSXcz3QySG7ZK
 PiEIMoOSYzmG9NNCbk0PPj9rvZvaOTE=
X-Authority-Analysis: v=2.4 cv=O6gJeh9W c=1 sm=1 tr=0 ts=6a2bd77f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=C3ITPKR1BmyQqgtea3sA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: quhikodpUhwiV_aXyckKxLMdEVia-xue
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX+Twn62XI04+Q
 ZS8Smk88DNyChJeKK2FVlwD0kkO/V+nwjZUc7bj2nwKDsVnab2EXpD7JAlAqw57JrOX/wVjRko0
 POt2NU6eYX7OQr1lCzZX1/4Rh4JeRq24IMrghUFpDXFWEQW9jRehHVA1onWJJY/SbprCmLxbqAZ
 PJ5dDRTkauXSxCCnIgIGGVFaiFs9sKxxDrLggaPgezv/7FYSi5YFhGTPUTWvFr3OxEx+PigXS8p
 yvPU3LybE0Rr8EV9RTVaqe/MWHgiz9cVO4kwPaDK3rCfCSF8moSxYZ+eP3KBNyQr2qrXATgtb8H
 DHdS6gA+8MN/1ZNvI3cuM1f8ZBh+lVtIh9WfeHKCVHNyoQQkOakCFNb+2GDIbxlcraMnqNxOT+Q
 ADm/R73+U9tuUi04Wg5E0u0ewT7ZeDFdy401W5jBxfgziLkNwRCLjE9LGuzx7s9JCPTLfRXsIZc
 oBknics7SYeLKhdnR8g==
X-Proofpoint-ORIG-GUID: quhikodpUhwiV_aXyckKxLMdEVia-xue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ef105ae6af41..a3e2c0a95a99 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_disable_eft_trace(vha);
 
 	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(vha);
 	} else {
-- 
2.47.3

