Received: from outbound.baidu.com (jpmx.baidu.com [119.63.196.201])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 074B036EAAC
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 05:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.63.196.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774935191; cv=none; b=a/8y8gFG9uIEuehDkP2G5bQqe8BnDJVjSD0RIIBJDSr1S/4VTIWKmO4DuqQL4H+liPkHUIiZZUf8+pynEHgWmgOi4CP7Mhd/2oq6ObkwFpyAYyR/lO4k8y+nvW8pAiNt/VAyM5UItBVh87PPdcBX/emuult5/pxuQ+STabZQQY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774935191; c=relaxed/simple;
	bh=iTi5hJwjo1Q9cvdytoEXMAuyZ+bw4tyVHdfCMP/brww=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hPYWdfYA2xqVp99wloFE3VP6u2J3+nAEWIpsc8ZyOWdHDlpRAkts+wT5Mn6Wx8lCoY257dB8ATnsvyNmyJZ0ybsysSp/Te4YVlN8zis5vjH4tOPq6+uiJbT79azRlaGd4G7C7sMV3XkHpNd28ScXgCn6wiHWNe6lCLvVbm25ieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=R1DTolL3; arc=none smtp.client-ip=119.63.196.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="R1DTolL3"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] scsi: qla2xxx: Use nr_cpu_ids instead of NR_CPUS for qp_cpu_map allocation
Date: Tue, 31 Mar 2026 01:32:45 -0400
Message-ID: <20260331053245.1839-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc10.internal.baidu.com (172.31.50.20) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1774935174;
	bh=qA2CAFZWOfr6ZqQDN/dc+gG/iXCfbOrjRjxIDvLO5Ls=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=R1DTolL3JOX5SvaA3eVtmCHropspn1V75d4Gx6MktjW2wOlI533/tCIk3ev4RojkN
	 1pzzoreq/3Pkjim7yiLhxf0y2RBp9Ty1GZF9WBW1fGl7CD30AL893hFaLQO+0gzq0z
	 VwM6yrJJQhDf06902IMQLiFhgrgOJ9Z7c8VKRebHutoorX+jy6BkkcByaxZVQSLk5Z
	 b+C7mWSvnzB2qmIwG6AHe0jEhVgSFsKMZ9+OrUGCWlqnJLjwntApJRZ2ZvTFbUqRfo
	 9jrkn1QjBpouWm7HT4yO29FP41wdU7nw2gEQVE2Q/RQZvk+2iwxW9RHrpkqV1rr83s
	 M+UvFjePFoefA==

From: Li RongQing <lirongqing@baidu.com>

Change the memory allocation for qp_cpu_map to use the actual number
of CPUs (`nr_cpu_ids`) instead of the maximum possible CPUs (`NR_CPUS`).
This saves memory on systems where the maximum CPU limit is much higher
than the active CPU count.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 53eaff1..47fbd83 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -621,7 +621,7 @@ static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	if (!ha->qp_cpu_map) {
-		ha->qp_cpu_map = kzalloc_objs(struct qla_qpair *, NR_CPUS);
+		ha->qp_cpu_map = kzalloc_objs(struct qla_qpair *, nr_cpu_ids);
 		if (!ha->qp_cpu_map) {
 			ql_log(ql_log_fatal, vha, 0x0180,
 			       "Unable to allocate memory for qp_cpu_map ptrs.\n");
-- 
2.9.4

