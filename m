Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5A149DFA
	for <linux-scsi@vger.kernel.org>; Thu,  8 Aug 2024 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723121867; cv=none; b=rTMyAJnplkC2hH+OezImwo9g5A346xhVnggYf5QUQgOM3/M9DNMYGCgOHkL0t6Z3hnatMbqiEm7YoBFhm27POj3uLS7uzk2LR6guDuUjsSkIeOJpJbOrxTHmbd0fDxgNHLNp84j9VKvqrgPcbZKu/MW1D0xY5AkthJ5ap07BOLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723121867; c=relaxed/simple;
	bh=9tSkIyDwr9yjKeq7U46n/Mz4NfmutFCP0YNPt/kJMfs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BIDIyc6NBJQp9AAWuLQCxoGUdvCmbeQshJfhXNPUXDu3GVF628J0Y6WPpP6++YWcYDmsYpO4y0CPVHlV9sQ2XV7a3M4gVNqa6/mfJLPA3TFZ0mdSs00RjSOyFh+EnmMnaxtJ+eNH6/+P9zTrpUG1utg/YaYFcJCFjuyW7LAiLUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LZB8kLRJ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LZB8kLRJ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc65329979so9521395ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1723121864; x=1723726664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JrX4akE5L+R3pCgNOMU+iWt7qu5j4qMSKzBrXpAKkqE=;
        b=LZB8kLRJb7rZ+Yst5XU5PjS/R8+c9ScgGs/iVU4TEtvLlx5LPzAp5yAjvoebyTIaV0
         YV6+rebNtXPGGauVvYC2vrqlkUOYLFnG0NIUmiSX+gdrGjpQavyRTt4QwSWWOaOUEt//
         tB6yFJtDjLFsaMLj2iBPc08Vwl8R4RgUDd0Hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723121864; x=1723726664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrX4akE5L+R3pCgNOMU+iWt7qu5j4qMSKzBrXpAKkqE=;
        b=YoRInRYSUtGxZyiNUUANwS4308KiB7HkEdQ89mg4OAVsGSNdkWRFv4B3REnBpK65ZR
         K6U+YWMMECsAdwfoxbmMWa77eAa4LbuGyot6Txu/ATGAtj8fOBEp6x7PGvCnUPLfuSVL
         jXtBsBUHqa7TFv7xvm5jIq+m5bHfq9bqwYEepcEUXpTwOP9QHF9cxXaqYxqUTtMQ9VTK
         v/AiiYRwynhOf+0SWpolY9PYa+pI6q5i0UqtNP9EOfb9q4TfwNiM0slHhHxND2P72EEi
         UmofGHI9eE5c0C1YOFLJ/u8igHzT+r/jMiUSmpZ7uVulDpv25UsOOU1sDYfWe5TH6rd1
         s/bQ==
X-Gm-Message-State: AOJu0YyOVKPWtfZlibmo8M7Wj9foDsw6E/jnpDiOcSYKO00K4uYKqyAh
	Hs6SdnFMjhu69jdAoyePmT0Ht2a7VZ6lX0Ufl9pKeKr7GRyYC9MwD8q/iAemHWycCCIZA7Klycx
	7Bu/805x8StkMHsxOL46g3vj3Q85jhOCUGB+JYWFG6VaOBa1qmM5o6gXIT+OoB8hyPPObZy5Roi
	CtX6aeLvlmxaiFFDXHe1PZWroQDUO/ihpqcPrQGjNDHMDFkA==
X-Google-Smtp-Source: AGHT+IFumT2I9kkjvlMfSlaXbByd+N61QuGfXoN44+hx4PBZR9fELU1SJ6LXuCkOihiYqk+63MKwtg==
X-Received: by 2002:a17:902:e80d:b0:1ff:4d66:d7bb with SMTP id d9443c01a7336-200952635a1mr18843415ad.36.1723121863983;
        Thu, 08 Aug 2024 05:57:43 -0700 (PDT)
Received: from localhost.localdomain ([115.110.236.218])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff590608b2sm123283325ad.152.2024.08.08.05.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 05:57:43 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/3] mpi3mr: Critical bug fixes
Date: Thu,  8 Aug 2024 18:24:15 +0530
Message-Id: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set contains mpi3mr critical bug fixes.

Ranjan Kumar (3):
  mpi3mr: return complete ioc_status for ioctl commands
  mpi3mr: Update consumer index of reply queues after every 100 replies
  mpi3mr: Driver version update to 8.10.0.5.50

 drivers/scsi/mpi3mr/mpi3mr.h    |  5 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 32 +++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 9 deletions(-)

-- 
2.31.1

