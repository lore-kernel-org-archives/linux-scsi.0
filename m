Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228903;
	b=l9NThg8Y3B9wPt1ucQG+6SnnhAI5cBkkthasGvWJuZM2sQkyVomU+FvlEArK4Pcxr6KZ
	 rU+UaZNvLfnXJvXIxMRW4yM7toxrNqvVhOOAL0z7pnp5gfuQSFKJIkumcObgep+/giPrI
	 goEoeJOGTrLTkYbCZdLnvV3Dr80tRTQGWX2udgOQ8Kj7tEIlkHsuJZZQouflUCNLaPRDU
	 F40n13sxrY5r+V/cx5RAPT47Ezt5OalXJPevuYFpCVbahN/QAhtiR1Zj4gqFqR/q3icez
	 ribtuUpFIznGV2fexC4tm9CG7lrCqPALBwpy9ULMWTcIBgw5JH7vkyf4mVpLlMnH4Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228903;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3lxaQTumojvPzQ2wpluAWWYI/xb5Jnr7WS/vyTAQ4TA=;
	b=qqmOqI5Er6wZtcuE265bKJtNaCoX+gkeKRdrYbDVhmZCGLnhxX9hYsFHUhXzKHQJtPuQ
	 0caFlMiHsywUAIxs6oh/t5t/NtvT8LSyGMSR21WbENyt2DsXrNHTz07gq4xDmIeJtXUU9
	 VpHy2cxI+0NAgEhcLQpgdBOhh4QRybf9XX/pgOtQ+pp3BBpmeERa88mJ+nXqhVWJDPRt8
	 7hehRj4FDsKiAu3TVDGNPvYZ5C8z8LzhT1Ifm/CxYun3FnN7byYncBevIWc7tyJuePxbI
	 ZgJSSNUHIqmYbgKC0LZTAEhGG6qqITBfUFY3CmoG4BfxHzDaxJ0EObSsy5dgntebc5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=OWbAoOGv;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4B1606A323
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F4B1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=OWbAoOGv
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso1819130eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 16:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793228902; x=1793833702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lxaQTumojvPzQ2wpluAWWYI/xb5Jnr7WS/vyTAQ4TA=;
        b=OWbAoOGvEz6fYBekUMOH+w5ILLkbuOzZgVT4KrQQkDc66+aOjgEP1MegAKEmvl1zaB
         MyKBXI9kOy4064fyJM+1zLZ6if3pOpuA21jsCw0S/94dxFcNDh0zSoDeCV6rYRU9zK0X
         5w2x7EzGpFSpcFP1HDTSEFA9zjgdjaD9kI5nT0Y+JblKtSYmQG5EatjyzHZOjRrQ7YZ3
         g/Un79Lgs3GWI89q3WjxFQva4LWwT2vcoT8afgYiGd9c8+rI3DHWpPedGRFldlM5lJm5
         I/GwM78iP0mYiO9VxKcH7shI8h26GjIDH4Qsq8NsOQXZHEtMsbnqng7LoVkmLKNJFWJ8
         mJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228902; x=1793833702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3lxaQTumojvPzQ2wpluAWWYI/xb5Jnr7WS/vyTAQ4TA=;
        b=IYNacUP+8fJygPLVJv6I085ioyvcilQvLaTalQtUUyK/16hWLR3hbgEDeamGyK3MxC
         jju1u8bmFSYWjFFjf+xEEt7r4dgzDzeN+qRpQjJu3qec7BFWoxyATwuWSe+qD/VAa52g
         4y7/KCildH9MMLLii3fSkR06YZ6e62zdMhGSoUG1kBR+zR0d01DWKJ7PKgth+JpxbB3V
         8nADytzjemv7/2dQse8FT6GXQourtRhf8gku/gGLHKYsTWiYBL2t/32JgU3I9aeaQPrS
         wU4OekQtkeNdsMisxNv9vx8V20e9VcCIY+FT3BwKHsyR5D1AqATu0N3UbuWBu0H7+djI
         gxNw==
X-Gm-Message-State: AFq9FYIMl0L4okIx8f+8T+8fkF7d6pj4YUQ6uBKBwA529iE31JX/8AuP
	DkVi0Lzynx1QU+PybXqewTJ+HpQZjxFxRymo8T5DsD+zjw0h5UxOptFSFZ+EbglWu1wCJKuHauH
	n9WdmUUGubu1hb1gpCtwvxwrwd/mqzRsERwV0BbeJCaOHja20lDBA8yGX6FKaIhZFXlmhVlPetI
	5N3oDC2YislMEiX9F+ze5K1ysXgMbr45pKSkTOlsAo25TPVXr/hg==
X-Gm-Gg: AYBFou0cDw9QDie1xDn6p/XVKYkLsO9hOpWVZhjU+pAO4ADN3EUauTnt6iI3tuaPZ+E
	ycMJeiDHCg60/2jwpy45uFYVA/INtrst7vJNcpMddDT1da0YC51XZj+at9ieSG6DwlkKzIPzgic
	pa+CMkcu+4q6F/WZ6biku1fnz53PQl6vzDLAfXgcS2lobz9BCawwx2UVpQDpwl81oUEEfSIcuMU
	6ru//RDQrzjvkyF1LaPcj4Eg5Mzdhcj4e5sVPuPxBdZkIu59we32wG+yCGYCg/NLSbu1ksmRdA2
	NrLMW1T5TdK+X473NEzdsmhP7tiZOXpGLVKzv3RWzHChOzU1bawyUlblOWQsQ2Hn3Mcbx872s++
	rsW1+/U1QTzcn39dyvXIAPt+R3F9r2lHaepozn+BHFj7UsOEORrQ4ZTHXKhiAaKQGTjmWSe6srH
	xA7+UuJeXxL1C8aJzrHhfxu06/1VuUYMhCGZ9edAWDbwkjoYGeEAKD8Nrv8vofMqPf0oPB6xw5e
	39GXHfL8sX2ue21zSwhQJCjxAGsUUjajHlgSVf7sGgNS2DX8FB05bp+qXfGuKuC8w5c7PX79n29
	zIYzrlQH2FZa4QUkJkdbeJQ/mRpxw0LI9P2ljmjvbR3rKCUZtCNLKahtqb359SGhQuECNi7gq0M
	JKVmLFNd2E8OendCivkfy0iHXQgcIhHnPiY6mh/1f1jugUqP21m097O4arr2BIAxl9JG7dxqQkn
	x8NpkJVbMNElGk9VAEIr3fu9IwJRCDxzJKTTfPSkd+ag==
X-Received: by 2002:a05:693c:810c:b0:36a:8a6:6918 with SMTP id 5a478bee46e88-36a25517220mr3895079eec.4.1793228901266;
        Wed, 28 Oct 2026 16:08:21 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a26d59f0fsm8156513eec.6.2026.10.28.16.08.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 16:08:20 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 2/4] scsi: core: Read the ALUA access state when a device is scanned
Date: Wed, 28 Oct 2026 16:08:05 -0700
Message-ID: <20261028230807.61578-3-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028230807.61578-1-brian@purestorage.com>
References: <20261028230807.61578-1-brian@purestorage.com>
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

Suggested-by: Hannes Reinecke <hare@kernel.org>
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

