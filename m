Received: from ksmg01.maxima.ru (ksmg01.mt-integration.ru [81.200.124.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D7E221DA8;
	Thu, 12 Jun 2025 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749746708; cv=none; b=knuuMJDNZMPjwYYv2xC+M6XY8E26HklYOZxvXH8go2p6XcrgeFq8mFk49UXwD1snuyP1ZrHOrrBylMYldaOUwfgiEG4VJpXyL3nCM8vHFzJ/B/l69rgxN3dTXYu/uerjDQSXg3Yc+baHJmU5gil4MjXIQHKFB05kMhd7WLMS/K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749746708; c=relaxed/simple;
	bh=MOZXZ36WD3BqwUhBic6EdETWBxhSyIzABu52Hz2npgw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Pphi+Xj36tfUtNS6HUUUOw2cgsdIELkpMuOWh4fORo2xNADEhdq0irn1vNds6p7AOg1HaKTOiYigH3JOrkITr8LW4VOA5uPfJHY2nvyGxWG0d8EZrXeWv1KKFlVxagnIMq9CVd5pJtmvY/AjjwOjy1T5AlNV5Bnb1JFdbb4AVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=IQxfot/8; arc=none smtp.client-ip=81.200.124.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="IQxfot/8"
Received: from ksmg01.maxima.ru (localhost [127.0.0.1])
	by ksmg01.maxima.ru (Postfix) with ESMTP id 3AAAEC005A;
	Thu, 12 Jun 2025 19:38:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg01.maxima.ru 3AAAEC005A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1749746325; bh=Idap/fFoG4XkipCO0MFBqKEhwqzYYXaupjHesI4b544=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=IQxfot/8iBGybBLU1W/fqwhwQnToiQ+XSFg7qR04gqL778kdk/a9gPP/U6bWam0sg
	 GH/ZQgzGvAG/RLhuqPSMs2abAMGEho4uObUprPoqiHEqdkEUuMRVrHegrVtXdUdBWn
	 tFd9S95dOfcbdQssJjZ9j2G9td8M3IdsJyYdUU/OQceiHujAgys5KXHggWPSbujeEM
	 pvmrYq2hHYlqjL4yza4pu458MQ/C5mPG57T09iTAfXcFBxUenZZbrJWmkOepzUYEgj
	 tbjUMm5Xc1IDNVwBoqYny7hv+SYn0PW0yS8At/PC964b4zX4p/KiC6+vx0R3UOHKrN
	 Sb5MxswM1XXrg==
Received: from ksmg01.maxima.ru (mail.maxima.ru [81.200.124.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (not verified))
	by ksmg01.maxima.ru (Postfix) with ESMTPS;
	Thu, 12 Jun 2025 19:38:45 +0300 (MSK)
Received: from localhost.maximatelecom.ru (178.236.220.13) by
 mmail-p-exch01.mt.ru (81.200.124.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.4; Thu, 12 Jun 2025 19:38:43 +0300
From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
To: James Smart <james.smart@broadcom.com>
CC: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>, Ram Vegesna
	<ram.vegesna@broadcom.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Daniel Wagner
	<dwagner@suse.de>, <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] scsi: elx: efct: fix memory leak in efct_hw_parse_filter()
Date: Thu, 12 Jun 2025 21:35:18 +0500
Message-ID: <20250612163616.24298-1-v.shevtsov@mt-integration.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mt-exch-01.mt.ru (91.220.120.210) To mmail-p-exch01.mt.ru
 (81.200.124.61)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: v.shevtsov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 62 0.3.62 e2af3448995f5f8a7fe71abf21bb23519d0f38c3, {rep_avail}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;ksmg01.maxima.ru:7.1.1;81.200.124.61:7.1.2;mt-integration.ru:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.61
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 194027 [Jun 11 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/06/12 14:52:00 #27561045
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

strsep() modifies the address of the pointer passed to it so that it no
longer points to the original address. This means kfree() gets the wrong
pointer.

Fix this by passing unmodified pointer returned from kstrdup() to kfree().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
---
 drivers/scsi/elx/efct/efct_hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 5a5525054d71..5b079b8b7a08 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1120,7 +1120,7 @@ int
 efct_hw_parse_filter(struct efct_hw *hw, void *value)
 {
 	int rc = 0;
-	char *p = NULL;
+	char *p = NULL, *pp = NULL;
 	char *token;
 	u32 idx = 0;
 
@@ -1132,6 +1132,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 		efc_log_err(hw->os, "p is NULL\n");
 		return -ENOMEM;
 	}
+	pp = p;
 
 	idx = 0;
 	while ((token = strsep(&p, ",")) && *token) {
@@ -1144,7 +1145,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 		if (idx == ARRAY_SIZE(hw->config.filter_def))
 			break;
 	}
-	kfree(p);
+	kfree(pp);
 
 	return rc;
 }
-- 
2.49.0

