Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19C3537EF;
	Wed,  8 Apr 2026 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672888; cv=none; b=SSFj1a3d6E2J05kyjquyUPKMqGNtZJnqu+BGrkofrGvLDgDsv692gjFt5NY3KAnkkY1HutAL6oR+mPEX1Zj99BuL36EBpztv0ypma2g/baby4yrMW+n54PuqF1cA27X9lPMElUkXMmpSmFdjThjai6ilDqIXcETFE/ZLfACHmBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672888; c=relaxed/simple;
	bh=WlrAhmetSU9nbzxRQMFmAz3R6NqWddt1MYZws7GKfrA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IQDeW8yUZICwmnTmzMPluevQeRCrWtt4QzcQ7FmWjkr+YoTxvIfEzsfIGdQpjsBgsrUNP1D/RM/zof0pIjWDKQ5B7CBjmeT5e9Wiq9yRgzBdsgUDsZF118i+uTakhFiwwDIOCbkRSYFc5EZgNESpYOPBr8E7ctJIlGaPsGMjFhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=klz5MX83; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="klz5MX83"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1775672885;
	bh=WlrAhmetSU9nbzxRQMFmAz3R6NqWddt1MYZws7GKfrA=;
	h=From:Date:Subject:To:Cc:From;
	b=klz5MX83typSQ0TrOoxxUYLlytjxdQMna4DXOfN9M/J2Kfp2TTu7KOxRSllMlwBdu
	 SEqN1fVdgq4sjZWh8j66dTiSJGwZgIrLlYSeK5CVIS+jOpvYV6r2eqbM1Bw2jZGdyt
	 auYhC9LJyck8WI/2fJbMms5FTeVNIXtKi7ngnfNY=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Wed, 08 Apr 2026 20:28:00 +0200
Subject: [PATCH] scsi: libsas: Delete unused to_dom_device() and
 to_dev_attr()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260408-libsas-cleanup-v1-1-826325bbc0ba@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqEMAxA0atI1lOorYrMVWQWaY0akSqNiiDe3
 Y4u3+L/E4Qik8A3OyHSzsJzSMg/GfgBQ0+K22Qw2lS60LWa2AmK8hNh2BZlbYWlQ2t8XkKKlkg
 dH8+w+b2WzY3k1/8FrusGlMJweXIAAAA=
X-Change-ID: 20260408-libsas-cleanup-336a5ba32c15
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775672884; l=928;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=WlrAhmetSU9nbzxRQMFmAz3R6NqWddt1MYZws7GKfrA=;
 b=20UWkHC6Rg7slqak5rikgTqj81nGCIjDxBnuh+BnvyPpFkD+JVj5CIeJxViq4VfxxkoS8oA+5
 zNlBCkOMqQfBuqyfo2ReDzS7d7KVr+FjrB+G5ww99pg4zpBRlj0zdYC
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

These macros are unused and to_dev_attr() will conflict with an upcoming
centralization of general attribute macros.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/scsi/libsas.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e76f5744941b..163f23c92b41 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -62,10 +62,6 @@ enum discover_event {
 
 /* ---------- Expander Devices ---------- */
 
-#define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
-#define to_dev_attr(_attr)  container_of(_attr, struct domain_dev_attribute,\
-					 attr)
-
 enum routing_attribute {
 	DIRECT_ROUTING,
 	SUBTRACTIVE_ROUTING,

---
base-commit: 3036cd0d3328220a1858b1ab390be8b562774e8a
change-id: 20260408-libsas-cleanup-336a5ba32c15

Best regards,
--  
Thomas Weißschuh <linux@weissschuh.net>

