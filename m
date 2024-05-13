Received: from mx2.usergate.com (mx2.usergate.com [46.229.79.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895B414F103;
	Mon, 13 May 2024 12:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715603242; cv=none; b=mLvKsiubRIZ8Tb8tGs3yLPHkFbbtIlkhFGqJAfc/EWV6cMlR4e+TBW7qQo5/g6NEoe9n8hKxAS5keFEhBTW8OqPERAQF/tGlgNi77wN5xrVtRL5f9T82YBMDxXgpodwOsS50B+HuUc1uIet/pgFgvwIVs6JGNiUTdNdYUvqlk+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715603242; c=relaxed/simple;
	bh=oKiXlEtPAhBwR95eRclzYiHrEd8EvaNuezey49g8C9U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a0FPFQM2SiAPieINiiXbjINy1KdDVg/kuqjK8MNpf7AOp/H05h7imiqVyZ46VnQoK4JmFi9yEmvUcCc6T8C4lfzqQH150wAfg9H2WF8hHyp2YXOR97lPcJtK9iYeyrhtdESZjQjzaTo9q/eVTOaIng0UXpnvBSmCssqtlfM7aBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 E1AB971BDF504F85A203326A77D2A618; Mon, 13 May 2024 18:56:57 +0700
From: Aleksandr Aprelkov <aaprelkov@usergate.com>
To: Hannes Reinecke <hare@suse.com>
CC: Aleksandr Aprelkov <aaprelkov@usergate.com>,"James E.J. Bottomley" <jejb@linux.ibm.com>,"Martin K. Petersen" <martin.petersen@oracle.com>,<linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<lvc-project@linuxtesting.org>
Subject: [PATCH v2] scsi: aic7xxx: aic79xx: add scb NULL check in
	 ahd_handle_msg_reject()
Date: Mon, 13 May 2024 18:56:35 +0700
Message-ID: <20240513115635.2507689-1-aaprelkov@usergate.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: C5FD6731D51D499D83B2034DEBA6EB62
X-MailFileId: 4187C307D2FD4A009E8A7EC63635124D

If ahd_get_scbptr() returns invalid scb_index then ahd_lookup_skb
returns NULL. Later in function scb used without check then NULL
pointer dereference can occur.

Add NULL scb check in else if statement so message gets rejected

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
---
v2: Removed "!= 0" check as Damien Le Moal <dlemoal@kernel.org>
suggested
 drivers/scsi/aic7xxx/aic79xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3e3100dbfda3..6bee62224d86 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -5577,7 +5577,7 @@ ahd_handle_msg_reject(struct ahd_softc *ahd, struct ahd_devinfo *devinfo)
 		       "Using asynchronous transfers\n",
 		       ahd_name(ahd), devinfo->channel,
 		       devinfo->target, devinfo->lun);
-	} else if ((scb->hscb->control & SIMPLE_QUEUE_TAG) != 0) {
+	} else if (scb && (scb->hscb->control & SIMPLE_QUEUE_TAG)) {
 		int tag_type;
 		int mask;
 
-- 
2.34.1

