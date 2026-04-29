Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248941C2AA
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 08:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777450589; cv=none; b=eeeMz4HuDEFct1tPnwLzRbAd5a0kRHbBIy0bHbmdV7S8IKqBtD/A20iSKFFYclLnYO2bMAjw9YyAM13sjPtM+hym6ByRio4sOyqObNan0g5Fc0ru0fvKFRy/6VNEYOKqYAPRuONEYCEvBczVoMOPN2bN3tPnMTHdP5970zSa2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777450589; c=relaxed/simple;
	bh=XUGUIRKE8r613a9DFE5PXjzMI2T++L3N2ye0TlG3P2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=An966SuLq/5mlzcQGHcufhZsL+8jaseeGwRErU8qFaV6BAF/hwmq6BH+pZ8/yyC/T/TUnDkiZK+1TGTLCOlr+FzS01XOQmfSmNKnsNoDTC3M+lMbmo/0db0zHee0zWhH+38J0uIMLXtM1aWRJEKsHItGNwZc33yt54irYq7zuNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uvj6WUJn; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uvj6WUJn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777450575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5QCm+4Xz4bTmLzTg2p/h6VWUvg7wguGkFoa+RP+amiM=;
	b=uvj6WUJnaUIdeTjsQJEhLAjHv6K0gb2qRAxPaf/G4TTdpIxHlysZKZO2WO/y1EZ15QCrZO
	lV1xct6I+Vt0z7AEDCwvwMC/0PbafynedXtRdsNFbccfYLDzQHid2+l+9cWJBc3eNtUd/D
	pzW3ulDDaYETKpM9KrJAfB4wXY4Y3BE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_ioctl: use strnlen() in scsi_ioctl_get_pci
Date: Wed, 29 Apr 2026 10:15:51 +0200
Message-ID: <20260429081550.56279-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=967; i=thorsten.blum@linux.dev; h=from:subject; bh=XUGUIRKE8r613a9DFE5PXjzMI2T++L3N2ye0TlG3P2M=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkf95k18d482CnGsaHh0YKgC19j2FK1VqTMqnmw/61Jh inX70lGHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCR0/qMDIsM9oX89Vq781uA UnqTh3DNpqaJZZ9vsasppaw5vOhfaBcjwzfNym9Jfg174+JOPl0T3zzV9lv65d/hX2uKvt4T2X6 EmxMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use strnlen() to limit 'name' string scanning to 20 characters.

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
