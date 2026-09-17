Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD5C3C1D5B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682255; cv=none; b=rRXhwKjIxReqxELU3jxJzKTQceR/Py0Mx3Y71p6dR5E6bToBkcafg7M32gAi2pI103om3tR24SJlg9lvhYJNmSacEPiuwRNpPmxZ28qJ2jHCS3bxdW8WiAbapotJG0e2B2CBlllfT2cIb7HQC96yOlaiIYF+tZKuXASCIXNZ/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682255; c=relaxed/simple;
	bh=4g9LB1Elq4AWDSZRLkj7+f9uRCd1aVgGHY2gPihztT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SKj0sNj4mQUdtZOy44IaSdpBGMKWoaWjsYUvarK6iZHivyqrbeAV5OxSExdq13/2+bx1JD2tsrWHAnWxqE9GtFTlf0sB8hYJahLSwAnKIqgiwQqpsB2p1qi9rw3oA3tmw9XhC9/Bqy6PE7DT7nVDgmIgJkEKIATSfYhwl8K5DVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MCG7MxVg; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCG7MxVg"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8692a856865so124730b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682253; x=1790287053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W5vMK2oZztz9uc2ethBOyt/7g5II8co/MONK3cmBCVA=;
        b=MCG7MxVgisg0hpClrkOigUjE9potwmFTDxbEqP1+OIk/8VtVqcszaDg2vI83N4gWTu
         YH9QLlnDSvrRdWMSX60Z01Chw3qWsliV/Pc5HsfnR68c6rq1WayJLurJa+TUxuDosY3C
         dyCM5gs5M9SPLcTWm0BuwiXyLD5cBp2DqZ3iVyAzgBOUxryYTo7G42usAbfUcSEQ1hT6
         gy1VnKIL4uyCSq49X516b4SN6JKTChLbxskFBYNygKfF/rrryv+dU/7BXBES0qbhB08+
         xzR0HXL5WZpHwnUJBDUkPzGmgVPqyHUR0raWFy9eUDfV83cFs9uY+3o4KbadJ7KI8+++
         qwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682253; x=1790287053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W5vMK2oZztz9uc2ethBOyt/7g5II8co/MONK3cmBCVA=;
        b=lbvD1x1eiLn224ofLplcDUbmWH9M4LeaT5Bry0yyiChsUtps05WgXoCmOKjPAA3jep
         yZZxGPnCsRxszb05X5GrNWZZJdpZP7nii4hft7W0Db2HxnkRmQKM+Iw+SjZZjk7FSO6D
         SGbGKOWmw6SBWX8Kofvnth4HouYbQE1bveEKd9oK/zDiuqU4U3xW/6COCBeJKrzUEcGk
         GazQA6an3pCYre0BuRHx5L79OsAAPoP9FImuftGdXKNv8WtFTjK5L/7S1CtpCqQ/fbfD
         5OUhHRWAQaG+jLgNhfuXqdBxZk0nXxpeeTUWWBdjg2Q9t4f75vpj+P9Z67hP64FT/Ilf
         hnbg==
X-Gm-Message-State: AFuF++nVQOn7Xsypf0T4sdUwqd8LO1GByu9ibCsUXCFfyAzH3pTqGuq1
	HF8CPQWIZKBhSWWhtICHURejDqHx9na/UQMBzQtScu6y0zcl0+m824ors63UykI6
X-Gm-Gg: AYBFou1Av59k5NtKjwYpSKj7/7MXDwVjABafQzgK4Hy/CzYSm3DIE/k3DXOdJRTZwyU
	xHkOqiTj+ReaGNm4YOI9PVo+hjnw2Hu2dEmedFM3guo2Dm8PTZsAxuMxMNJ9J8ymVGpz1YzhoI9
	tjQzpGh1Yz7qMvw8Va4ktr6xR2tLXPvhPIzGL3F+afkMCnuGgWe7WHwPk2R9G+ByeJY9cKRL6jI
	N77GSn/GnW1OelBZ2+sMGgTzyzfXMDNtaONGd/PDwatiZuwdEVIuD9lSyo8AV1c4ZJoXQWrBjgN
	4NOYIe7MUUrCeXoJJ6wGdU4bR1sFvmeG/hCHBAT+Q/9Uem/fzGtd7zdKz/SnpRRt/s5qvv3CSoD
	QlNtvcYzGMNnHW7P9cbXSl9khwAMaPwRpNlMer9i4gdipAhculWJGINr/cU3XT/wnxOLIPu7cvk
	xEnluDGL7cHTpHZpYLKj4xDM1xpfnZ0GrxBe3UmhNWkkwk7SGiyauJjv241gnNyjiqrROCGSUUo
	2Ie2DZjp/rZCiQzlYQqQSPSlsD8zEk4T+HZ562KyS9dBp25CXCGF1xoohE=
X-Received: by 2002:a05:6a20:6a0b:b0:3dd:85a8:4c64 with SMTP id adf61e73a8af0-3dd8c5dbaa5mr553892637.43.1789682252925;
        Thu, 17 Sep 2026 14:57:32 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:31 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 02/14] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
Date: Thu, 17 Sep 2026 15:20:03 -0700
Message-Id: <20260917222015.61053-3-nkirkland2304@gmail.com>
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

It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer. To significantly reduce exposure, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
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

