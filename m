Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31112140E5F
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302214; cv=none; b=mKdnOVYLLtP2ETan0NhBsc6gQyvp23tcKcYUA3ZpovLYLsZwXSUala9wyhMwW/1YtMsURmBQeDtif7uYEl4O6HlMSqw7+BWvYC0GOHFSGq6nn7UAKXXVxzabKyzLXAt/Ww1WD5fJCWfqL3ljkvLeKmx+EFbR0yYSo6wWtf+S8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302214; c=relaxed/simple;
	bh=PKWSxnZNlcUSCnb7l6wdcyEyMNMOpLomovySRtjtgy4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qi7Si5LwXWLke2m6hjG82yMK0qxZn19U3ZrI2UUpdohuKWFCW8dzKFdJQUHdhqR5Nj9XE7olSC0XyHE8akQV6xg3GKt7bWzERggx3gs7Ia6iQfHGsZ7wkNruTWCQxYN/F1A9uoDttcUxeveD+vv9lnWXeUp2yXxWbcv6JAe8OLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HnQVmZmW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HnQVmZmW"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE80lu094830;
	Fri, 17 Jul 2026 08:30:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	sTe/NKpOvzyL2TWgnv5nD3Nj7pJKuoEOmCzQGCLjXQ=; b=HnQVmZmWrFuo4GqJm
	seYwJr6SpqeknQaSGBf/cEjbJuoGC1jODlSn6yVZIuwFGjV+pmh9ztmBovvcynZc
	az/qY5mNxkV7R4kkvDlApYc5/+Nw6q0YIwI9fXoO5Yze5qa7aCw53YfoQanQManR
	Jh9eD5ICauJ8902q0gCZoXED2es5cL8Ub91A7D18QcMYlR6L9Wn7gI/9fd8uebER
	t49r7ksB3iwRw9+K1Bu/8iDc7ls11SpHb2s6k0UY7G0MeuP/URCpunfJ24CbAd54
	rEUFCV+iib0UwostUjqFM/skhVYMgjts/HxfcEtKxrkSDNNXLkUxWBnEYySWq33R
	wmaWA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:09 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1E99B5B693F;
	Fri, 17 Jul 2026 08:30:05 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 20/56] scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
Date: Fri, 17 Jul 2026 20:58:28 +0530
Message-ID: <20260717152904.3155730-21-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: -YRXM1q6XwAC-qrUTLNwC7AJYCFpyo4m
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX2xJiizrBLfs5
 zHKPFRDxXDQjdVBZBTVU9BZoWaDiMIoZtNxVeMbp3+/QdvWrhXGR91nLh7q8aiH5cB+u2eM0X1k
 gFragwcyYctKJoYTGbEXUV9UUKVD404=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4a81 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=UohhYlrJZoq7yYDAghQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX3oZWHyOJwNi+
 w07ilwBzSqIS6A5ArpDVfBnXAePVSJQjJ6F7DduFqRenLbrbKq4S3sJxJgl+NArCbr85JrmQpkB
 s/QtHz4Aopxe59+DZ9xirw9Eojvc6+4YQtFGP436Iy9i/17CQeQDD6Y4MuMm9REggYmb+zv9VkX
 7ywGHvjSVX0lFRwgDiInCd8hn51WgN1I6eFnSzFNqZHJ4VM9cRba6hv1nRD0edIFdKzMpwVZgLk
 qB2ButqNbEzigjNhi2rTCQ2kzBpatvjMMTPL8GKYtb4NHjGl46rIibD1OI741SZSVw7z+sk1QmP
 FQ476tpHv++KQms4H8UtATTcp1tLh027b4HlIKhbOULJpSoW9K/WLdINJHRv8v3fzLQUGKBrvt4
 w2DN0G31Zp3sdRsUd15JMLIeaPgyJQQJUI3LyV0i1ZSf0b9V2JiucBa29LgsPA370DsSU71FDNL
 /q0eW2Eb3VqRcP2N32A==
X-Proofpoint-ORIG-GUID: -YRXM1q6XwAC-qrUTLNwC7AJYCFpyo4m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Add IS_QLA29XX() checks to qla25xx_set_els_cmds_supported() and
qla2x00_echo_test() so that ELS command support and echo test
diagnostics are available on 29xx series adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d195723fc06b..a8dd01cb9a9a 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5087,7 +5087,8 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA25XX(ha) && !IS_QLA2031(ha) &&
-	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+	    !IS_QLA27XX(ha) && !IS_QLA28XX(ha) &&
+	    !IS_QLA29XX(ha))
 		return QLA_SUCCESS;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1197,
@@ -5492,10 +5493,10 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 
 	mcp->in_mb = MBX_0;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_1;
 	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha))
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.47.3

