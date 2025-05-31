Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E012904;
	Sat, 31 May 2025 05:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748670426; cv=none; b=JtitpLWgR70yRtJbi7pG5nsZyn/qPHNiOo7/Ojeo0wYgrxY0F70v1gs4v8K5rEjUboqIpa9tsrQAGqXcr20uR6uWgktH3WP0mzTMK2Zy68HL/aM8STaChC1x/w92vJjftgfniJv7iVSXWGymAp8mga516iTTDzbwzz10XDn0lYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748670426; c=relaxed/simple;
	bh=JbNwRxu6ES9byNr7PuccOmWVvlaqcsF0OW6OUJs+kx0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oiVc6aLHhMDEzNZfMtSjtFms+77N2VYGn+7GRgDaSDp676rXQOI6BPaV9ZlwxhZ61V5nRtpLTUrddc0xPX4Er/OHnY3z6DjLs+iXkHVY+Q/Ka1yN8f3JyiJ5wdFTfFAzStSCj33ts+uEp02YiFfmKvu6soEG61hsthfSEf00r88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OL6e8jPd; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OL6e8jPd"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso1985393a12.2;
        Fri, 30 May 2025 22:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748670424; x=1749275224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8OGAFuidSbukLHWdGtaZwvDWia5Iygcwni22a2YUHlo=;
        b=OL6e8jPd3YkPMwdpJvW1mPBvS/OYWj45lBiSZxycWSTi+BwZF6TXtvszS6R2su1yPH
         Sne3KoaBUFoimkCbceHMuLOB+SJOzW/5wKuJA7NgHChb0nvf99ff9EAW25N45VQk12uT
         1f56GFrQHoOpb4nO91avj8P+a6glo9FISTyHlP3TPI21r7S5dDXjb6dGTH1d0WF0UCkr
         YSTTQFwa7f/BjsLbSdVov/h6HJ7OZoBbAPZX9EOohihnKsafC3AueX2NXOcjq4PaBB2t
         3k5Xwr1JIx8f2TT6jyjLjVmTSyJhbliTCPx4wcxn24rZbMJNiZwR13LKq12eaBKMfYqb
         1Qag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748670424; x=1749275224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8OGAFuidSbukLHWdGtaZwvDWia5Iygcwni22a2YUHlo=;
        b=cFCzSKvzHcrJpSzWsIsjY15Oj3Rd3KXjE346C7Nq5J4HIAurpDztYjxZ79qUp0le8b
         Ty1STDYXup9YNz/FRnY5po/EMK0qG+QEtG3w1sNI0g5oo2ZP889RJCBmPSHxIvp+qD7J
         280iZyTGOgIAXtgQTNENmD5+pVphlo+5zUSmlvAR/kWAcicbK94CZdOMnmsKMhdILs6E
         HFQTYqDksYMFx7Y0UB4wnkSsjKSdI2N8UW/brJjlfLB1lRjT65ZQiLxEFnD6JDsyJfVc
         IlVxrdDWuaHgqk0bs76Ukdm0vj5u77XP4l9PG88c6s2OeWW/3s4N3mjKq6hAzYGIZA9U
         EbvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUuySYIgUPemlXTgWmfTkdinPhlWXbwnbLFg3LBlelGMDgAlsM/pseb8HTT0kDGH3j7EEy1GVB97/bkl0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjf20/2riw5a/kH1mSPnS1yKN2gAxScYx4Tgo7jninlyOTXxH8
	vRg2Bd24HCs1TB9lla1Kxn5kegLP1B8pzteY1whxy333nl1Or2jDqS3C
X-Gm-Gg: ASbGnctVb1HH27HtWcaJYfdZ3ik+ZOntt57UeLO4PkF6PE07G9MYq+5D4/a9YpCU1zo
	l/H4edsjcuLJjhEnXCfNs/VeRNso5O6mM+d1pDtviyOVSSuqP/Kq6uAyKMN8xcu/Is7oMUrFR8m
	AfEXVGYjR/7wrhdSWEjK8gp0Ej8nA0zETG4DOod0+Hnn5IQ8HfHStdfhPFNjsDomYp2fG0OinfB
	O0wZHG0F76SR0E8yjEFePwLYvQZY7FTBZyniJiMLy9ct9VlCpstYN+IYNhN6SHplyX/r7pyGPMV
	1GdQS0Ac04mAN9z0PK+024IX9ZtTe8ckapNEpizhgDBhuXkCXb5nvA==
X-Google-Smtp-Source: AGHT+IGyWRSq+5WawuoBQZmtBHPa+Z9VMl0R7+h9hZwLBROsZRoujhid1b22ob6LRl9WCDnAOxykCg==
X-Received: by 2002:a17:90b:3a0e:b0:311:d05c:936 with SMTP id 98e67ed59e1d1-312504137e1mr7645912a91.17.1748670423827;
        Fri, 30 May 2025 22:47:03 -0700 (PDT)
Received: from n.. ([2401:4900:1cb0:cf24:5234:d645:6525:6e8f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3124e3c11e0sm2062427a91.38.2025.05.30.22.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 22:47:03 -0700 (PDT)
From: mrigendrachaubey <mrigendra.chaubey@gmail.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>
Subject: [PATCH] scsi: scsi_devinfo: remove redundant 'found'
Date: Sat, 31 May 2025 11:16:38 +0530
Message-Id: <20250531054638.46256-1-mrigendra.chaubey@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the unnecessary 'found' flag in scsi_devinfo_lookup_by_key().
The loop can return the matching entry directly when found, and fall
through to return ERR_PTR(-EINVAL) otherwise.

Signed-off-by: mrigendrachaubey <mrigendra.chaubey@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a348df895dca..53cc60ab6dab 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -269,17 +269,13 @@ static struct {
 static struct scsi_dev_info_list_table *scsi_devinfo_lookup_by_key(int key)
 {
 	struct scsi_dev_info_list_table *devinfo_table;
-	int found = 0;
 
-	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node)
-		if (devinfo_table->key == key) {
-			found = 1;
-			break;
-		}
-	if (!found)
-		return ERR_PTR(-EINVAL);
+	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node) {
+		if (devinfo_table->key == key)
+			return devinfo_table;
+	}
 
-	return devinfo_table;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
-- 
2.34.1

