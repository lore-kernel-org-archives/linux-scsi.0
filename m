Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF3A1F754E
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 19:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739214797; cv=none; b=Hy1LtUEA4taLZe/Ops4kQdcLY8cRY09EJb2LNzag5e130mpzFIAvUD/M4kma68H7dS2hvqsAiBf+/u5OZ7pXXwQLnGOU7voWLxxRUg0yAWvWAMSR2vW6oVbBaBaphLGziPXOQPqBbXC8bKjmXt3gue2LdgdpLMOXU3K2v9rUnbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739214797; c=relaxed/simple;
	bh=60zYAXKRIPmnSv2y5imc6eqiFXpIRJ/sQiWM5O+SquU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oksdH+thmovuACtY0vojMaSq+B2udfNmVCukfMdbFhEr+dMrJbcGlC69J9XGkeVzOjLNR1JN4K9ASNIZqMaQODeGA4xASE29EcdpWWM+oEFHeqj0DpJmij3BQ/Cbe5ziErdqNtW8dioWavN5zxhF+NZlFvmFgv2+ozr5STbLWvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=OKbxvIok; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="OKbxvIok"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
	 message-id:date:subject:cc:to:from:from:to:cc:reply-to:subject:date:
	 in-reply-to:references:list-archive:list-subscribe:list-unsubscribe:
	 content-type:content-transfer-encoding:message-id;
	bh=kTE+R5fpY/Qz91GKX1N6I/Zg+oU8oNE6vP6JfJUmvKI=;
	b=OKbxvIokylF14wmKQvmm/sRbo5aDtETU/Vm0ZOnj/ghuhKBHh6UtZKHWdQMfR6CcxGZqCe21gAkcF
	 l1Hseef3tGe94HSO38gA5Mjgok+Y878zbgeF3V/iSX6p18YtT2uXFHxDL6cw8hpIsRMxpCxBxr3lvw
	 OTBI9or8kUCdUGys7MQAVF7OnqFlNeiIg3kHtE0M47cwxCt8AW9pnsMXVng4pspSZ6q0j+MAV14xaY
	 gTn1bDA4VVX2zsuh0VOLgvsBII09+ULKljC1b3ARuCkcNlsf5h7i1ByEZh+EtyT8Q2lg9Vk4GcfTRc
	 4ainJs/2F1WGJD9Iz0BdG/oVwIO35PA==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
	id 0dacf63c-e7e3-11ef-a27d-005056bdfda7;
	Mon, 10 Feb 2025 21:13:04 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	dgilbert@interlog.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH v1 6/7] scsi: scsi_debug: Reset tape setting at device reset
Date: Mon, 10 Feb 2025 21:12:31 +0200
Message-ID: <20250210191232.185207-7-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210191232.185207-1-Kai.Makisara@kolumbus.fi>
References: <20250210191232.185207-1-Kai.Makisara@kolumbus.fi>
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
index 7b84acebe0fe..b40023dd812b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6772,6 +6772,20 @@ static int sdebug_fail_lun_reset(struct scsi_cmnd *cmnd)
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
@@ -6785,8 +6799,10 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 
 	scsi_debug_stop_all_queued(sdp);
-	if (devip)
+	if (devip) {
 		set_bit(SDEBUG_UA_POR, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
+	}
 
 	if (sdebug_fail_lun_reset(SCpnt)) {
 		scmd_printk(KERN_INFO, SCpnt, "fail lun reset 0x%x\n", opcode);
@@ -6824,6 +6840,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if (devip->target == sdp->id) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
@@ -6855,6 +6872,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+		scsi_tape_reset_clear(devip);
 		++k;
 	}
 
@@ -6878,6 +6896,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			scsi_tape_reset_clear(devip);
 			++k;
 		}
 	}
-- 
2.43.0

