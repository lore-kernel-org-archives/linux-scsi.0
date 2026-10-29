Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.60.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266096;
	b=o5+o6m+QlbG3aluxr1z6pNDB/p9jiBPGAlNeo7X4glRf1PSxq5uH+1CDz4h/tEgmphBD
	 YUMUQ/l81KVLqWRZZItAAjYNqCbsWsFA1RCkps5FymU12kHHAzKFJAY8QE2MUZZxjsDBM
	 NLPBOKVGcY5P09PCCqi33fDWM8qIbVdvT0hyStjHhHLII/kTazRS3cKrCL8DaCSgisxAq
	 xCU+rHrb6f1/4NICjFAeGJ4Ja/28zcnrJAH3pYYn9XFaHD1gqZRq0tHGfTWwDbtdOOeeX
	 Az/PgQnbtce6F0pYzeMJwkZ1XVND+QkZr6AniKFWs9lNEA73OqhwgaZSueRZdKbLX5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266096;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Vvag0on8WMcFKzu99BTzRbCL46QnMPNmCAiZ7SaUto8=;
	b=iOYnMeKcljQaPt1GGZhMHPIunLfBsWG1kOA/1Z2Uw8YEpU6pZ/ZAQSYU/FDrNlgQ1yuV
	 Pi8p1HiCVN3LxccFEfS5BnHhpo0pcJ8i1iUl3r5QxAzzvJeeeZV0EA6QTWcOG2kwEUIKO
	 dhyNzcktCdQqQrQ1hawSFNDAEO9DJ9BmaeFys4EyEJ6E1uuRuW0LtYCjnBYHu3gPjNrla
	 QNa7PyODlEsnOscJuBcrHTPi5traV741/LWR/vUEDr9P4g8Not94mZbQDqs2dVVRQHxc5
	 iRRvUTJOaqooolEHlifHieFtBMzU04KzRjbbRe0P9OpybGuL2c2mGLu+aek6ZTKYWqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=ATwz3qlz;
	arc=none smtp.remote-ip=51.250.60.161
Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [51.250.60.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE079606A32F;
	Thu, 29 Oct 2026 09:28:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE079606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=ATwz3qlz
Received: from mail-nwsmtp-smtp-production-main-62 (mail-nwsmtp-smtp-production-main-62.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5724:0:640:b7ee:0])
	by forward101d.mail.yandex.net (postfix) with ESMTPS id 0C0DAC011A;
	Thu, 29 Oct 2026 12:28:06 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-62 with ESMTPSA id 1SfdjsOiIiE0-xr0k4e5x;
	Thu, 29 Oct 2026 12:28:05 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1793266085; bh=Vvag0on8WMcFKzu99BTzRbCL46QnMPNmCAiZ7SaUto8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ATwz3qlzFU2SP1p0LsLFstLSNOHYzaC3aJo71c+UMYCVdIiX0KcJM2uI+/lbqQU4k
	 otNKK4MwvxYqtzI/iMkAbKO20PpKdjYiSA4D7pbJEeI9FjbfjkJck4GeJgA6/UPBlf
	 8sop1yWPw0ZGzKr8AvjMKoYHznfc76XcaFuzGE+k=
Authentication-Results: mail-nwsmtp-smtp-production-main-62; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Jens Axboe <axboe@kernel.dk>,
	Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Martin Petersen <mkp@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 1/2] scsi: define minimum CDB size
Date: Thu, 29 Oct 2026 12:26:23 +0300
Message-ID: <20261029092624.579887-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.56.0
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

According to SPC3, fixed length CDB can't be shorter
than 6 bytes, so define the convenient SCSI_MIN_CDB_SIZE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 include/scsi/scsi_proto.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 9c7d31aa6bae..c7d2c38be4b2 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -187,6 +187,7 @@
  *	SCSI command lengths
  */
 
+#define SCSI_MIN_CDB_SIZE 6
 #define SCSI_MAX_VARLEN_CDB_SIZE 260
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
-- 
2.56.0

