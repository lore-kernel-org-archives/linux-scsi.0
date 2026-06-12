Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C1320393
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258192; cv=none; b=V0UW+JAF/51oQfUK59GpywPX1qSlniCiC/CxN3nDOypBqGodHpB0zT/E37Tchog1PGnjP0+h6I0ylPUEVBfEqxyHwYIg4/im0BbGL22tmlr1kZdu1xh04gX4HS+NEv2yPftb2GXrj9sh69RGPscSSF+cXPQ0zfEP4eVcnV3Hhds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258192; c=relaxed/simple;
	bh=23eM6diTFe/99n68Q9Lw/5Inw9Dxl+cm/vnvfpAPFuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgaUOMXxeAFeMVlyLNmOMgYop6pCmcKPT3mCmpwub1ixKf/popYGoD3JFEO9ILGT4wjSpfa91fYxMzJSo3AWMcVb5AhPfcoMzKKAu9gGFC4Iofz99K0WPS6pk22WfnevfXZl+uBJ6wSRqaRlhSSZiD112sAd+KKnMGlFDLMllH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=UfgOd63d; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UfgOd63d"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AOD6071008;
	Fri, 12 Jun 2026 02:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=a
	+FBeIXtgDGfm0Lpx4Ieu2+9Qtu3ycmnIXePUPvaQOI=; b=UfgOd63dCnKQzkkT6
	BBsaVj9Hx5DJBXMPHT09vu8+bOjhVLRXZxZxTwnYr7r/upOCt3xcpdhv0QQOwpaa
	Ir7Cv42Lq06GMTxMfYyIwportpf1gtjUqAuWIL31QkEXGCzOWtpokqn/HOvc5SIt
	0pbRfX6J6zEAnszXIX0ZfmUr5XlhM6sRt0xkcSVwBBUn+PfAJhtMqdtIsf3jiRhE
	gHkHvdzsn2EnknXRQqhls1a3800YbuKb5QsMnihl5h0XhnHHSq9jOQ2xA+y/wNKG
	j0KlZw5KqtHbxBpl82X53R2tylSylfpo6uyWwAZmvgF9ixUbovPzLyUVFJ2gKcDz
	Dbpvw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:27 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C16303F7040;
	Fri, 12 Jun 2026 02:56:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 48/60] scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
Date: Fri, 12 Jun 2026 15:23:21 +0530
Message-ID: <20260612095333.1666592-49-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX1AyhbQMfS/Kf
 hdF+pLXPKe1g/CffvSLsDzu99pJHLepBOSG9i2e1+/noy4/n7hM9wKL6h/DVUWRkJI0TlKk4arl
 VLtcFoabkwgW/jTnhhxwh3ANuQbyTM8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX6S7cCuVN485K
 20tEgQ8cdUVDGbyq6xz2LEoM1roM56gymq52ei0qqDn+ISwXQZdD5LSVeRdia8wbgQlO0Np0ktp
 ajN5NmM+oIPlsCtGLrT4pbApFUTNdUTzPTV7ReCBsvT6p/gWAKlADpbcpAZqDvve+zn7Za5ZiPa
 Ufnr1h0KDxfXtaMIJvR0nF94vHQ4sWMBbLM6sl/H6+81hTcRrejSI0XCzwdQVZJjaweph6XdXkG
 hB7qWq6wjenp2dR4Jdsl1L4KyfBzRee0V6VCnDZmN2Xy0awIwEGrFgNZbgw4mZa58wMJYqS9+co
 yrA07ThDIjfFd51Mgq0rEWk7cdA5B6EGT4gdzY4Qag25kMOYvBh74r6ZaIY9bUF9nYrAz4ECpeR
 Qxub12jr/7dR0a1+sUeEH/hRUMxEQ2PcHS8oYDULqvM+CydYI4SYjXq+vRhZQVxPz4Q9ZsgPpNy
 ESMVeezcwifo3s6jBGA==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd7cc cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=iV06YDqDG_NXW1ljYX4A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: W4Ci-EyRZDzzmvSIuP0cg4AzT8dKA8OX
X-Proofpoint-GUID: W4Ci-EyRZDzzmvSIuP0cg4AzT8dKA8OX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

29xx provides the 64-bit FPM transmit/receive word counters in the link
statistics block, like 83xx/27xx/28xx.  qla2x00_get_fc_host_stats()
only consumed those counters for the older families and fell back to the
software approximation (input/output bytes >> 2) on 29xx, reporting less
accurate rx_words/tx_words.

Add IS_QLA29XX() to the high-speed branch so 29xx reports the hardware
word counters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fd3c8c207535..308b85e04f26 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2990,7 +2990,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 		p->error_frames =
 		    le32_to_cpu(stats->dropped_frames) +
 		    le32_to_cpu(stats->discarded_frames);
-		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
+		    IS_QLA29XX(ha)) {
 			p->rx_words = le64_to_cpu(stats->fpm_recv_word_cnt);
 			p->tx_words = le64_to_cpu(stats->fpm_xmit_word_cnt);
 		} else {
-- 
2.47.3

