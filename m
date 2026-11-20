Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.250.60.161
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165307;
	b=eOKp7sfTb5I0RIwPjUGQoraFbKjM35F+d0/Jhx+6DFQoxiDCudQAnvqk9TF4450MRedb
	 HXWV63JD89VFXEZdcfZUmksSHI5q3LQm3mIVJlSzGiZ1rbXLo3tUNkQ9voCpcYQSKx1s5
	 QsM1/GRq/J/yEtLgXLyP0fqpCC2FPwy2P7il1njo1vsPguVdhzYQjKqSj2c7hbgP3zF9x
	 X0olHxOIOz1GmvnSQhH3BOOWlZ2CVugFwTz6EWn3hY1wl/f7+JUEQF1jdhlLzC702WqLy
	 71sg6JusEXbCAs7v0Sw0MeOkhz/2btnNa63lybxH+BJ3AD4t2I7xiPB3tbUdHJk+OjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165307;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jcfR/v+jHsKwQW2Dug1n1zWkuZwc2MjLTp1Z1BV+C3k=;
	b=y/RvPI1JV4QWGVzjmkWA2e3HUMi1RR/ERzzUM8e94vybu71v5ZpSo9e318LPZqQfzDdB
	 MjldrhE09tsqNrRwHQmWJ2Qg7FPJYVntDKcZzhGqqkOyEbnQuOFYELzyip39Vma3hfv5C
	 FPZkqvoM9dkj32BKGMgllo/PHDtS9aIaZrxcTOjyF5c9OhlrX18Wc/yIeXYsfxF6fcj78
	 MIoGNalMZ0p3UmD0TdjZgd1APQdxNv4DC1Q4yRyepNirVFHVx6geaeLC5KPOw8wolLxwz
	 JeXH7NZQmX+vCYfGwb177u/m2Ij0R0b/0dF3iLW5J8GiAbZtplHiACww7TdECyXtwrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=IvauYNhw;
	arc=none smtp.remote-ip=51.250.60.161
Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [51.250.60.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EB606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 09:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 729EB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=IvauYNhw
Received: from mail-nwsmtp-smtp-production-main-77 (mail-nwsmtp-smtp-production-main-77.yp-c.yandex.net)
	by forward101d.mail.yandex.net (postfix) with ESMTPS id F3CD1C007C;
	Fri, 20 Nov 2026 12:01:43 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77 with ESMTPSA id g1YdVLHge0U0-w38yal9c;
	Fri, 20 Nov 2026 12:01:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1795165303; bh=jcfR/v+jHsKwQW2Dug1n1zWkuZwc2MjLTp1Z1BV+C3k=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=IvauYNhw/gKujXRWlpROXfiUZx4V2LksxNlgQVC/jWU5lb17Cd45m7XBmet4PG5Oo
	 sr9PkOqQ7vhA8r/e0dnG1pizvKkYkX+F5bbpMe6XCWBzVRvASyYJC3AkIoXCWKDJf2
	 6SWLnh1Xpjc736hQyHjngd9IMCtciWiPmhafntL0=
Authentication-Results: mail-nwsmtp-smtp-production-main-77; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] scsi: fnic: simplify fnic_trace_ctrl_write() and fnic_reset_stats_write()
Date: Fri, 20 Nov 2026 12:01:41 +0300
Message-ID: <20261120090141.632528-1-dmantipov@yandex.ru>
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
fnic_trace_ctrl_write() and fnic_reset_stats_write().

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/scsi/fnic/fnic_debugfs.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 21b7e9666b74..b045102bbe49 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -155,21 +155,12 @@ static ssize_t fnic_trace_ctrl_write(struct file *filp,
 				  const char __user *ubuf,
 				  size_t cnt, loff_t *ppos)
 {
-	char buf[64];
 	unsigned long val;
 	int ret;
 	u8 *trace_type;
 	trace_type = (u8 *)filp->private_data;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = kstrtoul(buf, 10, &val);
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret < 0)
 		return ret;
 
@@ -514,19 +505,10 @@ static ssize_t fnic_reset_stats_write(struct file *file,
 	struct fnic_stats *stats = &fnic->fnic_stats;
 	u64 *io_stats_p = (u64 *)&stats->io_stats;
 	u64 *fw_stats_p = (u64 *)&stats->fw_stats;
-	char buf[64];
 	unsigned long val;
 	int ret;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	ret = kstrtoul(buf, 10, &val);
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret < 0)
 		return ret;
 
-- 
2.56.1

