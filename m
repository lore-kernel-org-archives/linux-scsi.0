Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF0275105;
	Fri, 15 Aug 2025 06:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755239862; cv=none; b=gqyMGbr+QGELjuZOlu3Bui1kS6yZjH5hq3uHYyqYU8GyRD94lZiPNEvWDaCEDEsIK38PkEGC1wFCIIsuRP8r3ChX/CemRoQvWiHRZJ58qrCdn+M2udzV8H0HaomEWsXTlT0k3Fp9Tdn/nTBmpvd3vyetcHKcPI1gzGfbzFQwMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755239862; c=relaxed/simple;
	bh=Rlct5+Q0ZGH8lCuU7PfBrhC179DbtJp3plmz5CFltRE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rqZTTTDUASVn4dpA250HH3H4rxfWne9ouzkB+cMR0NQFg5GjOtqsjTUiNsC7/2lCM4jcnlO5/kyxwWPgX4fnrpzadjdRehP8kmnEivV+l9OUM2vXe83lU0rAteEGbhObZMwDcLaUwGqN1rgzFjVjCMJyzKrpiLKA0j+VqnrJEUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 515e614a79a211f0b29709d653e92f7d-20250815
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:6ca49ea5-18c3-4f92-98d2-d0ab16a4e523,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:6493067,CLOUDID:4cdbe8e7204f19b9662f85ef8a02fbbc,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:5,IP:nil,URL
	:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 515e614a79a211f0b29709d653e92f7d-20250815
Received: from node4.com.cn [(10.44.16.170)] by mailgw.kylinos.cn
	(envelope-from <tanzheng@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 231800575; Fri, 15 Aug 2025 14:37:30 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id 54FAF16001A03;
	Fri, 15 Aug 2025 14:37:30 +0800 (CST)
X-ns-mid: postfix-689ED5AA-1417051848
Received: from localhost.localdomain (unknown [10.42.20.101])
	by node4.com.cn (NSMail) with ESMTPA id D6B1516001A01;
	Fri, 15 Aug 2025 06:37:29 +0000 (UTC)
From: tanzheng <tanzheng@kylinos.cn>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheng Tan <tanzheng@kylinos.cn>
Subject: [PATCH v1] scsi: target: Use helper function IS_ERR_OR_NULL() to simplify the code
Date: Fri, 15 Aug 2025 14:37:25 +0800
Message-Id: <20250815063725.1061672-1-tanzheng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Zheng Tan <tanzheng@kylinos.cn>

Use IS_ERR_OR_NULL() to simplify the code.

Signed-off-by: Zheng tan <tanzheng@kylinos.cn>
---
 drivers/target/target_core_fabric_configfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
index 7156a4dc1ca7..1448a7ab0491 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -479,7 +479,7 @@ static struct config_group *target_fabric_make_np(
 	}
=20
 	se_tpg_np =3D tf->tf_ops->fabric_make_np(se_tpg, group, name);
-	if (!se_tpg_np || IS_ERR(se_tpg_np))
+	if (IS_ERR_OR_NULL(se_tpg_np))
 		return ERR_PTR(-EINVAL);
=20
 	se_tpg_np->tpg_np_parent =3D se_tpg;
@@ -937,7 +937,7 @@ static struct config_group *target_fabric_make_tpg(
 	}
=20
 	se_tpg =3D tf->tf_ops->fabric_make_tpg(wwn, name);
-	if (!se_tpg || IS_ERR(se_tpg))
+	if (IS_ERR_OR_NULL(se_tpg))
 		return ERR_PTR(-EINVAL);
=20
 	config_group_init_type_name(&se_tpg->tpg_group, name,
@@ -1112,7 +1112,7 @@ static struct config_group *target_fabric_make_wwn(
 	}
=20
 	wwn =3D tf->tf_ops->fabric_make_wwn(tf, group, name);
-	if (!wwn || IS_ERR(wwn))
+	if (IS_ERR_OR_NULL(wwn))
 		return ERR_PTR(-EINVAL);
=20
 	wwn->cmd_compl_affinity =3D SE_COMPL_AFFINITY_CPUID;
--=20
2.25.1

