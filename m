Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212950;
	b=a7frDNpi8KWEybgY3EP+nLIu8Bs7Jb3Pvrh/SBEnAf7DBQcInFj+5iJZ9UshPzvBqBkc
	 L9YcjkSHi/qQVXjMtjdHfJbcYmX+4+HgGvfWZpOAbq29H98l1CZfcenEUnBC12TsRWyDQ
	 vMpmwf3BhhZQyGrbXYu7G0tpB6g0IgKwTb2ItoNLqTNkjY+nE1EefyPzvTKEeME+Dnd1N
	 k6a/wmZRvobEqQezq/W6cj97jIBtIh8/idAWKwCuh/EW7SWoFplFR/NvgpxXnkzeUv1Sb
	 7ldjZBl4XhMcbFrzjZ152E4oHSA5jOTieknqcXivCpIL9N6mXWFkyDqfV+f02S/yd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212950;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eaVbG5ZO8nieAl43cSJ1s+ZDD44yaOqeQNeIrqd0dGM=;
	b=QK4bG0NKn1yQl7f9D2yGl3KqC26jTdN20SyhGCI85axyq+btJrBHeegHHHL3xeftgjc6
	 MLc3lJ5OkcJ6S4GrIlxxXKFo4zqQyiPdYB4ymmrJvxKSaBL5RNqfSQndopzj9cdX+Y2QD
	 rrAR5K8fx87MvoIdKEMz1t1kXRfgdEdUoWy47UJQG+1+jddJ5RQe8RWBl63sEsDMjgR0K
	 T1/hTuINlBEu5jJu+BFMfLinDq/BarfoZ6WWagIob53saEAtQq36R6EjBViyNQcbHP50I
	 jcAvmuUfwKzKiRriQ/gwRWOGqrWY1bc/m8r9/wLpGlnnJKrYU64fM/wgMOk7m+Z3dJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IK2P+Lbf;
	arc=none smtp.remote-ip=74.125.82.178
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39275606A323
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:42:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39275606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IK2P+Lbf
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so2012767eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793212949; x=1793817749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eaVbG5ZO8nieAl43cSJ1s+ZDD44yaOqeQNeIrqd0dGM=;
        b=IK2P+LbfYwgMCn7y6gClug+lJsglJhB8mK+jKMKgKYZBVHQZNYDPcwyHRy7wtrYG9K
         QiN5Kh411i1S3xiByEoiqd8gisTHUh8HNy5Sf25tVSnTz1yjixbhMXnnq9+FRVUFoC7X
         SW1acC2yvUb5Yx3Q8P+6+CuazDkeX4hmkZUFfBOysswVYR6RFp7A5UzkbAz4hbSQ6B8Q
         2oinKRWbsp55PWBiEEzfvjy3qpZIIRzj/SVSJeK6gDjiuFcsCvmWOTcvzpj6PUIZlvJp
         c0fKXsurb97sd4AgT447b4+HojxT4+SG0hgVePOArzksrhme4dDtU4U+iaUNvd2wt2CW
         MIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212949; x=1793817749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eaVbG5ZO8nieAl43cSJ1s+ZDD44yaOqeQNeIrqd0dGM=;
        b=Fz4oEhwWpaJzeh68tL1N2kfYvoAqyYBT9ejj814Wqp0j1dNHJD0WHFbZMVf02TDl/c
         N7aF+0luCcwcF8jM9nNMF15aYD4kZQaS0JWUoiIsOGT9uu7JAA06RlhKSPUACkGRjCh6
         sAgiewfhH7inhGysBQUEjIESnwJ/aCNxlPe9grNpoh9gLpXJIVHCSdRzy5ipOBQj9JKy
         M+z8Wr+sl0bfNMxsvmsc9ZZ/PGsNZ9nPK6EBSsCk7aWI0TPqFwgj7bm4ClwXzS6lN4pF
         rO/4nQy7eg69R+pbIhyZLWk+e+lFJuprbGH6+1KgxWNS7IOf2AWfJ5dMPDnEmxKDDhaM
         MGcQ==
X-Gm-Message-State: AFq9FYJw//fL1zisfhA5mOTpKUyxuUwFlvtgeevUOT8liZgWtHzQD73v
	s4xrsByE7wnTInFoejjbqWhej0NYq/fj+pFJQa/54TkyooMRbndfUbkDDDwyOWw/vJhPH4koQwR
	Q01ziOq/FlVuohbbIYn3c/3l5zeCwinWo39ee9ax0MHvDyOfSe5Z/VQAcK+tEPVEZJCDOuIgV6c
	srbBNySVLzHszGdX/e6xMgBkHQWES5f4BavA2Y1k+DM6NEJw7mUw==
X-Gm-Gg: AYBFou10wCWwtOH2bFlZbyRUuH+YCk/UrJ6f22aVfgCZ9YCA6qt4I0F2J+KPvhoXKvR
	up4ycP3NM16Oug3Nd3+DpErz54kQQrqcL5H2oKrmNnscKUc1E/s4yUFelBO/TiCwfIphnUSSE9A
	lqx+R4yWcpj/OjT28J8HnOUJoVhvoFIGThekwivBtw4eT5TwU7hGvghz0HwWmsKh1Kekedequ49
	J/Ufkuac5OUGEgEy3C3saHXzkzQy432cWd2hqC3gVVadWvXIACKsD7tu1VuvA26UGHfuhJ1Cl0W
	xPFGuDxbeVa0XGBiSk77yPXLSryDZnD/QTEtsLVUWQ6kJ6fu5JOITB7mcPZtZsS4f0V43k1ckMf
	gy1rD6XW/YXKWi5JItAUfLY4L4rNaO5clYzFJbv4O6gtKoZGkp6FvDw9GsYt8Hf0JTiB/XPVK17
	uCaxOpFiI5vWIz07cbsg+jFNkUt9SFocOJp05X2FwQPSsDTFpPqqftwFYNwjUuIWyK8MjjdH+tH
	dPDXJDtnggH9EtFNBYpj0N4P7iOqrHfs51+pdiQF+kK2f4KQZifaIaNso6GOFPdQfn0Vy9w3CWU
	ZNGsjmh797Mcg//dBT7AZdEvF5eh2ESWJiBnmQlk9p32oBcovQMsYTofFRV2wWA9Ek7a7OkJ60f
	BP9ZZbVGaKk0RdzR7w1Rc2TfRnOZPlZwt35ZiAxEfkAvNun91kEgJmEROS9d9CnbeQrcmMxcoky
	Ut/L+dxoGW4xBRNlNK2yZlqHBw9A==
X-Received: by 2002:a05:693c:88c7:20b0:366:9f06:3c4c with SMTP id 5a478bee46e88-36a203dfa10mr4641363eec.32.1793212949053;
        Wed, 28 Oct 2026 11:42:29 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da3e1sm11604066eec.8.2026.10.28.11.42.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 11:42:28 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 2/4] scsi: core: Read the ALUA access state when a device is scanned
Date: Wed, 28 Oct 2026 11:42:14 -0700
Message-ID: <20261028184216.25453-3-brian@purestorage.com>
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

sdev->access_state is only set by a device handler, and the ALUA
device handler reads it with an RTPG it queues when it attaches, which
normally completes after the device has been registered and matched to
a driver. The SCSI core therefore has no ALUA state for a device while
it decides whether to bind an upper-level driver to it.

For a device that reports TPGS support, send REPORT TARGET PORT GROUPS
from scsi_add_lun(), after the VPD pages have been read, and set
sdev->access_state from the descriptor of the target port group of
this path. UNIT ATTENTIONs, which a target typically reports first
after a login or an ALUA state change, are retried, and the command is
resent without the extended header if the target rejects it. If the
command fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is
mapped at the LUN, sdev->access_state is left as it is.

The command uses the same timeout as the INQUIRY of the scan. The ALUA
device handler keeps updating sdev->access_state afterwards as before.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 94 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..a21dee1d9e9e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -861,6 +861,93 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	return 0;
 }
 
+/**
+ * scsi_read_access_state - Read the ALUA state of a device
+ * @sdev: SCSI device that supports target port groups
+ *
+ * Send REPORT TARGET PORT GROUPS and set sdev->access_state to the
+ * asymmetric access state that the device reports for the target port
+ * group of this path, as identified in VPD page 0x83. If the command
+ * fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is mapped at
+ * this LUN for this I_T nexus, sdev->access_state is left unchanged. The
+ * ALUA device handler, if attached, keeps the state up to date later.
+ */
+static void scsi_read_access_state(struct scsi_device *sdev)
+{
+	/*
+	 * Each UNIT ATTENTION reports a different condition queued for this
+	 * I_T nexus, e.g. a power on or reset after login followed by ALUA
+	 * state and INQUIRY data changes, so retry until the target answers
+	 * the command itself.
+	 */
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense_key = UNIT_ATTENTION,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
+	/* scsi_report_tpgs() replaces the buffer if this is too small */
+	int bufflen = 128;
+	int group_id, len, k, off;
+	unsigned char *buff, *desc;
+	bool ext_hdr = true;
+	int ret;
+
+	group_id = scsi_vpd_tpg_id(sdev, NULL);
+	if (group_id < 0)
+		return;
+
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return;
+
+ retry:
+	ret = scsi_report_tpgs(sdev, &buff, &bufflen, ext_hdr,
+			       HZ / 2 + HZ * scsi_inq_timeout, 3, &exec_args);
+	if (ret) {
+		/*
+		 * Some targets reject the extended header format with
+		 * ILLEGAL REQUEST (see alua_rtpg()), so retry without it,
+		 * unless the reason is that no LU is mapped at this LUN.
+		 */
+		if (ret > 0 && ext_hdr && scsi_sense_valid(&sshdr) &&
+		    sshdr.sense_key == ILLEGAL_REQUEST &&
+		    sshdr.sense_code != LU_NOT_SUPPORTED) {
+			ext_hdr = false;
+			goto retry;
+		}
+		goto out;
+	}
+
+	len = get_unaligned_be32(&buff[0]) + 4;
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+		k = 8;
+	else
+		k = 4;
+
+	for (desc = buff + k; k + 8 <= len; k += off, desc += off) {
+		off = 8 + (desc[7] * 4);
+		if (get_unaligned_be16(&desc[2]) == group_id) {
+			sdev->access_state = desc[0];
+			break;
+		}
+	}
+
+ out:
+	kfree(buff);
+}
+
 /**
  * scsi_add_lun - allocate and fully initialize a scsi_device
  * @sdev:	holds information to be stored in the new scsi_device
@@ -1126,6 +1213,13 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	scsi_cdl_check(sdev);
 
+	/*
+	 * Read the ALUA state before the device is registered, so that
+	 * scsi_bus_match() can use it. This needs VPD page 0x83.
+	 */
+	if (scsi_device_tpgs(sdev))
+		scsi_read_access_state(sdev);
+
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
-- 
2.56.0

