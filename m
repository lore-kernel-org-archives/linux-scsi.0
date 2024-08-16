Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D761C7B7D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845412; cv=none; b=hG+oW4q744WGLF38SFNNt0SbxOTxEbE60trCCAssUqjy//m+oFYbfGXbvC0v4M4v2ZYGYWqPzsF3g4NR9xdSeHKLUgboxPRzweDaGzrQAWiqTMoFk/T8ZLl7gb1UVa5m8Pm7vnIeVwpkHXmaBLvUjbgdB/+46hC1zXypMRlaBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845412; c=relaxed/simple;
	bh=lyWPRMevCNtWhTOSxORGERWH0uuAJLeJ550K2/e1G18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxRgsqBUau6fhbK8QYJ7vT0TYuHPVCYX95MsvVkIuxtbemRcr/QlwyHPZ0kr/yVWsUHpw+xjaPgiNflkJMPECnQVEuO8U4a8UG5nWpRDvWee4QzzSxN0/uLdwqze8KqL7taP0//kHynEOpNG3JvBy+lcIvhK0I74pNnIDe9Av1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eLLbVeaN; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eLLbVeaN"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnG4cTGz6ClY9C;
	Fri, 16 Aug 2024 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845408; x=1726437409; bh=+tcv1
	IVee5zSJiAzD8IyeZ6+jN0+Kw+2RPNa8uwxOBo=; b=eLLbVeaNXXS7CID4+gauW
	0pC4NUPgMsy9f5pqxuPQQiKatkF0jPX1KBL9AJpv9x1bu1lrEgSgCjS6mD59wzpS
	HFZFAMOJNxeZjQvzEH0o+6Mdw4945JNnviIIm2VHN/LIf7t8TjgPQ9jVZTZGCC3n
	963f5KY3tPCUkdPQOOSqAsTmoB3Jq0P+CI2AT3PMoVw43EK8bE+BZUBb4giAVDlb
	SiJNUswk/K0epIBwjUyIItN3UUhn8JrA0bvpKbJICFfm6TTAJ8vUGQDesAJ+O2eW
	kFnMp6kctJFL4wPcgm94r1auHA9+sMnBoPAECMnwDtWTRrd64l3WNU7jRX6E/bQa
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8KRbTFBLQhqR; Fri, 16 Aug 2024 21:56:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwnB596Bz6ClY9D;
	Fri, 16 Aug 2024 21:56:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 06/18] scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
Date: Fri, 16 Aug 2024 14:55:29 -0700
Message-ID: <20240816215605.36240-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
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
