Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1261521660D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609079; cv=none; b=Na6FlPneQeQdWSEjqguhPHT4XEThhYyWr2C3g4aVKoWOL3H1IAe7madoOJ+sC8BClukvIsNfohOeTxyfM1Imf58KlHwFPdMfMCE/pNZl+Pi+iuhHerzPvWn63yE1Z/p7TB60FynuyeEFOg5YXkeGCPNw1jW0TmC7M3v+QtmSSJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609079; c=relaxed/simple;
	bh=VSjs+NIQXig3rOX9vBtYQIOcUazgEsK0FkB8ZZrTFQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPm4zoNmMxlJ/VqvxY6/IeALel128yRQDr+1rgDGZtYTZEmGb1jMYEnHvDvlgxt9v1z8qlhqNCxhKWedokyzwrCcNZ4zK6fDjbR0CilN9Cc22qzlaWYdgT6a+5hxHId0aqh4w2NVUb7c4+c2NbuFwYp/ZWt9bKlRG/3wZ3tRyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6eVKQ1V; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6eVKQ1V"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-73bb647eb23so2349261b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609077; x=1746213877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYhOYgXaqhkkQemc9451PzSaJeWBkAGYuytmJ0DMpc0=;
        b=e6eVKQ1VaG72dNAHtMAJJ2uWK9wzzXbTsB1slI/NlgWmw8sI1f1YH8JSS3SgDrhwi7
         XRJQT3y4dAHcWherqdgyjty2C8lr0mxBTM5cXRFcb68ARtzH9dV+yan6DYOM6RbjTg+E
         WBkYojdFprLLtiyLj0Oo0zZHCv99PUOAHYJg41I6LMJC7ADnhXmx509EvaiMyhXMfhuP
         3zQOHNsqsw5BkXzTeNwesIbkWF6h7+lK2Cn/6qbP++YzwBwIgpThc6nycH714VLTLgZs
         +KUbgCvZh2HV6L9oPf2RJtCcy6TfEFu6XjGvLds+pLefNFBE3YGXxPzcHtqzT2044yX+
         M2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609077; x=1746213877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYhOYgXaqhkkQemc9451PzSaJeWBkAGYuytmJ0DMpc0=;
        b=hg6o2YYmFofLvZvRRKbFF0uaLqaKHYGJT6Y8g/rx+a6/xPJBEUpn8z7wj72dyCVhgX
         ngxSPYgybjBmbzja2Qe7Mlok0DpmpF0ATJw6fHi19uA6dm5TESXqYF+ysxMiXgapXR5F
         zDYAnpVHb3uykZKwDCoyV9lJ8gobcAbRrizuphwp7Mgd7QdUOaT58aNXWn8CDxH2jTE7
         TDGgkLdQGUQ/8b/+sKHEQnycwL21QKapCYddNbz4OExsdeap3SZNAB3dXqBTYBO+NIjd
         26vxx23mNFw7TiDMiD0sPtOsMtWCLCX3137ZoLe7LY2s8XcDbJgBdbHp7qnmRk9r3meL
         Z8jA==
X-Gm-Message-State: AOJu0Yx02oSZ2HdIEg7LYhDW4JHf+2hdDoWeJQ4LTIiQrBVI5pN0/uB3
	f6oiy5jRaOelOlI9/B8p2YSev/HuEmYn2EXcBHkRa7BmKTC9f+78xra2aQ==
X-Gm-Gg: ASbGncvKjMrXxwPN4kjf2/YLjMmu+TI0tJb/ZZljhELhXLMaL1WeaxXkSEVSq7etJM9
	VLZEt0x1QnohhFCBaMu7IxmXZKpXVx5X4LvJ7XByQmtyZJw/sND5ZJsQvqEkZeQErO5IMaVcO41
	nTmJjBz23y5tdMjX1Mday/WrhTPMwIzd4dwPIbD6vXtwDhg6VAdLfazxYZZcpw6dV4LdYQVM0jE
	nBignO85fo/PhOmFiIZPpn0kJJrqG4Ath9iKnoOlIsDIxKim9+fvBeTNyyvWduNUAVm+/BQKB/I
	hFLzefTj6EPZMqTcq/FmXC3nJ0z0Tm7zMuxay9tTXB9dQKDL6acWBsF9zY4OVeun6mo5t1+KbaW
	rfsPlC4r3jtQs2G0BM7ej4n0w9g==
X-Google-Smtp-Source: AGHT+IEq0EPfO2Dl736f1EqlJGW0i0KBhkUDkxthi1gx5LTcWJlUo3Qo5Ybxv8SP9mIFpGmnxfXiIA==
X-Received: by 2002:a05:6a00:2286:b0:739:4a93:a5db with SMTP id d2e1a72fcca58-73ff7396ad8mr752644b3a.22.1745609077231;
        Fri, 25 Apr 2025 12:24:37 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:36 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/8] lpfc: Fix lpfc_check_sli_ndlp handling for GEN_REQUEST64 commands
Date: Fri, 25 Apr 2025 12:47:59 -0700
Message-Id: <20250425194806.3585-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lpfc_check_sli_ndlp, the get_job_els_rsp64_did remote_id assignment does
not apply for GEN_REQUEST64 commands as it only has meaning for a
ELS_REQUEST64 command.  So, if (iocb->ndlp == ndlp) is false, we could
erroneously return the wrong value.  Fix by replacing the fallthrough
statement with a break statement before the remote_id check.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 179be6c5a43e..b5273cb1adbd 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5053,7 +5053,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->ndlp == ndlp)
 				return 1;
-			fallthrough;
+			break;
 		case CMD_ELS_REQUEST64_CR:
 			if (remote_id == ndlp->nlp_DID)
 				return 1;
-- 
2.38.0

