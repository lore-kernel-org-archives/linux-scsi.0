Received: from bg5.exmail.qq.com (bg5.exmail.qq.com [43.155.80.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6689C21773F;
	Tue, 16 Dec 2025 06:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.80.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765864970; cv=none; b=KtXAIQtT1P8vAcgTlydxp1f7rOw2DQ9dkV+6mbo3KT2z2qeahrrma8kJiLhhd7O7/jhbYh0HsUH25kyN7SZAOQMWH6VBnlurq8TjgDXu8YtaUKaWizTuBW407P/toyca1tl0ga1zJO7SmZZhsdoXzygJHPq0hh+7CpVIZQZyZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765864970; c=relaxed/simple;
	bh=N2VQ8Y8Ux1uugXkHDccXpplJB5yQXMPyxj6+3dhf67k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mQOJfah66RPKmpd4FyqqHCN3nYW0bXjJngI25h3P9GkYx4d5ePOFw4C5SAliYeIGNfUdTxJmb+MmKVNoTFtH/cGQ5/Cg4Wu7ItCGhjX3V6D30Jb8eRzda44QaAUz6eyTMlDJjVCaKDWsw1gGuSob7/plZs3MLhQA5GQl5nimEg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com; spf=pass smtp.mailfrom=darknavy.com; dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b=pVMi30sS; arc=none smtp.client-ip=43.155.80.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darknavy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b="pVMi30sS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darknavy.com;
	s=litx2311; t=1765864933;
	bh=PI+RBkWbT+GPFjFq6ycWvVKAYFCdUYVWezU7LCL0Yzc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=pVMi30sSWTTbvOEnD2VZG2a+NyAvBhKpPQqHkgFFpCcqSkJkbUrj7ln1/lby0cXfk
	 9bB399X/NwzeLxyXhHp7H/7wP72HfuuUZIXgBaAjQRJfWVQUodmoArydi2ymhiVJ61
	 9mYnqc2tDeC+lhctdy59vOk3X2Bh9uSvJaji1ydM=
X-QQ-mid: esmtpsz20t1765864931tde56b994
X-QQ-Originating-IP: b3IkCJu3XoBH+qkLJL3GTMoetrZr1qL8ustzfbn+JYw=
Received: from localhost.localdomain ( [223.166.168.213])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 16 Dec 2025 14:02:07 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8007578203522099435
EX-QQ-RecipientCnt: 8
From: Shipei Qu <qu@darknavy.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Shipei Qu <qu@darknavy.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DARKNAVY <vr@darknavy.com>
Subject: [PATCH v2] scsi: mptbase: bounds-check req_idx in reply paths
Date: Tue, 16 Dec 2025 14:01:55 +0800
Message-Id: <20251216060156.41320-3-qu@darknavy.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:darknavy.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NyuCELaSACDheqndvjvXVQNB4/riUI+EDW3ZxU50Sgq79p0Cz+/Xc+Qr
	9eTTQEbMtPYSn/iINsVvSM9tsNfoaWzswx9EZSGJXMPEHYlVV0jkftYPGYjqMyAp9ZSaxEF
	niyxZCI92mu86BJIe78mVKnTTSxOPO75kboREv2RKhgzNXsK+sI8isrHMLKtb2SyPyl0eOn
	qr2grD8vMtaw7PS4OIdwFWUhGGkMNGgPLiwbK0QWJl2KEef/TF3UqzIfF1W2myN8Eycqsji
	3ywzL/VQsc9RPNQxBaxY4/fAQyC08ejCv2eGwQqcKAzg23V826rgWHhICzMS64itUezLNvK
	YtV/VgmZGhM4ftIcc0aJI3buOWdtBhQgRi/DAG5eMMb2E53JLyF5z1HNFljPgGSGI+jnBCS
	nYHT47IXauThmqCM3B7sKLR3fg0eAF0990pRHIhoG/Qd0nsmU+fSFsateJtVoVraXzqS7XJ
	Td2/fBPHj5J9jKlz0iDRdnjT6orpKRNUIgKSHyF1yX2ZNltQxZCra/SOtJo9DpUTJ6KHeWl
	zmcn55+HgJ8aFF/r4R551gv/u5K1wdyqdK+pJGa4E/TvvDDhnBxtpvPY91W0BzDfJlNTGO+
	NQmdt9NGWeCbYOv0RLEki2CTnrJQP7+qWAw7zxR4o+PM6A3UQ++wgH5Q77nzS6l925hVDyl
	+sJkJPfg6jGGPVByp+TtzeCnJp+W3Fjk5hk15IgrfgSXqNmXBpxSKAWTb9WZsoBK6E/zTpZ
	wLheKULDmwYx8Xq6S+lLTKEDVqmwzkzUV8Mhcoaf3LwC/SqyRarz4dbrZ+SbKU85CMbbnLL
	wJBuiJZk3pOFCQU8Sxi9bkFhozEgHgrPrUU+gHw/6xy7n+2RBdGgC7546PY6Aq/rUSIzri6
	KspQGkbS39k+VzkMLf8shAPTzdHqjDg/H96J9/A5YqanYK3cVsQXJ5DLBVVqZs76HuEHk+N
	EVsslpibaz8R4tmNWrnnodJNTKDznTUrXCGjAvYbkDwmfXqbOWGd03iJzkVnnDhw3CAdDrz
	6kuXU9GIoE+QV7X2XjUzUtxbg9MM0=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

Hi,

resending with a correctly generated diff (the previous email had a malformed
patch header). The patch content is unchanged.

In the Fusion MPT base driver, both the normal and turbo reply paths trust a
request index (req_idx) provided by the IOC and use it in MPT_INDEX_2_MFPTR()
without validating it against ioc->req_depth. A bogus index can cause the
driver to compute a request frame pointer outside the allocated req_frames pool
and pass it to protocol callbacks.

In practice, a malicious PCIe or Thunderbolt-attached device that emulates a
supported controller and returns crafted reply contexts can drive the driver
out of bounds in this way.

This affects several devices supported by mpt* drivers and the code is enabled
in distribution kernels such as Ubuntu. The same pattern is present in current
mainline kernels.

This issue was first reported through security@kernel.org. The kernel security
team considered it a normal robustness bug (controllers are assumed to be
trusted from the host's point of view) and asked us to send fixes to the
relevant development lists. The patch below adds simple bounds checks before
converting req_idx into a frame pointer.

Reported-by: DARKNAVY (@DarkNavyOrg) <vr@darknavy.com>
Signed-off-by: Shipei Qu <qu@darknavy.com>
---
 drivers/message/fusion/mptbase.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index e60a8d394..58df10fb1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -453,6 +453,12 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 	switch (pa >> MPI_CONTEXT_REPLY_TYPE_SHIFT) {
 	case MPI_CONTEXT_REPLY_TYPE_SCSI_INIT:
 		req_idx = pa & 0x0000FFFF;
+		if (req_idx >= ioc->req_depth) {
+			printk(MYIOC_s_WARN_FMT
+			       "TURBO reply: req_idx %u out of range (depth %u)\n",
+			       ioc->name, req_idx, ioc->req_depth);
+			return;
+		}
 		cb_idx = (pa & 0x00FF0000) >> 16;
 		mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 		break;
@@ -469,6 +475,12 @@ mpt_turbo_reply(MPT_ADAPTER *ioc, u32 pa)
 		 */
 		if ((pa & 0x58000000) == 0x58000000) {
 			req_idx = pa & 0x0000FFFF;
+			if (req_idx >= ioc->req_depth) {
+				printk(MYIOC_s_WARN_FMT
+				       "LAN TURBO reply: req_idx %u out of range (depth %u)\n",
+				       ioc->name, req_idx, ioc->req_depth);
+				return;
+			}
 			mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 			mpt_free_msg_frame(ioc, mf);
 			mb();
@@ -527,6 +539,13 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	req_idx = le16_to_cpu(mr->u.frame.hwhdr.msgctxu.fld.req_idx);
 	cb_idx = mr->u.frame.hwhdr.msgctxu.fld.cb_idx;
+	if (req_idx >= ioc->req_depth) {
+		printk(MYIOC_s_WARN_FMT
+		       "reply: req_idx %u out of range (depth %u)\n",
+		       ioc->name, req_idx, ioc->req_depth);
+		freeme = 0;
+		goto out;
+	}
 	mf = MPT_INDEX_2_MFPTR(ioc, req_idx);
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Got non-TURBO reply=%p req_idx=%x cb_idx=%x Function=%x\n",
-- 
2.45.1
