Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071226AFC
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074224; cv=none; b=CYSPOJ4o2zl3tYokHlOB8oq3LqFMPvEHNwayXnqvcQML03TIcNWWAI0W1sOKyYS+rwZo+1PTqlywXIzYtaYzJ9ruJyGKdPiWgDec5w/Fj67aljJ/+6lmMOyNJljAundvlu3KpZY+8xYoXgYTgeJLyON8B+o9HuxVakYd2dIyxiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074224; c=relaxed/simple;
	bh=M4V0o920wPk3JAnnje4ukYTg9er9iN/OWPGE9UrUL+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0/dTYlDVKYFe6JwaRcDyAhPLzf54xd6RXoptqIuSj6/wRD2OpDxzRtUXzfteXHJwWdYQwq9ATIBydLYWyTWHZuBzVc/oif6ITspY18+VQ18RLK/J3Cxl9ghWG26sdTUXekhssX4L0orgIMIePrCOX582iyoZnZlUJqVjKzllYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=c1F63nvI; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="c1F63nvI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=TY7bfxzNMEh+jzYBN3KL7dgpUfFemZO6Mw/7ajBrC/M=;
	b=c1F63nvIlwLgtcQAOHJIihd7BTX0fea5ALgsZPppCLVJDldUkF8zHIBPOPwciYC5jEN16oJkaJLT1
	 dv/6M+AuY/6WytHDl+Q2BKLPx01T7bPkThJn5ldKBpgjrSUeN195lZ1FS8FoOhIaK0Yx7w6NbxcGEN
	 NaZw+BTgHeCMqmE5xhiLPbVfCP1C8rKUiJDyzUd3gqOGdalYvTqwjfkUBsyp7EetRlf2lXwQ26ktKL
	 PY6H6VIkOfk75shf80TgF58rKCgtSVE2rKDJeIfBJug8+7ktu7MwMXslsZSViORKO7IO4c9wVf03fB
	 dsklzGFv6jJmco9d++bVacxK6Rkzlqw==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 6d2b2707-dd83-11ef-a25c-005056bdfda7;
	Tue, 28 Jan 2025 16:23:21 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [RFC PATCH 6/6] scsi: scsi_debug: Reset tape setting at device reset
Date: Tue, 28 Jan 2025 16:22:50 +0200
Message-ID: <20250128142250.163901-7-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Set tape block size, density and compression to default values when the
device is reset (either directly or via target, bus or host reset).

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/scsi_debug.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ceacf38cee71..c5d7e8b59ff2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6730,6 +6730,20 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
 	return 0;
 }
 
+static void scsi_tape_reset_clear(struct sdebug_dev_info *devip)
+{
+	if (sdebug_ptype == TYPE_TAPE) {
+		int i;
+
+		devip->tape_blksize = TAPE_DEF_BLKSIZE;
+		devip->tape_density = TAPE_DEF_DENSITY;
+		devip->tape_partition = 0;
+		devip->tape_dce = 0;
+		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
+			devip->tape_location[i] = 0;
+	}
+}
+
 static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_device *sdp = SCpnt->device;
@@ -6743,8 +6757,10 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 
 	scsi_debug_stop_all_queued(sdp);
-	if (devip)
+	if (devip) {
 		set_bit(SDEBUG_UA_POR, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
+	}
 
 	if (sdebug_fail_lun_reset(SCpnt)) {
 		scmd_printk(KERN_INFO, SCpnt, "fail lun reset 0x%x\n", opcode);
@@ -6782,6 +6798,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if (devip->target == sdp->id) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
@@ -6813,6 +6830,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
 		++k;
 	}
 
@@ -6836,6 +6854,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
-- 
2.43.0

