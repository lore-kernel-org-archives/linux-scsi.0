Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598581DE3D6;
	Mon,  2 Dec 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733166042; cv=none; b=RUM9mSZgU7HlkZ9U29AlGszjsR1dAPVUzOJRRzWQbPcpchZ05MXz3tdRouj6uxSrJL7Ywp9QASckv4qlGTRtGa4nzxGT9tESkktR1+O6pRRxyJZpLqqJo3K9rr4spgtbjk+W+NYv8PnvJ3k1Og6AEe7yu/5D9dbHXPQR/hSGzb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733166042; c=relaxed/simple;
	bh=c+OK0c9DqudvV6de1q2cguTuEZ7rc+EiMnpII+VV+gk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hs67NXjXl1A7AW09f88xZwX1TiBYgndrSszK6ScRPpz6qQhGPpjaJ8ZtpVkIV1bP3Hwh+v30TYTp3kIl/UuVxuw+braMv2I/1Eqo8bci2WmHMwyvKxFMD8TBiJfxags1rORCD55p8GFgCko0KXvzRcv2V8FIiMi7ktuTvszH7Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=PRoJTN2/; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="PRoJTN2/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1733166037;
	bh=c+OK0c9DqudvV6de1q2cguTuEZ7rc+EiMnpII+VV+gk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PRoJTN2/WD38X6ex2MklShCZg4/Zhp1aBS6bQhM8KrWUKqsIfTO3E8JpPTZQWn4yX
	 i5z49I+Y6UsDRqwh7UMg09/F+TG8YXqtHA7xPEWaCEmYJ+9zF+wZlqRnJCyDh2xJeW
	 xqMnqBJ6ZG0AY934vDKCRdaTH8lcC+h9nHW3odGI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 02 Dec 2024 20:00:36 +0100
Subject: [PATCH 1/5] sysfs: add macro BIN_ATTR_ADMIN_WO()
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241202-sysfs-const-bin_attr-admin_wo-v1-1-f489116210bf@weissschuh.net>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Tzung-Bi Shih <tzungbi@kernel.org>, Brian Norris <briannorris@chromium.org>, 
 Julius Werner <jwerner@chromium.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev, 
 linux-scsi@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733166036; l=1326;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=c+OK0c9DqudvV6de1q2cguTuEZ7rc+EiMnpII+VV+gk=;
 b=fYgHqAdIAZatDuw8uWF0U9ElsIjChzM1qpbbyZvPW4NW8SrhhzeOs4sK7avctzwIrWksSbzAm
 jxiHNn1GgsFDhjK/57O009WAci/xOF8vWIVviFFNIlMNHEynIxZO/h2
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The macros BIN_ATTR_RO/BIN_ATTR_WO/BIN_ATTR_WR and
BIN_ATTR_ADMIN_RO/BIN_ATTR_ADMIN_RW already exist.
To complete the collection also add BIN_ATTR_ADMIN_WO.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/linux/sysfs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 0f2fcd244523f050c5286f19d4fe1846506f9214..bcae49105e54a79b7d8a610f17212cb5920c205a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -385,12 +385,18 @@ struct bin_attribute bin_attr_##_name = __BIN_ATTR_RW(_name, _size)
 #define __BIN_ATTR_ADMIN_RO(_name, _size)				\
 	__BIN_ATTR(_name, 0400, _name##_read, NULL, _size)
 
+#define __BIN_ATTR_ADMIN_WO(_name, _size)				\
+	__BIN_ATTR(_name, 0200, NULL, _name##_write, _size)
+
 #define __BIN_ATTR_ADMIN_RW(_name, _size)					\
 	__BIN_ATTR(_name, 0600, _name##_read, _name##_write, _size)
 
 #define BIN_ATTR_ADMIN_RO(_name, _size)					\
 struct bin_attribute bin_attr_##_name = __BIN_ATTR_ADMIN_RO(_name, _size)
 
+#define BIN_ATTR_ADMIN_WO(_name, _size)					\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR_ADMIN_WO(_name, _size)
+
 #define BIN_ATTR_ADMIN_RW(_name, _size)					\
 struct bin_attribute bin_attr_##_name = __BIN_ATTR_ADMIN_RW(_name, _size)
 

-- 
2.47.1

