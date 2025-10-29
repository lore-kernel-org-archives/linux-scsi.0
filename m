Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868192DE6EE
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761823; cv=none; b=K5gttuejEkHIW0DLWGAiFA2ozKPvsHLqUbBbywJnF6J57l+GXVMZrOmOYtzrCpHkj8e39Sq++iATxOBSvt+mRO6zK1uXw57nuBsSFlbJsQ2F3Tt3dv8PnnhbfrQqiJLjHmJY6XSq52a0eF5KSzlrB08lPCx+onn1z2viCRxaBi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761823; c=relaxed/simple;
	bh=826f7syER6CVjG8tgWNRmzu2cg3XwS6Sp02SDx4qrvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G+jUKkLPYt51cdsPLlAUpphIpgkUSyWReeJvAy7YuliljgCLYtbfeRYZQD1mUvyEE7K4Eyyg67BtsugNG6fXD6MpZ/4RbJQJYOTdpbbCfCP1jauHAMlvZ1WpjbyQXYZLQUu1FkY64PePmIi7kkWIHUHMtIknvm8T3ZFn/g8jckE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hOkzUOfx; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hOkzUOfx"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3404db5e368so56872a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761821; x=1762366621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyGgq/r+aDPnBVe7k8CwapG3DKnUYOYn4VkxR9lDhsA=;
        b=o7HgpkQq2KbPkClrc5sr48L/xPU3qs99edvmzJMZGusElB7FRNQQ6QaJKL3fBx+KXp
         yGeYpWcHWO91sSnOWCMIXRvjl4+3kEJV31CIXcoFCfpHdjpkSUNLaPBAVCd1jteuhzKe
         dfN7iLl9As67OXnt3b/WMLUOtqGBk9Xu0Nlsw2SiDTX5gnWZ2hNjqLux89ZGbv0n4TNl
         X+w2FUitrxzc1fyBI+yNS0CO4uKf0GO+ADEBD79CjRQjhSNHV2BYQMsGtyP4aC77Le/m
         8KzqntyBUI4PMC3WUGTLsENNesDl/MbAtiEWr4OegmB3ZDq6fjRu7ogCDLG80wH3I9Hx
         wdFA==
X-Gm-Message-State: AOJu0Yx8uGyv7iasQDpg1jEJ+zXEbCflVE3dxm4D7dMIzXwTjAd9H1VD
	OJhO44gqSg1IjT0+HhNSqCs4YLdwqYmoQ6JYIv3uUCwlfgm0Wp9P+cAFJd5XKBk5ndglW4xg29k
	Pj/EyqvJ/6d09c8ucJC7uYGzwkqWlbOP0GBrSolZhtU2H/lmA7mt3BY8i8ThErLYX2f+FAecIvi
	HyrQw682JSJyShbgZih20XuDLSYLNG9OQ1wdRYkeZNbb7TqZBErP/Us31+7U520l/yE6Bg/RGuP
	qSEg41HQfS17OCc
X-Gm-Gg: ASbGncu7Uks2qx2LMu27t/Mg4C0/Fqt4BZpKQsKK6N/AgoZqE/lpmgt4O+4C+LsYyNI
	FBb+6Clk1nQgWcKNKLgqsN+0h4+q8Rj4ZUVenxWClVWMm8vnc0nW6uURLauzbSDP5746Cb4Zz9t
	N7EIksJX0gTxdwsYDkK6zWFP72X+Pa0N8+fWTn1YdqSz7ljuN45v3aXhWAX9hBCG7mFdOXSOqyQ
	K6aSY2H16sDjn+brKAhbsLwaDiOKgi3WoMNFel/6CkwFh4Y9SVK+SxNpOnjVmgTmuXKSWzqjrhs
	c7cgFaxqcYVGiuxJs7rAsPFT7rpdtsvms/Z/PpD+fYn3++Zx87e+t7f/ef2BQIIEIrua8UoIxFH
	eGWOThAmyAq89ptEDXk+ef66ldTm1kgXahKaiu39DWe7Yk0UnAh/BUVQhQQrGysva57D00sS1Pv
	0Ti7gfPsDUvw0cAAagVzO6rG2p+6UvqoDbhgXQ
X-Google-Smtp-Source: AGHT+IGU9PQYeUD4I+NHIjzMqw8cRKQ4qRFS2A19JWudyOcVH7qGrhWdBvbAKDnVBSVJ9dnWt79wnihuXriv
X-Received: by 2002:a17:90b:52ce:b0:33b:ae39:c297 with SMTP id 98e67ed59e1d1-3403a1581a2mr5038938a91.16.1761761820840;
        Wed, 29 Oct 2025 11:17:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-34028fd2197sm181600a91.0.2025.10.29.11.17.00
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:17:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso120444a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1761761818; x=1762366618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xyGgq/r+aDPnBVe7k8CwapG3DKnUYOYn4VkxR9lDhsA=;
        b=hOkzUOfxtegjq4G2Q4+qeCYuYZcyUWInOcqj+El/N9hTSCPQycoW+/pSIbMW8YcVTD
         asUZmTo/XZer5dujLkLLnOwHPUY0k+0gVVTvhGysWUcrDtJjIEB+ym6QxMQBtv4+KaLZ
         +c+ZFHOgRmmmEN7gqwDWWmqwQvtnQuWOzPh78=
X-Received: by 2002:a17:903:2a86:b0:288:e46d:b32b with SMTP id d9443c01a7336-294dee2ed04mr47628025ad.17.1761761818164;
        Wed, 29 Oct 2025 11:16:58 -0700 (PDT)
X-Received: by 2002:a17:903:2a86:b0:288:e46d:b32b with SMTP id d9443c01a7336-294dee2ed04mr47627555ad.17.1761761817529;
        Wed, 29 Oct 2025 11:16:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf341bsm157284565ad.14.2025.10.29.11.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 11:16:56 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/5] mpt3sas: Improve device readiness handling and event recovery
Date: Wed, 29 Oct 2025 23:40:44 +0530
Message-ID: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This patch series enhances the mpt3sas driver’s device bring-up,
readiness detection, and event recovery mechanisms to improve
robustness in environments with slow-responding or transient
SAS/PCIe devices.

The series introduces optional control over issuing TEST UNIT READY
(TUR) commands during device unblocking, configurable retry limits,
and a mechanism to requeue firmware topology events when devices are
temporarily busy. Together, these updates reduce discovery failures
and improve recovery reliability following firmware or link events.

Ranjan Kumar (5):
  mpt3sas: Added no_turs flag to device unblock logic
  mpt3sas: Added issue_scsi_cmd_to_bringup_drive module parameter part-1
  mpt3sas: improve device discovery and readiness handling for slow
    devices part-2
  mpt3sas: Add firmware event requeue support for busy devices
  mpt3sas: Add configurable command retry limit for slow-to-respond
    devices

 drivers/scsi/mpt3sas/mpt3sas_base.c  |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    4 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1459 ++++++++++++++++++++++++--
 3 files changed, 1370 insertions(+), 99 deletions(-)

-- 
2.47.3

