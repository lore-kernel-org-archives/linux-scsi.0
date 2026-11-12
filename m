Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794470414;
	b=xUjbEJYAspSYc2rUX8N7pfgw2iWt4yJAqkPALNopn+9VTi9xi54nNjHpPgBnIKLdc4IM
	 sKDeVtu9VxpznP+sWiKdKrI256X74fIANSyNwZvRa+frNyg3T+t/LMIq0yAB2HeXXVbnl
	 Reb2OlYpYhbXnRUppPb+SUV8V37KVPTBNR2vh6OOn3qUx8iz2vZJUigFg2fFdO0nMl6yo
	 U3HErP4YGXeu+QiuHijzUKUw7vGd2DawvKEvTuGHUVWMfRTGZvDQ1hi0qOENq58KEG733
	 IqHAQIMVT6RGpXAWn56P19dSX4u1Mzx96YNcSQgpFIdDenxOTkL37kj5lnAm8XzW5Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470414;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:Sender:
	 X-CM-SenderInfo;
	bh=NkPtVqxeoYDZLwJbkH0y+IovzwVEjlDT+oHtCsrAZsA=;
	b=45JFpXuuSho9JNlgVzNaedcxJ8+XmPo5qinIl+D9uEAmC/5qaDI9du+UgN46LiTEMp3E
	 aOj8oBwRNkk9YrhORozjTN35PuTABeLaZIVnNHWAJnpCiE2SSS/kCH0om5X+nV9fi2xRS
	 sJjhsSCcTqi9SwCkXxFgRwicA8RcwNuUucZO6Lrf1l0jfllwsm+osowx/yhOyhtHrxS1p
	 62Ip0AtW8FLgy6sGSvsdzMzHjCZ3Laub70JRyq5p/fG/ys5qNU2DWHTk853mnob6raBNq
	 wagWnrB5Dw+SaGguFg/4T3BIBjAGgPOoKGUmq25N55tLlNw0Pz95Gwm0FIz5coXwhgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="XJ+m8Hg/";
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E6606A88A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 08:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C9E6606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XJ+m8Hg/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nk
	PtVqxeoYDZLwJbkH0y+IovzwVEjlDT+oHtCsrAZsA=; b=XJ+m8Hg/L77pakyN07
	yfqW1jHeABsZZQ0PlEA1sv3m3BQnGTQ+CrXNln791dWl7NzlCqJkCRGbN9KH7kSX
	cvT+lD2WD1B2YKWSWN8bUCt6lVpKyCkfqALrWVa4LG2sRIWu1xfbi+0oqjTtzBsF
	uxcZxm2FAoyvGqrRa/h6Xw5+k=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB3ppvXcfVqYQ7NFQ--.53224S3;
	Thu, 12 Nov 2026 15:59:20 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] scsi: lpfc: Test FC_UNLOADING in load_flag
Date: Thu, 12 Nov 2026 15:59:18 +0800
Message-Id: <20261112075919.1247605-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261112075919.1247605-1-yangxiuwei@kylinos.cn>
References: <20261112075919.1247605-1-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:QCgvCgB3ppvXcfVqYQ7NFQ--.53224S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw48Wry7tryfZFW3Zr4xZwb_yoW5uryrpa
	y8KFWUCFykJFsYgry3KF1kGFnYyw4rAay5AayDKa4xWrs7GF1DKr18GF1UZrWrXFW09FW2
	yry7Kw15Ga17tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jra93UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RiqO2r1cdjsmwAA3h

lpfc_check_unload_and_clr_rscn() tests FC_UNLOADING in vport->fc_flag.
That bit is FC_PT2PT_PLOGI. FC_UNLOADING is set only in
vport->load_flag.

Pass the vport and test load_flag.

Fixes: bf81e9cd1767 ("scsi: lpfc: Clear deferred RSCN processing flag when driver is unloading")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index fb8844c69491..7d53d3c88aa7 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -49,14 +49,14 @@
 
 /* Called to clear RSCN discovery flags when driver is unloading. */
 static bool
-lpfc_check_unload_and_clr_rscn(unsigned long *fc_flag)
+lpfc_check_unload_and_clr_rscn(struct lpfc_vport *vport)
 {
 	/* If unloading, then clear the FC_RSCN_DEFERRED flag */
-	if (test_bit(FC_UNLOADING, fc_flag)) {
-		clear_bit(FC_RSCN_DEFERRED, fc_flag);
+	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
+		clear_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 		return false;
 	}
-	return test_bit(FC_RSCN_DEFERRED, fc_flag);
+	return test_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 }
 
 /* Called to verify a rcv'ed ADISC was intended for us. */
@@ -1619,7 +1619,7 @@ lpfc_device_recov_plogi_issue(struct lpfc_vport *vport,
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
-	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
+	if (lpfc_check_unload_and_clr_rscn(vport))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding PLOGI */
@@ -1794,7 +1794,7 @@ lpfc_device_recov_adisc_issue(struct lpfc_vport *vport,
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
-	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
+	if (lpfc_check_unload_and_clr_rscn(vport))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding ADISC */
@@ -2055,7 +2055,7 @@ lpfc_device_recov_reglogin_issue(struct lpfc_vport *vport,
 				 uint32_t evt)
 {
 	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
-	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
+	if (lpfc_check_unload_and_clr_rscn(vport))
 		return ndlp->nlp_state;
 
 	ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
@@ -2366,7 +2366,7 @@ lpfc_device_recov_prli_issue(struct lpfc_vport *vport,
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
-	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
+	if (lpfc_check_unload_and_clr_rscn(vport))
 		return ndlp->nlp_state;
 
 	/* software abort outstanding PRLI */
@@ -2902,7 +2902,7 @@ lpfc_device_recov_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			   void *arg, uint32_t evt)
 {
 	/* Don't do anything that disrupts the RSCN unless lpfc is unloading. */
-	if (lpfc_check_unload_and_clr_rscn(&vport->fc_flag))
+	if (lpfc_check_unload_and_clr_rscn(vport))
 		return ndlp->nlp_state;
 
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
-- 
2.25.1

