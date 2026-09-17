Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC842CB1C
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682256; cv=none; b=J5kfgqHSWnV5iG9dsdn/qI24eYi5kPq8zJiAQtitGkcWvo3IE7eOo8qH0/HmKNLDQ0dMKb+M1s5upWUeJeTB7y8Mcy7Z7qkaxQDKacCNjm1H4PrzRsrRdW8v1r0RgHwSq0isph4KWayn3NUeMcvNKHRhQXE+TIrQGQ8kH8Ax0ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682256; c=relaxed/simple;
	bh=n2DzVKfXY6g92JDu48SIz20vD0k+CfdbmDrO5jgovd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsJU7j2fU4NTRKVFqWfGUHNqjs2RMCsXri7PN5D0soI/bA9n2ButkQQUWFrcQy/XwzC1jihirw+ZeWrpd3C6ETuiT3EDIZ6dxTk2L2Jz8iReBS177VDZCgUxfpvxokfEcoVaQyd4xycgxHFzltt5SFzZzO5sHyBWqevPhsH26PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l5vl91cP; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l5vl91cP"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea50dc3so2545a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682254; x=1790287054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SF2lyk4B9tRk05b+m0f6bFDUt7cIneDFpylgWStsJCU=;
        b=l5vl91cPQqRG88RWS3k3Gl5W5kSNfFmR0EjCmNdue0b5OyCRgI4Nf9ff+9npZA3Yt9
         yze7UoExofhnTRiDKcatgrQ2VIS7qRgNOEAm/ty5LOpKkzyhg+pty7W5DHFeWT74Ot+y
         AOb2R3jJ8IuKAg1LY1r+S0i2fJC26dkHdcRCDjuOyKdEmCyxPXIuqc3N8RArNXe07gme
         JWLZQeFuaSeSvvpJxthIwt9ajjCTbfieVw4+8kwVJ5VHkY+2OaVwR2Lg/j3o+feBX8GI
         YmeJiLWv7Ti+Orttrno/QcZTiae1j6t6Ns5OwYiL+/fkNMcdWz2/m+Ep1Ng4566P5mRu
         RofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682254; x=1790287054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SF2lyk4B9tRk05b+m0f6bFDUt7cIneDFpylgWStsJCU=;
        b=Rv4C0WoJ5OZ6NhwCAu7R48QA1mxLAXGo8D0E2mBHshW1tUnROMJXUwWKhrM+SOpOhi
         wV3KTVNcPwJRI/aTKukkYBmSX3OZGvWBsE7JQrkhESjbXsbN9K74j3Qv41Zt/4Fn6dMX
         wavkJW/4myWGtT1JPiDZbvMYlO59No3FRQEjxukbxh94k+TJPA9vVrP/4itv/rmQWPN3
         VKBOwo8ppa06+XgFJYIPgja6Q+RwM3uWVhuwWEI9OAdRKGjtMJPEak9yZmX+03fvEesy
         IEcjhWEctBttBpXQmFsduwjccFwEXnBfxPMaju2iq3Q/6+Qa6n99UgRWd0Mib3gsLHTR
         p92Q==
X-Gm-Message-State: AFuF++mevMgUBc/gU9vVFs80gP5fCOo//1Ci3NyJULFttxerGXZ/7Xhq
	rC2lrzZYe4nwYdNWyL0BdwCxcz1X77tRrFfXh//m4PPMJR7jW3mIdUcz/IpL3suZ
X-Gm-Gg: AYBFou14Idoc+oBA1uZTBoIwyzAdmTKdDgEBF6ZviHoqBcASzpYMyLsrCuCCkn77Ut4
	zzKsDFIrOhQi+jBjJtAUX9hnUXL8x63mo0l3joX92wuT6C4B/3o/DSkcX/bLMN/4gj6o1Yw6AYj
	lCYK4JA9182zS6AaruODIA+RweA3hlyM3yQG8Dldf30JKIXjZvJlGrqPEw2AeIA4mUV4ZaAZ0MX
	xkYMxmAuCHZHOKrzqDSoZd07eLfI8Ft1e+H8IAIoOzpeBKIYg0RERn6b0NMJOcGKkkYh/OTDnKp
	oCPd2fPkfqdomVfklnH3wc/k5j1OrHzK/HR5J8g0NeFZ8SiTCStfAPeR50dWL75oDpIQDGkWhrh
	q6FAT9GiJ01QHj1M0jZJDxINyMbZFc5EOD8qkd4g08z+pJ4yZWHfAmHdmW7qo/ZfA/yEFlX1Ajq
	ikZQ+YOWezgA5IYNWq648YVh13qPbE2WGZDPplxuzXURxo+0rDPdwbD7HobwTtjzOdpsNl3g/2v
	zMpQMbLuno92CquYoXNYEcoOj101Rk/smKZg7K2u21ovy7gz2EwNXNML+k=
X-Received: by 2002:a05:6a21:3216:b0:3cc:917f:f302 with SMTP id adf61e73a8af0-3dd8c4051b9mr702536637.9.1789682253995;
        Thu, 17 Sep 2026 14:57:33 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:33 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 03/14] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Thu, 17 Sep 2026 15:20:04 -0700
Message-Id: <20260917222015.61053-4-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A kernel oops at dma_unmap_sg_attrs may occur due to a race between an
aborted scsi I/O completion and a scsi error handler issued TUR using the
same repurposed scsi_cmnd structure.

The LPFC_DRIVER_ABORTED cmd_flag is set when inflight I/Os are aborted
via lpfc_sli_abort_taskmgmt, and this flag is not cleared until after
scsi_done is called.  The inflight I/O test is changed to check scsi I/O
for either LFPC_IO_ON_TXCMPLQ or LPFC_DRIVER_ABORTED.  If either cmd_flag
is set, then the I/O should still be counted.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd285e87c278..b370a64e6b67 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12730,8 +12730,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
 		if (!iocbq || iocbq->vport != vport)
 			continue;
-		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
+		/* Only count FCP i/o */
+		if (!(iocbq->cmd_flag & LPFC_IO_FCP))
+			continue;
+		/* Count i/o whilst LLDD retains an interest in the scsi_cmnd */
+		if (!(iocbq->cmd_flag &
+				(LPFC_IO_ON_TXCMPLQ | LPFC_DRIVER_ABORTED)))
 			continue;
 
 		/* Include counting outstanding aborts */
-- 
2.38.0

