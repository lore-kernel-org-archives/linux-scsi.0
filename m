Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A347A0CB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573328; cv=none; b=E2pEw0ZbZe8a+JM7YWKjevrlEwjePtNQ/p2s4zcw5kP02niPpJ6oMx95wuO6hNXgM00d2ZTkvuGvfbxHhh5dcetTdfzRO0+Xgcx9BeqddZHiZpeddh+ueZXdll41KUmeulknZqkYF1ZyMTgeENuE9YsAeODReeEGmvfcWGF44pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573328; c=relaxed/simple;
	bh=V12Pc5OMX1UvVv3hRPpz6eFRvy1OPNOixc+HWskkBxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCxei1fIVJL7ksqP/iR7oo+ouPRwp8u+hJXBXEnWQ6NX8adILHMSCdqH47dhHD9tYH2YvbgM2Wmfepbzrm4+wU/pNKvAki09mD8UjotZGNmmZ9qsiDkw+4cMRbNHmkaNpzwvhVhHJbEA4U98whPpmzadMMHJII4geRcIKQ9G884=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pJjDDT+0; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pJjDDT+0"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62ZR07R9zlfftm;
	Thu, 30 Apr 2026 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573324; x=1780165325; bh=7QCpp
	/jc4hIAmCgYIIxH8fAFq+e/dPOfLojEBHq/Ti8=; b=pJjDDT+03EBJUsVDMGDSF
	KpHNKFglhGiwz9S3Jn/FVz0FlSQ2+fNYQAJ9szy1IhPvmebKNAbJIrry3QpsGuJ7
	bBktTSno90vyW8hdt5DEpODCUu8yawuomcXT66Dk8bvhIgv4jFVJ5Gd/9AhGYaQu
	Wzg5XQ/BIpgKiTM084wlWnusa4vUKwj9YscV+AYaiIaII+JxzyXAHnHBghV4lvpe
	d6ydPXT0mXWs0XX3S5vmp21M0GVK48Hwvj7JPGNnqHXSPPyXlD+Y0ZpH85et0Q9p
	GAfHNLVE11QS+4SGZpfrUYvr24ixSWJsdimtVUZTgAVKnX7PHYylni450ZCWRPqz
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9Bxn8k9JjHA7; Thu, 30 Apr 2026 18:22:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ZL69clzlfpMB;
	Thu, 30 Apr 2026 18:22:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 06/56] scsi: BusLogic: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:36 -0700
Message-ID: <20260430182130.1978347-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index e3790ff24e56..bb5a63baf897 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2879,6 +2879,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt=
)
 */
=20
 static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
+	__must_hold(command->device->host->host_lock)
 {
 	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
 	struct blogic_adapter *adapter =3D
@@ -3183,6 +3184,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 */
=20
 static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard=
_reset)
+	__must_hold(adapter->scsi_host->host_lock)
 {
 	struct blogic_ccb *ccb;
 	int tgt_id;
