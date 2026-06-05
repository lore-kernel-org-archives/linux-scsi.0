Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E05391827
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681503; cv=none; b=NAep4rbS46mPkRLYpHiaadTnEqRzHVVZQsdMIDh1b89bejcC6ltZvkh9uG1ruqjX+TYpyZm2osRXO8eHvu3mSRItx5GSYMGgkIbVn/Ei+XCeiGwI5KBqvWyrOKcOCHV03Wo9I96flM6vyovoGeFuDk26DqhU8ZyCcZHCZ5K7SWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681503; c=relaxed/simple;
	bh=+3m0JMdiXpuvCHnm1FRh68WRusl50l4Rbyh/OO5Hrs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ISRqRrU3K0mUs0RsgqS25Um6aV5PJw5yBYt8JkLpaRnj8AgHH7uuuIT/8Xd1MX3PoBBRI9LwntycBRzD3MTsROG/P8mWD0pvaEP0qFd6WSZS8HJKS9Adygz2qfMzNDOsCjUoO+2H5oJQcPWeBTtdHWCe7lP7qu7soXOnqIpIm7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dH1oBni3; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dH1oBni3"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51776b4de37so17584291cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681497; x=1781286297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4r68B/dC8VXpyqdhvL5gBI3YcpNd9ejYho5aID98pyU=;
        b=dH1oBni31jPAjUpKZTk4Z9+3KwWLA3MiNIcLK49j4EfjOtxnaPkDNaAk4lWaXFAupF
         vkYxGVa7oZu68rOyjlE0axsvc+ZVLnzZOznzM59pc00puP8VSyUsQYpNdBxa8iXIBpzc
         vn+DZseBFBGGpUETL6ETW1fwy5+SoJa6fy9sii2LWBPq85rZuTq1x4CRV1jCDdz7iEH8
         ugB+1dywZN67LCtw/KomcAIOXew18t8n1U30R6WkLNnG2vBcJtQ9i5K0kAiJlMHqTjyG
         54QPN5UjDcih2NnStH+KY4oyQ+OXm1baMvFEYDNFUW0Bqe+7i/TFHNkG1mfSSGXdcygX
         OjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681497; x=1781286297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4r68B/dC8VXpyqdhvL5gBI3YcpNd9ejYho5aID98pyU=;
        b=tZKLBOhxceTfS1pABggVtOxrS1OL6MScuV8rrJPjISXPO45yIeBOxnEGUn/3EKJ/Sp
         eVJa8nDIUIOUe29HHkAh9Y9neUEGgi5aPbrU8V4HhYs8N1OAJAcKSSY36yv3qqMhAlK6
         7gAVMtIIrbrOm0RCuIRaQn00hQdCZMfBmzteUjbOR/ZDQrflnsGk3glYQFbtamwOcTu5
         LEWbSa11YI7PoeuJZZ+oGBbmcwmrRCjIBsy4r914/n8D6W9KeZzP07n844byq+SzaQPU
         f9tJpNYMl1eN6Ka+zF6BqmVgrlSuO7WDAVElNg5kgzq+d5enpz0+eyvLrsQeq/i8KWhb
         b0cQ==
X-Gm-Message-State: AOJu0Ywr/vI+cJUMxtOxs/vhtGpT0VfAH5qwZ9i4t0piPOBktvV6xoXh
	9lRyaE+MM9Sb38FbuwL9rcrdTuYx27QrzlvBLaCJ0vwdyLBerjUFpZ6Vfk+07Hus
X-Gm-Gg: Acq92OGcqw/Ds0p6QKshle8DXDb5ndj+KswCGQ0YvqMGbAR1m2O5AAJIfFBbqlhcQsD
	+jRBXDujloHAm2dpd04bb1Sn7iG4IFI9pdTVMtlMLTsIwd8c98exxd6qH88hvxArubtkfDaDbRb
	qCR5tiiBNdLqATOblPRJmtgCdlD6ZTaHpYABeSXdQ7j/41y2JprSRx4oQz+PiAsjhD/5UehIKYN
	GMTa6DrGd6txbD4I4h746ErINtmoG4AfMrOSdoGmHXPfcdH/6SKBQaFmnfdfuCfF7SeHtO+8SwE
	cyvbUbCkwkJKwJxZFgfWVOT/YmG4qMETGT7Q4WhZIRHI8gOOoPV/yw0y/e9HHB6od7/tCQnt2VG
	IvIqbnWFOddCzi4V+PmRAnD6ypYD/YiJYu1S30/3GMrErqS8S3q6u63mfKUXQUk7I7g+NHr+5if
	scsyuzYze4SikUaX9BvwHr5fiXxJFTHUbEg52I6hPv/QzjOgYF0uafKvn7chEmA1iHoQHUEb4t/
	tz93Bi0Q2uQN5AnWIkNQVklFIkdn4KVyCqE59yV7OhArBXYsCgPOA==
X-Received: by 2002:a05:622a:4a07:b0:517:8e3c:efc6 with SMTP id d75a77b69052e-51795b17f4emr66298371cf.24.1780681497049;
        Fri, 05 Jun 2026 10:44:57 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.44.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:44:56 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 02/14] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
Date: Fri,  5 Jun 2026 11:23:24 -0700
Message-Id: <20260605182336.134919-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer.  To prevent such a condition, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9c449055a55e..2c8d995a45bf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int retval = 0;
 
+	/* Exit early to prevent race with queue teardown. */
+	if (unlikely(phba->sli_rev == LPFC_SLI_REV4 &&
+		     !test_bit(HBA_SETUP, &phba->hba_flag)))
+		return;
+
 	pring = lpfc_phba_elsring(phba);
 
 	/* In case of error recovery path, we might have a NULL pring here */
-- 
2.38.0

