Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666733FBEDE
	for <linux-scsi@vger.kernel.org>; Thu,  7 May 2026 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164400; cv=none; b=Mj3kVZOUCZLncw60SfiQV7/iZ9KwBxMnSjL9KVj1mp3G9XuvtPcNJvWeja6/AyIV8TUZhSBJXnlWvN5HdL94ibCDqO+Mz6PGKH4O4hJ6FmxFlVZUa1FWwoPT2VQV0q/27CKk1bFep0yZ5DqFAFwVLgxOpAq3Cg4rJJ/PiZpCuy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164400; c=relaxed/simple;
	bh=/n+7llmepQAvJ5J8m7gmaT9JZWY/jvh+7hnDojvXqTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VQMCkcbDoRs0EE3PJky0ljyifvp5BFMZoaN4jnr2mxIJPoy7VGUPFwD9LDkx/AZZPSdG6TfCXNfzaYo99dnLYzHzAdYT04lAWRBTVrKw8utlLMFlRiQhO9i2iuRPAK9S5mTga7QyDdSJB4tj+9p3kvywJ1CTus72A9aiEU7YpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qiMsEF8L; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qiMsEF8L"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-900fa9f178dso101206785a.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2026 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778164398; x=1778769198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5kzcSdsCpo5Y3mn41POdySZcZFAGaT53MIAxz0TRGE0=;
        b=qiMsEF8L1E88iiuA5BvbiIgz8FiS+bFiAP4TF+bxCN5utzEYD0M4/OpGHvpMsOBo8u
         OEspr1NQCQoVplh+6Uw3fcKghu/ULNj1DOtozo+9PCHS2UQLdWexGIuVRUr5d7LrYGal
         a/mCmXVfsyUKkrX9w3jSFZeqHwWWzVfDwkAU8kJarTboXO7xiAwus5W0XbFAFZiD9vaC
         JykfBYLaV7fSg1EyG4LKkh9KjXl1Zw21ClOeOTBeywStGjjerJLQwi/J16xnxdvghj2M
         vr7AXA5JQ178AqePauHy9qFLiQm09boHMTdvQ+/cJn/byeCkCwD5RJ752SgEqIw6vd3m
         /ViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778164398; x=1778769198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kzcSdsCpo5Y3mn41POdySZcZFAGaT53MIAxz0TRGE0=;
        b=MqgghDvJIbtB85OQmBUaRMLlRqQbbPAhyxF8YAtblM7Vr55iiJ36p5XJDlZyEC2SaF
         EkA5yp7rmSHRxJpgbicjm/o7rmlVbPsuDIeAVnSjIPzdbbLOCAgl1rGAlKs7ozXHmKqa
         /VzZ3PZPu1CFb7GxOWJL0RUqY5SnZa3kn8h7RCqSzxrPmc31z7eYt88xwRqYAHw4qPJs
         k9qwkfj7IwyEHWS+UtmgYhDlHAGRSoj3GDpsYffO6WzoT3KV0EDPF6w5O1YpptqegCMW
         Dx4VhtAdLURyWMXMlOMXQqZ9P2/dhN7V2JGHlp9x2/7FWff5qNomgCPmU0vg3R3FNr7B
         JvVQ==
X-Gm-Message-State: AOJu0Ywnzc43Y3dfjBi2RplcOipaKZf93Kfn0c5QWzhIam2mJF5h0nUO
	U3YntOsjV6OIpjM7tMgwnSQkb9u3p1TJgGv+UDKMhZQLLudb6y+mYwUQ
X-Gm-Gg: AeBDieujSSnHZpO6z0U/lXSIyp0NtloAOtxtWaouVmnwwDkTYg2M99v/kLA2R4C3rKc
	2f+qi0jINMC/FBbXeuwDWuWN5SivwpaypOLIm9hDBxHGwWlBFEpOGIswrEJkXtq1OXB2gSBm989
	VRsVvuTLXghc11wkZM12HYzEqbOhDPpCRlW0yrKXkqrstBAfbGyvd4pOiuneCNBK6+vpbwH9rPY
	+hSoIFJ3BL5XoarSVZ53nh7QFvw0wTbpPRXGpKYUDsxV+8CRKH0j87EoM/YN+SiypOKLcuB7Kc6
	/NxyZRS5yL2kK4rC66Whkkf1FiTlxxgEbnqX0fn/5tFFAd/ZOvcgtm3vPDZTEVHfuQ2BVLSXLuk
	TLlBAkvUzWrlc5s2XK6FfBwuFCQjku1z1A1U9gT7pJXsYKMronxtUUbpdgQWhdxlbpqQ4oXJDEU
	C+2FwnBLOjOF+lw0RTr5zlOSvbPczRgoVnVQrAe8YOR8VIh+fl219/3xnXy4FMwB2F6gIxi1MOC
	CS6teNDQ1jWrybmjWCyv9AQaQ==
X-Received: by 2002:a05:622a:59ce:b0:50f:bd51:f1d2 with SMTP id d75a77b69052e-514621d1bfdmr103573311cf.50.1778164397873;
        Thu, 07 May 2026 07:33:17 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b80a4dsm175420501cf.24.2026.05.07.07.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 07:33:17 -0700 (PDT)
From: "Jeremy Erazo (Devel Group)" <mendozayt13@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jeremy Erazo (Devel Group)" <mendozayt13@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: validate ECDB AHS length
Date: Thu,  7 May 2026 14:25:59 +0000
Message-ID: <20260507142559.2373177-1-mendozayt13@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

iscsit_setup_scsi_cmd() processes the Extended-CDB Additional Header
Segment (AHS) of a SCSI Command PDU without bounding AHSLength,
despite the long-standing "FIXME; Add checks for AdditionalHeaderSegment"
comment a few lines above in the same function.

A SCSI Command PDU sent after iSCSI Login with hlength=1,
ahstype=ISCSI_AHSTYPE_CDB and ahslength=0 reaches:

    cdb = kmalloc(0 + 15, GFP_KERNEL);             /* 15-byte alloc  */
    memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);         /* 16 -> 15       */
    memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
           be16_to_cpu(ecdb_ahdr->ahslength) - 1); /* (size_t)-1     */

On CONFIG_FORTIFY_SOURCE=y kernels the first memcpy is rejected by
__fortify_panic() because the declared destination size is 15:

    memcpy: detected buffer overflow: 16 byte write of buffer size 15
    kernel BUG at lib/string_helpers.c:1044!
    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
    RIP: 0010:__fortify_panic+0xd/0xf
    Call Trace:
     iscsit_setup_scsi_cmd.cold+0x8c/0x224
     iscsit_get_rx_pdu+0x9ec/0x1740
     iscsi_target_rx_thread+0xf7/0x1f0
     kthread+0x1b4/0x200
    Kernel panic - not syncing: Fatal exception

On kernels without CONFIG_FORTIFY_SOURCE the first memcpy fits in the
kmalloc-16 slab object and execution reaches the second memcpy whose
size argument has wrapped to (size_t)-1.

Reproduced on Linux 7.0 with a malformed Command PDU sent after a
completed iSCSI Login.  The trigger is reachable post-Login by any
initiator that successfully logged in (anonymous on demo-mode targets,
authenticated on CHAP-protected targets).  No claim of RCE, LPE or
controlled write is made.

Validate, before any dereference and any allocation:

  - the AHS area received from the socket holds at least the 4-byte
    iscsi_ecdb_ahdr header,
  - AHSLength is at least 1 (RFC 7143 §10.2.2.3 minimum for the ECDB
    AHS, which carries one reserved byte),
  - the declared AHSLength does not exceed the AHS bytes that were
    actually received.

Reported-by: Jeremy Erazo (trexnegr0) <mendozayt13@gmail.com>
Signed-off-by: Jeremy Erazo (Devel Group) <mendozayt13@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target.c | 33 +++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e80449f6c..de291eb6f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1100,6 +1100,16 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	cdb = hdr->cdb;
 
 	if (hdr->hlength) {
+		u16 ahslen;
+		unsigned int ahs_area_bytes = hdr->hlength * 4;
+
+		/* The AHS area must hold at least the iscsi_ecdb_ahdr
+		 * header before any of its fields may be dereferenced.
+		 */
+		if (ahs_area_bytes < sizeof(struct iscsi_ecdb_ahdr))
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+
 		ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
 		if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
 			pr_err("Additional Header Segment type %d not supported!\n",
@@ -1108,14 +1118,29 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
 		}
 
-		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
-			      GFP_KERNEL);
+		/* Per RFC 7143 §10.2.2.3 AHSLength counts the bytes of
+		 * the AHS that follow the AHSType/AHSLength fields; for
+		 * the ECDB AHS it includes one reserved byte, so the
+		 * smallest legal value is 1.  Rejecting 0 prevents the
+		 * "ahslen - 1" memcpy size below from underflowing to
+		 * (size_t)-1, and ensures the kmalloc(ahslen + 15) below
+		 * is at least ISCSI_CDB_SIZE (16) so the first memcpy
+		 * does not overflow.  Also reject any AHSLength larger
+		 * than the AHS bytes that actually reached us.
+		 */
+		ahslen = be16_to_cpu(ecdb_ahdr->ahslength);
+		if (ahslen < 1 ||
+		    ahslen - 1 > ahs_area_bytes -
+				 offsetof(struct iscsi_ecdb_ahdr, ecdb))
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+
+		cdb = kmalloc(ahslen + 15, GFP_KERNEL);
 		if (cdb == NULL)
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
-		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
-		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
+		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, ahslen - 1);
 	}
 
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :

base-commit: a293ec25d59dd96309058c70df5a4dd0f889a1e4
-- 
2.53.0

