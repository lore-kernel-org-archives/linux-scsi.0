Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233545;
	b=zOkC3NJsoJlycwJPEjxpu02wi5mg7Nk3Ow+oEsv3I3NZYNEFkZUn0q9sdR4aDXz4dOLM
	 Jr0BJ2ELSGDr7JNev/SwKqE/oiQg1MJM0Ige1zpp9sb6sPpqFyhT9n6nHkIZGuitqE3qe
	 8o+8GM0R1BxOb6ojfA91DoZ+Ni+xD1n7yqMEgjgj8y9lOFHJ75BPsoRZfpPkiTEax+udt
	 Nk0tSQGhM8XdVTahU5LhbJoWUJ0/SgQ/3L1A9TbJzLJaNV9ZU1ZKQEXTDosNJqvomXPyz
	 17DO/uL6nSJtQEwqbEQE4aLc0fGolMZICm297RjU4BVNa/Y3QoGmX6AIpCmnOgxQ/Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233545;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
	b=Hd08gCI+lLgqGPa7/px7ET1Cc6ZzWA8pH0ji/bQ5sgHM3zv0+YrWxzFMQXrY1e03g7lu
	 RbIFVQAC3COdK9u2cQ9ImONvxMASb86XrkNqj22nNoM8sRNMF0AgtRjkxgwQd/U4ahwdD
	 gbzzLvrVAtesz31079F2nU33On7nEPowK8Ue/oPUibEZsuBnBRhfs2dxBe7EcHseQugtP
	 wuf/C91tUo1ZwwDWz4KVUqfMw37aKaEfpAZTl4pYWHOK9N0iCJL4MJX31CH2pVSR8E1JR
	 Qn6QYroRSqTGMwEmUYGXQ2ZSGSzTTC7DacqtzMFLCjhSAMoYXLgGdVoxrfgndIBPz+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=OVv8kmyQ;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B15606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5B15606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=OVv8kmyQ
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3514b90bb89so2960678eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 17:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793233544; x=1793838344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
        b=OVv8kmyQ4JUBa/ZpjgvrAbS1Sx2CWnps4eyLy+hbh+wkGxn4YtliWhIhCfFRja6N17
         5y9H1JUx82B/6H8mIsaDN/2/Un0F7VMSTL6XHgcFE8foW/H4WyGLFOmd9my+JrCKGGeW
         kwlMJ6XTBpK/ga5cGbGOoMbPut+MAlJP3NrWdIhUQauuif4NKs1iB4oOZXgtJnsE3FeF
         lIB+VQphi330yqdDVG4iVUErh0OY9WX9LJ1HHYgfqiA+cqwNqv6XWW+BmZ+XNunNVT1p
         xsVcPH656CpTXblgVobaFRp2vX3vLIlK2+6q6BGcGa617NJlnJFsbY0L62ace4XRpomL
         a24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233544; x=1793838344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k/10f5c+oWWOXFNZyBGAsvHHDb+DQboLM334VsQA3NU=;
        b=W2MTKxHwD7Mg83ynRFYTOeVjfY+oSx1V+WUwhhZ2prrtwq5NfrY+1e5cpLwnuVeLjL
         WRl427t2l3WUNSFftc708qRJnRPGnT25hvnvOenO8hUFbTcySrTdvydDkf+lWBj3DPpV
         yFraI2BRIPerP/wnJROU+ADp1LC4KMToR6/xqSkPvgdyo1gIDu7J+WiGD70VpOV9Z5lh
         5wCMfYFTzFn7iV1UASgkjfkBZ/gsI6iE15Pmayv+nio3En+K1uK6OY9OKo6aPDbXcJH9
         T1DN8xJIitKLVKyKyp/psKZq89zc8Txx9nBnRNp1BnKc3enQ3dUTBamB39TAJg2M4vCX
         ZL0g==
X-Gm-Message-State: AFq9FYJZRa77KlNybag30hnHBibQz91WPbvbOqQAx8xtMQwuTw7hMgz5
	6qyzCxwIRcEzJBwLGoKUzM/2vIK1f2zKOI+6wEKGHFnueFCsAWmJgO4IdcdNIMPWNy2iN0Y3ZCF
	2ZZACdGgFptyx5BsLRgKb0ZCw9/AuXSIp9uLuGLa5w5aZDoUqKLuy0+hkcs2fwCtsl+5bbrXM4e
	Y5O/idcT4V2gfkRdvgnfUb0VySqnGZwgJQRSMW61fhIXqMwd47DQ==
X-Gm-Gg: AYBFou3kHy7DJUGuPD620XJU3R1pXmn826WXtvhaE0jeSDzuNLAmkJfWWZHVCCCOHlq
	sS5o/c5HSWXUE8M6LsABZqhM1lgOHNOizi60OTQUHZAmHVsuAbNpGVaSMEKaWU7v+myTP9NPUhs
	8SumCU1EKaXCBkXS3o+w3Hc146wpPC2miq9cSAz0IWJ2MCiwRO6JVsodcPq+zN1Sn1vHrcKk6/A
	GtdQotqFV1qK2OnDtFlSP5DVhhY2wdVM/cJR++yKD6ifGqE4+EmmJ5QAHbv02yME3p/tPFdLDe8
	wPnBHjGSY8tMB1+M41+XgVOZURtVIHC7Qvd096osyVHpGyHytc7mPj2vb4leCWIgC/XTvhjScog
	WWJRA8kyj/cF7S0vH81eBjUuBWp944AMWDKjXEZ5ZO9oCaaGHFuu8hZvVlJbFvAIbT2RYT22VJr
	/8g+qGnOV0GQ4cmiw/RAfAqTwk1VR2DBl/0Rxzs7vL0scV/CTPBA5u6Dq3g+csREY8DfDMSlc4p
	tcV6ZI+ceOF9lQPcfpaBjCLHtAxR0TRraXqPtEUlgCcbBVJJv5YcWxoo73a8OC7g43wUs59sKk+
	uKfdfiBXlF4ODRjBUdUsFyqG5LvInNHrNf6eCz1ZymlwmKgkzwuWF9zSMQibDpvT4YRlDuBPhRD
	hf8c1B2PLU1QXzVK8c8Wq/oxxcGw8pfVX0uDk/KC52OyqvM6mFLOtT6kB9g4tuTlZSf/bdTC3wa
	r1OzRVLz6LpzoONR3XjkV3CEZRtHIOC3NQllkAjL5UCZvHWcw=
X-Received: by 2002:a05:693c:6092:b0:369:d7b0:99f0 with SMTP id 5a478bee46e88-36a2007b9f2mr6322299eec.21.1793233543172;
        Wed, 28 Oct 2026 17:25:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239a2e29sm11294226eec.26.2026.10.28.17.25.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 17:25:42 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3 1/3] scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
Date: Wed, 28 Oct 2026 17:25:29 -0700
Message-ID: <20261029002531.82824-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029002531.82824-1-brian@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
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

Suggested-by: Hannes Reinecke <hare@kernel.org>
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

