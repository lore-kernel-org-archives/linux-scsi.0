Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3DB326937;
	Thu, 13 Nov 2025 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763057825; cv=none; b=kxS675jyZgZA0QmGihNPjcjzvmiZdKaqlhqxSQ7yvUxXhV2iwpCXc8MCHgeh/mqZEBD5yPK2bKUTeAxEPfEXnK2F4Qu5TZUCXFqfGOQZtCWMYeuCPe+M7ugVHwxyx6u43Izh/j8lZbO+OYdrTPI9I7dpKcKGa54ziwsBivUHoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763057825; c=relaxed/simple;
	bh=tIAMkL4abpkqO1UKWuVTulyKSmyD+EbZET4M3Pcp9xA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pXawqrFBpr8Opsbg94e3iAow34htRCzvld3mi4yhU2FFwN2AuLVTcHFjrbZWLPIHe5lO4gd8o6Qs6r0s1Di5iQO6gODiqVnRY2YC9UEQDipt9t+h4bREDM9T2w3cx3pnyBKX8rt6eYzmwCaq7zM7vYNZHIe5zHEWbfkeF+F6aUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WDrpRxX3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WDrpRxX3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d6pQ66VCqzm17vx;
	Thu, 13 Nov 2025 18:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1763057821; x=1765649822; bh=e2JzViC6JvXkQTbEtCyOfPhNdVTB+H5X3gX
	jMq1FvDE=; b=WDrpRxX3jgJjs4P1lnLcNSYMBB7f4DP4AhO3I9HMyYCh/T0Sd0k
	jaF4pAGy71ruUa0tvWQoMUTCm9TdZPT5B0RhomZS/myS6mbAy3OHkXstb0qWewpX
	6PmzjmmBUeBvj3aKZeev9NvfMszKa6UfcLknmz8O9VaWqEFtd86elBlZYal021Jd
	DY1JQuMoOiH6qgkcIBT7DJNnTTZtAV3io5bmqyS/QzbM8N6VazqQ4QTPeSiYPLV/
	VFNfBmBuML/HEcFrUDRIEfujGrATcUiIrXNsr2AhTcqkdDSZJwUm1p6PUS9iUPF4
	dja9deDJUJXZ0wOoah38zfM88vehQ9YJCCw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id POLuWaMDJIlW; Thu, 13 Nov 2025 18:17:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d6pPz324Qzm1CHG;
	Thu, 13 Nov 2025 18:16:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com,
	Hannes Reinecke <hare@suse.de>,
	stable@vger.kernel.org,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: sg: Do not sleep in atomic context
Date: Thu, 13 Nov 2025 10:16:43 -0800
Message-ID: <20251113181643.1108973-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

sg_finish_rem_req() calls blk_rq_unmap_user(). The latter function may
sleep. Hence, call sg_finish_rem_req() with interrupts enabled instead
of disabled.

Reported-by: syzbot+c01f8e6e73f20459912e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-scsi/691560c4.a70a0220.3124cb.001a.=
GAE@google.com/
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org
Fixes: 97d27b0dd015 ("scsi: sg: close race condition in sg_remove_sfp_use=
rcontext()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4c62c597c7be..b3af9b78fa12 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2208,9 +2208,17 @@ sg_remove_sfp_usercontext(struct work_struct *work=
)
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	while (!list_empty(&sfp->rq_list)) {
 		srp =3D list_first_entry(&sfp->rq_list, Sg_request, entry);
-		sg_finish_rem_req(srp);
 		list_del(&srp->entry);
+		write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+
+		sg_finish_rem_req(srp);
+		/*
+		 * sg_rq_end_io() uses srp->parentfp. Hence, only clear
+		 * srp->parentfp after blk_mq_free_request() has been called.
+		 */
 		srp->parentfp =3D NULL;
+
+		write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
=20
