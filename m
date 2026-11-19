Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107904;
	b=H2G0NJr6BSXxCPaIUkSSRi9yFipmy4I9u6rqK9yUNV4A7DR9Z+9Sog2UPUnziGxJJ8DL
	 tvjm/Rr1TS2SzIn+iBAYIyAPa1f4+tZT88U/JeWQx9zK44BTSGDmD0RtLARVIiMuswfeh
	 n42hjlUOqzWwFW+GcVzinRJ5EufzmEcUrSzY0DPA8fbF938d+STwSS4/6dzriASu44Pqo
	 H5TpbfCkv8u42yLIL//pOFWKaZB4BgPEKAaXXnJkv2JWW9skIGy/R48EtvFJAKF8ivcuH
	 UJ5xFEwCgAyMMfiMrM/3LmQeI1eVe6VMK01Ke2AIxOJnbj+9mPupMeDSqWBwwQK7JIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=tEWTKd67+sE6hXsJjat4+R5/kfA+hMcRoqTzGHNveW8=;
	b=Xyac2DGSbVJpkjdksr4CgN0O8UqRCHK9gVZNK/IS1Wb0fK8iHkB8cbJ1d1g13nLwd7Vc
	 J2sNW1EUtawPXlzZKuJnPFCN6liF09ZRQQGg9cPVpMVaI795IcIY/12YA5y4N605kOUUU
	 iMEsLmkK/uuds1Gr8Aye9+eaEVSJndF9bDvaE0YbQiVb1UaQJJqAp437a1bi8Id85YrKe
	 jhkel72oxDapxfohd5/cqIbk6fwxVvyOTT3nU0I+YCp7z/4IRqFSxrIAIXm0zvrd/vFvt
	 Tg4XjWhX7qGiOnsEaomeAdmohp1e/e+JpStGoPx40E31LSB0UPDCzJwM+uNPtoCfksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YLWZOcx6;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46755606A337
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:05:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46755606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YLWZOcx6
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3b45597c7so4715120c88.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 09:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107903; x=1795712703; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tEWTKd67+sE6hXsJjat4+R5/kfA+hMcRoqTzGHNveW8=;
        b=YLWZOcx6/QoLsL/1TXsxTFGuZq33rQl5jXZYghA+UiYhS9k65Nw7Kr83z1yQ6oFixG
         x385VKJocvNTv6lvfu2rze7It6RimPkSvBmF6WyNsQCYWBmLkA2HVuZ21VfvAn5KM21/
         nM9Qy4lWYIJO2QRegdM+H1S90Sysd1A2trPm3bAQWhG0IEgIvsgNfg7I/xEz3v/wmFAB
         lQhSeKaYlxpVyNDu3wrhv2uyAnibocdC/BwWMB/shvpUNQ59JtrmbzBpvQoH5vEgi4zK
         JrXFreBo60+bLoSMLYQsHXFXQNcBgzmO/TjOLsAgGQYLGnX9SA2ZQ2QSIhTOzHk0IFIC
         6gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107903; x=1795712703;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tEWTKd67+sE6hXsJjat4+R5/kfA+hMcRoqTzGHNveW8=;
        b=vcxHIU0h7ijbxYYaprrkM3rHpn0E9LwHwOlKgBcGvUiwr9WuQH8I7N1XIuxWKehPKG
         7tZteTPvo9ke80pfwi1LZMXB7A8U4LBc/9MrCh77Bv5h07xLdZ0NiLf5j/IYjY6854y8
         Y5pHYrMsHz1UDJYB1iwJ5wZipGf7jQ6khOWyLyAEpMuyRDgiFBuSAfiilGQBIRR/0/ep
         WmVq//xYdel2wKpfreVD8oD4Q785Egj9uiemFtPg+QFw7aZTbkxr2J9UZxFVhCOb2kud
         L0WhPF1fDqxY6ee0HC8bnu32ExlntVVb67HWPLTEyOLPdlRvgEScJg5cNgZg1eCwGFei
         xpYQ==
X-Gm-Message-State: APuU4Z/wZSOWoHSOIe5n/Uf8nnToKdJQhHfcQ9jAL8LHd13nS88TcsAI
	KrDlplrlC5r2GY/7NeBrZ1bnku8AdKlb/cCKa6V8+esNrvgWrq1c11VYZyImpc/MbHIGyJa6ohT
	TMsC0vpRf+w==
X-Received: from dlbsw11.prod.google.com ([2002:a05:7022:3a8b:b0:19a:1425:bb9c])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:4204:10b0:1b5:4cbd:ac02
 with SMTP id a92af1059eb24-1b556895b10mr269905c88.15.1795107903109; Thu, 19
 Nov 2026 09:05:03 -0800 (PST)
Date: Thu, 19 Nov 2026 09:05:00 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170500.1514537-1-irogers@google.com>
Subject: [PATCH] scsi: lpfc: Fix format string and OOB copy in lpfc_read_object()
From: Ian Rogers <irogers@google.com>
To: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

In lpfc_read_object(), rd_object_name is a 26-element u32 array (104
bytes, LPFC_OBJ_NAME_SZ) populated from rdobject via scnprintf() without a
"%s" format string, and then copied to the SLI-4 mailbox request with:

	for (j = 0; j < strlen(rdobject); j++)
		read_object->u.request.rd_object_name[j] =
			cpu_to_le32(rd_object_name[j]);

Because the loop bound uses strlen(rdobject) (byte count, unbounded) to
index 32-bit dword arrays of length 26, any object path of 27 bytes or
longer reads past the end of rd_object_name on the stack and overwrites
rd_object_cnt, rd_object_hbuf[], and adjacent mailbox memory. Passing
rdobject directly as the format string also evaluates any '%' characters
as printf specifiers.

Format rdobject with "%s", capture the bounded byte length returned by
scnprintf(), and iterate over DIV_ROUND_UP(len, sizeof(u32)) dwords.

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wformat-security enabled; fix and changelog drafted with an AI coding
assistant. Verified with an ASan/UBSan C reproducer for short, '%'-bearing,
and >104-byte object names, and build-tested with LLVM=1 W=1 and
-Wformat-security; not tested on Emulex Fibre Channel hardware.

Fixes: 72df8a452883 ("scsi: lpfc: Add support for cm enablement buffer")
Fixes: 59936430e6a6 ("scsi: lpfc: Fix CPU to/from endian warnings introduced by ELS processing")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9173263c87f9..26c9f5721340 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22259,11 +22259,12 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 {
 	struct lpfc_mbx_read_object *read_object;
 	LPFC_MBOXQ_t *mbox;
-	int rc, length, eof, j, byte_cnt = 0;
+	int rc, length, eof, byte_cnt = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_dmabuf *pcmd;
 	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
+	size_t len, j;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
@@ -22283,8 +22284,9 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 
 	memset((void *)read_object->u.request.rd_object_name, 0,
 	       LPFC_OBJ_NAME_SZ);
-	scnprintf((char *)rd_object_name, sizeof(rd_object_name), rdobject);
-	for (j = 0; j < strlen(rdobject); j++)
+	len = scnprintf((char *)rd_object_name, sizeof(rd_object_name), "%s",
+			rdobject);
+	for (j = 0; j < DIV_ROUND_UP(len, sizeof(u32)); j++)
 		read_object->u.request.rd_object_name[j] =
 			cpu_to_le32(rd_object_name[j]);
 
-- 
2.56.1.708.g77570a6a1d-goog

