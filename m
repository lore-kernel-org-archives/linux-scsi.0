Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77491DB92A;
	Mon, 16 Jun 2025 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113312; cv=none; b=ABBmhIQSDJZ2yh0jDaZCdOIN2OL5SSN5eknl0iIkWAgNR0w0YVzdXhqBigN7Z38VqF5hqb/b28QJH0NQEaORY1FoyiikemVOa90tt3syyQVTroYP4Vyj10s2YjiFWNfRFXImnEHSGvje+S6eMTTS1+0HgAuWWX28OoDRskrMPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113312; c=relaxed/simple;
	bh=YHcEf0Io7x90FXsKM9LClEIG3XWXzAJPAYSIijCa6bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OthzWaKC3Q27MLmHPIHCT7CU+lqqGdalxfJ5KVOlQ114avRgIKhHGi5wrpEZafHnvHi7ezh1vrU9cM1mQR7ldSCTHWISwgFZbxvBvc5/f4VNS8cjUW38mDozT8GOjLxoc+7up7q35UIJ26ibQGWch01k5+bc+yqyqTIL/QVck60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sbbTfqM1; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sbbTfqM1"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlFB1fmqzlgqVt;
	Mon, 16 Jun 2025 22:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113308; x=1752705309; bh=7ln/S
	4tTfu7oHvZMjNMdFWQTW89wOPPM01ySWg5IhX0=; b=sbbTfqM1kTFqqLzzO2Myh
	OuPN/3SrE0AzWccAP7G2M/tm0ddmv6tL0XPVuKw+NT3c8VyCarpClSkdSX1TRVz1
	LB2PMjlk/Ah6IEm6e4Ao70Hptx3s8SgOK3pOLpiDKviR3dbdYMOEipiFq6eXM9Kl
	OC87t3Cz6HUIKS0ElFOoBwDA/+M/h5pRzoD7GIyCJN1DzmCqFe7mU/leu16lltW5
	oggZiqIhruiNvSWskocVbPSMEr73BAcgVo5pjTD86jKGT52BxvTUfjWBx2AldRM0
	wLW9baY8cyjYxZFEkmuShiPUzycIFyNUQVZPv2QtFJ+WpICpNeUqwcpSYI3ihouR
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id A5F1wrgUlpJj; Mon, 16 Jun 2025 22:35:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlF11PCKzlgqVx;
	Mon, 16 Jun 2025 22:35:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v18 12/12] scsi: ufs: Inform the block layer about write ordering
Date: Mon, 16 Jun 2025 15:33:12 -0700
Message-ID: <20250616223312.1607638-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From the UFSHCI 4.0 specification, about the MCQ mode:
"Command Submission
1. Host SW writes an Entry to SQ
2. Host SW updates SQ doorbell tail pointer

Command Processing
3. After fetching the Entry, Host Controller updates SQ doorbell head
   pointer
4. Host controller sends COMMAND UPIU to UFS device"

In other words, in MCQ mode, UFS controllers are required to forward
commands to the UFS device in the order these commands have been
received from the host.

This patch improves performance as follows on a test setup with UFSHCI
4.0 controller:
- With the mq-deadline scheduler: 2.0x more IOPS for small writes.
- When not using an I/O scheduler compared to using mq-deadline with
  zone locking: 2.3x more IOPS for small writes.

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4410e7d93b7d..340db59b7675 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5281,6 +5281,12 @@ static int ufshcd_sdev_configure(struct scsi_devic=
e *sdev,
 	struct ufs_hba *hba =3D shost_priv(sdev->host);
 	struct request_queue *q =3D sdev->request_queue;
=20
+	/*
+	 * The write order is preserved per MCQ. Without MCQ, auto-hibernation
+	 * may cause write reordering that results in unaligned write errors.
+	 */
+	lim->driver_preserves_write_order =3D hba->mcq_enabled;
+
 	lim->dma_pad_mask =3D PRDT_DATA_BYTE_COUNT_PAD - 1;
=20
 	/*
