Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDD31F03E2
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2025 19:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737402680; cv=none; b=SMPBReMuaJEEsgdPEEJwvvm2adblB+cAiRQYk6OsQ77SI2yzWsrCNX1pZaElOzz0I51n+LBcQCBrtY3WLnmiuJjFiUkvM0I9hzCAFyCnUG1lbMWFPcQeYi0Ka5KJIpEiNO6NJR7QybJuAXt0D/SjEOLK19BXR5/DIPAyWRn4KFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737402680; c=relaxed/simple;
	bh=BCulJklyaVilXsUyQlDwxUFa+2ea6FdqbSLucPGG1xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ecCNxk/IFfRgeB/ZOAXapKAqZNa/7gXAK8e36b8uBUhwtHtPC51IUE2MaHLLZJxDC1TP72XyIPrn8muCTk97/jeZ9AIxJHjvxaTQQZc1Su2+t3pRkiCxdClPTSdqH6DOHCiifaKl1K/K48OGaVd/Qs4iEZ1vj6Aea6G1caWJ43I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=GGQ93oQY; arc=none smtp.client-ip=62.142.5.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="GGQ93oQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=J7gvWeXf9JaeEwT3helUnwbyKeFTP/imC3PMdengEN8=;
	b=GGQ93oQYcJRgAC2cGpWaoYMS5BwVI4tPQTfU5QgTzo3Ly0gQJ5Q9VAz8xgE5QvJLuion8yb1XRP2E
	 E2O24kguMgbhG8G5T/8H7G8d5I9BfSorX8ySw80K5K+ovuqh/UglndObIXagONC6CZ00AFb2QTuWjD
	 RdULf/iWVepfc42FcTVtGsLvffRZwwbUpK5IKfzwyMGt9e6l8ZQI35Dfs5YukkYVY1YQDzeQ1PHQPD
	 MuRFB9fOElN1q/EW8CUR96qsLAoqNYJejiskId0lwvvtvNQQWsJK3FYRIkxseIXB09H1pJR9EMFFvK
	 znasC3HzWpbjJeoDmE+Ymek10BJJbZA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id be1e9af9-d767-11ef-88a3-005056bdd08f;
	Mon, 20 Jan 2025 21:50:04 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v3 2/4] scsi: scsi_error: Add counters for New Media and Power On/Reset UNIT ATTENTIONs
Date: Mon, 20 Jan 2025 21:49:23 +0200
Message-ID: <20250120194925.44432-3-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
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

The ULDs can read the counters and see if the values have changed from
the previous check.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_error.c  | 12 ++++++++++++
 include/scsi/scsi_device.h |  3 +++
 2 files changed, 15 insertions(+)

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
index 9c540f5468eb..f5c0f07a053a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -247,6 +247,9 @@ struct scsi_device {
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
+	u16 ua_new_media_ctr;		/* Counter for New Media UNIT ATTENTIONs */
+	u16 ua_por_ctr;			/* Counter for Power On / Reset UAs */
+
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
-- 
2.43.0

