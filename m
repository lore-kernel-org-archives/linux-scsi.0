Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448A3537EE
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309835; cv=none; b=Qsp3QXQjgKj49mkkGKfRvN/bV421YnwJ1P0IYiLA8bbOAmYuSXpv+NUpIzr23mHNr/oIIENx+8zAJC/XQUAmp9cKp5LB1GbXO6LFJhfF0auOryCbYQTIhXpbF6i/2ULHNAK/iuBdtVGMtiwAsR2j7kU+66QQdyxkzwSGomMHB8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309835; c=relaxed/simple;
	bh=I5gZPa+OQ3Isx77Na+mJoed6mh6SuEbqw/KXUtXfoCQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dT6NuB2QzjKrLT07L+uDvBMIj1Xj9M9FA4EEREn9FHN0dvWeMr+67U319yJ8t7KzM6F0gBoDF/xzkZ3WwcsIBArSDFBiGsxP8jDRIybDlSuY8nza8QkQGElDZL99y0okzX5/j648aGEd057Kp/IMmfjKPgR1Yyp4brM9/yKqyGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jNT+FnTz; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jNT+FnTz"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLsCXH1012907;
	Mon, 1 Jun 2026 03:30:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	DyHmEMTer/RMBLl0mSQzn/hMpmNjtzCkH/Nz1+elZo=; b=jNT+FnTz2C4k3j86u
	m1dXGR8hqHK+4D/sCV4yH/O/IjfLPYTTI3QK49XVwsG+9AmwE4y9GgqjNYjXqHvR
	u+6pKreySESyf25QF4nfXZqBzNvKoHDvezYbkCOtr53pRxP75F+18evZsa4EKoIe
	60ShHQladwQEFplrdgugUXJYDEYUZ2i06+dAkPPI34xVr1UD6B1Sisz1CIi7ZK6R
	XerRvk7K3YG/4rX1HHYDQ09F9oeFNNszbWr3utta60mDOM6P+TCNMW8zn+Rr+r5T
	n3qyTLJ6txiF5C7AunVideIgPICgkzg/CsIcREOWouwVa+1DTCZVtWm6uflv4SWA
	weNZg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4efw8hwppn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:30 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B37163F7054;
	Mon,  1 Jun 2026 03:30:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 24/44] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
Date: Mon, 1 Jun 2026 15:58:33 +0530
Message-ID: <20260601102853.328426-25-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX0O5K224xqLkK
 IsY77+pRoUlOxs6rSIofGevzW97ONqIz6Ir9VwrOyGnaGD6lkThE/XP9XkoRgvsElwpg66KY+oF
 cJ+T/mwYIqUU8OGDiklZwPbezv9z9zkm7FAs0wGTQYOqxm0FddORDjMPwXiB/XR9ZzzkOIK2elt
 Q2RP2dgMxs54OcewDYzlr9pTZJqC4MuLSqizyhuNB85rLKQKqQr3TgZttaRfE3fRCnGOV5kTv6/
 WXe0nTo/BZelWtbH40fJWObbOhs7BUj01LvvYaJeut09oOVbZbxRa2SKaphWdh5Wk17y3pmQiPh
 VYZ9u9TjJ32YW6p88uqVLX4z4YK7FsUn9rwm33Ysg1RaaRfUjJE2D/0DwBksWAxxlNbB5aZqgKY
 Ice3tlayYVjixBxFyPktyccshyXTC+H1lFR/5dovbNNTBYnrFUjmWCOPUUljcEIp1b5DeTZG4YZ
 +Zop03m3RXST64KXS1w==
X-Proofpoint-GUID: BrvtYNNcydR9VNhsc8WmQLdbwEsUDwIg
X-Proofpoint-ORIG-GUID: BrvtYNNcydR9VNhsc8WmQLdbwEsUDwIg
X-Authority-Analysis: v=2.4 cv=F99nsKhN c=1 sm=1 tr=0 ts=6a1d5f46 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=C3ITPKR1BmyQqgtea3sA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e79708f5bd8..2f713974c5b8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3830,7 +3830,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_disable_eft_trace(vha);
 
 	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
-	    IS_QLA28XX(ha)) {
+	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 		if (ha->flags.fw_started)
 			qla2x00_abort_isp_cleanup(vha);
 	} else {
-- 
2.47.3

