Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212950;
	b=cAgNxRc0hm01xmPdeAsmWotLe1Kg4EDZfV6iq6UnvWsTQv0VJ8CCXYbeZ8n7rujHSIft
	 FlWC/85dNdA1GwLgedFwn+iqm121OcwO8yYZQUGrfqLZ0KF45B9O9uSkPpCJa4fpUncVL
	 usKAgGCnR7VIg6f/goNblueKDkHsQVBL1P8uKhiSGEEDrMK1DjAhVkgbRcSZcVO7Ysg84
	 mW0HZy18z2uuKwYJ118dbEMmZO0tAaTD3r6Rlx4jQD4S/3/LdUTH+skJdWJkFhLHabfBE
	 EEviUi2sAKdJPW4wHtqOGNekh6SguT+naJtM0gLOqppWpS7Msst9LyAtqpjPPZXyFyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212950;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G9Xf9d+TcC3wKF3CXKN5sr+dLCMHuzHoaCmaooT/vq0=;
	b=384ero0y910Z4PEWgjthJM8WXWZM/oO1nF+/i9R7wDtH56dLA+dtUyLL350Gs7iOiOK8
	 6qD1ILCBW4VMRLmAV1f+8+ORV14ySl790asLE3MOjlWftP3JVhXpNpw9cf+egqgp9MNHP
	 vB9uCJ/FB7jDc1lOnqMpdYhfipoweMtv2dUTG/FDZDnlE1QqqalZ9em3oLXbapQQqLt4Y
	 DuBZGSgjA2pbog0BJcCbX/a/ND+M8kGs6N1w98GunDMtI6bRSX8gwMBtA5drk6goWb7ZR
	 46lxZvq8ioRHSj1ZyqZa2ebaQA54v/bZWhwyfa0cQPEGhNHFzq5Sxka5M/59lyqWk6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=dSYRAzXl;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57900606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57900606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=dSYRAzXl
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36661f953e4so2092137eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793212948; x=1793817748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G9Xf9d+TcC3wKF3CXKN5sr+dLCMHuzHoaCmaooT/vq0=;
        b=dSYRAzXlp8LZTmLBGrvgKt6TZJwX1NtEgJoL6sgOfnVX02t96GxY3T0/EELeThL2vN
         YVcjOFMquQhOtah4FreXiRT4uSl8uFOKTqiggm1AQxPIEoHyzeaeVIXaBfJcdhB4GnZ+
         gPWci8yHHUovRnURkAgYE+yQxxgtWiXsLSei99IHK8l9abLUDkNgWF4dExejjF3wWbAe
         XDb3o/PGZB5LLdLYm1J2kBO2p/hSi2Lm9JQIckgrq8nGTme6bTzILEotDR6k9Q1qq+Ch
         mfzRZMw8ssTBnr0ytfGY9+wliDZxcyWy5nx3bVDFmUngoA/4ns7ZC4M/ADz5SqWZVfc9
         7YRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212948; x=1793817748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G9Xf9d+TcC3wKF3CXKN5sr+dLCMHuzHoaCmaooT/vq0=;
        b=F0tCd4Vzou7I4Up9fAHpzFppiER6ai/TR0RQ8SqTjVIooDspRKlFSPM5eAYx0b9hlQ
         YS3f0Kw4esLmZ5w7sWs0q0Y6xR1WEzGDX9WWPWhDQhwxN1hXJh1YkINetTWzldCPQ9ZC
         MgdvAF0JgV9ucn0+CfK2J1RV0jL24ckG3CH/Hy7SF2gK10YZhk0D1TGf0deEDRMoQm5C
         3+89cabMT14Eu7TtZEA1WPNA67e8PovToWS8kiBR2P/T/xfjlRJkfiLdw2BhCqWkdE0q
         zSEVfKBDE399y2eJqTDRpjEZ0fH1j6bq6Yapc1zxSzpnhex4QtKIYOmi2fv1Tb2Q2Ocx
         vIKw==
X-Gm-Message-State: AFq9FYKBUlYQEiSA1ri+zPvhsjgVnXD9xyq2OIhr1zzwEy27PCM73G3h
	zkOtp78NTLWEipfWZVK67LWGVtnTiPybyaYsMlPXuVg99PlEiqo6Srh5LLklXHYlenQwOe9/Sgg
	kpcCxQSuIMRmzzxC2QcjoVQ+ZJMBvUanpJA7/esVEyBz9lsitZY8SxJZ/yu4ZCLZMrlZMaxQ94f
	FnTVeIPWn6WYFgbWo+av2GPfY8HAwj3bCme5FUroL5WBWKPMw3WQ==
X-Gm-Gg: AYBFou3ORiMmtxQcd8zNw3bXxNe35xHGnGgkO355suZ0Pq+lbhQG8KU9nXCPWhjbOuk
	d/ea4Q2Jw+rDJwSVnnm42332Vm/tdLaT8ZHU+Lp318iHwU0NHzlRYTqYJW9f8wO70+ZcpXPLWzw
	FdprHm0/u998bHqci8C/AAfUSKKemk2mBnQkBBErMHu1PBwB4fJ2A4LdjNvMmJrw/NoMCTq3AtX
	tAavuzx0aOOFhF+k+mO/6UIF0UDWjToHrFJza9bjGeLp9//KsXLG2NGPITLEccUea+xArO6fUhk
	ULOn+Qk404vmjddLTBgRaPVywjCrvPx1eXIG5OAq9m4aCH6Mf1ReG1MGOxNAXqVoaFWz0ra59Sj
	a9Ph2EbQRr66KFgfv5v2KLV0dFiSrYVgfE5SppK5LKVrT7w8T/M176yO7AgRIOGzCmYWTSCt3LR
	yg6OGwA1qBuHqPHgCc2qq9x3aUSKHlojesB9X4LEkEWD417FCBwgjYSZLWC072hXIHe5pNBDyr1
	FSVYDdOPvgcJmidK70kqbDq0Exig004ydn5jy5p9qrWO0R5D7pUIpl137Lo0EDMhYcGKfQcUEZy
	qvrlqXBXZ1MzFz5BDEnlEGZwrvzD8FydFn4z9zfVW1ZgQTPH99i4Crr5ypabIsHyPRDDxUwWhd6
	qpuwvNzcLL5Lp4XdCfoowKdr27tOYWCAN54GcZGtwOjZA02m1yQOsmMFHZHHscaqmQAyDF1Yjw1
	QlZ+u8Zar4mRZQlDnQhlUwLOElYUpgH9XO3/YjVKAEfMeFHcg=
X-Received: by 2002:a05:693c:23c4:b0:351:202c:c7a5 with SMTP id 5a478bee46e88-36a201152d6mr5913716eec.0.1793212948040;
        Wed, 28 Oct 2026 11:42:28 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da3e1sm11604066eec.8.2026.10.28.11.42.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 11:42:27 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 1/4] scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
Date: Wed, 28 Oct 2026 11:42:13 -0700
Message-ID: <20261028184216.25453-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028184216.25453-1-brian@purestorage.com>
References: <20261028184216.25453-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ALUA is a standard SCSI feature, independent of multipathing, but only
the ALUA device handler can currently send REPORT TARGET PORT GROUPS.
Move submit_rtpg() into the SCSI core as scsi_report_tpgs(), together
with the resubmission with a larger buffer that alua_rtpg() did when
the parameter data did not fit, so that the core can read the ALUA
state of a device itself. The parameter data format definitions move to
scsi_proto.h with it.

scsi_dh_alua calls scsi_report_tpgs() with the same timeout, retries
and parameter data format as before.

No functional change.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 63 ++++++----------------
 drivers/scsi/scsi_lib.c                    | 52 ++++++++++++++++++
 include/scsi/scsi_device.h                 |  3 ++
 include/scsi/scsi_proto.h                  |  3 ++
 4 files changed, 73 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 87ac0a6d63e5..06eb35cc9d7c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -29,9 +29,6 @@
 #define TPGS_SUPPORT_TRANSITION		0x80
 #define TPGS_SUPPORT_ALL		0xdf
 
-#define RTPG_FMT_MASK			0x70
-#define RTPG_FMT_EXT_HDR		0x10
-
 #define TPGS_MODE_UNINITIALIZED		 -1
 #define TPGS_MODE_NONE			0x0
 #define TPGS_MODE_IMPLICIT		0x1
@@ -120,34 +117,6 @@ static void release_port_group(struct kref *kref)
 	kfree_rcu(pg, rcu);
 }
 
-/*
- * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
- * @sdev: sdev the command should be sent to
- */
-static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_IN;
-	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
-		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
-	else
-		cdb[1] = MI_REPORT_TARGET_PGS;
-	put_unaligned_be32(bufflen, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
 /*
  * submit_stpg - Issue a SET TARGET PORT GROUP command
  *
@@ -518,6 +487,9 @@ static int alua_tur(struct scsi_device *sdev)
 static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	struct scsi_sense_hdr sense_hdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sense_hdr,
+	};
 	struct alua_port_group *tmp_pg;
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	int group_id_old, state_old, pref_old, valid_states_old;
@@ -549,7 +521,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  retry:
 	err = 0;
-	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
+	retval = scsi_report_tpgs(sdev, &buff, &bufflen,
+				  !(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP),
+				  ALUA_FAILOVER_TIMEOUT * HZ,
+				  ALUA_FAILOVER_RETRIES, &exec_args);
+	if (!buff) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: kmalloc buffer failed\n", __func__);
+		/* Temporary failure, bypass */
+		pg->expiry = 0;
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
 
 	if (retval) {
 		/*
@@ -581,7 +563,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		}
 
 		/*
-		 * submit_rtpg() has failed on existing arrays
+		 * scsi_report_tpgs() has failed on existing arrays
 		 * when requesting extended header info, and
 		 * the array doesn't support extended headers,
 		 * even though it shouldn't according to T10.
@@ -629,21 +611,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 	len = get_unaligned_be32(&buff[0]) + 4;
 
-	if (len > bufflen) {
-		/* Resubmit with the correct length */
-		kfree(buff);
-		bufflen = len;
-		buff = kmalloc(bufflen, GFP_KERNEL);
-		if (!buff) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",__func__);
-			/* Temporary failure, bypass */
-			pg->expiry = 0;
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
-		goto retry;
-	}
-
 	orig_transition_tmo = pg->transition_tmo;
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
 		pg->transition_tmo = buff[5];
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f695a6605815..ebbfe3238d97 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3581,6 +3581,58 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
 
+/**
+ * scsi_report_tpgs - Issue a REPORT TARGET PORT GROUPS command
+ * @sdev: SCSI device to send the command to
+ * @buff: buffer for the parameter data, replaced if it is too small
+ * @bufflen: length of @buff
+ * @ext_hdr: request the extended header parameter data format
+ * @timeout: command timeout in jiffies
+ * @retries: number of times to retry the command in the midlayer
+ * @args: optional arguments for scsi_execute_cmd()
+ *
+ * Resend the command with a larger buffer if the parameter data does not
+ * fit.
+ *
+ * Return: the result of the last command, or -ENOMEM with *@buff set to
+ * NULL if a larger buffer could not be allocated.
+ */
+int scsi_report_tpgs(struct scsi_device *sdev, unsigned char **buff,
+		     int *bufflen, bool ext_hdr, int timeout, int retries,
+		     const struct scsi_exec_args *args)
+{
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+			REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	u8 cdb[MAX_COMMAND_SIZE] = { };
+	int ret, len;
+
+	cdb[0] = MAINTENANCE_IN;
+	cdb[1] = MI_REPORT_TARGET_PGS;
+	if (ext_hdr)
+		cdb[1] |= MI_EXT_HDR_PARAM_FMT;
+
+ retry:
+	put_unaligned_be32(*bufflen, &cdb[6]);
+	ret = scsi_execute_cmd(sdev, cdb, opf, *buff, *bufflen, timeout,
+			       retries, args);
+	if (ret)
+		return ret;
+
+	len = get_unaligned_be32(&(*buff)[0]) + 4;
+	if (len > *bufflen) {
+		/* Resubmit with the correct length */
+		kfree(*buff);
+		*bufflen = len;
+		*buff = kmalloc(len, GFP_KERNEL);
+		if (!*buff)
+			return -ENOMEM;
+		goto retry;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_report_tpgs);
+
 /**
  * scsi_set_sense - build sense data for a command
  * @scmd:	scsi command for which the sense should be formatted
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e6fd6bc30644..691275db0677 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -583,6 +583,9 @@ extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_lun_serial(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
+int scsi_report_tpgs(struct scsi_device *sdev, unsigned char **buff,
+		     int *bufflen, bool ext_hdr, int timeout, int retries,
+		     const struct scsi_exec_args *args);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..6826f2d74407 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -145,6 +145,9 @@
 #define MI_MANAGEMENT_PROTOCOL_IN 0x10
 /* value for MI_REPORT_TARGET_PGS ext header */
 #define MI_EXT_HDR_PARAM_FMT  0x20
+/* format field in byte 4 of the REPORT TARGET PORT GROUPS parameter data */
+#define RTPG_FMT_MASK         0x70
+#define RTPG_FMT_EXT_HDR      0x10
 /* values for maintenance out */
 #define MO_SET_IDENTIFYING_INFORMATION 0x06
 #define MO_SET_TARGET_PGS     0x0a
-- 
2.56.0

