Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57901A264A;
	Mon,  2 Sep 2024 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725288703; cv=none; b=jgB9mu3Vp7Y6C86OvHLeG+DjGVNknKyqtrf1yj2gHEnapWp8zGgIvhrQAqIyLDAj2CuohaPusUAwd7OIJ50H4adcaYILnRJhRcOsDGKClqEEASikwojxyg7et8ojoaEK3rcetY7Bx0s8UlHRIhczfeALTh7Ck7VcjH/FHpetzEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725288703; c=relaxed/simple;
	bh=1Wx2Cw1GJMtzjIU650b2+0QUXSmQLlqUGHfA8UPe8zc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oYL+yiZ9B/ImnOMW2cjArUN1C1ALZlzagNeCy4yDXT5cj/XB+p2y9YLJfelpD6PPLpVbwkb8BTyOOu0JBDxiwckmix58vTIRSxb8cXxeiP2GaHOY+Pe8ST51K69kPODut48Rfn419nP93FEPFp+J7KxrOveBHs/VEc5Yfxmg3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXH0xMQ+; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXH0xMQ+"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-427fc97a88cso36279205e9.0;
        Mon, 02 Sep 2024 07:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725288700; x=1725893500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pWy1TN1RjyZU7+CTS4hGkzmJa7pKvcHrIIgV7YhlkEg=;
        b=nXH0xMQ+HxfjfSHbNfHSWNuakFBxRcOD4FE/7FAaHeEmx/1dUbhqDRiZBKxafeXtXh
         3zHR3rgvhLtlq+e0aUJ+FOOLhH+fDs9lR9h7B30a20xwHWy/F9iFboSgM+BGO1gHQLu+
         2YUY1QYr71G22mm9spzCltP4hNMw63d1225E1RPd/kNlK+nEZkSCcLJ7UNxbEYGTo8hY
         IwuQ0MbD0zPWgukw9IL568RsMPGIS5yG6LAH0lCdTNtnTzBZnUKtwUALGqN4K57cudS5
         7aGIS5mYUvLFzxHIe0p9TLZYD6SMh+Ijj6XtaGKqNkenembhmor4K9j9pm1XdMefjKl+
         Lpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725288700; x=1725893500;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWy1TN1RjyZU7+CTS4hGkzmJa7pKvcHrIIgV7YhlkEg=;
        b=RDLcPFAwtLKO4rbbYvBmeyAuLE631eonTHlZSSh/7JU24cIsE8r1Td4shGMpRbikqx
         +0cmUY5wiy8yqsmG27RWGzeCSPmLao3tam6EFIt3ifqxrczgSn9xXKoto9KSwap4DKsO
         qoUtips6XL+EVmvctrfmo2I0AcQ/u16MoZEk5i3fJVLi3Cec7ND9WwalFnXW8bNvrbaI
         EvFOKzRdMM6q7jJH6lBZfcJj4m+9i59LYNqXsmaC0AWKBnpU/mOGm8/5tMgUeAuvY75c
         umhXnpSQWydnTXFbZ/cAJhuz6+/lK3FpjIihb9pZEF4xokoA18b4NH1MixqbqgbI82w2
         7Sbg==
X-Forwarded-Encrypted: i=1; AJvYcCW/2442+Lsoi6AL+cTLYnvWxLeiq+v79ThNXGnL5XhSprsPPRNA4xTxwUyLazjXk0g4VvSYstBHITtT/w==@vger.kernel.org, AJvYcCXcpNasjBDQZvOQZM9RNxuyUbdu4rUo7VYgn4hHE0az4J2KEXZb8Ivs5zjXhP9B+7vaTS8BMfq9ObM9t/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJGMDU5BUOxsaI1fSLRVxNN4C8AJMGQLIflSuQeII8jGH4zs67
	wZ2Ep3NYzPI6rGvApzYgEIZpR4dQg3kCcoVuejhjUcvOVC5eb9u/kIVzGb3U
X-Google-Smtp-Source: AGHT+IG2OwSIBFDA89MpTwPyc/W8W3HqF7rnDHUKbOfHp37hVdVkTdMvccymGdDzdCFZWuNLDki27Q==
X-Received: by 2002:a05:600c:358b:b0:426:6099:6eaa with SMTP id 5b1f17b1804b1-42c82f673c7mr23775565e9.26.1725288699662;
        Mon, 02 Sep 2024 07:51:39 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6df0dbcsm141233895e9.17.2024.09.02.07.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 07:51:38 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: qedf: Remove trailing space after \n newline
Date: Mon,  2 Sep 2024 15:51:38 +0100
Message-Id: <20240902145138.310883-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a QEDF_INFO message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 054a51713d55..fcfc3bed02c6 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -310,7 +310,7 @@ struct qedf_ioreq *qedf_alloc_cmd(struct qedf_rport *fcport, u8 cmd_type)
 
 	if (!free_sqes) {
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
-		    "Returning NULL, free_sqes=%d.\n ",
+		    "Returning NULL, free_sqes=%d.\n",
 		    free_sqes);
 		goto out_failed;
 	}
-- 
2.39.2

