Received: from ksmg02.maxima.ru (ksmg02.maxima.ru [81.200.124.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09F255E3C;
	Fri, 28 Feb 2025 09:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740735111; cv=none; b=i3UwoAf98fWOQ8jj74ohNQTSHwuGp4kc438Msv5ygOqX7iWDv9ICeM2CfE5sWdNbX1G1NvfhS4zDGzw09wT+C3HNvYZ+7FzlwzKM9Cq73HrxPz1gPeqYfR+0SRJIaSzYgYLQj46zdzx60s90DTv4L8g7c5/dMLfgR85JfNAjwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740735111; c=relaxed/simple;
	bh=UbVjHik/5DNU77Br18BeoUx4vjSEEApwEdjBWsKa7oo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jabPQh3JFB4vjyI24EYawOG4zZnXnVd9F1QfNzFKHGSt7wPezXmFNGcoTxNS0v3dI3qTWzvdGErntah2qYXu6L062ccvvNsTr/5XM+Ovd/Imbr/GGfxgHgZTxquK3bM1my4BnFSCoLZ9Lf6ABMvoo4mQwRFFcL+fTED4RVISEo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=mGUKvLO1; arc=none smtp.client-ip=81.200.124.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="mGUKvLO1"
Received: from ksmg02.maxima.ru (localhost [127.0.0.1])
	by ksmg02.maxima.ru (Postfix) with ESMTP id D20B41E0003;
	Fri, 28 Feb 2025 12:31:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg02.maxima.ru D20B41E0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1740735095; bh=6am0DVWgQ/p6WF/F84JYY8+aR4hpn8GfUGtoqNrvHHE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=mGUKvLO1wWglDHyOXokXy5KC8UcXzA4xXBfgjzwi7J0VlzE9szmVVzCf74cYK5P3a
	 VdKLtqQ3lXenO95UIMGYE9xcsi/xxfO72XbqoImoPypWRjI1HZj4zOCCKUXQ8WSe/L
	 mbNz30viCSnitlpJ+QVf9xIHYuyLS+S1g3fPWxy/mB6cXUeArbltls6lQENVQaKsom
	 tR0YOryYb+s+pv7eq+T++yU+RUbxoLWmn8E9fq2aCg74tzdVWQbHQlnyJvTpA/jnj1
	 ed0OuuaKqVz53o3Tzz5LwH9vf5vZUOYv3G7yAj4hS2YEErnJCERikYmT6A6BnI64zb
	 eM5JMLP1riEfw==
Received: from ksmg02.maxima.ru (autodiscover.maxima.ru [81.200.124.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg02.maxima.ru (Postfix) with ESMTPS;
	Fri, 28 Feb 2025 12:31:35 +0300 (MSK)
Received: from GS-NOTE-190.mt.ru (10.0.247.99) by mmail-p-exch02.mt.ru
 (81.200.124.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1544.4; Fri, 28 Feb
 2025 12:31:32 +0300
From: Murad Masimov <m.masimov@mt-integration.ru>
To: James Smart <james.smart@broadcom.com>
CC: Ram Vegesna <ram.vegesna@broadcom.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Murad Masimov <m.masimov@mt-integration.ru>,
	<linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH] scsi: elx: efct: fix integer overflow in efct_get_stats
Date: Fri, 28 Feb 2025 12:30:55 +0300
Message-ID: <20250228093055.22-1-m.masimov@mt-integration.ru>
X-Mailer: git-send-email 2.46.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mt-exch-01.mt.ru (91.220.120.210) To mmail-p-exch02.mt.ru
 (81.200.124.62)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: m.masimov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {rep_avail}, {Tracking_from_domain_doesnt_match_to}, 81.200.124.62:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;ksmg02.maxima.ru:7.1.1;127.0.0.199:7.1.2;mt-integration.ru:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.62
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191369 [Feb 28 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/02/28 06:44:00 #27492638
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

Efct link statistics contain receive_kbyte_count and transmit_kbyte_count
values, which are converted into 4-byte words in efct_get_stats(). Result
is assigned to a variable of type u64, but the calculations are done in
u32, which can lead to integer overflow.

Integer overflow is possible because device registers are not necessarily
reset regularly, while the issue occurs when the value is over 16 GB,
which is realistically achievable.

Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
---
 drivers/scsi/elx/efct/efct_xport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index cf4dced20b8b..048f89bc9553 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -830,10 +830,10 @@ efct_get_stats(struct Scsi_Host *shost)
 		stats.stats.link_stats.crc_error_count;
 	/* mbox returns kbyte count so we need to convert to words */
 	vport->fc_host_stats.tx_words =
-		stats.stats.host_stats.transmit_kbyte_count * 256;
+		(u64)stats.stats.host_stats.transmit_kbyte_count * 256;
 	/* mbox returns kbyte count so we need to convert to words */
 	vport->fc_host_stats.rx_words =
-		stats.stats.host_stats.receive_kbyte_count * 256;
+		(u64)stats.stats.host_stats.receive_kbyte_count * 256;
 	vport->fc_host_stats.tx_frames =
 		stats.stats.host_stats.transmit_frame_count;
 	vport->fc_host_stats.rx_frames =
--
2.39.2

