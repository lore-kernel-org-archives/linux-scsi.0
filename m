Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165169;
	b=YNQYZw4ZFCLuZy+aO70PEGtv3c7sl9DB1pbBobO6/ZcOqEw+KRSSGlParuhjxIXI3Csl
	 eIRa2PhNa7nNU5kht7I88wEU7KA7sAavLlkfLWNJ+Bw5XXpvGb14WE1E9ScMTTeST8IJv
	 IxP33GE2ZxI6/HG/ykepZlINzqrn2a/ttqYw2mQE53VrTbw9zXMf5VMrZXXrjiK5aZmvy
	 lM0XnbK3Otvid9RcsCzVXT1hWHhlYcveHTCatNP7CYmlBe3oyhXEOBuHpU8goRMr2hH0w
	 AajwMNUZ18jFXFIDqzj8AdLiRQSkrjqnGMYHVCcukmqHo2b0G1SgxH/ffN3i05/J+fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165169;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UVAnS5Mt3D6wmh6Fgx7r4Okz4Ekubx7JX/X5qsN97TU=;
	b=YFT5e3L+AFdwqSSZZheR6ublw6vVN2eGcXLVXY53AA9X7jVwDuTw2N5Q5CnQvv8ssGVQ
	 GSQwpCyPP6HgyEBAByGrYpwsBQ6vN4iB6vA0ugcspLN8GalYOsDlETxg7bXDQR8bnGSCv
	 UWyUINzNxi7yNRWT0xZSNgD5gdmiQ8po6HFTi4UzEpGjb54vXnRvANMPAMsrDMxCE7tB/
	 JVxjAEwisZQ9qNfOk9NqZtdBawBpJPklwQFe8Cim4o+aIoiBzOBzBj3YIL6i1uRrH8N8N
	 i2R7QLsevgH+5cbrRulRqEdNFOE9GewCQi5dlP++5CBUQkwoUNCagFGmVD/lTnUgAFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=JHjeIL+F;
	arc=none smtp.remote-ip=93.77.172.68
Received: from forward104e.mail.yandex.net (forward104e.mail.yandex.net [93.77.172.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8215606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 08:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8215606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=JHjeIL+F
Received: from mail-nwsmtp-smtp-production-canary-94 (mail-nwsmtp-smtp-production-canary-94.yp-c.yandex.net)
	by forward104e.mail.yandex.net (postfix) with ESMTPS id 431CFC00CA;
	Fri, 20 Nov 2026 11:59:20 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-94 with ESMTPSA id IxXWwRHg1Ko0-OUsfX8cv;
	Fri, 20 Nov 2026 11:59:19 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1795165159; bh=UVAnS5Mt3D6wmh6Fgx7r4Okz4Ekubx7JX/X5qsN97TU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=JHjeIL+FoTH7IPclSp5t+vid7IXJb2mOxE2XS/mrGkV5jroMLy4GsVsIV8rqfiWce
	 LgDD0wE25rx0vUWMYOhfK+8oNEKl/L3UB5/7K/GRDrMU/ySPGZCtA42VlwbctTJKeY
	 BbakxAMah/AQ+8LyA3hgho/0bWZkG3Q8bkOBIqq8=
Authentication-Results: mail-nwsmtp-smtp-production-canary-94; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Karan Tilak Kumar <kartilak@cisco.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: snic: simplify snic_reset_stats_write()
Date: Fri, 20 Nov 2026 11:59:09 +0300
Message-ID: <20261120085910.630467-1-dmantipov@yandex.ru>
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

Use convenient kstrtoul_from_user() to simplify
snic_reset_stats_write().

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/scsi/snic/snic_debugfs.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index edf3e5ef28a6..b4a679d0c718 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -107,19 +107,10 @@ snic_reset_stats_write(struct file *filp,
 	struct snic_stats *stats = &snic->s_stats;
 	u64 *io_stats_p = (u64 *) &stats->io;
 	u64 *fw_stats_p = (u64 *) &stats->fw;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = '\0';
-
-	ret = kstrtoul(buf, 10, &val);
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret < 0)
 		return ret;
 
-- 
2.56.1

