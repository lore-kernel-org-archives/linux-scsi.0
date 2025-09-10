Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E96D23C4FD;
	Wed, 10 Sep 2025 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531254; cv=none; b=MUiNL0eQ4/3FHnQDT0dUSPrSAs/yoqJq7CwBR3kJmm3fhnHeBmZ0sIxzOoI6YwdDQgx44SQHnc5pwZNkcYb/PxwkuaTuRLWHvwb8D81qyMtAGKDkrVygMHIVP3BYMqBkN33dYvTxBPJMcWSCNZ4R7YAEQoNvz9bdUYDC3f79/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531254; c=relaxed/simple;
	bh=6aeO4MBjEAXMN7S+fFrX16T9MBul2DIntPn4+t3K6AY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MynogdrVhj2ZgtwNZHR+pIP+wRwZwdOdsnBaD17MPKUFQzAmPakhu5XZLz9VCl9uNAs+0Mxz7El+waPS9/yAXZt2dapGJxIZxS1HmIxfrL7FW2mNTrXnwXbxk7meDx3i/ptk3fpe6r6kQB1ujz/JSygRf//C2tXPF4LMgoObUd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wx8K6I/N; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wx8K6I/N"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGfpj9007364;
	Wed, 10 Sep 2025 19:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=kSzH0FMWoF9ySM2kjUbzscFMAsip6
	SiLjxWiLldgpEw=; b=Wx8K6I/NJEuefGgkoLiBCQ3tBgjOz0SjoMTOyHMWrBB0j
	UIf3G9H88hOqJHI6pfh8/7oMU+WxX2Q4lKJl/iJoKuSW6fS1ynjDRnAGJFkQqLYs
	Pq4i4BD9mgg9KWQiSo9Cy8/f9rkHUcM4ROQndNn+flmGvswkEIEYskbjRZCOfjes
	DlSxHfLBshCVAsvRb/rwaTlz36ZEvxwAf68CsNflaNeU87JlnQOvXLJx3h2Bzl6v
	Sh9IPQ23MnUnZY4NxKCNhygkWiOkPJvV1Yy81tpcy3JA++hbz8/a4vmGM2oBJrOq
	9fz7n9oX085QlQ2qKKLJyWuoUW5drTySzrkP1eSdQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pecwdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:07:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AIErtA013640;
	Wed, 10 Sep 2025 19:07:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbmn2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 19:07:31 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58AJ7UFj030945;
	Wed, 10 Sep 2025 19:07:30 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdbmn2p-1;
	Wed, 10 Sep 2025 19:07:30 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: michael.christie@oracle.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: alok.a.tiwari@oracle.com
Subject: [PATCH] scsi: target: iscsi: fix typos and formatting in lio_target messages
Date: Wed, 10 Sep 2025 12:07:20 -0700
Message-ID: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100177
X-Proofpoint-GUID: IVFXu0ekA-dbGXTMvkvK8M0ACyfaQOrh
X-Proofpoint-ORIG-GUID: IVFXu0ekA-dbGXTMvkvK8M0ACyfaQOrh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX3y58blJPgWsO
 x/8dSal1LhqC78hF5lfW94ScHlg0RQrNxwT4gFrlSlhAVPe9rpIsJtTYFGt5QtcggV1AQrnBygG
 TShJBttoVE7TKHNEVwBIA4+WHIkHQm/YomNY1D/CJahML+J3rwBZgL9qNFW+GAi35MYQHZI7bn4
 IyvIloK9DM3Ok1nBEvuG8u46fawCCOhOWnEn/eMPGFFTVAHJ6ZDUraeR8rwzmvoG++9H5hyhPG0
 TZ8/920ril2cJIFXfB66RiEyVQYsN6oBAvsEO2x32iyfjXfuXVrOoGbWESp52y0we20t30RFW7O
 K6gTCAe1z8u+A+HP6KotzanE3NR1rtSgq3J9D9wubnL3julHtKblmN/V6QVx7Zt7UwhuUvC7lml
 HgGeeC1C
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c1cc73 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=u35TvG4S8WVXa3pOz-gA:9

Fix several minor issues in lio_target code and messages:
- Correct typo "locatel" -> "locate" in error log.
- Add missing space in pr_debug() message for better readability.
- Fix comment typo: "contig_item" -> "config_item".

These changes improve code clarity and log readability.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 88db94f382bb..efe8cdb20060 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -665,7 +665,7 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 	}
 	acl_ci = &se_nacl->acl_group.cg_item;
 	if (!acl_ci) {
-		pr_err("Unable to locatel acl_ci\n");
+		pr_err("Unable to locate acl_ci\n");
 		return -EINVAL;
 	}
 	tpg_ci = &acl_ci->ci_parent->ci_group->cg_item;
@@ -684,7 +684,7 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 
 	ret = core_tpg_set_initiator_node_queue_depth(se_nacl, cmdsn_depth);
 
-	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
+	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for "
 		"InitiatorName: %s\n", config_item_name(wwn_ci),
 		config_item_name(tpg_ci), cmdsn_depth,
 		config_item_name(acl_ci));
@@ -1131,7 +1131,7 @@ static void lio_target_tiqn_deltpg(struct se_portal_group *se_tpg)
 
 /* End items for lio_target_tiqn_cit */
 
-/* Start LIO-Target TIQN struct contig_item lio_target_cit */
+/* Start LIO-Target TIQN struct config_item lio_target_cit */
 
 static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
 		char *page)
-- 
2.50.1

