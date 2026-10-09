Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF753E2ADD;
	Fri,  9 Oct 2026 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541445; cv=none; b=HRJLtg2N8IUGJUqjgRyfg5dSAPKiOo1cG6S9o/mTenF9LGAE1CRPStLqFXBjUXqa09VDbZ6rlvzn+JBRuPhZBd2NPyC6MRGtU4NBsd1e92GCTocKTT8oDsTOITUpoCMqD87DqGpl3rXn9XnfV+waNK3/8fQR2unT3mcqsozqFH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541445; c=relaxed/simple;
	bh=3jnEJfI9bG59EnTPShiBSpf9VAFTlbiYBQMI58KxYYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqA9OaLEQ8PZx/EpiK1zmC13aBKJWjmcV74RQSaeClhd+e7yAnqDne5zhNNfaBbW6deh3ARj2u1mBBrGZAHa2h43RD9M4eZL5OrNIdYpy4R9rQ0o+57uacbx0BafCPTQOi6vt93QsVQ0C4c17hQnjFUZ1us448iHCMnYcI9knzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TNjniNco; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TNjniNco"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=s0
	uKwspedI1IengoDShNkXFAQfrnciU53JECdxl0ipM=; b=TNjniNcoFcqZ8morE4
	OxX+JCyEmO79+7mrTRXEBO9je35H58d5Ulh3gxZfqInAWZ17OkxR7yMvJyi8wpYD
	+XWN4xSkMKanufhqJtyqdSGUpinjj6MwoELl0sVvOXh2nZSVEF6FGwAgNMijegl4
	5SlWDDOqICHMc/xbkd+vRbARw=
Received: from WIN-TOG0NDEIICD.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnjvSRwMhqk4VBDQ--.5655S4;
	Fri, 09 Oct 2026 18:23:16 +0800 (CST)
From: Shirong Zhao <shxzhaosr@163.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] scsi: mpi3mr: check set_identify result in update_links
Date: Fri,  9 Oct 2026 18:23:11 +0800
Message-ID: <20261009102313.18-3-shxzhaosr@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009102313.18-1-shxzhaosr@163.com>
References: <20261009102313.18-1-shxzhaosr@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnjvSRwMhqk4VBDQ--.5655S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJry3XF4furykXr1xJw4kCrg_yoW8Ar43p3
	yDW3s8Arn5WF409Fn7GF4IqF98t3Z5Ka45trsFq3sYkF4YvryayrW2k34jqay8Crn7Xa10
	vrWjqr1DZF4UJa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jDsqJUUUUU=
X-CM-SenderInfo: hvk06xhdrv2qqrwthudrp/xtbC7RQiYGrIwJSmxQAA3u

mpi3mr_update_links() ignores the return value of
mpi3mr_set_identify(), which leaves the identify struct untouched
on FW query failure (recovery in progress, config page error, bad
IOC status).  The phy is then attached using a stale
mr_sas_phy->remote_identify.sas_address from before the failed query.

Fold the call into the if condition so a failed query takes the
existing zeroing else path (same "no valid identify" state as an
invalid handle/rate) instead of attaching with stale data.  The next
successful link event re-fills the identify.

Verified against scsi.git fixes (469fa055664b), the current SCSI
fixes tree.

Signed-off-by: Shirong Zhao <shxzhaosr@163.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 232af978d..abe8c4fb9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1093,9 +1093,9 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-	if (handle && (link_rate >= MPI3_SAS_NEG_LINK_RATE_1_5)) {
-		mpi3mr_set_identify(mrioc, handle,
-		    &mr_sas_phy->remote_identify);
+	if (handle && link_rate >= MPI3_SAS_NEG_LINK_RATE_1_5 &&
+	    !mpi3mr_set_identify(mrioc, handle,
+				 &mr_sas_phy->remote_identify)) {
 		mpi3mr_add_phy_to_an_existing_port(mrioc, mr_sas_node,
 		    mr_sas_phy, mr_sas_phy->remote_identify.sas_address,
 		    hba_port);

