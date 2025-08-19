Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1CB207A18
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 15:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618260; cv=none; b=HUz6U56CdHUiWwqpltOBkhi+ESQQ+zX9ljaNii33U1VqgNu9JnbtCRA/8Sdtpe91rZl1lo/XvOfvoksRMGLGZZu7VeJiW2v9lM4rc0QqOM4GzdmJbYVZfz1m6r8iWwf+0D3sXQPUYJZTjKlNXh6EPfdSGMW4AWX5njooo4q/0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618260; c=relaxed/simple;
	bh=cjXdL0tNam2+n5C7KSac4S0OrPy+0tYJuE8bw3D2lvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dfNnGSetMa8H+ApZ90yKTBO0E7klEtZ3OUOWddps8boihsr70WAw+cKhYcOUanaVzCFSvEKy1/PcEU3cpFnmjRKXSEEsmih1s7JPxt1drtfujAnNfC6wWoAEAbcGcenFZgD9X2FlIt+ZG8CL/5UVLzlcrJZ8xOSLwEoK2hF44Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jcJ+a2z6; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jcJ+a2z6"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5v5Z1ZhlzlgqVj;
	Tue, 19 Aug 2025 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1755618256; x=1758210257; bh=nb9tbnFnwaa/ZrCAAUKQ+roxc4np6fva9Kw
	zWb3OtgA=; b=jcJ+a2z6ZVVRr+pMimykvz2Im78synipZr/NFWpVNj+PEdNKWS/
	2RHAJ2mgv2oAt28Htqk4Mayxv9wKss7W7tWEkFv9PWVCMSBVZxpBnjzhIQRfvcRU
	OObXmoZauL1UvRqaOeUaIh5vmwAkYcWPSYWcEyQ7auGbG1yedUY+2TdtKXnWFGb7
	GzX6T+mtOhWzdJWZQ5nOuHSGKCaEmVv+e5ASzz0R+g6x8ruP1UBaUzXNkCkN5dl2
	8xw2Y0LbKicpNnsXbqOyvPYI04COcpustMyRW16pLj7MR1a2rZA0PcYenre9sCaV
	t6fyq+2W907Hbk31pPNrEqOurUNaC9JAYLg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nOxHqRuQP2UV; Tue, 19 Aug 2025 15:44:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5v5N1KNMzlgqVr;
	Tue, 19 Aug 2025 15:44:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ufs: core: Reduce the size of struct ufshcd_lrb
Date: Tue, 19 Aug 2025 08:43:49 -0700
Message-ID: <20250819154356.2256952-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The size of the data structures that are used in the hot path matters for
performance (IOPS). Hence this patch that reduces the size of struct
ufshcd_lrb on 64-bit systems by 16 bytes. The size of this data structure
is reduced from 152 to 136 bytes.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/ufs/ufshcd.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 81d8592fa36e..621901d13b52 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -167,13 +167,13 @@ struct ufs_pm_lvl_states {
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggreg=
ation)
+ * @req_abort_skip: skip request abort task flag
  * @issue_time_stamp: time stamp for debug purposes (CLOCK_MONOTONIC)
  * @issue_time_stamp_local_clock: time stamp for debug purposes (local_c=
lock)
  * @compl_time_stamp: time stamp for statistics (CLOCK_MONOTONIC)
  * @compl_time_stamp_local_clock: time stamp for debug purposes (local_c=
lock)
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline c=
rypto
- * @req_abort_skip: skip request abort task flag
  */
 struct ufshcd_lrb {
 	struct utp_transfer_req_desc *utr_descriptor_ptr;
@@ -193,6 +193,7 @@ struct ufshcd_lrb {
 	int task_tag;
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
+	bool req_abort_skip;
 	ktime_t issue_time_stamp;
 	u64 issue_time_stamp_local_clock;
 	ktime_t compl_time_stamp;
@@ -201,8 +202,6 @@ struct ufshcd_lrb {
 	int crypto_key_slot;
 	u64 data_unit_num;
 #endif
-
-	bool req_abort_skip;
 };
=20
 /**
