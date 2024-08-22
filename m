Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC691CDFCE
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356822; cv=none; b=Og/VUgpAoJlQCVmzYXH7BluAuhshO9SA5kkPcxby//vMnzLESMk1dMgOW1qofjQdXu6Ny5/VQUF3DuWdhXnR3IadW+o6AwD1qG/m/2FrXCJw3Vf1tF56U89JpYpI0/FzegQoGMWj1KVd8cpvj12/0rVHNlKJg1tgePYejwbpRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356822; c=relaxed/simple;
	bh=lyWPRMevCNtWhTOSxORGERWH0uuAJLeJ550K2/e1G18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHTJSBa9JiIVdzBpbLn2ATIn8tgESFNYg0uxAfLVNswucFzULDF6cAlxGmpouApARXqr6SQRk1Xh4nJPE9VkcwKEZmiaHMyakuuGTLsqcmz/jeoCJGn7SHEuDpTmOzhhMufAi3EEYH7PsU8rvj1ugoFTc80UeOSTO0fh1WUE8oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FjubeGn+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FjubeGn+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYw341Ytz6ClY9M;
	Thu, 22 Aug 2024 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356816; x=1726948817; bh=+tcv1
	IVee5zSJiAzD8IyeZ6+jN0+Kw+2RPNa8uwxOBo=; b=FjubeGn+LiYUgJ7wwpXNR
	KcRPEU4YsM6fgHDLmKi3lgPdHGg/UiWoZmXpGtrwjix5au4d7VU+aQygXblSwKrL
	GayJLBaLx77rRhqVqmCmac8xugIm/Cua2sLQgKNzCem/eLRXJmLG3zi3EghbRDdh
	FC4FuXaBftY4OCqXMXLs1rHSv19wlaMVtYnhnZVDBY/6/r0Q724agauONu+S8gHv
	Wvrg6kRn3y5pt5BZt6unmTpC11Y+gWg4VgGSqpqaoAduzWIEbfzFgt/SOzIqEFi4
	dQRAp2+LqFIB9dlOde+8FeUxVtdCTiXZZcp5MyuIZSvzYUlaoBWnipuumapl3mHx
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RbxvObZKGBVj; Thu, 22 Aug 2024 20:00:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvy4k22z6ClY9N;
	Thu, 22 Aug 2024 20:00:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 06/18] scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:10 -0700
Message-ID: <20240822195944.654691-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 18 +++++-------------
 include/scsi/fcoe_sysfs.h      |  2 --
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysf=
s.c
index 06357bbf6b2c..0609ca6b9353 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -45,12 +45,8 @@ MODULE_PARM_DESC(fcf_dev_loss_tmo,
  */
 #define fcoe_ctlr_id(x)				\
 	((x)->id)
-#define fcoe_ctlr_work_q_name(x)		\
-	((x)->work_q_name)
 #define fcoe_ctlr_work_q(x)			\
 	((x)->work_q)
-#define fcoe_ctlr_devloss_work_q_name(x)	\
-	((x)->devloss_work_q_name)
 #define fcoe_ctlr_devloss_work_q(x)		\
 	((x)->devloss_work_q)
 #define fcoe_ctlr_mode(x)			\
@@ -797,18 +793,14 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struc=
t device *parent,
=20
 	ctlr->fcf_dev_loss_tmo =3D fcoe_fcf_dev_loss_tmo;
=20
-	snprintf(ctlr->work_q_name, sizeof(ctlr->work_q_name),
-		 "ctlr_wq_%d", ctlr->id);
-	ctlr->work_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
-					       ctlr->work_q_name);
+	ctlr->work_q =3D alloc_ordered_workqueue("ctlr_wq_%d", WQ_MEM_RECLAIM,
+					       ctlr->id);
 	if (!ctlr->work_q)
 		goto out_del;
=20
-	snprintf(ctlr->devloss_work_q_name,
-		 sizeof(ctlr->devloss_work_q_name),
-		 "ctlr_dl_wq_%d", ctlr->id);
-	ctlr->devloss_work_q =3D alloc_ordered_workqueue(
-		"%s", WQ_MEM_RECLAIM, ctlr->devloss_work_q_name);
+	ctlr->devloss_work_q =3D alloc_ordered_workqueue("ctlr_dl_wq_%d",
+						       WQ_MEM_RECLAIM,
+						       ctlr->id);
 	if (!ctlr->devloss_work_q)
 		goto out_del_q;
=20
diff --git a/include/scsi/fcoe_sysfs.h b/include/scsi/fcoe_sysfs.h
index 4b1216de3f22..2b28a05e492b 100644
--- a/include/scsi/fcoe_sysfs.h
+++ b/include/scsi/fcoe_sysfs.h
@@ -50,9 +50,7 @@ struct fcoe_ctlr_device {
 	struct fcoe_sysfs_function_template *f;
=20
 	struct list_head		fcfs;
-	char				work_q_name[20];
 	struct workqueue_struct		*work_q;
-	char				devloss_work_q_name[20];
 	struct workqueue_struct		*devloss_work_q;
 	struct mutex			lock;
=20
