Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7292A376E0
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543425; cv=none; b=h8zteG/BFllZ1XQc8COZ8Jt9HYIisyPZ/Wjef5PmSQjq6BICejHrTWdvSvOOk3wsjZ/PxoMPJlRlBhSM4+SneE4ZRpE8S3nl16sq5p6jN5Don+iK/PBMB68/9yTeTHMtntVCwK+zUnh6DwfLcDki7Zm/eM7eIdSl6uuZ23AZG74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543425; c=relaxed/simple;
	bh=KM0+gSVYcVSbV98eFilQZSlBUj4LlQl8rZ1uc7YDnmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5Vh20yCwDDZ0wANeHjANGEQ7fhxQVsNuQwImV5KQt7utt2+XfdLDSA81BVIOpaLHmZgL7ONKha+BSlC1TvXXXIKErFsJwH2S4VD/fKLgeRcelD6CA99bmW9KN3zriuL2Xg8yShG3qE6bpXuBxx1Vx7+ThKUYfyErcml76+9A5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=DehU1BUq; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="DehU1BUq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=Hr0qlNYospOGJ1FTldS39b0lMVvrLazIGwPQNi2ZC5c=;
	b=DehU1BUqjia7pdel89zxyDro3gzatst4ei8M7QXhrc8jlJWHVQflD2r2U8H9TYrvonZPs7O/r+YMB
	 /lzQxL5qgiAvjuqEg6Vn2+Ecz6BJQ9eH9bPP/o/CWrFD4K+BEMvadjsL9x44xeS0JOYBdECO+PyCki
	 eNVJYSW0wL1clGrIzJx+snJPGcY3BhEbfKgAmzV42EliGt3L3PhnTsb7ecD2JMKColbCBQee4ZKBmf
	 6T85IzJlIqbP/uEl3AJZliK3vQqOMMS0uHMlDUq4vsDE1oYWiYwp1wIG4tzlB2qFr+MhVPCuxSj/S+
	 +YGV/wB6IkVRJ8DTV6mcXWT1unIzZOQ==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id 044dcc28-ab36-11ef-8882-005056bdd08f;
	Mon, 25 Nov 2024 16:03:16 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v2 2/4] scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT ATTENTIONs
Date: Mon, 25 Nov 2024 16:02:59 +0200
Message-ID: <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The purpose of the counters is to enable all ULDs attached to a
device to find out that a New Media or/and Power On/Reset Unit
Attentions has/have been set, even if another ULD catches the
Unit Attention as response to a SCSI command.

The ULDs can read the counters using the scsi_get_ua_new_media_ctr()
and scsi_get_ua_por_ctr() macros (argument pointer to the scsi_device
struct).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_error.c  | 12 ++++++++++++
 include/scsi/scsi_device.h |  9 +++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 10154d78e336..6ef0711c4ec3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -547,6 +547,18 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 
 	scsi_report_sense(sdev, &sshdr);
 
+	if (sshdr.sense_key == UNIT_ATTENTION) {
+		/*
+		 * increment the counters for Power on/Reset or New Media so
+		 * that all ULDs interested in these can see that those have
+		 * happened, even if someone else gets the sense data.
+		 */
+		if (sshdr.asc == 0x28)
+			scmd->device->ua_new_media_ctr++;
+		else if (sshdr.asc == 0x29)
+			scmd->device->ua_por_ctr++;
+	}
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..b184a5efc27e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -247,6 +247,9 @@ struct scsi_device {
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
+	unsigned char ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTIONs */
+	unsigned char ua_por_ctr;	/* Counter for Power On / Reset UAs */
+
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
@@ -684,6 +687,12 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
 	return sbitmap_weight(&sdev->budget_map);
 }
 
+/* Macros to access the UNIT ATTENTION counters */
+#define scsi_get_ua_new_media_ctr(sdev) \
+	((const unsigned int)(sdev->ua_new_media_ctr))
+#define scsi_get_ua_por_ctr(sdev) \
+	((const unsigned int)(sdev->ua_por_ctr))
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
2.43.0

