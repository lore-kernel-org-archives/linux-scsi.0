Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA323FA5DC
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 12:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106717; cv=none; b=VeL4JGEeRKDgEpsom2ViaBIvE9jLs275sTkeyglNSma7JX6M9UOcVnMJ8lplBiGErwmhx0/ncq2vSUUKgfR5BDzIOiyVUhfVaj79SVnPbNnQHT7PRPaUA8SH0U4nUVTZlrBxgP1dDIEIKyDZOQa3pS/EK6Rz9WYF+7U97rXESkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106717; c=relaxed/simple;
	bh=4Uh3eQNG1AzQ8+Z/3G2EaHP2yuu8tI/1ewQgpcXwoSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uyZPOKBl9/267iTbi3F0tM1hVESQpkGWreKeN8B1Iaoc6Fyfik9ybHK39OjzsW108kZOyt81SmagmOlH2yO0brIn5H1EikPNxsXtws5b+qfkjU3K4go5kL778FMPpTA58xcMUAhCozATFEkB0vuqe4REGBlyhd6883nNn3H++Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNHR5HHi; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNHR5HHi"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6804e24803bso5070653a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 05:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779106714; x=1779711514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sUmwK/E8k0/+bmmnitAn3thbhE/x2wsT2IrX01fre1Y=;
        b=XNHR5HHiAin54LUGTCXqPOGiCVfjzXfUfv9IkxU8pnXfYfY96DkGw8aQG3nXhzEAwj
         +eczCJmsg+NQNbCg5opZN6BLAJ8SQZYVjg4kVN3Wf/rQtZpVLe4nKk3KC1quH0WTOC5m
         rzZ1FYohAIrjDCC0Owln6/cl3cL6ctTHJORLoSorM5Cm/lDaPc9eeQJICOx6kR7FgJLf
         SGTFvW87eXDavUi7+PjVduuhLlVJVSCxyV8cKsCtjnXhFQZJgZMieC4AtaouvRx7eSNh
         uxVW0kzDTgaZWHkhhxva82iiisMLRiR3Um7WVtEO9fsqzAh+//ByPsopqn3YutA9Wr9O
         0pSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779106714; x=1779711514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUmwK/E8k0/+bmmnitAn3thbhE/x2wsT2IrX01fre1Y=;
        b=AxRlKbxx+6MGVd/NezB84q7d2dha4h57+Cdsr/KG+DKcKPdqfNAGmcyLFGbkn72rXl
         RJ7rs3rvb1iBf625AfLFTcs6CGDIQ+wAjYg/hfpg/tzjUqF0RxlQL0acwn13Kwt20eI3
         zGttkQRup9fEROl2J1EVkZRm8su1XHIXhi+jr1c2nrZq4Ocw/9IUYgmlpZaj3I561z29
         QEQYgWSmhXId2WhwguQBL7HLQPsHyI+VUXwSjtCOV33Pu45quvsdBMMLr9gjeRb3xsf1
         SA0lROC2LR9568tTsZSFF2NZNVs2iP2Fpej7F7UohZpuiM3aJrkVkAivy/yyWnX5HcnM
         P2MA==
X-Forwarded-Encrypted: i=1; AFNElJ9pway92AcmRDrHn5N9RDwxwJaW1iwMT6ErryWbW4X8VdOOuWtOTe40Ox5wNSUi442LfUhArPyMp1b+@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5v2FRkRBfpGr0ATge+3F0qmu2cQ561Bb75zr9jhF0HpD2zA72
	ccvAaHD6sxuSJYAWxhnf0Blb1nz/Y3UOfbRyGHl6bXaIKx7WF2HZMLtr
X-Gm-Gg: Acq92OFuopliOehdt3wL/cNNHjo2ClEfdNcyzMLIY1TiUbo+uMnoDqN8aKLBCFCOYXi
	FJiiTv3IdPo6CAWfEL9Q9yW6xdlgGfjB4Jaj9cbMoZYU4V80QobHpt4v8uyE6N+fmvBWKrb1hgY
	ZDcKE1ikTxf1nZd01PsKyfe8KeuYyPVECJ/TZvxM+tdi0lxhBEV5peV8NTZnCySJ0pwlIb+Vuz2
	l63lh5GI9ULr/8v0HHPfWdXi7N1lPgCmpQaqxeKn9rdLHSFeYFLWuNcDvJRGl8/FFPNK0817eBB
	6CD3uibWbcttH9MdQSQGggPjvmVMgvOTXy/dzhW7XNV8SevL6pvuTCtOr8v8ObjTyOtBy+jMac+
	Q67JjKEfA0dZ7902e0wzZYo/aYnknWU0OYtkDuqLjsTS6FArNwvPpmbsTe5Udvm3p6ob/XDxPQO
	gcotyFy7LFgvFmE30GIlA0IVsQs4nIgGEVwvB8ghAAVN1UEJ6FC4leMMyyMe2ur906ix44RTdZz
	QvKKhAbJdt9JOsYDRXqVI9Qy/Lhl6LW0X9cVjkf3MZ54doDBP25qBxNb3AMnFoxunnG0LmUdap1
	DopAwvTVJtgX9PQ0P5ki4dBnh0Nw
X-Received: by 2002:a17:906:5189:10b0:bd4:f814:efe8 with SMTP id a640c23a62f3a-bd5177ee44amr557710666b.18.1779106714108;
        Mon, 18 May 2026 05:18:34 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c631e2sm547638066b.28.2026.05.18.05.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:18:33 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	hossu.alexandru@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: validate CHAP_R length before base64 decode
Date: Mon, 18 May 2026 14:18:11 +0200
Message-ID: <20260518121811.385350-1-hossu.alexandru@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

chap_server_compute_hash() allocates client_digest as
kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
passes chap_r directly to chap_base64_decode() without checking whether
the input length could produce more than digest_size bytes of output.

chap_base64_decode() writes to the destination unconditionally as long
as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
the "0b" prefix stripped by extract_param(), up to 127 base64 characters
can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
(digest_size=32) this overflows client_digest by 63 bytes; for MD5
(digest_size=16) the overflow is 79 bytes.

The length check at line 344 fires after the write has already happened.

The HEX branch in the same switch statement already validates the length
up front. Apply the same approach to the BASE64 branch: reject any input
whose maximum decoded length exceeds digest_size before calling the
decoder.

The formula (digest_size * 4 + 2) / 3 is the ceiling of digest_size *
4/3, i.e. the maximum number of base64 characters that can decode to
exactly digest_size bytes.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index c46c69a..653be1a 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -341,6 +341,10 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		if (strlen(chap_r) > (chap->digest_size * 4 + 2) / 3) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
-- 
2.54.0

