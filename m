Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DAD15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023011; cv=none; b=cccrdCeitSZ5Fol0VSx4Hk0rSPvb2BJc97I3YNHxCOJIYie8Xx4P7OHfeqklG156Pa8Z6qlNZTnh3YfQlODukR/KrIuCN/xjc3ze2e1mKO+RnUO8TjgbZ+UVSYReAU0SqZ5K66CCEaxZPmsrWIl1VQfVAGvQIZci68kPegOmp7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023011; c=relaxed/simple;
	bh=9/TAKVgzm1AtFSHb/L9/07g90/TFo7LBxWZIujTNLCg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jdokpqy7I4sdyK8kbB2goFIGko1XZS7e0KjRfH0VGtFzYks79EJYZ2i5zVRYDt6HTEpehmT+7vsfAHCkH4PlTwXwdK4eWyp7Dfdh6CAn37sLIDTaGJFiakZZY2jIU8sLMNEQ61mdhCxxuqmuGTEfXDDKMuaggAXjak8isStFwIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cylr/ltY; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cylr/ltY"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UQud2353891;
	Tue, 14 Jul 2026 02:56:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	S4dePk1fFXr+NnDpZf6+JFjFcfDyzMWNjJgHUHWSmI=; b=cylr/ltYFSYCAVgMs
	9Z1XWM1IXu/PEZFp7s2TXxJhNfGIQTiApHtV2k8gPXyKH+h5fk0i1oE+OfDO4lAv
	nHZ6EJQG8qn2KkTAyt9qhlUJA2+QiZ5FF0gwtGURORsll9STvLCuqPCgTnYkTanG
	pbGOKRxL89Qlvpijf6qTusCvEk55lHDb/DTtHR4ne3try6E1W3mOYm+uDyBakaHk
	tza4meKDdLXr6kl9PvF7X8pAU4PzssuBulOWC4Itx/SMF2AvZ1dq1wW7hlO6MG2u
	z/j1sw1KHSIjGp1u52iFq9golEz7aG2vUyzmNXCBndshEzK0BWyOs3X0fs/T0XWS
	BuKpA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fca36nj45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:46 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:45 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3480C5E6867;
	Tue, 14 Jul 2026 02:56:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 53/56] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Tue, 14 Jul 2026 15:23:50 +0530
Message-ID: <20260714095353.289460-54-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX1S+U0CPzDgxg
 96zIiPPwR0xJRXat7e18c7PGdx1wihOZZ5mTubz1u+Wyc7qew6vjmc8Y/ZbMZK1Ec6S8oeZu7We
 JJEbjPkQhjXNl95yvELHj0ZllbjxWKOcnPESBy9tCFieXblJl+fjUVx//fODOEsjfRMDhhqnMJz
 5dsBYia11OuTp9BtnlFA+At9uivvNehljr9YGKMUX7C4KxVFISfsyx6o1pOZQCigbcFbDSjD8Yv
 8JZn6VKzrTo+DyoSkWncDFLmZ4AaaM4MNPNZgoykTvU/eySRcQiAP3Vji/pA6QAE/5W4kylKki3
 PglduwKM5l0S9uHskHAn3+sghQdbePIePfit80KGrFRTGtoaQlJTtT1Wfj5SMdmzUs+IlRikpdE
 BOZpJ7KUjbTqzlEBsWPeBWrgg4zqiBvc11cszYdsMXwnRAU2IvKHiPHnw+hexOGWnnY8866bG/P
 Tq2sY3YoZycX8YRUJEA==
X-Authority-Analysis: v=2.4 cv=EeT4hvmC c=1 sm=1 tr=0 ts=6a5607de cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=cZcaXCM-GTnW6IyOXjwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfXxcR7fzwmKoZB
 ll3DPEP3LpCmfFto9mdB+XMlDJwRInK5TVykftjYqGbsFc2La9WMmmzlkwqd5HBAoBD6O+OoXqc
 RPmow+/xEBbTTcEnESkjKYWnxyQrzeo=
X-Proofpoint-ORIG-GUID: 4q9OuQ8CN2LB5sJf-1Zfs4wZ-U3QAsS9
X-Proofpoint-GUID: 4q9OuQ8CN2LB5sJf-1Zfs4wZ-U3QAsS9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the
full sizeof(*dd) back to user space via sg_copy_from_buffer(). The
inbound sg_copy_to_buffer() only fills as many bytes as the user
request payload provides, and qla26xx_dport_diagnostics() zeroes only
dd->buf. The options and unused[] fields are therefore copied out
uninitialized, leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9ee56ccd52b0..3bf3a7b96eb5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2858,7 +2858,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc_obj(*dd);
+	dd = kzalloc_obj(*dd);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.47.3

