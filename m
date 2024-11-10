Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56B2288B1
	for <linux-scsi@vger.kernel.org>; Sun, 10 Nov 2024 15:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731252143; cv=none; b=s+TJCCQkfbIDfC6AI5xFODKmicda+FrOfEsJKgDBQh/aE2Ldw1pigGO8Ik0plxxvZeC0ejHwO5xzBD/EVx6U40StDnrvCi8jzRPfrwbQ20lFdTKWQ7N05Ev3li1pimFFeYU6fX28U6jR/qZfk0hnNw8Pa3M+4u486JxWNHgZceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731252143; c=relaxed/simple;
	bh=XZveZfdfEe7GHPTaQ+DcTl1LvudeUki6avQSeQ+cQak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZYWwwfD7RXsR02gorXlE5mlJZgsVnUpPJy4XuTyXZSZcuOmSw9tOF7IasOWqRcEKZBIwESjvC944vQhfjYCSDopsWQzBR7Oq7V3dMb4q/pDoWu3ay31/p1zwElSHKmAoPQqIT50QpOCOBEnij7TQZBMj5RftYLeyx1yIMFfZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wQl8MDRS; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wQl8MDRS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731252139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FwUaqcMHBb2izLMC05xKkduvRf6O7Ag76Km51G1JrLE=;
	b=wQl8MDRSzbIH8ND6WyNyqtTXdUzSfo+PUp4KdZDyxld8wDdFe1c83gKvO2b5sdrNaDDxUo
	O9NXcnrCqRclt7deb13hioUDjEQQSMflvAmKB5Phk4eUtoHX+DYYsOc2CEiYMvK7KxcT7c
	5SktcsKV9soCQL+I7ktPmw03ZXMGmEM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: Replace zero-length array with flexible array member
Date: Sun, 10 Nov 2024 16:17:49 +0100
Message-ID: <20241110151749.3311-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the deprecated zero-length array with a modern flexible array
member in the struct iscsi_bsg_host_vendor_reply.

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/scsi/scsi_bsg_iscsi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index 9b1f0f424a79..df8083f12119 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -59,7 +59,7 @@ struct iscsi_bsg_host_vendor {
  */
 struct iscsi_bsg_host_vendor_reply {
 	/* start of vendor response area */
-	uint32_t vendor_rsp[0];
+	uint32_t vendor_rsp[];
 };
 
 
-- 
2.47.0

