Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7D737D104
	for <linux-scsi@vger.kernel.org>; Sun, 17 May 2026 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779038176; cv=none; b=ZQPGjZHSlDpF9+g5PUYukdSF4ss7WtlnfsPX5HR3oNMbfIlOYgr7dSaXPxoQzJadvcv6qp06mi5S635rfrvwKOGZ7nv1SnT6QNU017/ByznA2tkxi4vDoR08NqGoR68zkIiQ9SeAEMY84ZAhrbLDsasnBSMCkfHs6Ca7AgS3tNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779038176; c=relaxed/simple;
	bh=9rY44sbWnpihJIsKmAD6U7luIBD/yOhdo1SUcv8mbug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qR3xWBChZ81sasXFQcbBQ5vQpq85KYoDM9qq20mlgz0jH7MnQ4ydA0LubYSDtKGcgpwxBduv0YWQYVIUx29j2LLNMlJCITapk2a/DR0qgLceGsdzfwIre3Ys1X/GQmEsMUhIAYRbjzGUprf8GamgQj79SBn6qmQSFDshXOkChXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tcsb/GXH; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tcsb/GXH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779038172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h9Chlt+pE3mYXTXx/yV/HXgRvRP3IFwbvwyTB93cD+s=;
	b=tcsb/GXHq8gMO2gh2PEl4xg7zUK7awwB2erHio4Hnez+YkcgH8GVnrp5t3YqEFNT9p74gW
	nNZDIuvNEqxi11Z+TdLGUFh0Lp8gb2KF+50HCnKDlDeudEc4HkaDZi9lsTFqMv5hXbMtBs
	K/sUprq7l6q++RPMZm9Pk09Ajir3NAs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: scsi_ioctl: use strnlen in scsi_ioctl_get_pci
Date: Sun, 17 May 2026 19:15:47 +0200
Message-ID: <20260517171546.2304-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=960; i=thorsten.blum@linux.dev; h=from:subject; bh=9rY44sbWnpihJIsKmAD6U7luIBD/yOhdo1SUcv8mbug=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmc3w9x+W73ZJcu2ff02oyWvqfBVxm/rgzxk+xMFTZL5 DGde3xFRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExEro+RobGxVnhh2URRHYOF j7cKe7Y3Z/SXprQ2zDlclKDqeTnQmuF/0P9LPar2s/Y8Mtir9s4y68j7outP4mK9794XqF2yf20 jEwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use strnlen() to limit string scanning to 20 characters.

Reformat the code and use tabs instead of spaces while at it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/scsi_ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 0ddc95bafc71..d98c2f19b1e9 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -176,10 +176,11 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 
 	name = dev_name(dev);
 
-	/* compatibility with old ioctl which only returned
-	 * 20 characters */
-        return copy_to_user(arg, name, min(strlen(name), (size_t)20))
-		? -EFAULT: 0;
+	/* compatibility with old ioctl which only returned 20 characters */
+	if (copy_to_user(arg, name, strnlen(name, 20)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int sg_get_version(int __user *p)
