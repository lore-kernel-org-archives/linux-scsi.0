Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB43FF1D9
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805090; cv=none; b=Wl3mSWoriGAaQARFzafQmh7hpHjhv1mAfIuKHpcvIOnY9dDkyUNib9mD30fqHZyLzS8jPnygkw7Bi+q1bH6033SECDyrpcpfY+iCq345Sfv1nppK/GZpUnM+szStW9kC8x9mt7NUG0OGob3KxAkTzSEkEiFemqaCR/RUnJKZJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805090; c=relaxed/simple;
	bh=Ix4gGdcmIUtHIAGt5LB/LnKcTd8cRB2hDL7DnBkFdMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fS1m6fnG1aLHSiqF6MWLwGDXQcBRvJRGIRKr9bmgImmcPxiN3LHT5S+4Ey0WbRvN6KCvl9QzrX/aANoDSnNeMdfi4NAd3gk4m6EdENj0d6kFvoApPA4gUtSBTgav+6jjU4pSZucoIbwzBfWRw2tQnGDdrDHMO6Q+iGH0ZQ2lVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=ADpu5IQa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="ADpu5IQa"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49041fb8c23so34296205e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779805086; x=1780409886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dby4bTclHz03p3r+UXN2janGddikm0fNCaCLphFWWE=;
        b=ADpu5IQa9D7AbE0/0xGEIumv36KE/YMDWfhciwmT7CcDwmEvxXFzJ5iR/5NIv3o4iI
         Dr8KHtyVcS9TwIYZgZXq6hzWRcBVWadHByHcsgTGA+Me+ppuuwTsATPhng62ikBgpfd9
         DDNgwnFrcfnmy8SsfS2kCcBZeiRc/y5BrcHTOQDtsIuufEfc8oHGPoGbTcPrcxNMmB+/
         fnxNbnQr1O763v7wKxyfOQfaJu4n2dKbf8lcE4HYJZsWjS11AvtRkMKnf3bMAf1191q3
         7t4bjZ/QElCcGrStHfHMA0asvjZvtzV4hyrsDBaFb9VTaxAEibAyMQhz7Z6wEdRkzZSP
         0kig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805086; x=1780409886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/dby4bTclHz03p3r+UXN2janGddikm0fNCaCLphFWWE=;
        b=lZWyMkr2funoanWYzpayFeiACXcceiUt+3rx6+onIpiiiZ7gLOZ+6CTsewhrMMaqwD
         oeTckdydvXfxYdIvtrYPi1mJtDRjGIaIjz9lGwDeF2jJlsilR69LDo68m6IVFsUcltwo
         ZylK4JJW+44Pl7suPVI/z0zWm4bOMg9eOcQslvJ7zSpQP4mDe7K+f7uVY34xDMsb9SGa
         cGda69fQuXDeSrd+fSPdwNoVDltfJXwqPgjCThQ4aGBaW6PgaIZ3ZnGVJR0qwPIoe4Od
         Y34tA1vUOI3z+o45gy4AOTGbyR9CbOkwWRU1oERGtfLtHssWWfi1n72bvJBtf/NCicfE
         JClg==
X-Gm-Message-State: AOJu0Yy3vpWjGMtv5/DLfGLVO7aJWIZkC3QX+AOPA+c34sQ45L4zZjbH
	ZQmsAZGbBmn7GVd6DmvYqZAiCBXlaFy70bfq/jlqIgGsSspPbPbAq47iomkmi4MczaU=
X-Gm-Gg: Acq92OFm6EZ4K4mauxvFm6Tfz9GdWOeKSqhCSycR5XkCOPE2z69Jo3HzK73OQse4WjA
	p8slUQ7ODLfncxDiSHi/74Vosp4TVcZwPCslkCVB2q227Vir0OR1IFNQzfRg358C3fHveiITyi0
	ohpCzJ3sDmftfVcCU4G8gyVnCW7Zykvew4zh/Tq1zX7XqL7nbraBYcittzWtkooO7pCsb1Q0fz1
	vFpzCCv8VDqEh+vOCRuRwIYd3v+chv8knaOR9Nv/6f+rfuPfO2tITiSpKzhIAMdfN4iI7MJbP9+
	Bz6QNi1FzytTG5uyzGX3/UnFqNz6IUjMy72uC7+XegTuYbnmHDjkU6X4swxIzxsnxavTkkNJC/C
	eo27UdCcJUZkM2BtfFp/2b4R77PlhbJEGy6BZhc2z4p1EQQ7Atrh537GDOXFXmQtQzC3Cde6a9n
	+UCsuoFN7R2tFdO9zTimq9+J9X9zqlmQmPjU1jAMVPD8nATko1Uw6Gy1/HjxI/Mh2gVAsLUhKgc
	YIuTNZh74enleE=
X-Received: by 2002:a05:600c:8b86:b0:490:58f4:ba2f with SMTP id 5b1f17b1804b1-49058f4bb2fmr215395865e9.23.1779805086603;
        Tue, 26 May 2026 07:18:06 -0700 (PDT)
Received: from localhost (p200300f65f47db04a716d2bdeddb4813.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a716:d2bd:eddb:4813])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49042ce923asm110275375e9.35.2026.05.26.07.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:18:06 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>
Subject: [PATCH v1 7/8] scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr
Date: Tue, 26 May 2026 16:17:33 +0200
Message-ID:  <b7f3b4bfa5daabf8a3043177341b8dbb4e4d980e.1779803053.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2055; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=Ix4gGdcmIUtHIAGt5LB/LnKcTd8cRB2hDL7DnBkFdMo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqFauHUarOpMGYf1Rjh0RTIsmazNAMEXK0zgF/y G7Zt03BuSeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCahWrhwAKCRCPgPtYfRL+ Tn0DB/46adco11LpUmr3pq6WowYZpIZuSwC3qKUC6/tp8YLIb5d5Q/4eWjjHCOU5kxUfDM5i2H8 24BgnkxRLjvbGeleCWOPr7KrAty/IpYp8gSPyYKJPrQxHGwe7zbktu0xeqiChrf/RxSLf9LVkhY UY1ialBjaoHfwXc9wHIOiYvTYbOnPuob7B891AhRLa4rJ9XhVcSnOe2VZM9aBVhqvZxIzqVWPtm cox3hbRzhqUyMmLZ5N4siHl8zpV9Bg99X6DdRRMrLuYB0z71/6vCatNsJ6HS4HuSRGu9AhLz+Pp AQIWXdQO/NY1iY97vZt9WNY8BTsKMsy2kixRxd+TnN5oslcL
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Usage of .driver_data_ptr allows to drop several casts. A nice upside of
that is that now the constness of the linked structures is kept and the
compiler warns about zdd missing a const. So add this missing const, too.

While touching the zorro_device_id array, drop an unneeded explicit zero
in the list terminator.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/scsi/zorro7xx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 1f74586f0428..21c769dc1ecb 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -50,23 +50,23 @@ static struct zorro_driver_data {
 static struct zorro_device_id zorro7xx_zorro_tbl[] = {
 	{
 		.id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS,
-		.driver_data = (unsigned long)&zorro7xx_driver_data[0],
+		.driver_data_ptr = &zorro7xx_driver_data[0],
 	},
 	{
 		.id = ZORRO_PROD_MACROSYSTEMS_WARP_ENGINE_40xx,
-		.driver_data = (unsigned long)&zorro7xx_driver_data[1],
+		.driver_data_ptr = &zorro7xx_driver_data[1],
 	},
 	{
 		.id = ZORRO_PROD_CBM_A4091_1,
-		.driver_data = (unsigned long)&zorro7xx_driver_data[2],
+		.driver_data_ptr = &zorro7xx_driver_data[2],
 	},
 	{
 		.id = ZORRO_PROD_CBM_A4091_2,
-		.driver_data = (unsigned long)&zorro7xx_driver_data[2],
+		.driver_data_ptr = &zorro7xx_driver_data[2],
 	},
 	{
 		.id = ZORRO_PROD_GVP_GFORCE_040_060,
-		.driver_data = (unsigned long)&zorro7xx_driver_data[3],
+		.driver_data_ptr = &zorro7xx_driver_data[3],
 	},
 	{ }
 };
@@ -77,11 +77,11 @@ static int zorro7xx_init_one(struct zorro_dev *z,
 {
 	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
-	struct zorro_driver_data *zdd;
+	const struct zorro_driver_data *zdd;
 	unsigned long board, ioaddr;
 
 	board = zorro_resource_start(z);
-	zdd = (struct zorro_driver_data *)ent->driver_data;
+	zdd = ent->driver_data_ptr;
 
 	if (zdd->absolute) {
 		ioaddr = zdd->offset;
-- 
2.47.3

