Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.60.162
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164988;
	b=GpGPqSf0vM0FOD4ZTrIzHMRmwnvdQwODrtZYBqwpamGLD/auDJ/X17q1w4in6Tef36Gg
	 a53OaImdsBMr/PWYhtRsm34Ro18XYcSUOWygsxm9KT5FzrQMcCQDacNJzE1JUIAL5KnIL
	 Mu/2+U/KGl1ufd+a/4MHkVAb2hGujNGDp4VJ2PtzxYIJ/gP0m0LL9lmK7Hyw9ObPT1r0v
	 oLCmIkfEASf4kFfqb1ynYbdH76IfRwn1a5wiV2jXOzst7/8Pc3Dlzkioe411VT/Simy0q
	 YFaODplogiqZh0OGKzG1Je1RI5eCzT8RsZgErPvVDSIAm28Qp38G4t95jxAUmIBKx3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164988;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tJ7O5wJqr5p7EZZFrLDZ9Y7x5QtJZc8J39Aq3LnXDLg=;
	b=2pttuzdXoYGajY1qT0bH798Hih2L2l2Di76OYeDrdEi2sg7D7E/E51hFL/RGqR3YCFJ1
	 ecUYIDuJVXvLW8p/BSU0Q3BNR6SwdtuU8By203TEKI8yknaeS7pQ465GIBMrNBZjQmvFW
	 Fw9lV7PmmBez/FITTNQ+kwOkygpQIe1TdeDA2nkudMVuhR0auc0jkxfX8T96PKBeTZkS8
	 6fyivEUj1P3SZVtFEcR8mVpB/1mj26AGmD4cwghRGFjDF5xZyHVGWGlrMhUVs2qDB1tH3
	 wrSnGn5n5qkMhp+vg6/eh4rLboPzvTa9IpEwdAjKqUKZ1dqpZeIMfmQMGZ0YMQogO6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=XBAxdPb2;
	arc=none smtp.remote-ip=51.250.60.162
Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [51.250.60.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BCA606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 08:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3BCA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=XBAxdPb2
Received: from mail-nwsmtp-smtp-production-main-88 (mail-nwsmtp-smtp-production-main-88.yp-c.yandex.net)
	by forward102d.mail.yandex.net (postfix) with ESMTPS id 71BC1C00D8;
	Fri, 20 Nov 2026 11:56:17 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-88 with ESMTPSA id FuXbxfJmfqM0-rFaYI7QT;
	Fri, 20 Nov 2026 11:56:16 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1795164976; bh=tJ7O5wJqr5p7EZZFrLDZ9Y7x5QtJZc8J39Aq3LnXDLg=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=XBAxdPb2F0vUDYbntoVBal5MvbTKEieV60f/+NAMxr5vhVB8dUrhLNIIZZunWh3Qz
	 U+4bVCEoLKHtxIqBL6Fcybnu1/B7ThG0wQsaIzq3ymJN/KZMD4+TTTDGm3brqwJQuC
	 8ZUIxl3ix6z9W+8FFPGZMaW0TWK9Ks8QL4fWWFL0=
Authentication-Results: mail-nwsmtp-smtp-production-main-88; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Can Guo <can.guo@oss.qualcomm.com>,
	linux-scsi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: ufs: core: simplify ufs_saved_err_write()
Date: Fri, 20 Nov 2026 11:56:03 +0300
Message-ID: <20261120085603.628107-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.56.1
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

Use convenient kstrtoint_from_user() to simplify ufs_saved_err_write().

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/ufs/core/ufs-debugfs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 44a1a9692324..2fa0996acda5 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -172,14 +172,9 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
 {
 	struct ufs_debugfs_attr *attr = file->f_inode->i_private;
 	struct ufs_hba *hba = hba_from_file(file);
-	char val_str[16] = { };
 	int val, ret;
 
-	if (count >= sizeof(val_str))
-		return -EINVAL;
-	if (copy_from_user(val_str, buf, count))
-		return -EFAULT;
-	ret = kstrtoint(val_str, 0, &val);
+	ret = kstrtoint_from_user(buf, count, 0, &val);
 	if (ret < 0)
 		return ret;
 
-- 
2.56.1

