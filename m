Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432684446FA
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139318; cv=none; b=lMLhJ7UeEBJ0apXKIWQGi9Kih3uvrX9iKozTI9Haz/OhSzVsZ8CZp8734iAG3Vx887eWdWbaWNa7ayCw5AWO6WFW4DSLZ+lxz22F8LyXa1/08hUUL1kcqOcwlCt/wau3V1CjreAkN0OuwI1xp6LXquhLVGplwoqLh8T9IUXbTjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139318; c=relaxed/simple;
	bh=HbY3uUHAijh/1I5FX6ar9CsRcM4iQLAX31lRTMUxHTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9U8T1tNq2+kE/Ct8abVDWydGp1bCVA5EAyOB7OmSmELOS4wb5JWQmaTzg7DPa0liQJ70Je0d3gUTSbEhoAN1NbDVWYMidiiASwcfx1hd+oOkyIvODZT1tV8AMj0PyqBt9pXRlrwh4TOdYJ9mZWsM1bJc+bnJjt6SdyL4KyDE/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=z0wbZaQb; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="z0wbZaQb"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ab3260b2cdso2815957a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792139315; x=1792744115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E3ZfqWHYTUZi3lFXImIbDdakWBiYoO4rGCBdeYzvOoU=;
        b=z0wbZaQb4L0otuOWwf2X1LSyysP9qgWU4a49EJoIQgRFRYclTR82X8ABtcn8TXYf72
         VYvnsBIe4IUbyIbQlQrqrSYR0tC2jhsY0Popeg4ebZcE0DWyF6drsB5VWUS91jRmZGtc
         cdv2MTZ1Jr7LWFacYsNdLMrEbnLu0pLiwSej+mvg6B8teFERcV1Pji86GjNNJxV72pu+
         nwtLpHOQRJaP1jONyGtSKHtk+CCQzpHmXcHSSBSEioYauAViQKLrnW4X8ZpkSVM6T/8l
         sKQs7feD1xKDblKomEls6uzcOL27Epm3D5c84wRb06jsqmeUzAAHpQUxI0Dod1TfosQ1
         9Jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139315; x=1792744115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E3ZfqWHYTUZi3lFXImIbDdakWBiYoO4rGCBdeYzvOoU=;
        b=REfXmYq4wktMcLYQs5B7awc/1hiIOntEbsn9RvUzPK2oxR3wZbQA7mFMBt7tneObHe
         psPzuYIPjwSEzC8e13Z3ISflhi3KCfuXKrRq03cjHu2ACZNHInNDdsEeNLD2XvaLY51l
         z5xrXaZKgSNpMscPRN1MR3X2JZeihDgrlentAdL+JS+BaLSX8miVZqIjxnsyoOl/JEFF
         cLF9NGK7Py34bM3dyqAz5yPm2uMs8BnPw6dkrLsVOqPYKxogeNtaDdRtxvv1+wAODRpi
         uE1s0WoJD9idc9Iz4GnMIpXDV/MM3GssvyOTEvQxnjIxSoJBmWzHmOSAOexhk/mxUX0i
         1I5w==
X-Gm-Message-State: AFq9FYIOsWj4Iofc90XOnrgNtCUcUqqkZ6h7eqNtlU574hD60S90OrXJ
	szuacIHu4GpYE1qwPFmL436MPWhBSkQ80/zaG81krfcWNJgHj3/ptgkXvuNrBJ9i3GQ=
X-Gm-Gg: AYBFou3n1XWKykDYnZutMuH/1TZ8OpV6bIEPxJe1k7v+ObsJFQf6thfKmYjbS+ve4CY
	kJ9bOLzb7Qpi6/n+JGxqq15EQ+1xeWGwtVYAQvsC1Fx9CU+W7t9JEuGstEgh3q5Q6gswuTsdXtm
	NDIXzzj5t1crqPhCo/rsdMS7BXaigc12/qxDPZxlrlG80WbeZC+krLmS/RAw4LUArbXJaY9IFkh
	gkTDWcQFx0AQn/R7F1bcMOnW0/pBzzYn5zydGWwikY2pAeMCG6fO5xO7IbtgufDsLmFVyxFZk5Y
	jN8q/3DHvRX7+3DgGmWF5t73b6sxundomAvPKKkcxZ8lMHFt2Qc5rlO6kdlfIzohYQcuGlfGwnN
	WtyMb2gA95Nsm+IV7vsfinPYAiWl1Uy39YQP/tdt9qH5O1wTkoUp0JfpF0cXvYbuSf6LZXmTbCo
	rhnunPn6vvTkJ9AaHOoC8el9VHlF5a+raAOOSpYhlFxd38ViTS4Bveal2m52F0JUKnAGli4GTip
	EwhY/3ZMgRV5kMb
X-Received: by 2002:a17:90a:38c7:b0:3ac:8897:7b9f with SMTP id 98e67ed59e1d1-3ac88978312mr3951542a91.43.1792139313572;
        Fri, 16 Oct 2026 01:28:33 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f19d9sm3088933a91.11.2026.10.16.01.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 01:28:33 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 3/3] scsi: bfa: bound the RSCN event list by the received frame length
Date: Fri, 16 Oct 2026 17:28:18 +0900
Message-ID: <20261016082818.1237059-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
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
-- 
2.43.0

