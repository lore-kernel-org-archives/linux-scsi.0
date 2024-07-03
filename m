Received: from mx1.t-argos.ru (mx1.t-argos.ru [109.73.34.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92371849EE;
	Wed,  3 Jul 2024 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.73.34.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005636; cv=none; b=Eos317FleKe83ehjtSIArWnUF3+nFTHrtRoopnzvjOPP9Kov4lGww2nIYIv/Hout1xhECQEnjmjilmEED897nCwVetjGkW1ugUnEbvwX24ULjUfUta0obJ7n5sn8Kd9sO68GwsUtm4c3Bwd3/bthXRA79TMNwc898snuXGW8kJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005636; c=relaxed/simple;
	bh=1Y3oThU8WEMtPQE4Icgyd7HJ0E3q3OIkiapFylm/uxQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Gony8sFAEbtTsvN3iqrVsyO54QSbIejZzGtoN4z92uJEk6AVs9SlnZXci8JnlDNdb1sEgIHKKi98Uv19Oz4x/97WfO7UEr0wiN+2QUiYeqEDb/AQlkcVmGVTv10KgR8CIT6RocryUDub0K1ojJ8X5mqB6kvIm94bqU/HfTeV/DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=t-argos.ru; spf=pass smtp.mailfrom=t-argos.ru; dkim=pass (2048-bit key) header.d=t-argos.ru header.i=@t-argos.ru header.b=eF/9XAEK; arc=none smtp.client-ip=109.73.34.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=t-argos.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-argos.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=t-argos.ru header.i=@t-argos.ru header.b="eF/9XAEK"
Received: from mx1.t-argos.ru (localhost [127.0.0.1])
	by mx1.t-argos.ru (Postfix) with ESMTP id 06999100005;
	Wed,  3 Jul 2024 14:20:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=t-argos.ru; s=mail;
	t=1720005614; bh=K75l601GXn6E9TrKu7conNPQF0Wy//xLGLL2PiLxfyI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=eF/9XAEKbupoEYJ5IUipM8yaJz0qzvL6IJXbrlZ6J8ItCp4TmqFbg1YZbltNX8Cdk
	 7WMVbOuSC2WCan4ab3rWFPc9psWxmHxdI4Fe2vKVYQbqRNUjengeilGkdqMYgtBRN4
	 sTrUG8ziNg1Kc43ZSjCpqYqGxtulswnI21EGBd2inukJD8NPk0doN+qw+iJc2xOXN5
	 yMbuynbg6YRV6DOTjV/29m056ErvRTJNa2tAcTQufbK9PiOHsH7dgi0JWEXwjmamT1
	 REoRYbgkXlmTc6hUAtGEnt9kftartUTUMo6lGcERJ4h1y+NiAtN+QonrEnG3l0emzo
	 OJSreh3XO73Xg==
Received: from mx1.t-argos.ru.ru (ta-mail-02.ta.t-argos.ru [172.17.13.212])
	by mx1.t-argos.ru (Postfix) with ESMTP;
	Wed,  3 Jul 2024 14:18:46 +0300 (MSK)
Received: from localhost.localdomain (172.17.215.5) by ta-mail-02
 (172.17.13.212) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 3 Jul 2024
 14:18:26 +0300
From: Aleksandr Mishin <amishin@t-argos.ru>
To: Daejun Park <daejun7.park@samsung.com>, <stable@vger.kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Aleksandr Mishin <amishin@t-argos.ru>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van Assche
	<bvanassche@acm.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, Can Guo <cang@codeaurora.org>, Bean
 Huo <beanhuo@micron.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH 6.1] scsi: ufs: ufshpb: Fix NULL deallocation in ufshpb_pre_req_mempool_destroy()
Date: Wed, 3 Jul 2024 14:17:51 +0300
Message-ID: <20240703111751.23377-1-amishin@t-argos.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ta-mail-02.ta.t-argos.ru (172.17.13.212) To ta-mail-02
 (172.17.13.212)
X-KSMG-Rule-ID: 1
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186303 [Jul 03 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: amishin@t-argos.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 21 0.3.21 ebee5449fc125b2da45f1a6a6bc2c5c0c3ad0e05, {Tracking_from_domain_doesnt_match_to}, mx1.t-argos.ru.ru:7.1.1;t-argos.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2024/07/03 07:47:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2024/07/03 06:16:00 #25818842
X-KSMG-AntiVirus-Status: Clean, skipped

No upstream commit exists for this commit.

The issue was introduced with commit 41d8a9333cc9 ("scsi: ufs: ufshpb:
Add HPB 2.0 support").

In ufshpb_pre_req_mempool_destroy() __free_page() is called only if pointer
contains NULL value.
Fix this bug by modifying check condition.

Upstream branch code has been significantly refactored and can't be
backported directly.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 41d8a9333cc9 ("scsi: ufs: ufshpb: Add HPB 2.0 support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
---
 drivers/ufs/core/ufshpb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index b7f412d0f301..c649e8a10a23 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -2120,7 +2120,7 @@ static void ufshpb_pre_req_mempool_destroy(struct ufshpb_lu *hpb)
 	for (i = 0; i < hpb->throttle_pre_req; i++) {
 		pre_req = hpb->pre_req + i;
 		bio_put(hpb->pre_req[i].bio);
-		if (!pre_req->wb.m_page)
+		if (pre_req->wb.m_page)
 			__free_page(hpb->pre_req[i].wb.m_page);
 		list_del_init(&pre_req->list_req);
 	}
-- 
2.30.2

