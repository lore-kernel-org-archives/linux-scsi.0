Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA95D1FF7C8
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762518813; cv=none; b=nsdjifi1jq33h7MKA2IXsrVsD9XKu4vr9B5G5mAJOZTXkrfOm9W6agk2CEuReKVa3g3xcxEhLNaQCgqa/zajgVWUEqLf8+RvzJaMHnqMEL8qFzUoZ54kDbjbpF2wyu38fpVpXQUOqzVoJefKNNkqUbkbGjyIRPovjSuDRanxJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762518813; c=relaxed/simple;
	bh=5lcnyf06aV0IL6EQb9F8CzVHgFLLL8ViHujqnpHB5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WVS73t97BNNTq62LQkXdAFKu0kjyJSbIvaPSfl39CQ/P5ROZudkuA/wkiKhWPe9rWgRfkRggo1AscW2J3J8XdfHHkgZ++xKSGXgZEVSl/zWyiwnfnI437gLBm1u3g0NAelSSyxX1rTA7BPUCjxzN5OEfcblsM0m1H6CUUYS8Ico=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XleZ2MVw; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XleZ2MVw"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29524c38f4fso8306455ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 04:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762518811; x=1763123611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2wFg4sEi9OuCa1c0qwdmYGRON1nIlfIlliXKoJp2VYg=;
        b=XleZ2MVwOJTKC6W/6mfrsL0h4LHHxq7EMz1xZPJCRrKlj5ohCvU6n39MSWybzmvR94
         /C4LCtGf4+MYPLiPHC2G039tk3mRa0A/qPiv6qgCNRfaOn5HzXOOSiiujeTBiHF84Iq7
         7uW2xu9EScGNHImdG419IGhCGYgCF+AJ4DRPb1CRGo7SA5UsgZAbJFZKFdsNjqcWKOEo
         WzygMvzpE863js+3GcvPAJ9bhukv2jJ26siQQYD0TdnG//Np8H4SnX8DNfv+O1NeyW5G
         ll5Tr0j+4oEtUNtiKkbl/u1YB77N92WUIpqVw3JQeOuQq5YcYHb7Y4cEGn5PR8wlrXL8
         NxLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762518811; x=1763123611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wFg4sEi9OuCa1c0qwdmYGRON1nIlfIlliXKoJp2VYg=;
        b=TEG0OPNqLcJrCcjSzihFd8H4B4+NTbbx9lJRoYvw4monLeWVBuSR5I3vXvVLDGffTU
         ddkb3A0rX6XIRunyXGfDGFlr3qvTGKuhxJG8s01pBT2JJszK1BEulWQWtfvB3U0BxF4H
         VsJr7qakha8mVjUb7+tGDOUgXQrKFKmMRoWyTS0mhfC9qCPCL5V2HR1bDJt7NJMb8Dhk
         QeE6NrNfQvu8cpyEjAX4HcCW61u9nYH+Lj+PLgdAhuDsi9V9y0S8xhRJF6Q4NQ1y6oEp
         JHT4Qw4D4wNtae5szIXNqZT0HWY1FtJyM531zyxLX9OvwhPItWfM21KK80mXWa6DlJf6
         xoSw==
X-Forwarded-Encrypted: i=1; AJvYcCUFWnbCR4b1inU8b0yGRLCeI5pXxxlRi7UNuRrgLq2n+Rnd3OdkEW+cHZXbfa0+iaQrREcEJvVefdfr@vger.kernel.org
X-Gm-Message-State: AOJu0YzLwM2zOPrSyi8xa40CmSxgefElIN1VCfmtACLfX/h5f6oM2CID
	T4IWDD7MRR7lrYWqkQfeYDrfp9hUKsGPAOU9VwfV9apgA2E3sO7FD2gr
X-Gm-Gg: ASbGncsUUm4NKgB1AbjEgOJ+H1+9kd/1XiCjLWbtf26uICXMOfmfyUNFCkdGZOWhXV2
	/hTZgub+29/dMlSXmJknlsAnm39ol5ih+G7fAzOKiiFRVvCo1kZAi4HAdu/Bfz6PInDiwWhHdSq
	IcWm1ru/PfwNhsVJ5nzr4QtZjEkPAoQinpvlTmHDQyqzDkuQ1WnepSkCcDJq7RzZUc47UIwguMy
	qEYQnusuXsyXHKHGqt7BaWO5N3kDGVDhNNOKBXOSMU46Ihp/MMGOFh75KWkioZUwt4KVBUpOTo1
	CZRXxp4Y/hadSLuLaL2/iv3+G15+4oa8LYl1FEaUDNClSRaUpDCZteuNKx9RCRi681t+tQB1/Vc
	HJLSh29RjNXwL0oJThsZaXjKYVDpiiJ+1lNFW9fHJ0fMIOJ05x+dX8AuePrri/SZdLSgDXgelup
	8wDQuhIOQkJ21yjRM/WB3daTx3CvtKl6Azhw9XMXNivyR3thVXWLFGZbne/FnmKyk=
X-Google-Smtp-Source: AGHT+IE7z6KNZTDs+X3lQn5orUAZb91cr+qoIc5amPGDhp4Mbj7m/pXX02bL6DNNvigWgocoVupEPw==
X-Received: by 2002:a17:902:ea11:b0:288:e46d:b32b with SMTP id d9443c01a7336-297c03ad66fmr43022505ad.17.1762518811194;
        Fri, 07 Nov 2025 04:33:31 -0800 (PST)
Received: from SIQOL-WIN-0002-DARSHAN.localdomain ([27.57.191.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650968269sm58959735ad.17.2025.11.07.04.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 04:33:30 -0800 (PST)
From: Darshan Rathod <darshanrathod475@gmail.com>
To: linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Darshan Rathod <darshanrathod475@gmail.com>
Subject: [PATCH] scsi/arm: Clean up coding style violations
Date: Fri,  7 Nov 2025 12:34:34 +0000
Message-ID: <20251107123435.1434-1-darshanrathod475@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Addressed checkpatch warnings by separating assignment from a conditional
statement and documenting the empty for loop. These updates improve code
clarity and maintain style consistency.

No functional change intended.

Signed-off-by: Darshan Rathod <darshanrathod475@gmail.com>
---
 drivers/scsi/arm/msgqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/msgqueue.c b/drivers/scsi/arm/msgqueue.c
index 58115831362f..7e09624e5505 100644
--- a/drivers/scsi/arm/msgqueue.c
+++ b/drivers/scsi/arm/msgqueue.c
@@ -23,7 +23,8 @@ static struct msgqueue_entry *mqe_alloc(MsgQueue_t *msgq)
 {
 	struct msgqueue_entry *mq;
 
-	if ((mq = msgq->free) != NULL)
+	mq = msgq->free;
+	if (mq)
 		msgq->free = mq->next;
 
 	return mq;
@@ -99,7 +100,8 @@ struct message *msgqueue_getmsg(MsgQueue_t *msgq, int msgno)
 {
 	struct msgqueue_entry *mq;
 
-	for (mq = msgq->qe; mq && msgno; mq = mq->next, msgno--);
+	for (mq = msgq->qe; mq && msgno; mq = mq->next, msgno--)
+		; /* intentional: iterate to the msgno-th entry */
 
 	return mq ? &mq->msg : NULL;
 }
-- 
2.43.0

