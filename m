Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D42628C864
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957968; cv=none; b=sLv6NhJbrriMmQvthODRCG2VKc6cOA4JOW7AiVHkJDPzs6mo/7mqzGg+G87Wsp6Lt5Y8qV/8gJFcbkAQK/2QAI/a11o3BxjetiZIC8/ZfgUtX4Sn6yAGY1XDNUWlN8btod7KWW/AQa2d8lXl7tki0Q4BQHC6BylpYv7s4AYD3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957968; c=relaxed/simple;
	bh=r11v9LqIGeMF343aKmxqZRBFhyMHPXPphjqVpXJEmjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tp0+79t4EBJ+MzXA/PYItqe82wqmEkTqwZIPH0hoy2RPiBIe/7AVgxJzI9t74+71SSElprLHbiq5KMwnex5SS+4GPwNYLpxDxt3L/nQkoFeLLHAFAiudaD2QFlgTm8Li/ou44i4GSs5TNJF8vvZJgJmbP4/VmsJxK2nC3YpSKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eIYsH5xs; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eIYsH5xs"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8287fedae95so247972385a.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957965; x=1758562765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjO8c3erZy4WXKRcrWjCp9sd0ML6yz3C8vPnthii1Gg=;
        b=eIYsH5xsnUz+krOxXrma5D7bwkj6My9KkDUfwRZHX0s46GJcb2qF1M9Pk9WAqv56VC
         hWUQ2Fzr0JQWoORcrZGkrMsNFFUhqx+eUUtOrE0veYR8RTDK4YzVg6V2JKWUxpfDh5Ec
         5MEuMyLH+v7AEZzgGx4td9ISQcHWkQrpXtIKxmB1T/xdt7OG6VfkaZRiFFA0v1LrnviF
         B8RXks2UNtS6HYyvOCHmSFOzZT9tj2DbuP1lGXLZaJYICgApCIaqyls3uyAoi0wDVzQT
         WdRIySkIUJYivmV3GK/2xUdLcOAw1rK2QTIl3xsOxDLUSLkQBQCaGTqAIsbIDdXXfNC8
         JVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957965; x=1758562765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjO8c3erZy4WXKRcrWjCp9sd0ML6yz3C8vPnthii1Gg=;
        b=elxAI3gajV9kq9RL1wFB/YHE6Ud0HrhvvDFjbCx+4vtK19GumMDNYijBP6ehCkItF8
         mrbwOrQUigvji5CqkWHZTslDMdRDrWu4uTo/3MaHi2y4IRbg2HPwDylzVfE0SstKlPKp
         1cujGze4FSrR51DOWVBQL4rO90OZ1JfeetY6JkBzWZMxxth7T4eOmucq54Ym9i45ew7A
         B2nrvKs95enulixFmUfwhpshhChfn4KF9RsrACo2AF3WoSyGLZn+eEFQFQuaZ1FrK6ee
         DWtXMinriQ7ejqifPr652lB7KGvjadwqHXeXw3dabiuBN7rG1xw4jhu2H8aGZQr0uN5T
         u6eg==
X-Gm-Message-State: AOJu0YzvkRoJ3gvt57DqNERFK6gqUqieJBWRVvdJUfYcScmGT6X/Pgry
	4y9ubp44iCDSnafNyuXAxzsi85OuIhYPIshpxQkw3qKjoTZYWORspxykqbaX/w==
X-Gm-Gg: ASbGnctpjvXAnqlspoi33QxvjtpPvipAq80FslMwM1hPXocisSvArSQmIUuKh0JkC5H
	wRJel5lV7ADH1nmxC2g/QRodcWbRsmO4/CM7NzeKnNF/lmyUSxiWlq31ao6fsAxAj2lvPLT6p6K
	5ryR6H9QuUxeFwt2hiXZkWBUmfo/dt9vaXDkds8wR1ilLpRTcZqtLFgheuJhTqAqJiaWV7DPgJ3
	iFTMMpkAx42KmxGjCmzPQ9lRgTFYr9QUkDMNV76KfeVHtlENUIBfaNXhv1naC/dMZuz0oCGu6vs
	Z2jTB4YMeStNGOE2kO+km6KU3XiFMrwbAJj2FUwRP0ZTk5oWtJVfJdeAOe9yl9UoCOTZqFa+R3D
	55JHk1PALlSebrdx7oEgWId5DsqwoIAvk0RDbtqSWhbMAx2LOFL9b4X/WK1cZw1saXhvKgaoYuM
	EOu1Q2K4xf0pqtkx9ngIf/jVTdZrDL
X-Google-Smtp-Source: AGHT+IEXdAH5R835Wn4s5rDwFLeTQE5WO+eEUlnI+tup0TgVLKXSQztq68pgrwQkNlGr9iOOqD5WYw==
X-Received: by 2002:a05:622a:4a89:b0:4b6:24ba:dc6a with SMTP id d75a77b69052e-4b77d03ee54mr193888091cf.38.1757957965395;
        Mon, 15 Sep 2025 10:39:25 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:25 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/14] lpfc: Fix memory leak when nvmeio_trc debugfs entry is used
Date: Mon, 15 Sep 2025 11:08:06 -0700
Message-Id: <20250915180811.137530-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right after phba->nvmeio_trc is kzalloc'ed, phba->nvmeio_trc is set to NULL
and the memory reference to free the kzalloc'ed memory is lost.  Remove the
phba->nvmeio_trc NULL ptr assignment after kzalloc.  phba->nvmeio_trc is
freed in lpfc_debugfs_terminate.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2db8d9529b8f..7c4d7bb3a56f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6280,7 +6280,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.38.0

