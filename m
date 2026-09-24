Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF61371D1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290513; cv=none; b=pX8eooDxS0KG3lhyknf9cZU5l9au+oTcfuvMufVdrcdpZ+fx2MDawPrRS5tDYM5GDuHdHMYPVuW/Y8c7Mxx/0wreWVKOdTqd80zUFgXxptqaxkaHDvH6ZlpFJb6WKg6vUpkcUbY3KjgTf7rCJDfMe8sISQfpDzEsaIhLAu9jaYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290513; c=relaxed/simple;
	bh=xZL0n4mvR6+C+i+QRz3cZb2iGuXLmGHFKck5FE+Lfhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYSgeyuVV7OaN9V1mkXSRPB86sU/apRvV6hMqpFbI/gMNABHJ/+Hq1nH9i7Ydd9dAsEi8+4dIujHRDrAoLKDulU8e2duL6ota4AKr5VHVS6OD8lqTGXhVJuCxzu8sYY9a9sBEOAXXh4KOyjCHYUw4UI9506XbnXo6eummrye+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=p7iO0jtI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="p7iO0jtI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgg6mFRzlfvpK;
	Thu, 24 Sep 2026 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790290508; x=1792882509; bh=xZL0n
	4mvR6+C+i+QRz3cZb2iGuXLmGHFKck5FE+Lfhc=; b=p7iO0jtIZLapAoFjM56zQ
	lD3myc7VBRhE/fn3xX9k2XxHTw3jUh5IROPrYrUSMSwFxAlzgdS0PKt5GavzDATo
	ka6sWVWlQjz+fa1COejzI/4n+mmLTx3ltgnUlzERQheG8ZW5TyPSZHrZCmlQZzFS
	xf/phlRo3jmOdRf3GLESOM4K+k0qlBn13OdBDafARIRs1qZaXdLWVT8bRPTC2dvY
	Q2V58bYE6Q/OZtXegwFeUqL8HMepT3DkLjbZ6mrXCmlVJc7lAkMLParp1SKJQmET
	Qw6JU61zUUvqWyhx58E8uoXSaGFyzfpw/2FBCEj1H4LyTAklCvQYgid1PYjH2n7X
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MbF7bOPVfpkX; Thu, 24 Sep 2026 22:55:08 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgb1l1kzlfvpT;
	Thu, 24 Sep 2026 22:55:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 7/7] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Thu, 24 Sep 2026 15:54:43 -0700
Message-ID: <4e2a141483142d490753b07a118dacd1221294e8.1790290090.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790290089.git.bvanassche@acm.org>
References: <cover.1790290089.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis now that all lock context analysis warnings
have been fixed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca..32d816e942d6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,6 +18,7 @@ CONTEXT_ANALYSIS_constants.o :=3D y
 CONTEXT_ANALYSIS_hosts.o :=3D y
 CONTEXT_ANALYSIS_scsi.o :=3D y
 CONTEXT_ANALYSIS_scsi_common.o :=3D y
+CONTEXT_ANALYSIS_scsi_debug.o :=3D y
 CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
 CONTEXT_ANALYSIS_scsi_dh.o :=3D y
 CONTEXT_ANALYSIS_scsi_error.o :=3D y
