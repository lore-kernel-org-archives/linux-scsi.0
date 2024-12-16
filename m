Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C3204F66;
	Mon, 16 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348563; cv=none; b=bl/ZhhCtHxNuJnnHh8AVHD/a5feAFd96dCs2nzhRWQRRM/G37uMS84CshuIwGXP9cm7MIshIt0c/qmKvbVcSXnTdvWhMv9nrVc/1ODVTglAcZOmB4qZ9zMmSRMwwYB6/SsOgDaRoFFxnoouiNgSu190ceM0PtA08Hwbh+IC8EP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348563; c=relaxed/simple;
	bh=0zAR1Zgw045+wqZMsF16+d7FFPr4+tRVMSP1LbUeDkQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RicB43d3X3lAizq50wf9aaUop7EVb/8Lve9ByuEHSYR95in7epa4FkdiF8pQ4u53K2MIFM0XcXTgTTVQiQ64AhinlA7HzqewxQyIxtEGRr6LS3Dliwqo3yNi83N5AfWl9f6gcU7I9L+ItnW9sw7PDPR5YPsuiyUnB4EpxljtDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=IfQGNQzq; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="IfQGNQzq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=0zAR1Zgw045+wqZMsF16+d7FFPr4+tRVMSP1LbUeDkQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IfQGNQzq3sv2I6lR7Bm4wIXf4JexmJ6Orz/ItN7wWI5NG1ehxVi8OJiDmBs3XloXw
	 SpKa9d0FdcuKXuLbHQ0vgALExfPumXMeWpgHDlTMkDWRfAvHcYQabjxC0qb4cyffv7
	 Tz2Rcr8yjxSC1drhVomftVoQCIvwhT/jsZ2yCP28=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:16 +0100
Subject: [PATCH 09/11] scsi: qedi: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-9-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=802;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=0zAR1Zgw045+wqZMsF16+d7FFPr4+tRVMSP1LbUeDkQ=;
 b=1W6RZ9BA9Dsc+CBzANf4Tht8N5AIdCyB6NGgVKB+IsTA27eXPneFAttchQy0ojXOOZQZt6vds
 A+mCsUddQeNDsjzwyDljmAV7qogymPgp/ZcoHbiY7G+vm89CQ7DGCvg
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/qedi/qedi_dbg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
index fdda12ef13b0fd1f69103a28b8a9e8641281e151..5a1ec45421834bfed5f7d7b87391ae8cc4905c6e 100644
--- a/drivers/scsi/qedi/qedi_dbg.h
+++ b/drivers/scsi/qedi/qedi_dbg.h
@@ -91,7 +91,7 @@ struct Scsi_Host;
 
 struct sysfs_bin_attrs {
 	char *name;
-	struct bin_attribute *attr;
+	const struct bin_attribute *attr;
 };
 
 int qedi_create_sysfs_attr(struct Scsi_Host *shost,

-- 
2.47.1

