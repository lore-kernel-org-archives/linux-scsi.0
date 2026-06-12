Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDBD367296
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258223; cv=none; b=ofTc0dQ0fBpheYaSBn4T07NzblPddNfYl43pnjnNMuJlBHdmtYAHt7Jlr+SbZfmwRIIkM3cCgbZpEoDFx3a2UeUAZKVu1AOIhSR8WVs4luO5d3fqCIQUXIFuRMdIXVvEd1SAck5n/hsM40vns4ISdAZrQdR7hxIwAdUgRKkfEPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258223; c=relaxed/simple;
	bh=amziOL1w8os3vXSZCkAOtPRf46YfILJU/F22Vah7GuY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nugngbcDhuvs92aOVLxrDnTc3IDrYvhpfDfmQSI1MxsbLePq5irC6bI41Rjm9fIGHCX0QQOyBHGz/C+DRr5TN2NKkgScps6abUh08dfCkjta3l4QxxPiLw2u0Fr8Gz4uWntbEx2URioQfxgjeZy03FjU+295UMVbPC823ohKNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=FRojg4XV; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="FRojg4XV"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C393rw3678753;
	Fri, 12 Jun 2026 02:56:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=c
	EKNf/ER8R8tusdYg2n7dfU/oWOPjtiTNctYaKHIa3g=; b=FRojg4XVjnK2QeivX
	ZVD9wbKblht1hGKiwKguORTsFTDdl7W9WSjE/vkWiR58Y0N5l/aMkunHWG2QpI63
	Uxvbf+42+uZfHXhuzU9p4NalFvnRcscQI9wV8bpXVjiC0zX/W4tZel50t4hgex4p
	oILdL9nbnHua9lZy3cLaJJiR5PBo8WUEoJnwrHuOTWhKv03ZTZXk1SmmNkthGAMa
	w5qatMDgMV8EPBzq+BsDZlpi56S+5eu3BZd4aL6qEntN9PNf4hg10tOUSsK93Co+
	gtwDHiEGGrmKiloV26e+GabC4sfXguez8Xjp3GQcuTeXe2ULkrFddG6aRJsQhcuZ
	nM9sQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:59 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:58 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 101703F7040;
	Fri, 12 Jun 2026 02:56:55 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 58/60] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Fri, 12 Jun 2026 15:23:31 +0530
Message-ID: <20260612095333.1666592-59-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: TZR5hGhsTV6NlXJ_vSfxz6K94zmkQ3td
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7eb cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=cZcaXCM-GTnW6IyOXjwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX3Ko+gRWb+gqS
 Jbvw3dJHy76G6qNXzMtLGfmnElaheqv4mUahyxIZyoLtcTDIg/ycA8/MkPUjIKXxKuj9oy4AJTR
 NvxEbe9efjim62xMmRdemd9mnNNp3ik=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX/mOU0e9vDFfM
 2F7MowSYTyhOu5NzSfPE+4PKcD0vZNRz7dd3d2Ky4q1YgTY0WZJMLcwIWYmRvCtqe9LBBROam2J
 D3f6vZ/wsAu5RnKjBtSYrS8Ez4J5HsLz4bA38cBUlH+FQBBb+bXlWlBGHw38MhwkvLU23ov+0+G
 v9AUwBCX6MJ6mqOrEnVuJGMrw7otp4MR963lvlJ/HyJJmRblztTQdg5kw8yiROAWF4CI+CR//4g
 CjOlfAlT14LbS7NZgMyG5PLaG4LIVzthntPL7kytn5d4DxQHOvbAG2PMVv1JbbTU7B5Li7tBRbG
 oT5zn1kMxpN1mjhI+YffjLe7a+WwgK4ROssQ1lL4nMycQnq6rou8vhke9/xN99F8aeTgzKSGAHf
 h+6Fn3yvJjWizKRhPyfa0es+13CzmxuYPuxcAGcvO4d2wFxoBtq8hn/rY2tx1hNHo3CPLMH42Gs
 rh2P1g6lu+iThhTxZ7g==
X-Proofpoint-GUID: TZR5hGhsTV6NlXJ_vSfxz6K94zmkQ3td
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 7f4558beee2c..b57c55964f9e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2744,7 +2744,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc_obj(*dd);
+	dd = kzalloc_obj(*dd);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.47.3

