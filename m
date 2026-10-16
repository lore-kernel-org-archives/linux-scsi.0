Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92F031197C
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 06:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133919; cv=none; b=kxOJJ2qiAobKQRwadOkDonPwapoT8sxi6i+SKiKz0if34fEae6JWFPwXYalKg4KR6uzJrAbhaJ7OBckyQfnEmN6H+3N9ecUFK0oFADuDMbV7OyTc/zMkm781pCkGW8pZC7b/+EA1F5eANQt/1kabneVbWRVLtWGle/Z2qk1xdKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133919; c=relaxed/simple;
	bh=/QmjDIzxFxv7B9+RJHIJIap4aC0fYrOEg6LTg47Ow6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M5WN8YfOmfxZtKumP8ed0Hw5u46FL4Q5TsfIP0UxmMm8OwozEolb+XFnUHTq7HYc3uOwtv5OgxwLFV7TEm5k4wSRvJ5dxS6PuVlKf6wT+1uDpKm/UWGB6tCuTNiY4sVsfoBqbjmimAZ3POqxER6+xFrtHGMKfBIcM2aymnuVgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=wwO0yVDM; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="wwO0yVDM"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-88834d30002so3153888b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 23:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792133917; x=1792738717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DBflvqmY4i8z8xnUcTVk+s1WaJsD4jRg6K85yIIY1Zg=;
        b=wwO0yVDMLD+aQGTF4kG24zfTTHBW7yaFB0CAxhDEcBllX2D+lCNW5cHHr02xFWvjpV
         6EX5Y8f7KFkOkzgyYG0HtELRNcbxTAhgi1vpK0e/mOnEQS5UUZ6GwuYevV5KocB2156T
         eqdWQ7aXHCJ+unrgXPV5CWDO4tKntpbEiCKyzcTEfkkSEpxKCFccCUifyxG64pNqehwH
         QGbaiLwWjhBA3Uqz1ycbG0Gsfo5gLzhaxjf0IVx/1JBO2OF06y1KYbcsQJeQdo1p8JRG
         +RaOlKtUoQdJ7nvJ95rkaPaLxvCB7sEIImY0Gtgx/BRKD7n4mTI/f1E8R9dr43yDnGZS
         nvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792133917; x=1792738717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DBflvqmY4i8z8xnUcTVk+s1WaJsD4jRg6K85yIIY1Zg=;
        b=rPGkRwXxBH/22M+BwNlXvew52NB4pCUZXOc2KrMPmeQt1ecLMYQLvmeXBGL+FeAkQT
         +nUD/R1TwBnUzV5ZVEU/Dqp6AH2GkMftSE6X5Rxn6mvGYjb34XLa+p67GnDfXBH7suYA
         z5zcogW4TzLjhNROxuve/kYEIzciqWj9/UqK62EUbpIDgGbbZqke+J6qqiaLo4I5AGYj
         mU1BKvYcb8H/pN/aoDr4/XLus1F+1lM9yHWHmZDj1dkYkSV5lCB8Ej1Sv7ikQw6PuCqh
         ZXU+p+j16L6uM2x9AIotidljIAaJoj74ujiiN4P+yntDVEUuihXbJD3SyN8aU6iVs/Jr
         jv/w==
X-Gm-Message-State: AFq9FYJAO8Azwo5Gmt3hVL2rSeksKI0Jxng9moyQWqHCVbEdynSUwH5L
	gX1NoNiv58ndY0nkd+wUR0Kie+EMp4RVWiABZJTBGQGZ409XS5WVoeOM+iawx+n5EbM=
X-Gm-Gg: AYBFou1nipxeNji5YOLpu7bZyX8xaK5DbYmES0r+1YCHi++OiMhLVhuPIT123Brs5Y3
	mAfgLgcyEVpTuPxR8g3dO6H1JCMc/MgfELUqJWUsGuUSzSPKyHuAidM8HPEM6ZdOyuZJQXybkMF
	kfyEpiWWbD4Qo/JmdCzdMNHDg5HoWIT/4P66LW1Y5VQJFT11egFISO+4IB2KEzBYaeb8WGa+d5k
	WfrgBMkzT1eT+hBERZEgsNHlTyhhzFyDFDtT9oK7nuQgvNKytSgeNAwevwAbPZy2t2hkCwNMZBv
	Bth9xkm1VQlahfpLLDRptsy1at8/F0wH+tg3UJz8KZUexy9jlRPihh0owQYtM5OmEN948wx1kBx
	JsRnJuzHvRbwDbIMEw5Z9ApphpT0Ddbw7lY9H33p/3iat078k3re82+1uju9pHM2jO5uF8Y3NIi
	hJN0FqeXCnMnEWzhTPtOTvOJhsX8AtG/jj5iXTTdNvnyv+RPHQyrO2qXjaXmRPVXwe85qw3Oudj
	ATvFw==
X-Received: by 2002:a05:6a00:178f:b0:88b:72d6:b80e with SMTP id d2e1a72fcca58-897c5d55bc4mr18421605b3a.13.1792133917035;
        Thu, 15 Oct 2026 23:58:37 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f5735e513sm636642b3a.27.2026.10.15.23.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:58:36 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2] scsi: bfa: bound the RSCN event list by the received frame length
Date: Fri, 16 Oct 2026 15:58:27 +0900
Message-ID: <20261016065827.1011210-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bfa_fcs_lport_scn_process_rscn() is given the length of the frame it has
to parse and never looks at it. The number of events it walks comes only
from the payload length the peer put in the frame:

	num_entries =
		(be16_to_cpu(rscn->payldlen) -
		 sizeof(u32)) / sizeof(rscn->event[0]);

	for (i = 0; i < num_entries; i++) {
		rscn_pid = rscn->event[i].portid;

payldlen is a 16-bit field, so num_entries can be 16382 while the frame
sits in an unsolicited frame buffer that holds 569 events after the
fchs_s and the RSCN header. The loop reads up to 63 kB past the frame it
was handed, and the duplicate scan nested inside it is quadratic in
num_entries, so one frame can also take the receive path through more
than a hundred million iterations.

The length that bounds this is already here. bfa_fcs_uf_recv() takes it
from the completion with bfa_uf_get_frmlen() and it reaches this function
through bfa_fcs_fabric_uf_recv() and bfa_fcs_lport_uf_recv(). Work out
how many events the received frame can hold and take the smaller of that
and what the payload claims. A frame whose payload fits is parsed exactly
as before; one that claims more is parsed only as far as it goes, which
also caps the duplicate scan.

Reject a payload length below the four-byte RSCN header it is measured
from as well, instead of subtracting past it.

The same shape is in lpfc_els.c, where lpfc_els_rcv_rscn() and
lpfc_rscn_payload_check() walk the payload length without comparing it to
the frame either.

I have no Brocade hardware; this is from the code, with the arithmetic and
the loop bounds modelled against an unsolicited frame buffer under KASAN.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
v2: bound by the received frame length only (drop the buffer-capacity
term, which did not account for the VFT header offset); reject payloads
shorter than the RSCN header.  Addresses review feedback.

 drivers/scsi/bfa/bfa_fcs_lport.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 8c9d423129c07..49bcb76c118b6 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5533,17 +5533,28 @@ bfa_fcs_lport_scn_process_rscn(struct bfa_fcs_lport_s *port,
 			struct fchs_s *fchs, u32 len)
 {
 	struct fc_rscn_pl_s *rscn = (struct fc_rscn_pl_s *) (fchs + 1);
-	int             num_entries;
+	int             num_entries = 0, max_entries = 0;
 	u32        rscn_pid;
 	bfa_boolean_t   nsquery = BFA_FALSE, found;
 	int             i = 0, j;
+	u32             pl_off = sizeof(struct fchs_s) + sizeof(*rscn);
+	u16             payldlen = be16_to_cpu(rscn->payldlen);
 
-	num_entries =
-		(be16_to_cpu(rscn->payldlen) -
-		 sizeof(u32)) / sizeof(rscn->event[0]);
+	/* payldlen spans a four-byte header and the event list */
+	if (payldlen >= sizeof(u32))
+		num_entries = (payldlen - sizeof(u32)) / sizeof(rscn->event[0]);
 
 	bfa_trc(port->fcs, num_entries);
 
+	/* the event list cannot run past the frame that was received */
+	if (len > pl_off)
+		max_entries = (len - pl_off) / sizeof(rscn->event[0]);
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

