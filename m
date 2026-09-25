Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833DB3672A8
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361122; cv=none; b=e5aD2Izo/r02Me+ErQVJHPCrL8h7dvWLVWr8AX5yQGScYC2KcEsAdNFXYkndtrOh398Iy+t6WvHCrzgi4Vbg1yLPXCgVqLHHyzcmNMHGjiA74WMtU9rE0UB0frz8ukU6l2eXtDRsnr1sieO/3Q9KKuQ76mVMrXEkY8pFJNSu3cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361122; c=relaxed/simple;
	bh=jkBaaX3fswOzJBryZmOJCwbhehR5ja+0lhOZsnubYcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhw+Vd5FwCbLTGb9om3zm9Ia/97ApSxRZ03ja1a1txff/Af9B/vyISI2/fJR19zuNji0CEprXTJHko4QfZVj1b4Yc2vzO9TscK2rr0Mn0wskRqkWPspt+Sis0LakNgsP6vhHxmx0FZ4H8hR14S3AAwMutMHSPNfx7rsiFpwc21Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3O6VZusC; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3O6VZusC"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznY04mMz1XM5kW;
	Fri, 25 Sep 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361118; x=1792953119; bh=6jI0p
	cC10q66grU/E6Q6GBF4vhCzJyle4HKc12rXP8w=; b=3O6VZusCh07g0aOLYDEEf
	Ky+2U1n8/tL+VO37zJeIjbG84MZuWSEt4IQhDVkjR5BedJbm9VWcWNWl6fB3meyp
	KCBgZbB5iR/raExjastKmGRX9sQnYnMpzX322Z+X7LfufzqIXIQua26biPRycmJX
	oU1b6y+X+VWYzlL3GCysDg5NBG5pwj5NxJUYYWj0iPTNd4dWbI2aYVi2eruxHLKM
	vKcG56Mns+Ec/RtRJxQc+vx6/2kfb9wOdlYR/h/i81M/H5IuIR5oJL/QPtfup0BT
	f2u8dpI5C/IYwGcWG1+rC+l7nKHk+jajD/dUXyQGzqOezhzDKobDW1Kkjt3KX4C3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zFrA1ysq65zC; Fri, 25 Sep 2026 18:31:58 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznS5012z1XM5kt;
	Fri, 25 Sep 2026 18:31:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 35/54] scsi: isci: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:13 -0700
Message-ID: <bf1003a84db3f1f15e67a2f02ccfc2f0b156ef20.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/Makefile b/drivers/scsi/isci/Makefile
index da6f04cae272..00fd5c1a8d39 100644
--- a/drivers/scsi/isci/Makefile
+++ b/drivers/scsi/isci/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_ISCI) +=3D isci.o
 isci-objs :=3D init.o phy.o request.o \
 	     remote_device.o port.o \
