Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2318623
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726241; cv=none; b=AHr5bx/G/fFb93ERKfEukHwdTveCswAoQPOA5zptwmyQPQC1aWO4pfjuHIcKd409jdytCdQvnGVlEkfTn5El+UQOgCzl4O4KA2OSasOzb3RsqYRSmdiVsrW1/1MDy9krecf2jdW5WswW43k/+2YY75IcsqbT58wDH1ltxBVLNIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726241; c=relaxed/simple;
	bh=AC9HdCLQepSYxvoCytacu9ihASlLSFUOokrEkMF3VI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PujEOalbNSU9yZL4hdoOr99Va9t3dCYH4ha3RrkXASlmCiD3zPLohwLRSW28VFJbXuNP5VBi3vLYGh8oGqwZcGUvnlbGJlLH/9zC12PPNdHZnMOGx9sp4ni0K4GGP2eEovIUkM7YUarp+zGjbQi8Pe01Ea7oYV91p9Hd7y1B9xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSKpSREL; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSKpSREL"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7d3216781c5so27291241.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726238; x=1707331038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xrYMQbBGouBKeVUjbH/ujGHtT8PpnV9jorOVqOvoImA=;
        b=WSKpSREL3Rhu/JS+s0Mu3BEt5p3IjQm+DQIQKRF9FQgFtFYd6Vsadzw7rm7tH7Hzw+
         EDnP1jvR9Ii2S8vU0EHh+ATqDCRbQD4qjMerZ2d45BdCC/zDl9AFgbNg5fEagCFVF+p+
         jONoxnlP1gWPlxnmMipxv+lvdyeCQgLqLvYN5udoxR/b4nHlIsBkqRT2h7ldtlcV2Dz5
         y6O0jc0/P6qLp+8kN12KVlAofsx7Rh1s2dYujgzx35zCPkzZNUmi7wsuKleFCVl2Ox2v
         4l2Fd8wZPkZ4inm6PgIpAuPHtaIu9O/z5ilSH4XuWWfMqg+ZuQfSpJicreQ2RVvrvOmx
         KGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726238; x=1707331038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xrYMQbBGouBKeVUjbH/ujGHtT8PpnV9jorOVqOvoImA=;
        b=rZamWSJYpFXMczxnfwI4eHNlVPMTVDriqCA+NyaXxCiYL+z2eNsBOryFRJm1sFUh8I
         83dW6A/pGgAD4v2osiLsGJxVW5+cA9zaCqa3n4wedUGFOtk0tgEeUAQXa2k3gOdZF51+
         0QsRNyT1OY6SQwfCJhupP23R3u9ETcpnv+tnGqf0MzUL0GuZ8EZhH0htSB+V2MFf7fho
         FARLhLDW1HXkA5skGj6ycHfBk15o81Wc2SFcFyAjEvVGMlySTbv3JZh6jAb0YSyu7h0M
         Nord3yHnM3Zlcmy8VSmE926ywYOzjOXHZIjLX+/Ek7K3KO1KamwguNHafcL2PDrf2XWF
         zpHw==
X-Gm-Message-State: AOJu0Yxg8dpDyiZUvimwe28KeIq4fMKmSpluvtUPbIPiaNdO+eFQWhXT
	GcQgR5bLj+cvBNn51LTX6vxP4wa0xeeQ+hP15wx45JsYsfj7KY3QaWndJYor
X-Google-Smtp-Source: AGHT+IFyck+7qSVWW5YErwfxaNWk+bFmAtM4iRkrQ/xsx8Ioh6nkga4BRfg9ijHw4P5mSCq/25tvVQ==
X-Received: by 2002:a67:cf43:0:b0:46b:1494:ceb3 with SMTP id f3-20020a67cf43000000b0046b1494ceb3mr2151278vsm.0.1706726238680;
        Wed, 31 Jan 2024 10:37:18 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:18 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 02/17] lpfc: Fix possible memory leak in lpfc_rcv_padisc
Date: Wed, 31 Jan 2024 10:50:57 -0800
Message-Id: <20240131185112.149731-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to lpfc_sli4_resume_rpi in lpfc_rcv_padisc may return an
unsuccessful status.  In such cases, the elsiocb is not issued, the
completion is not called, and thus the elsiocb resource is leaked.

Check return value after calling lpfc_sli4_resume_rpi and conditionally
release the elsiocb resource.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d9074929fbab..b147304b01fa 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -748,8 +748,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				/* Save the ELS cmd */
 				elsiocb->drvrTimeout = cmd;
 
-				lpfc_sli4_resume_rpi(ndlp,
-					lpfc_mbx_cmpl_resume_rpi, elsiocb);
+				if (lpfc_sli4_resume_rpi(ndlp,
+						lpfc_mbx_cmpl_resume_rpi,
+						elsiocb))
+					kfree(elsiocb);
 				goto out;
 			}
 		}
-- 
2.38.0

