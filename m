Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97B025FA2F
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741722873; cv=none; b=DSZzmbbBXX3xdoJ2xlTbn259H7I+sR8NVfdFHib5b4xscvTxMt1spOzxJWLEUfjCTaSWn+Uqkuk76GOxezBN9upJkfUOQXlWg+Rui4Jrjhil7WDMRUde4za1UhcX/qSpnV+4PwvtCBp9nJqUD1Pty+GQgmCK2erOqFiSpw1LsBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741722873; c=relaxed/simple;
	bh=M9LX761K3vWysMsIg5DTqdGwQ7w8cnk+bFtyfne3JGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PJ7/LFuuCrXzpH3IX3ewSCnflsRnH+GeZN3Y3Ew6sUnEg2hPJV7Ysosc5Vztfy7mYyaEshHwNlJWjd/lfLEypqUnvyOpp2xyz+PQgjlpNmfxq71KSsCcUpXD3FnzKhlMXTavVHQvbPBZz9cwjIUmxPkM1as+TD0JvjzSZTaJB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OGNWcQHT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OGNWcQHT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZC4GS5G8NzlgrtT;
	Tue, 11 Mar 2025 19:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1741722862; x=1744314863; bh=CzwSOlB4VApsjV4VmDUhHZaNxAaikU1jN8K
	Oo6o+guo=; b=OGNWcQHT+4TbsHHIbgpKmKUjmSfzEuccUNf3f/0JV1LA3NJoCbW
	8fMHjI2u5lnjFGseptxxk42uxX1PqeFpGpd2Wd/nYYddva1zVEyGS4TamWOPeTa0
	MgRruVuREl14B39GBzP6ixzQWBGxoRfc2jRCJ86147N3CcQE4xnSO8/rT3jyttZR
	TbzLt32lUNMUfUcL8mx5UxVkAFtbRCPADwqlAYeu/bmpmFjFq5nuGFeSSVsdb0Ea
	rpmGW9A0oJDAbWWfc6kKE6vozbDpzjXWAO6eC+9ZEenaWNbEec0/l0FFeWLog501
	/O6fR28dEztz8Om+GY2t/8kVn62RG6QZ1dQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id B_JpWxQX1mIK; Tue, 11 Mar 2025 19:54:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZC4GF5565zlgrtN;
	Tue, 11 Mar 2025 19:54:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Can Guo <quic_cang@quicinc.com>,
	Santosh Y <santoshsy@gmail.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH] scsi: ufs: core: Fix a race condition related to device commands
Date: Tue, 11 Mar 2025 12:53:26 -0700
Message-ID: <20250311195340.2358368-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

There is a TOCTOU race in ufshcd_compl_one_cqe(): hba->dev_cmd.complete
may be cleared from another thread after it has been checked and before
it is used. Fix this race by moving the device command completion from
the stack of the device command submitter into struct ufs_hba. This
patch fixes the following kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 00000=
00000000008
Call trace:
 _raw_spin_lock_irqsave+0x34/0x80
 complete+0x24/0xb8
 ufshcd_compl_one_cqe+0x13c/0x4f0
 ufshcd_mcq_poll_cqe_lock+0xb4/0x108
 ufshcd_intr+0x2f4/0x444
 __handle_irq_event_percpu+0xbc/0x250
 handle_irq_event+0x48/0xb0

Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 24 +++++-------------------
 include/ufs/ufshcd.h      |  2 +-
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e1e214fc5a2..23ba3f540f27 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3176,16 +3176,10 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba=
 *hba,
 	int err;
=20
 retry:
-	time_left =3D wait_for_completion_timeout(hba->dev_cmd.complete,
+	time_left =3D wait_for_completion_timeout(&hba->dev_cmd.complete,
 						time_left);
=20
 	if (likely(time_left)) {
-		/*
-		 * The completion handler called complete() and the caller of
-		 * this function still owns the @lrbp tag so the code below does
-		 * not trigger any race conditions.
-		 */
-		hba->dev_cmd.complete =3D NULL;
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
 		if (!err)
 			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
@@ -3199,7 +3193,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 			/* successfully cleared the command, retry if needed */
 			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
 				err =3D -EAGAIN;
-			hba->dev_cmd.complete =3D NULL;
 			return err;
 		}
=20
@@ -3215,11 +3208,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba =
*hba,
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
 			pending =3D test_bit(lrbp->task_tag,
 					   &hba->outstanding_reqs);
-			if (pending) {
-				hba->dev_cmd.complete =3D NULL;
+			if (pending)
 				__clear_bit(lrbp->task_tag,
 					    &hba->outstanding_reqs);
-			}
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -3237,8 +3228,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
 			pending =3D test_bit(lrbp->task_tag,
 					   &hba->outstanding_reqs);
-			if (pending)
-				hba->dev_cmd.complete =3D NULL;
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -3272,13 +3261,10 @@ static void ufshcd_dev_man_unlock(struct ufs_hba =
*hba)
 static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *=
lrbp,
 			  const u32 tag, int timeout)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	int err;
=20
-	hba->dev_cmd.complete =3D &wait;
-
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-
+	init_completion(&hba->dev_cmd.complete);
 	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
@@ -5585,12 +5571,12 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
-	} else if (hba->dev_cmd.complete) {
+	} else {
 		if (cqe) {
 			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
 			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
 		}
-		complete(hba->dev_cmd.complete);
+		complete(&hba->dev_cmd.complete);
 	}
 }
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e3909cc691b2..f56050ce9445 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -246,7 +246,7 @@ struct ufs_query {
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
-	struct completion *complete;
+	struct completion complete;
 	struct ufs_query query;
 };
=20
