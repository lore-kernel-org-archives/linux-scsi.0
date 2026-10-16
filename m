Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEA03B27D3
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792131328; cv=none; b=jdvzvUosqnxKlhnQvKZ8waF2DtIRBszUBo6PV4Z9ySOgZjPx0s7Kc54esQQQoPs2SR3Rh5/w8iU3Sqpwqf5hLr8IxB/fUMaE72bHDWahrEpwlp7FqwF+Qidp+iznLdNr9LsUifZJSGT8BAUTwP6DEOyB/f7XXVYyX612qcHzDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792131328; c=relaxed/simple;
	bh=n4MJC6iMf1cwKq/+yJirYmIkCBgatUkCCRnBrIPUEdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LjRl17Z1rkKRNt7Z2f1wQnfdTNmmzg/Nc2dfE1ywFfjEBD6haKrBVmiVQzu9r75avpQbpqB2b+NB4RQBFwIZlIXCwfAmJJc0qoYRunIimso5Ft6AEChijX/wqVsYdBzu3HepsWRhj0RB7dw36BdZocaEWykGeiYN4YoX6ZaykqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=iwcoB9DA; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="iwcoB9DA"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso1281636a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 23:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792131323; x=1792736123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eVW4rC+ucvWPCD3KbEY4n2x4mXCfOqTdSeZ6A0pMGGk=;
        b=iwcoB9DA2ZkCF9DmPCzMhg1jnOVewj+7oA9W4IUUKz5jQnTRH8+ruZyaNVu0hYrKN+
         O7sXv0VOG7SyisHMA0dsCbecQyu/VEzE9vLgLOE1/8DC1Vkh8WpDB4N3JyseSXhTOaa+
         j0c/1huf3vt9ssZJSg35ytnI47P3hgenXU3HGDsDFUZfxOFNjHsXQANSt6FIc80suCx2
         9H8qhen3y83Rm22j1jfCVN0lyUVOtn/SDBp4IIR3jU0d68x6pHKR4cjAB3Jwa4FlLVjA
         hNoGBrNMfc8EBWFKZAgYPi8Bcvfu+jKkWG5j/E7CNjMJXx5+iXVpd0Mng+QWNOYrEsaL
         k7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131323; x=1792736123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eVW4rC+ucvWPCD3KbEY4n2x4mXCfOqTdSeZ6A0pMGGk=;
        b=I/AnDtuDuLKm0koEXYsKYhn9YGrkRLpZjMaNhwEq1Y4OPfXWyy9/O9MeRDWU1ayOqh
         cDmvZcfjiUH7WL1CINCvuCED3KSxKONgUrsk38j3SQyxSVYWwSaQWDrTKTyJIxtrDEC2
         nADr7uQHY25KeDcWJEPTX3PcYPxDpHC2xEn93OGO06VC5XCZ+Gqba6z5ky231xiLJEID
         HNrNqYP/KuLkn2s8VVW86HQidz72n+dXXd2jfceFbCP9RRzuutA9mV7sRQcFpm788j+Z
         gDLiBWln+kkLkYRWa1ECGlcLMNRLxc5YZupRh0xk2PTzmcrluWRDxolFlkuNwXsGtzhZ
         9hAQ==
X-Gm-Message-State: AFq9FYLOTdBOoaG51roUPu9fcdm4LJb3y6HOYAK2zFC4ou03AyCJdgtM
	2SofkVmmlhrdfNbswO7Ayx8c5eeaEXZ2Uc/zMN8R3em7YBy0zGbmh2802zSJIH2WS3A=
X-Gm-Gg: AYBFou0fcEdzUJ+bdje4UA5Fh/cekzwlYD5Ssr9FCuW02NfCCj+/yAdGpYJErVKyeiR
	SLe9cPbVBYSwqfkFe6zm1aeXAW6OaTQa7V3/n4ogMwsK+FNSLtdy5/obO59SscagCHu7n9J0UeP
	RYjerQt8QwPlWWUPpd6AQ7PtlkxTYdOf3oDjkGJ6lS1hGS9EKCNBGguaENHAOR3IRmVrSrQk2VJ
	D4S6zPZh4rUaJWPdGUl9AiX9f91IEpkACsmKxQ2q/0Sq79KdW1ilo+qz7zGVen4Cb8QI+lB6Tip
	xOH+osoiLPdtUa6RuUVIAfvcH0GH3fDdjZrrWFXa3wfYKKKPmV9yCo25ytjDC5+icPfyAY5xQNu
	BctlPrL8PwcOMjjp4jLV6SgoJ4vKGjIRQwStdwIXDRAWiJTW4fuFe8jsvneGBs9/MZCBjldALvL
	aZREgDT7gs0k15uJwfI3NE68gvglJe86joQ1M2hDfta0+HZ4V4iiO5qRWroYi5ZeEJOnUMIZxAl
	mKVLw==
X-Received: by 2002:a17:90a:bc8:b0:3a8:545a:9e87 with SMTP id 98e67ed59e1d1-3ab3a747e4dmr11957759a91.15.1792131322640;
        Thu, 15 Oct 2026 23:15:22 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e7311sm7678604a91.4.2026.10.15.23.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:15:22 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH] scsi: bfa: bound the RSCN event list by the received frame length
Date: Fri, 16 Oct 2026 15:15:13 +0900
Message-ID: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bfa_fcs_lport_scn_process_rscn() takes the length of the frame it was
given and never looks at it. The number of events it walks comes only
from the payload length the peer put in the frame:

	num_entries =
		(be16_to_cpu(rscn->payldlen) -
		 sizeof(u32)) / sizeof(rscn->event[0]);

	for (i = 0; i < num_entries; i++) {
		rscn_pid = rscn->event[i].portid;

payldlen is a 16-bit field, so num_entries can be 16382 while the frame
sits in an unsolicited frame buffer of BFA_UF_BUFSZ, which holds 569
events after the fchs_s and the RSCN header. The loop reads up to 63 kB
past that buffer, and the duplicate scan nested inside it is quadratic in
num_entries, so a single frame can also spin the receive path through
more than a hundred million iterations.

Bound the walk by both lengths that matter.

The first is the received frame length, which is already here:
bfa_fcs_uf_recv() takes it from the completion with bfa_uf_get_frmlen()
and it is passed down through bfa_fcs_fabric_uf_recv() and
bfa_fcs_lport_uf_recv() to this function. Work out how many events the
received frame can hold and take the smaller of that and what the payload
claims.

The second is what the buffer physically holds. That frame length is not
itself bounded by the buffer: uf_recv() assigns it straight from the
completion message, "uf->data_len = m->xfr_len", and only warns when it
is below sizeof(struct fchs_s), so a 16-bit transfer length larger than
BFA_UF_BUFSZ is accepted. Cap the event count at BFA_UF_BUFSZ as well, so
the bound does not rest on an invariant the completion path does not
enforce.

A frame whose payload fits is parsed exactly as before; one that claims
more is parsed only as far as it goes, which also caps the duplicate
scan.

The same shape is in lpfc_els.c, where lpfc_els_rcv_rscn() and
lpfc_rscn_payload_check() walk the payload length without comparing it to
the frame either.

I have no Brocade hardware; this is from the code, with the arithmetic and
the loop bounds modelled against a BFA_UF_BUFSZ buffer under KASAN.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 8c9d423129c07..bb1a821716f38 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5533,10 +5533,13 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 			struct fchs_s *fchs, u32 len)
 {
 	struct fc_rscn_pl_s *rscn = (struct fc_rscn_pl_s *) (fchs + 1);
-	int             num_entries;
+	int             num_entries, max_entries = 0;
 	u32        rscn_pid;
 	bfa_boolean_t   nsquery = BFA_FALSE, found;
 	int             i = 0, j;
+	u32        pl_off = sizeof(struct fchs_s) + sizeof(*rscn);
+	int             buf_cap = (BFA_UF_BUFSZ - pl_off) /
+				  sizeof(rscn->event[0]);
 
 	num_entries =
 		(be16_to_cpu(rscn->payldlen) -
@@ -5544,6 +5547,21 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 
 	bfa_trc(port->fcs, num_entries);
 
+	/*
+	 * the event list cannot run past the frame that was received, nor
+	 * past what the unsolicited frame buffer physically holds
+	 */
+	if (len > pl_off)
+		max_entries = (len - pl_off) / sizeof(rscn->event[0]);
+
+	if (max_entries > buf_cap)
+		max_entries = buf_cap;
+
+	if (num_entries > max_entries)
+		num_entries = max_entries;
+
+	bfa_trc(port->fcs, max_entries);
+
 	port->stats.num_rscn++;
 
 	bfa_fcs_lport_scn_send_ls_acc(port, fchs);

base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0

