Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE64FB9AC;
	Wed, 16 Sep 2026 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567133; cv=none; b=rBEJ0AWiTZ8uQSfDXNYf6kLthzm/325NFLbXZhrBsgLcd8qqg5zwu02AKC6K81QegwxzU2yEuW3Q7l9G7V+dsEuYbBXsBF0J42pa47gx+BUsA6zbKfQMtbi6mecfyOeka1QvXLxTMB+F8APMO1bLKaPnFnLvvJ9ouNtmSau77V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567133; c=relaxed/simple;
	bh=ZuHk+3iBgvzUnCx0X4YC+WK70zQozxAiXKb/zVjNhmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHULic394RNPCxQnNNY0KkYZxgop5mgNKQIziz7hVUae78IIVKiFClh4dDHysfJS5QdHhGbujmSjnamJMUWC/w7ySwGkY+cnTj3dTi71M7D5bJVbiYyiF6BFrZsq8Ci0r8B3LZfulBG6/xAXAoW7EXhuTm9SwBl7k2AW09IAYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz; spf=none smtp.mailfrom=fxti.xyz; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fxti.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fxti.xyz
X-QQ-mid: esmtpsz11t1789567108t98646e29
X-QQ-Originating-IP: ROJcARv4Y+bIXQLzW9DFoU3H8vw5I/A5YjupkDBVBuc=
Received: from fxti.xyz ( [14.153.126.83])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 16 Sep 2026 21:58:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13732379124321655985
From: ZHOU Jiaxiang <me@fxti.xyz>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v4 2/2] scsi: sd_zbc: reject disks with too many zones
Date: Wed, 16 Sep 2026 21:58:22 +0800
Message-ID: <C41798AB5AA6BF2B+20260916135822.32584-3-me@fxti.xyz>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260916135822.32584-1-me@fxti.xyz>
References: <20260916135822.32584-1-me@fxti.xyz>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:fxti.xyz:qybglogicsvrgz:qybglogicsvrgz3a-1
X-QQ-XMAILINFO: MpJmQ90V4eWUopKKoN/k5TY6lu168g42MWDmEn9NdEnuXebyet7WRuM2
	7EPScU2ConyFWME4nyk9tGQC/6p9i/UbrSAEfgUiNWTAWNzbY1dTdEntGc002qtmZKjyT/X
	WXwo6WXLiwNrvHQmykUt1sMHr5TQgJJsxHlQRO32BQthk5TcQIVFko2A7hl8wMhQUfUYdJT
	Xw82z5LzuY8QArlt4cHgIiYGcEJKVPi75rCT0Lrs63zdh73JX+llL2yuxnM53LrFoMXv3Mi
	tdHIAd1KaMcNoH/ujcpmul5gGy1rxLOb9dyJw4mP3RUbT8Hor72K1iqX8JdVVSyvr3PQD54
	ACq+whFUcpDKEbd/J5mGo0l/egbhm2kXaAYAHmJcR3aZhzU+T+MTHSzDEMfhNS+V2p3durT
	KcrTYAJvRdNhhfBgxlnHd9hQWNvM9SbRqpjJbTCsQuwWi8dvrC1cB8eNdptZEyvOkIEJVUu
	8xHZQwUjLO+Lp+cxzB+/L+bnxq+ZuPvf41SWmpl/FEk4BXSH0uJAcsIpdGnl84JxRQxnXqW
	sxggJFXpypPCvo2PJTJOdxw+sdOCP4nR5fR+LiZ8yhE842FzDA6FAz30hJdpUFf8813X9nT
	ETrqHAY8DY/6a2Xq24IeoDHIpivn8jJOL+04RnBEh5y7Kw0WgfNG9ozkloaQLhXHQYOQhbE
	rmcp6lTzOdMrFRsNj8M6BgKyA8VBi1rMRsOP3x6QBBAc9HnLTl0G3EMoAjiGwEfYzFQDQXw
	YJJfA1BY1uS9WmpIr9ZkPG+IixJTT04r2Wxog61T6dzn70RNGZt+pnoVbGmActMnWeRhVBJ
	mxfc+YCOMyZu4msLmVcwZkdo9Wx57WIwMIHekBnmMDbmMC5Y1Q2bjIkdiIYOZDKElK1t2gK
	nDPsDwg5LYw2P/nJIrlfiWlo2d9MChhCe5lukx8/GumNkEFR7WXddLNv0ufXc/RYpAiwnBn
	euvEDWUzY7pOXJzryl/qq4gI9xrTJyyqxb7yvEO3u+SWxNojNZgE4QG3y
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

sd_zbc_read_zones() computes the number of zones with 64-bit
arithmetic and stores the result in the unsigned int nr_zones field
of struct zoned_disk_info, silently truncating counts that exceed 32
bits. The truncated count is later used to size per-zone resources,
while the device may still report more zones than fit.

Moreover, sd_zbc_report_zones() counts the reported zones with a
signed int zone_idx, which overflows past INT_MAX. Reject devices
reporting more than INT_MAX zones at scan time; such a device is not
realistic for any medium that exists today, and accepting it produces
inconsistent zone bookkeeping.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Signed-off-by: ZHOU Jiaxiang <me@fxti.xyz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5..456beaf2e 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -589,7 +589,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 		u8 buf[SD_BUF_SIZE])
 {
-	unsigned int nr_zones;
+	u64 nr_zones;
 	u32 zone_blocks = 0;
 	int ret;
 
@@ -621,6 +621,12 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 		goto err;
 
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
+	if (nr_zones > INT_MAX) {
+		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
+			  nr_zones);
+		ret = -EINVAL;
+		goto err;
+	}
 	sdkp->early_zone_info.nr_zones = nr_zones;
 	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
-- 
2.50.1 (Apple Git-155)

