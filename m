Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46573222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467346; cv=none; b=jCNrsASkE0lxRTDJFp7zAApJum2FlZJQosJA30ujScq6A2aiA5OUU66aCoUFGCE8e9N/55nqW+flTjBP2YB4c3ck1Btoz0rFcEoo6xgb0GkLgCASvMu69xTRso3tH8MyuktLU5FjzgNRVEtqgeCZUq4pNT31JuhpQVjoicTmn+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467346; c=relaxed/simple;
	bh=j85860p5CXtlGFuA4WoXnDOtCd/uFKlFqpz2f+1iUuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FynJY/epWOwc7/P56lJNe4QzvWZilALHCEPunEPzqnG/cRcxTvL3KWTMeZ1+S/xyv98jKkc7vQkX44BycG0tLS6iNhL6Tcg+BM9d7n5h2revvVF79SXhUIE0HZd0YrlY8m9GbNatvv02L9XnCBZSpRWUI6L07/9U8V4Vi3MxsTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iF+xwU+V; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iF+xwU+V"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-780fc3b181aso99786b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467344; x=1763072144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpm9itkdcRBJZXZToJlxg/VNHIayiou9amu8U5QZ3WU=;
        b=iF+xwU+V6h7gxUubSGwjIOMBFrPmY0j4/V+8RpFBC2W0oDduLYrI3Pi68k2Awuzrnq
         IIhh4zNRvnNOIfM/IOOCXO5yxckGZWPGoiaVCGrKjoBraM2sCCcazfD0/3YZIMQN+lNp
         BSmq3+SoNrVTJ5z4e0sQaS+nZN3OMueVDf7EUkuhsE4uq1n06fKRjL8TfJamYwhwrWp2
         jSNwNL6K3O/dVqon4xVMxU9wSOZObHk6S/IMbli/RU526VU6My9feK4LxGLy/Ine/UsW
         cdehscYOPQXXWua2/RiEdogHD1st0RqkmBwOdThqVEh76einga1B2RQylafYEmdXVMUc
         zvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467344; x=1763072144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jpm9itkdcRBJZXZToJlxg/VNHIayiou9amu8U5QZ3WU=;
        b=P99hmLmMk3qnAMa1htED9WFv4EGF/nNboNhau1wSWZ/tjaz+ox2gaEW4zVj2RyjEyn
         GYeP16k5z3hs9VD92NFN63dQi8ddMk1xrPdiyYRYvVai4yRxtNe1xnWHWfpQva5cbTVB
         Z9PhYOWc3KYtW5Zc1uCOcLr7iCMTq1cP372b567Fuo0LFyVZZi2qwiCn88sjagv09RSl
         GJtnKUSt6PmH1579FFJJoE+72h1mF2k+rujKGfzNF1mzHeTm6l/seUdoF2WvqKf29zmU
         t7H7c42IhCet/5liygknmHdoEFpSro3xwHnJysiLcwk/6rZBl8QwmPF/87CfdggW9Ki8
         vhFA==
X-Gm-Message-State: AOJu0Yyueu9Q2fEBSmWBHFP4bTHUndlzH8hAxA3UpdTAImBmTjocQfzQ
	14gXLQ75mNGfTnAo/LwYd6qqbNta8rpo+v5hd09nEBuPZe2tfQZ0T0iSR/lUcXUH
X-Gm-Gg: ASbGncshTbWfhYSkoCZ+SRZNvYHVgsdcYYBOX0ldfi9h5BKhzb24W0kUiKE2ZtaGyF0
	JIc3NWoMr9WMG0na5Ajvf6dATCoNBj9ctPU3+EopnDro+KDdDU85fZXYQjlqJk9GQxhE2zRKPke
	571tYNk9c66T0AsFCEPe+PeihX0CknZu//lNNlgl7dP+deVN4HH6M8+wMSWsjBk7F4aGl3CdBCW
	ta+s677+6t/MSRMxGk3fLiJEpUn+UOVNKPrvdFKMKxHK57NO2hvXpHpj2vb32+JGZbocIyMQWr/
	v0DQ0cKJ2ad7ZGL7/68XdGQZsN/OHY1CpsbINyiidCgA5l9r9+IyCyYurxJN5piqe4fpvTfqkIU
	6PE5lK226B1lBztT/7ca90AGxBiWWCWM2wVmRsbOxD+jr1TS8w5yZVACJZ3avz5sVVHdh6fluH2
	nOl/hDJwdoV/jaMLA4GoKaae4gx88lPzFBn1voza8XZZ8NcIlnH5U2CFwKBkgl
X-Google-Smtp-Source: AGHT+IEneaaj+whyfywQNW5hFU3LnzJZilm8LrWVZC5GJwCB5M6MHWzj63XO/Dte9mkIt9B5mgnNZw==
X-Received: by 2002:a05:6a21:998b:b0:341:9db0:61f1 with SMTP id adf61e73a8af0-35228067d1cmr1459971637.16.1762467344423;
        Thu, 06 Nov 2025 14:15:44 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:43 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 03/10] lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_iocb
Date: Thu,  6 Nov 2025 14:46:32 -0800
Message-Id: <20251106224639.139176-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove redundant cmd_dmabuf and bpl_dmabuf NULL ptr assignment as they are
already initialized to NULL when handling a new unsolicited event.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5456d2ab2d36..b4aba68afb66 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5159,14 +5159,12 @@ lpfc_els_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *elsiocb)
 		} else {
 			buf_ptr1 = elsiocb->cmd_dmabuf;
 			lpfc_els_free_data(phba, buf_ptr1);
-			elsiocb->cmd_dmabuf = NULL;
 		}
 	}
 
 	if (elsiocb->bpl_dmabuf) {
 		buf_ptr = elsiocb->bpl_dmabuf;
 		lpfc_els_free_bpl(phba, buf_ptr);
-		elsiocb->bpl_dmabuf = NULL;
 	}
 	lpfc_sli_release_iocbq(phba, elsiocb);
 	return 0;
-- 
2.38.0

