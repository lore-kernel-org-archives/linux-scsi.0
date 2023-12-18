Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1752774E0F
	for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 22:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5bcfc508d14so3028065a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Dec 2023 14:52:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702939959; x=1703544759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izqRM2fIGr+MoNASx+wzsiMDBz3fSD5uGBcRBnpnCkU=;
        b=pVL7eGL1i7EqfIjn2gOAbxjbWBZFkf0HMLfh6XSIJsAp89H3mS3KvDfclkiOm9dQRT
         hRXMDVjmPkPpn9xoBSRrDoQCX94C2b6mUpMixgIe1UEgYUuIC1FMtgF00aeE+skygKcE
         pFBbNjPsYHPb62ndzYAZcyvzPlbJeLsNljA/Z1uFKUZ37J+b4Mq1r9thRHLJkjGKDQ8Y
         tlkpsPzTLMzflDbJtfUmFvdTZU3xaDzcUpqwilrvfRhAGKZG5Br3BB2szfdBmsgwALrP
         WZUk0rbmKE0KHbZUwKtZiovFnZkBDLQ+VecsuPGyVsKjB2sgbDh4mLyfxaoam5O8IZi4
         X5UA==
X-Gm-Message-State: AOJu0YwBgl4AqTC4/75pl7uRQLolv7P/cCzohATVrZ1wI+HAr20pggm+
	wNe9eFEdJB2lc3i0OpH8JOY=
X-Google-Smtp-Source: AGHT+IFY0Gc5UemXt0S3WN6mHRMFj+EjoAKCkS72bIv+ptxGJAmjIpUNMSiDAToQ+qMECZuvZ5kwiA==
X-Received: by 2002:a05:6a20:244f:b0:18f:f040:86df with SMTP id t15-20020a056a20244f00b0018ff04086dfmr18091592pzc.82.1702939959249;
        Mon, 18 Dec 2023 14:52:39 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:e67:7ba6:36a9:8cd5])
        by smtp.gmail.com with ESMTPSA id h18-20020a056a00171200b006d45b47612csm4078329pfc.89.2023.12.18.14.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 14:52:38 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix the error path in ufshcd_async_scan()
Date: Mon, 18 Dec 2023 14:52:13 -0800
Message-ID: <20231218225229.2542156-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

This patch series fixes a kernel crash triggered by the error path of
ufshcd_async_scan(). Please consider this patch series for the next merge
window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: ufs: Simplify power management during async scan
  scsi: ufs: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()

 drivers/ufs/core/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

