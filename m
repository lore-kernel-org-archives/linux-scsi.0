Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AE737C902
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403890; cv=none; b=B3cFyrvYEOwwjDnNEm+1tkv/KDfbqk27x54fb+9P0OvgI1ALMvX9sOcTSvcxCE+TB4uaYf620/ftkPYaQJMJz6F6U6BYxmyTr0wxikFjtKcmi8dUCnThX17Vm8icjhBY/FbfXOt+tAK4v7onkKjG7Pvp8aUM/8siWOJFrwNKkgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403890; c=relaxed/simple;
	bh=w7jSaf1bSkmJZDCU4pDBOPdY3z+jz0bc5/R1Y9phK8A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jsYtPFXKpvq/LMdp6o8iAjC0HGiGL2p4JwJYhND6yFDoCbI4j9hOFxjFLgezGSlRpJxEN0okLTZhwOLVfTzzBKsRtCy5vZopdAhEig61ZyuOVYVIFmrYKoISIjsNCyZVRX0SRhMJ4S5ZQFRk1GI6FRavphI8ztwceNKbFOQfP3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RcMpg0+N; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RcMpg0+N"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748kWC1656479;
	Mon, 6 Jul 2026 22:58:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=z
	s41WJTpkCyjT4S7ESDO2r3yIQD7kNbY2ocOrZolkbU=; b=RcMpg0+NJQ3ElRoDA
	nBT5vcxoDsa0nr2cIh66DaRsdRdzsl+lbdbI/hZMTq5dUmDExg6DCPn1tEKnfn9v
	GiPAJUielmdGXt66pSL9aIkzfjzrBBdT89Jbspqfcvo06FzWIF3hHfWkH6/Hpsm1
	GrFNZFF8LIUYA0VvCJIRUC9elF/I5eInnOdqqv8Z9vA7XM8pWUARdl79+9iLS9YB
	C6If4rE6e3YD15kmqdlexVkQ0aFWAoFw2oTfEdzREo1ZXIYchq8Y+tvIhbg9nKWw
	26/SbTAGKXnH4M1J8td1oIZUHevuJ4RJgAyGlzR9ncM0FnepMbA2pLbLVpyYA45p
	L/yRg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:06 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:06 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id ABC863F7066;
	Mon,  6 Jul 2026 22:58:03 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 64/88] scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
Date: Tue, 7 Jul 2026 11:24:11 +0530
Message-ID: <20260707055435.2680300-65-njavali@marvell.com>
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
X-Proofpoint-GUID: c2qIphDakJVhACdug9oJCA4xg53PR8YL
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c956f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=kHUOPGJzchApZ1z3-SAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: c2qIphDakJVhACdug9oJCA4xg53PR8YL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXw7uRWcP0lgoO
 t6ZceWfFqMEiC61MN/R8JbbjT2/+EwUFJ3OoRlu9DelKwnOmpXd8eLGrkoZWv25755KOaw0qhY7
 9o6NT+F+RdxjPvWeRsEpYqxhRS4ddA4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX/MIqSUdRpmIj
 NKONrkJ8p0vegRSM3452sLIA3UPF64Ce+mQwrhhkGOkDADlGRHZnGL/TwD5GyQ4A/MIu/xk43ik
 FvhVPSlK5NNb3nOCkwHiZ0aCudv4XZyEu/Us2ASZEVUavu79SgzsdD9IDOA61JwlCgEoiDYl4A8
 eMj3uX1KcSqwR3luJshx7E+5hB8mabp4eg2MmGFY/RhhD0rvYX85xSza3bysXRrnsfbNVYKj7Bp
 34czN0Np5trFt3LtpyZV3O1ygPNABQo4fAByUDydNnI+/wGgeQN4HMNvY+RFBz5/e6AMikh7Qt6
 XEGDG67DNSv5YqK0VZJC2qo/KG5B0NR26azN1Z6USswYpq46/payYGAlbkQG2jsEPibBGRHNEDE
 O5NlElHUpkz7c/pnNbNGVW7ubeMLfH/No4oSE/8WfaIX8DdrRnXRFE97aXCQXdc0FL1yednRbpo
 e2yKn069JY+1GrpB6Ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2x00_dfs_fce_write() called kstrtoul() with a NULL result pointer,
so a successful parse would dereference NULL and oops. Worse, the int
return value (0 on success, negative errno on failure) was assigned to
the unsigned long enable flag, inverting the intended logic: a valid
number was treated as "disable" while a parse failure enabled FCE.

Parse the value into enable and propagate parse errors to userspace.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 177d47e92e49..5d08bdbcf70a 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -510,7 +510,9 @@ qla2x00_dfs_fce_write(struct file *file, const char __user *buffer,
 		return PTR_ERR(buf);
 	}
 
-	enable = kstrtoul(buf, 0, 0);
+	rc = kstrtoul(buf, 0, &enable);
+	if (rc)
+		goto out_free;
 	rc = count;
 
 	mutex_lock(&ha->fce_mutex);
-- 
2.47.3

