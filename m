Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E54DAF90
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166110; cv=none; b=hgrSLwl/e5qUXa2wWn4//IXaBDj2fjc5BzvOKkrTynpj0YEthmzcH8S/qUZFDQCXaXSH1bHUJ1qKahdCzfpe3BscVZ3u964bXnTGXtyZZEQs6m0YJT62Sd9w5lW5p+M3m+nCKFHg4HgNEWBJCP+pIEGAVhvI4LfjMCp02Va2r4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166110; c=relaxed/simple;
	bh=1aZ1Hbx0leHFN1nuRH3mHqgwJWSeWWZ5qKC0j/9xtH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzl6CZcivhDxKxza5057km6GVNqPs17Xg1kePdZWRoA5VXjPvC2N5b+ltpHbIzT5WZLjBu9IkdK/hpcDVOVkE7F2umapPG3G3pFaQ44P7QOPTmkruBcvwDYm+0QsCw25ZWf/AlFM8pvGAKHu3hmxCcztTRjEIk5Qj7xVAViUd8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=cp1Pw6G0; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="cp1Pw6G0"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88b8f0a1bcdso40798b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792166107; x=1792770907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+nMO90+ihrPi/+vHsOKHFmp1mDYdajMoYewWX5BF1cA=;
        b=cp1Pw6G09qsgGPrrnGYdMYs4f14g2mw91YkfZG1VZIYdGs3vkVve40OyM5aJJsFHSK
         d+E0g5pV9RW+twafCaTd27ghvk0TSus9D0eId5lvOqHbLEtrH++pgYGrSXsHNEHvQJZa
         kpzyAWzpAqZeMwigkXpNwNsQfKw3mPAm0YbhYIb0j5NN+Qu65Kq+pGfjaAoLVp1RCJEI
         VYcMsDRjfX4mn5DTfo10DM13czB8l1dAH1RTWmy/LKnyaWGge3AjPWqA60h26SP5kMsk
         yXFEdxfuNeZIYZEzH9DbXrB5Zq0HF5i8abKwFpF8bMpbAi5cXRRHCopsQ7RqDD0NLrCc
         djAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166107; x=1792770907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+nMO90+ihrPi/+vHsOKHFmp1mDYdajMoYewWX5BF1cA=;
        b=RgAkjtc+G91dDNvENpy6oV8NDHk6nWIAOfKQVrTAe1fblyGiqeobzBHmAEhlHGfcZz
         Qyf8kAAJ2h03FbgEO/ByF6IwE059n6AK/IhdhxxCyI8/ioEVUnhMhn7gM8YBijStHjO0
         DC6Wmvprlw5FSQrWuewuivCGUE+8nHJIiY5KHr7JvBBQm1Jz3yH2LNgrwyXJl+hElnhn
         xn5LEMt9th+lTZI/C+Zv5yzSpchSB7pfCGDwHmaxX/Vq4fpddiSzIaQ5xoAxBBxyvGKJ
         lXIvkQAXFnL4TK9dKthgSzwGoYw+TFMtPE3ucEj6gokif27w7vC4t9+Iv9f7BXklCrrp
         Eqjw==
X-Gm-Message-State: AFq9FYItFRqYNn6bHkwdAR5MAJR2OgoWKMmVzyRq0CDnO5+Ui+tJoy92
	5afCu18tfL2s9jkdgfZUOLc3N5T4C4z0QiRYIgInz0kjVSGOwOW5073sPMz5AOvUAo0=
X-Gm-Gg: AYBFou2LtG6l7sAuO5g3MEf9WwPn/4R+KRzq6hwOu2WDobzHuWHP1JYzaXAdk+PkiM1
	eAhE6H0bdAPMR+ZgrSRtpT6Bjrho3RFBqcvWOzhYLvzQ81VLu3GLlU0xE9OpBjxGinGKtDwWr34
	TCYIkfmVCG0igkoAZXIptrL23TFGQUUyHX+s1wOYSg0no24VEcFt4Y6OfGH8ypPuvG/qrDCMXWv
	GQPLbgqrMnmOiTVo2pUMJRa+B47pC3LvYiSnuhzt2tRqIT3woeaHEqKIklTUVbONhssAVxKcumY
	VhmpcsZjcdfKh7Bi4nJ8TPt2lrcZE/k3U8DyRFP9UG07qJQQqDNHiDPVDPDBR6ifLpcq9YdUtKr
	LAkHCyfedpdf8tOEXRb4nqFAR5idXck83LG3ZJu574iLrmuRo5sF80/qwT//9xcmi/nR8Lt6htx
	qnIMUVZ+pDVjFWG+H/hBKw6XdHRQ6lZ8P0U7XBHeiK8LamxJyhoMkM8xY4L6ti0WRv1Oc3Dh63z
	qbY6HYIPlnie201b0iNyA==
X-Received: by 2002:a05:6a21:2d46:b0:3e0:e242:5ff with SMTP id adf61e73a8af0-3e16bec70c6mr18933541637.56.1792166106456;
        Fri, 16 Oct 2026 08:55:06 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5e7a:332f:f584:a3d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65ab63cadsm983076a12.4.2026.10.16.08.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:55:06 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 3/3] scsi: bfa: bound the RSCN event list by the received frame length
Date: Sat, 17 Oct 2026 00:54:41 +0900
Message-ID: <20261016155441.1607196-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
References: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
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

The read is caught by KASAN under a KUnit fault-injection harness; I have
no Brocade hardware, so the frame and its oversized payload length are
injected, with the arithmetic and the loop bounds modelled against an
unsolicited frame buffer:

  BUG: KASAN: slab-out-of-bounds in bfa_fcs_lport_scn_process_rscn+0x1156/0x1750
  Read of size 4 at addr 0000000062270900 by task kunit_try_catch/19

  Call Trace:
   [<60935866>] ? bfa_fcs_lport_scn_process_rscn+0x1156/0x1750
   [<603b5d8b>] ? kasan_report+0x11b/0x160

  The buggy address belongs to the object at 0000000062270000
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 0 bytes to the right of
   allocated 2304-byte region [0000000062270000, 0000000062270900)

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

