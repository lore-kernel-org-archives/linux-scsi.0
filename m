Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3F13D279;
	Tue, 20 Aug 2024 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131096; cv=none; b=QWWv66RJTurNHe+4+a2dBSZMTNaYzsPDhq+TzmjQ8mB6Dir7Lb5Qq8BK16gHKbnYQMPm4VuGS8b4a84vKYWjvgaEketVQJyA7hCdl6hl74PNtW0pLeLGk0oUcGgHRNevrUSvLUBMoTH5eFhAkNYxwUte8IAdg2KYdUu0DS03m1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131096; c=relaxed/simple;
	bh=NAwDUEc9uYNkZQ09MAyZm2CeVqJeiPxe4IV/Jt84zGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gWXSVaylKvlWT+IGhjz96d3L8EcnoXl60rsnVAKcOpzDEMStWu+0IxvAKJmS4H24ye5L4FKzkbG4sZotpnJKMeasx5gVKnceR+Mmk/OCzbrUZ/gdgCTxZ5ex9LYPGp/gnydx67h5N4GnDMlZSvw9brOOvwwbqCKgc1rFUEnswp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=C+57hKxg; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="C+57hKxg"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id g7nGs4tHluuNAg7nGsF3gN; Mon, 19 Aug 2024 21:11:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1724094717;
	bh=Z5HvWWNMW7KUiPSHycs/wBMeEfPiLkg9IwI2OC2MFhI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=C+57hKxgBcEgMbhr5KxmYXW9Stj0Oqxj2a/vKsTWHXaxuyLdgJr8U5csqqUuszQP5
	 fPeW17oORxHdvYg4BTk7cIL2uCO8gUL/e+u3zpk9jckHXsY1EbNmoR6BJ/juD9Ktep
	 vb4G3L2KWXN2DxdIsA55LM8Fv1ok3kQ9tAbgDtQfxz7rRmtCtkgtJY/7b85mQEG01i
	 AQmf0ZBEDHtEWl1kXMOpqgXtfF5zRVZNWeKybqxS80SP5yq0Gl5ZUKy93kQVw5BEYF
	 TpPH9/PLBQM19TUPB/fleajdpzcYZ2qip88wrDdHnFq8iY1poaSfE/3scpbP1MinNo
	 6cGejvSI9Wcvg==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 19 Aug 2024 21:11:57 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Quinn Tran <quinn.tran@cavium.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Remove the unused 'del_list_entry' field in struct fc_port
Date: Mon, 19 Aug 2024 21:11:43 +0200
Message-ID: <69155321ab26c1f4d473d5bb6cd44b59b9b6a020.1724094686.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'del_list_entry' field in "struct fc_port" is unused.

It has been introduced in commit 2d70c103fd2a ("[SCSI] qla2xxx: Add LLD
target-mode infrastructure for >= 24xx series") in 2012-05 and its usages
have been removed in commit 726b85487067 ("qla2xxx: Add framework for async
fabric discovery") in 2017-02.

Now remove this unused field.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only.

Should a Fixes tag be needed, it would be:
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
---
 drivers/scsi/qla2xxx/qla_def.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7cf998e3cc68..15066c112817 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2621,7 +2621,6 @@ typedef struct fc_port {
 	struct kref sess_kref;
 	struct qla_tgt *tgt;
 	unsigned long expires;
-	struct list_head del_list_entry;
 	struct work_struct free_work;
 	struct work_struct reg_work;
 	uint64_t jiffies_at_registration;
-- 
2.46.0

