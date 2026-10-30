Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400178;
	b=kpcBfn+aVGcPGsyFD29XCbNwdf/qreJxcMTgKGUsAlESVXLS9pu8G42iO4p1ZEQ58CU5
	 zhZDRQI2XDjFk7Tx7n9lzRvQTEdE1vNbC2s3lpf0zr+l/gdgtafjU2w+g3lVLh0G1BXdP
	 858+xGYNfmcvIbUKsVjWbcmZp/qo6zwrA0SsMJUtBdc50pmifqsVxTqL0y2fUjdk0vM2o
	 +tkHcLg0K09t4ZVMjpP+FjRoxisfOMnpaizaQh+MhafQr+eCXU7lgBPKlP5/auS10OaMM
	 hMs80hbQM6dbAZ9WFTIG0mcpRVudkSlDAV8WSn+F5qjoNRIYrOCYKB097+CbVW9fxcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=+yai0S4IOWzQpDW42z0yQiwqshtFSb4Zmxtb4feiJXE=;
	b=rfHNO82obChmsH0tOdT0Dxmlnn/w33QsNQrGbGpD2tD8mISBykFtTK32Ms8z1RtJYXwm
	 pVPBPUkJO6E+qOaLN5H478t/E+Y+YcpwSoDu0m6QBbXMkUZqvbp8idNNCp0Z9PNN+h5wu
	 6J3SZ55LVHEZXqgLSALt+5i82It5XYYBTD/1PoFIPiTaUDiR+zribkBGShOHC4D5S60Qf
	 PCnhv96ll/km3yQdZzNt0ifPGDeT0u7UsakaVErYRTum6V4PkLjYqent1LJUBsFscwzF2
	 KMv6rLCrr73gsRf40jNGBmQcqPDyuswVbyiOnI5bsCCggnixp0nPq1RGQeMlJQVffvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=KJAyZnZD;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED00606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AED00606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=KJAyZnZD
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbhx1spGzlfvqP;
	Fri, 30 Oct 2026 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1793400173; x=1795992174; bh=+yai0
	S4IOWzQpDW42z0yQiwqshtFSb4Zmxtb4feiJXE=; b=KJAyZnZDIIhvSnSMwiyXt
	1eeQWbUyj83mWmKk/lTyjjfEJwdmVJKjOoiuw89GiD/nXG+/1H4u3qug/gC/mTV8
	A99tNd3JOQivFFk6UR+YLRmvHxoxAo1C123xxt1BoXxUg7toaa1EU8ONlWOdmyTJ
	YuXAmt5RbotUtm45NmQP0G7mTIKuuqUJaW24Xsbt+LvqhdM9hNicjM+CC/zGtHYV
	/XTQx4XT9m+bNHXuBAemKz41ztk+MbpJoJHXLZ1GugGr8gOI3+pEmrgkGQ31qigd
	hxOPvA/gy/D8vadCb75NB1EE0NDOklqE1GlgbM4bEmeBcuxP7quLs8Csys3BxKDI
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SkFvB3Rw0nTL; Fri, 30 Oct 2026 22:42:53 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbhs0mmSzlfvqC;
	Fri, 30 Oct 2026 22:42:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH 1/5] scsi: core: Introduce scsi_cmd_needs_stu()
Date: Fri, 30 Oct 2026 15:42:35 -0700
Message-ID: <c35a3b27958cb93c26c1ccecccd572c54da448e4.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Introduce scsi_cmd_needs_stu() and use it in scsi_eh_stu() instead of
testing scsi_check_sense(scmd) =3D=3D FAILED. This makes it explicit that
START UNIT is only sent for LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED
and prevents that the error handler reports sense data a second time.
This patch prepares for making scsi_decide_disposition() escalate
persistent UNIT ATTENTION conditions to the error handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 75442d60c30e..f27186d5262f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1582,6 +1582,33 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 	return 1;
 }
=20
+/*
+ * Return true if @scmd completed with CHECK CONDITION and current (not
+ * deferred) sense data and store the normalized sense data in @sshdr.
+ */
+static bool scsi_cmd_current_sense(const struct scsi_cmnd *scmd,
+				   struct scsi_sense_hdr *sshdr)
+{
+	if ((scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) ||
+	    host_byte(scmd->result) !=3D DID_OK ||
+	    !scsi_status_is_check_condition(scmd->result))
+		return false;
+
+	return scsi_command_normalize_sense(scmd, sshdr) &&
+		!scsi_sense_is_deferred(sshdr);
+}
+
+static bool scsi_cmd_needs_stu(const struct scsi_cmnd *scmd)
+{
+	struct scsi_sense_hdr sshdr;
+
+	return scmd->device->allow_restart &&
+		scsi_cmd_current_sense(scmd, &sshdr) &&
+		(sshdr.sense_key =3D=3D NOT_READY ||
+		 sshdr.sense_key =3D=3D UNIT_ATTENTION) &&
+		sshdr.sense_code =3D=3D LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED;
+}
+
  /**
  * scsi_eh_stu - send START_UNIT if needed
  * @shost:	&scsi host being recovered.
@@ -1610,8 +1637,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		}
 		stu_scmd =3D NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
-			if (scmd->device =3D=3D sdev && SCSI_SENSE_VALID(scmd) &&
-			    scsi_check_sense(scmd) =3D=3D FAILED ) {
+			if (scmd->device =3D=3D sdev && scsi_cmd_needs_stu(scmd)) {
 				stu_scmd =3D scmd;
 				break;
 			}
