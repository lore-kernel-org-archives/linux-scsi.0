Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6CA3C4B64;
	Sat,  6 Jun 2026 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780777645; cv=none; b=pyMmussoNCZESHIZ9Y2EhOqmy/Pt2TfCs6xmE2ubnqRVCfIMczNOQm0pPreH8OQ5GfrziecWoy4VzlRe/QSFgUmUsEwRxd5COWVIVlL0E1Ov9PxNuiiPW4vED8mU1PJRMA8I8FOZxl4dlH5A10GYpDOJ+Fpjw0RpLvQJ9uYSsKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780777645; c=relaxed/simple;
	bh=REI97TkIhRniVInqZO0EIxrxjcRCipcco1/8n5eTLEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=onEwZGxNPSssOw4QezitYag51ke74TuCRdem4wDE3T1NkcCvilywUBreY2UEkE5e6ZNGbZEfnyhpqQ7oJR2UsXxvBlF76Jy3C7MQ5+09fR+0RYUUBGQMypC8ToB17biyTKEj/9r1lZQTQATkhTNe4Y7Y7ennvlUqN3b4Bw3dqtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=ngXuQet4; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="ngXuQet4"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbx-007cIc-Gl; Sat, 06 Jun 2026 22:27:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=kWjuf1g6cy43Bm0IGGIGiw7IX2e5DSbEIybtUGFTzJw=; b=ngXuQe
	t4gnreCwusAGR7PIEIjNG35xDyOA3jv3r+CJYnFGSuRA83P4EHLVKDwqBAXFa0BZDGhsVLbRc/muj
	HJLuOXpiZcA2CU/dRTC3N/06AtkzZuqjB3x60fsEF/Z7DH3N9XjFVR585Gev47oZc0GUksXmOMqr2
	3ydFtc2BRlTtXSK4fS3gyVtftx3UUD0UQuuXKV0eNkt/y1KRe4rOS5OLM+Zlygcksb68UzjQNvfBb
	Rp1h3Ont2cqd9B9a32NytUZO0xqe7m/WjknOvEVNr7wLTmPdRhUiHJDYwP+pBxiAtmXpaX6lp4SDc
	Ve19L09HViXOAPbazKd3iNt0Bigg==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wVxbw-0005Da-VU; Sat, 06 Jun 2026 22:27:17 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wVxbm-006V18-ET;
	Sat, 06 Jun 2026 22:27:06 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/aic7xxx/aic79xx_osm: Use kstrdup() instead of kmalloc() and strcpy()
Date: Sat,  6 Jun 2026 21:26:26 +0100
Message-Id: <20260606202633.5018-32-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index feb1707feb7e..97ebee94230e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1233,11 +1233,9 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	ahd_set_unit(ahd, ahd_linux_unit++);
 	ahd_unlock(ahd, &s);
 	sprintf(buf, "scsi%d", host->host_no);
-	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
-	if (new_name != NULL) {
-		strcpy(new_name, buf);
+	new_name = kstrdup(buf, GFP_ATOMIC);
+	if (new_name != NULL)
 		ahd_set_name(ahd, new_name);
-	}
 	host->unique_id = ahd->unit;
 	ahd_linux_initialize_scsi_bus(ahd);
 	ahd_intr_enable(ahd, TRUE);
-- 
2.39.5

