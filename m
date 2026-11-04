Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758433;
	b=hhEQ6btfRYwqwulLREnXahpus9YbXJmpNU1rptMCvkM3SctFDlLYCJjFtoYaxpy4FZ0i
	 K4C0kKv8NABTK/7dXzuS3WFxq1d+EU52VnyeHvCXGBE/duWQ09DEQJhp3hsXZXcLS3jkc
	 djoOuhN+MXOWsatmm+m9S7EwvfV8AvPYbQkm+thOVzuK5PGZ7HuPFQW1IecSuWCETZ1WA
	 fnbQiHOs/QHhSml5/zzYnTABaKTDydxwjXX9dIikUxb+SmGHRngcPHG0mxdceFGSoxh7j
	 zWTDkMi3BGfbLRCinGjjHaNwInzE4HlvWpAWvn7YgBzw/5J8GPSwnMaHyHAVTjW8wfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758433;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=QtHPL2rdtixoG5Bb8juTqkzbpQDCMlIlUahmhdeFLog=;
	b=VckBnJMzzcqZ9Wf4SPsepId8bPvY1vN8KX2cCq4MAlPJ+NfQEjw2r42387+9spZBj65x
	 x5lOkAiv+KomZF5sSfLKjR/e1lu3kRBL1JpB+xlhdTI5lOdny1OlihSJHS1YNVroLeErv
	 +aeoIo+/wk1P0Y97drX1ErwJcgii/5CAf4ZZlfS6LTvXx5lwAz7+NBxi9wEZb5bs+R8iE
	 s656rsQRO2N+SNypfYZ0u3jh+RJTfTQ6s/NhAbtJ6/JYUn/bK9AZ56iGBbVao67Y/71rU
	 M77XVg0WIZv11NvKG+P9FJj88o3QQ+VArt0h64Q0hLsecAHGEzM/dQxpbktAtKEbJ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27EC606A329;
	Wed,  4 Nov 2026 02:13:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27EC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACXvvjalOpqnnM+AA--.9637S2;
	Wed, 04 Nov 2026 10:13:46 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: free the HW IO when SRRS submission fails
Date: Wed,  4 Nov 2026 02:13:55 +0000
Message-Id: <20261104021355.1467759-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:qwCowACXvvjalOpqnnM+AA--.9637S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WryxGw4fZw4kXrykur1Dtrb_yoW8tF47pF
	ZakryY9as8tr4xG39rJw40qF1Yqa1kKrZrGryag3y5uFyfur4YqFZ8JryxurZYkry8u3y2
	gF4DAFnxGF48XFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
	ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x07b5lk3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwMBA2rqZFi3QAAAsN

efct_els_hw_srrs_send() allocates a hardware IO and only hands it over to
the completion callback once the WQE has been written to the work queue.

The paths that bail out before the WQE is submitted - hardware not
active, WQE build failure - leave the IO allocated: its reference is
never dropped and it never returns to the free list.

Release the IO before returning from those paths.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/elx/efct/efct_hw.c | 38 ++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index b79c6a7ea791..2b0c75801496 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2715,6 +2715,7 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
 	if (hw->state != EFCT_HW_STATE_ACTIVE) {
 		efc_log_debug(hw->os,
 			      "cannot send SRRS, HW state=%d\n", hw->state);
+		efct_hw_io_free(hw, hio);
 		return -EIO;
 	}
 
@@ -2820,24 +2821,27 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
 		rc = -EIO;
 	}
 
-	if (rc == 0) {
-		hio->xbusy = true;
+	if (rc) {
+		efct_hw_io_free(hw, hio);
+		return rc;
+	}
 
-		/*
-		 * Add IO to active io wqe list before submitting, in case the
-		 * wcqe processing preempts this thread.
-		 */
-		hio->wq->use_count++;
-		rc = efct_hw_wq_write(hio->wq, &hio->wqe);
-		if (rc >= 0) {
-			/* non-negative return is success */
-			rc = 0;
-		} else {
-			/* failed to write wqe, remove from active wqe list */
-			efc_log_err(hw->os,
-				    "sli_queue_write failed: %d\n", rc);
-			hio->xbusy = false;
-		}
+	hio->xbusy = true;
+
+	/*
+	 * Add IO to active io wqe list before submitting, in case the
+	 * wcqe processing preempts this thread.
+	 */
+	hio->wq->use_count++;
+	rc = efct_hw_wq_write(hio->wq, &hio->wqe);
+	if (rc >= 0) {
+		/* non-negative return is success */
+		rc = 0;
+	} else {
+		/* failed to write wqe, remove from active wqe list */
+		efc_log_err(hw->os,
+			    "sli_queue_write failed: %d\n", rc);
+		hio->xbusy = false;
 	}
 
 	return rc;
-- 
2.34.1

