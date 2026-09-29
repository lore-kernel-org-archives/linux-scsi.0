Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E15437E8
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702315; cv=none; b=NVStmH8/SfZHuswjEGLXrEuik95Kr1OyZ//xP9vB+YLlp2mYCXyqdNIpbCnliOrolqR7r11unRwtqWAn1xhbQfLQRLarSbHog1rmh4TyEORwmyP8OBgaGq+s1ZYOMZQ2gJJmZGkWnIfNsaTgWetojKB6dUNP1BLh7m8KXkn2STY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702315; c=relaxed/simple;
	bh=exS/iQEw+VM4UY8RYaE4bvJkdbiHx2WlbOKJrZKdnOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4Fs8mtP8LRpht2SFuafelicDx5tKXahOnSXnc8D8ICQuRyyOcG4TNIC6G0TpUXRNJI/iLSpbJscgbdGXCWi1F8H6+4q5ZuTdogzB/qeEmol7Wi6bmDN4ZSjUsycS+YN/dCcPovjtjRSh8OKRXtYvamQBnBzsRLKVbGlh55a2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADAqmFzs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADAqmFzs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jESWP+l1waENJJxroJHo+Cf6BpZDBoXL74CvpnwuL4E=;
	b=ADAqmFzsdI1jyDYEWNEmnALBEqgp7IrmEGygMQOfKytgCBpMlMmDkt65JsSZ0seNFQwgie
	P3U2VWIvVlr1DKHlx9lDY9j1yROOvgAiylK5rkDz8Eo5o/ii+XIWQHR6vIj0vZ7H0IZCug
	xte//XnRc2hUDJelRbNPwH5vDHjE99E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-laramcp7NfewhycSdriqmA-1; Tue,
 29 Sep 2026 13:18:28 -0400
X-MC-Unique: laramcp7NfewhycSdriqmA-1
X-Mimecast-MFC-AGG-ID: laramcp7NfewhycSdriqmA_1790702308
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D14BD1955F56;
	Tue, 29 Sep 2026 17:18:27 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA83A1800591;
	Tue, 29 Sep 2026 17:18:26 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kai Makisara <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH v3 4/4] scsi: st: Relock the door after a reset
Date: Tue, 29 Sep 2026 13:18:13 -0400
Message-ID: <20260929171813.844733-5-loberman@redhat.com>
In-Reply-To: <20260929171813.844733-1-loberman@redhat.com>
References: <20260929171813.844733-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

With auto-lock enabled, st locks the door at the first read or write and
records ST_LOCKED_AUTO.  A device reset clears the drive's medium removal
prevention, but st keeps its state, so it never locks the door again and
the medium can be removed from the drive while it is in use.

Set the lock state to ST_UNLOCKED when a reset is recognized.  The door
is then locked again at the next read or write.

Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
v3: new patch (Kai Mäkisara).

 drivers/scsi/st.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index efb8c6792c2c..dacd05092e0a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -368,6 +368,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (ctr != STp->por_ctr) {
 		STp->por_ctr = ctr;
 		STp->pos_unknown = 1; /* ASC => power on / reset */
+		/* The reset allowed medium removal; relock at next access */
+		STp->door_locked = ST_UNLOCKED;
 		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
 	}
 
@@ -426,6 +428,7 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
 		cmdstatp->sense_hdr.asc == 0x29 && !STp->pos_unknown) {
 		STp->pos_unknown = 1; /* ASC => power on / reset */
+		STp->door_locked = ST_UNLOCKED;
 		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
 	}
 
-- 
2.55.0

