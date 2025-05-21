Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077111459F6
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846318; cv=none; b=a2rWNlu9tVgXSmfSNxyFTlzl1QeRGpUvVXbQcWYSP7IhTloOf9OQIPAP+hbcSelgVACc5GTuHtp4ypUr2HsluXp/5c51yT6oekzKp0CfjFfsHsJ8dd+iuFyegOCUeCUmIVy3e/sNfvLcEhYngaVTNJWsFwPDZQWUJOJPoHJg+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846318; c=relaxed/simple;
	bh=bxsRn0vR+cV+EBo/cK1aiQoZ3DG/lKh9hWCSldmnwB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sQrAt48IzOV+38+bgtqHBj8x9/utE+2zYuR+38V/8CXVxcL6PXGnt/6uueyeNwdLrEA8JhCLicVtnBVBC/5cLGILWUSiwmcAdeFC+IVK6vxVoNpN5gY2ot6ltDA9InFxzXW0Zdf9SB7xlz9qL0dPvnl8NxXGLCKcIZ+LS8Vcbhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZE56Q4aw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZE56Q4aw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747846315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=40bqgGZoIFw8pU5e3iawrsuIQNROVCimAGaH8oGlcYA=;
	b=ZE56Q4awBkG3GeWpRNxBP0fCfumxpx1cFUycviMaiiRWjSHYVxxZ+9xkNkPNFSG1LtJUIX
	ZrnyD3KagAOiCX9V54EOogNR59KHcz0Tl1cGHakk4xHVsBdjdoeMprHHW/lri9YAkFjXHi
	8ZVMidFjsZU0Ytm9/p7Bb0dqPjhY5XI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643--dYU5V1gMMaXKF_iVRVkrg-1; Wed,
 21 May 2025 12:51:52 -0400
X-MC-Unique: -dYU5V1gMMaXKF_iVRVkrg-1
X-Mimecast-MFC-AGG-ID: -dYU5V1gMMaXKF_iVRVkrg_1747846311
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 833E51801A2F;
	Wed, 21 May 2025 16:51:51 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.102])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BE2B19560AB;
	Wed, 21 May 2025 16:51:49 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Tom.White@microchip.com,
	sagar.biradar@microchip.com
Subject: [PATCH] aacraid: remove useless code
Date: Wed, 21 May 2025 18:51:48 +0200
Message-ID: <20250521165148.8856-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

There isn't a AAC_MIN_NATIVE_SIZE defined so
remove eight useless lines.
When at it remove also an unused #define

No functional change.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/aacraid/aacraid.h |  1 -
 drivers/scsi/aacraid/commsup.c | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8c384c25dca1..0a5888b53d6d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -93,7 +93,6 @@ enum {
 
 #define AAC_NUM_MGT_FIB         8
 #define AAC_NUM_IO_FIB		(1024 - AAC_NUM_MGT_FIB)
-#define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
 
 #define AAC_MAX_LUN		256
 
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ffef61c4aa01..7d9a4dce236b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -48,15 +48,7 @@
 
 static int fib_map_alloc(struct aac_dev *dev)
 {
-	if (dev->max_fib_size > AAC_MAX_NATIVE_SIZE)
-		dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
-	else
-		dev->max_cmd_size = dev->max_fib_size;
-	if (dev->max_fib_size < AAC_MAX_NATIVE_SIZE) {
-		dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
-	} else {
-		dev->max_cmd_size = dev->max_fib_size;
-	}
+	dev->max_cmd_size = AAC_MAX_NATIVE_SIZE;
 
 	dprintk((KERN_INFO
 	  "allocate hardware fibs dma_alloc_coherent(%p, %d * (%d + %d), %p)\n",
-- 
2.49.0

