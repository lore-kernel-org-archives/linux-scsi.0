Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1C832E15F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607456; cv=none; b=NG+v7cqfZfB4Y5dBNUhfVSrR4fST6GRvqxS2DKebTub145VRVimFDFt5a+IwQcPooshvZyJsBfKbk5pAKUAQuL4s5TlCkiUMVaSiUfr25zPJt49tiKfk9zUD/p2boGarKScq+7yv7xLYJLhvYM34Byuj6mN436ceuD4pMe3Vi7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607456; c=relaxed/simple;
	bh=7sqGaujQEoFL+B58CX4J0Nfq/oaTYI1ds1GgAsQr0MM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m7//LYKFO2eXgKbIMzjMg6QOVgd+t8XOcnBXymxEkoBWDIGn5hsGsKB7/AiklES2d+czb4HxkNoSsYUL+d82Jtr05PzLt3JR7TBLgY4WnZCufHzXxpncVz4GBbV3+K9wyZhQY2TdGeFxaVQvSzk+3pEAkwZGyxIx7UpFc+kclpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwtKFQRw; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwtKFQRw"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a2738daea2so4487204b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 16:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761607455; x=1762212255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/zNdF3I6WYvd/brOg8FoB5EMYG9y5PXQ61LH2S1oyU=;
        b=SwtKFQRw2WKE8HuS6ApWW1cWhoVGaNZ0UZ10QiJLYGbmMkVlSAVGKX1EypgmXhdpYe
         e+xrhOnQHa0qUTS51QMTTQPqN6sGSyLjnkL1a3MHI40GDN7x3v2jx9f2ixd6pFhtZ0wv
         f0Zah4cNezbzXtdUtBVTQQtrpp0wlCRF19naj3Ki4goUII7hYSneusTfqoS8P6gJE9UB
         5e3DYWRpAbn5JAjAIcNpXX3ynDKXhQ8NXprEEzwjU51sTshcFX7NSKjGbCfJ61GSTLja
         IL3WHTuJ4CUMICZN8nrPx+RyPlLn2VF42XK4LwsIr4kxdXbsVkZAqintyAd4OzviTfgT
         2JeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607455; x=1762212255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/zNdF3I6WYvd/brOg8FoB5EMYG9y5PXQ61LH2S1oyU=;
        b=KIp/3au/tPGbz9oFQ7DP9aU4p0Sq12Q/wZAmimhK5ESbsEcZtg1+1YdKheoBj3NE8u
         5OSmFEL+PKv8cRqgoAzsrjfeXobjXobKn+QJISeM428b9t8zBhRNz33MqeKUAxrdWtpY
         XqlIC31hs1bkLhqzEmFM3pzMzQTP9Mh6CqFs2l2h/7wha/ufhVfakS9T+kzwSS2Io/dN
         EAyPi/l/NcWF5vBSZ7XqWUYHjpjGMM6UntiNhjM43kPHKe/2b+fsDf+5GtOIHpA9TJZY
         CEE3f5RJYBrvu2RzAOWIVs2wLTZgKkGLrRHnldxgkpTrjh5nQ35hZRF0YFPpqLfa10Rr
         5Oug==
X-Gm-Message-State: AOJu0Ywse8h7gSFL1+EHREF9fYvo4gJ33bwMmVmwvYv4n8hfr5TWdBtu
	xfNpjUar+kwGxqnWLae7O5jCDswXCsp6CCgvzYxkbtIAmdk7aT/9Psrl7/OT/g==
X-Gm-Gg: ASbGncs/x+mg+0A2H1Ov6NWs311cYqoTQtjxc5D3OkIrXmPWlyiCuUUpxSxtXw1PVvz
	QzoE5yZQOS5lAu35q49OenbxTriMa7wzoD6I0ERCQnsr+j94LcLeRdQWPDAJ5F2jjgjLxS5DDHX
	dQuD1AATTqzFvaEhAmZ7Um0KzVhZsdkFMTHKzHq6/fxrRMfZ1/hKwv3+B8d8duY0wnRPizMDcMA
	pjtJ9QsfS239CWZ6Ek53HgZeDpgd4dzVb0m3DFLdNVU/DYNQSuKePOEcrtZFmUslhfhTNkwOiY5
	Hn5jnPQNiR4Ya02gkuInRhYJyPXFuKgRDHhhkcYTW9fSdH6RWQ6UzcAAPnHFCKtTrJobg87r5Yp
	gzMrr0G3EI434GbMKr5BhPJBSr2XiFYTKBaT76uvmUNQarxslZsGPIjAA/D4Kr4hfPrnvYMmigw
	I7JJpAzUP5IDahlNylIdwsiMy9jOoJtzIOatppOhJUDYI6plqmIw6bALrh2+m8T957/Yle+Qc=
X-Google-Smtp-Source: AGHT+IEX79W7iqIL9K+Tl3eOtu17/QNPSrsJ5avrZPLpmsmkxEH42xitLcARyTpTuxIZX87v7TOoag==
X-Received: by 2002:a17:902:ea0a:b0:269:8d85:2249 with SMTP id d9443c01a7336-294cb3821afmr18202725ad.22.1761607454673;
        Mon, 27 Oct 2025 16:24:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm93805855ad.91.2025.10.27.16.24.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:24:14 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/11] lpfc: Remove redundant NULL ptr assignment in lpfc_els_free_iocb
Date: Mon, 27 Oct 2025 16:54:38 -0700
Message-Id: <20251027235446.77200-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251027235446.77200-1-justintee8345@gmail.com>
References: <20251027235446.77200-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove redundant cmd_dmabuf and bpl_dmabuf NULL ptr assignment as they are
already initialized to NULL when handling a new unsolicited event.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
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

