Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7497220127D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957204; cv=none; b=mHGkhmExSulYD/8sE2BYDvb9WAb2nMf//DsFg1cW7J68sZE5naIVyaJo1y374ba/HdCl4n6258vP5NKj5Wr4PjIHAylu+TpZfY1qwGa3+KJdTfLVRZR3xk8PwTLoDLZ8lvtc/vBLgatvbpzM5SSEshFbM7b0/zKKmKQ78ddQ1N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957204; c=relaxed/simple;
	bh=S4Mllv/I3k/tPI4P88H/ztzvKaiRlJKf8mauaPYMrCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRouv2wcgDJGuDuMv3XV99vx4M9y3UGtaYTUvA9fEvYlq37CWYqOvCAXd2fzGQLsCP1NHypdQ59K23t/Xrm8U3zsOxKWEDlGnOBe+d0rQUQ3STRUND6Bw3QvzCnbwN0qddDyqoiy3NgN2uq9cajDo8RypPUEfrBqqV2Mo/Gh6pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BS5TJ8mM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BS5TJ8mM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGr31lC8zlnQkq;
	Tue,  2 Jul 2024 21:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957200; x=1722549201; bh=/op8f
	/spYRwTeE5V0MFKc4ueZyfa+LW1CQb3WKt7t38=; b=BS5TJ8mMJIXf8KHFd5Lob
	/3yZxnBygDWmRtfcZD90h6YAGP/8HJO9ogPiy1KD4JhR2Nv2ts4Sp2z51QTGQwuk
	b6jb0k8/8rZopVXpuJuEXe2dvbxoKGo8TBk3v2FBfr6wTR6VtnPdPxSuki9Y3EDh
	RTbi9VhruyYe5KatPKZV0L8lE0VXE2tN5GBmMqpOacfoboqnnT/z7cV0GKsZTL+/
	HaHLUERP/K6ilO0/X8wFsp+uOOdf6aCQY+YNuYoPEdXw9hKRPfVCn7gLPs7zMZVi
	ORpnP7Wm5dWoKb1A4sypzzXd6LvZRZRD71MnUJ48prkZ8+PzCMJ/J/IhN0yq6nAH
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7oI2d1c2ePh9; Tue,  2 Jul 2024 21:53:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGqz57L3zlnQkr;
	Tue,  2 Jul 2024 21:53:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 06/18] scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
Date: Tue,  2 Jul 2024 14:51:53 -0700
Message-ID: <20240702215228.2743420-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c | 18 +++++-------------
 include/scsi/fcoe_sysfs.h      |  2 --
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysf=
s.c
index 94582e6fe66f..b7294452871e 100644
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
