Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA26757FE;
	Mon, 25 Mar 2024 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406671; cv=none; b=kLVJvRfQ4h/vXC90z4dnfsP67OsCAvOetuOkycizPHkR70XFwwDBMZwAor8t/d56oRxenCPa+UcphEsx0z8gN18QVFJETJ82EixYG9oIIBpNKHGvIBHjmVEG2yYl2Iw++hdcV74G8Fe6LKQ+LwsQgeRVy5mF1U0O+Eot73p01Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406671; c=relaxed/simple;
	bh=FqAR+Ze93S0/wP3fz86mi6oEKKEdcwrhtvntMZJBRUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pxVJFq9T3x0OfoVj0fmB2V2VGtSdN7lhsRzHPHRMNO3puoxu3EQIh8X7wfPpwn61V3S25M0Dq8gm4M1vEvCxHWO8bmjNsahXcvTkQmG/erxuGmvACPV37V4bah3JgJ3a5m0B6ifHPsJ5+l7Zk3CnPD/yvVzLNbfKfR/3kMps+hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e0ae065d24so15733135ad.1;
        Mon, 25 Mar 2024 15:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711406670; x=1712011470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CEtqN21NPk7qVlH0grRm+VUsTURjOFZF7Zd8pI9zJjw=;
        b=BjHF/N+RrBiMnoBWkgHBGW/BWwv01v1QCfNNTu2BKq3jA4mv4X4umc4Rp3iHbOz57Y
         cuKYhRT5uLk+uFtzQZp11eFnEJmhLWD//HcHaKxCVYhAeQg2mEEOmBb08cxB42c62TmT
         /SZ6k6LQIkyEYTHIt8dGi0lOKFQQJc20fwli9eP+DrnEXaZrzbif/DbaIySmlV+YKNrU
         H1GxXzY9uDIXV9qkrNVNvIieDpMIiAbk5BWd2mRBAF2xtRKGQkWCR7GS/cgrPJNnUzTf
         7q82drVISFt/PQofEuvQs85jK+KySIoPSXUCciaK028UIF6laBmYxAn/av0QfWi+yqFe
         YbJA==
X-Forwarded-Encrypted: i=1; AJvYcCXZnPQv/YdLSJ/sy4E6xV6XNyxsMQIOvwAQtA0SeS12rfXa81ZQ7sl+A7KfBrvA5r3LutSt1oDjtjNulCmbvXrrCa44syzY
X-Gm-Message-State: AOJu0YwQ18hMDdtvoqHzNOveZlVwKIRCSFQ0XJF5S0Gd22tcsEj8g8Sz
	McIqFoYmnW0Wfo1l3VkJCbbxovYq51KdSoc3FRWVLJFVaUEQTzJN
X-Google-Smtp-Source: AGHT+IGLzWWDFm8F/FgdEDB5/LCuAo0yho0JjLmU+SbDhI+17aOgDkdinTbWV+kL0jt+13ujSADavQ==
X-Received: by 2002:a17:902:e80b:b0:1e0:a839:f2ba with SMTP id u11-20020a170902e80b00b001e0a839f2bamr7881210plg.58.1711406669611;
        Mon, 25 Mar 2024 15:44:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001e0b5eee802sm3268851plh.123.2024.03.25.15.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 15:44:29 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: core: Fix handling of SCMD_FAIL_IF_RECOVERING
Date: Mon, 25 Mar 2024 15:44:17 -0700
Message-ID: <20240325224417.1477135-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.396.g6e790dbe36-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is code in the SCSI core that sets the SCMD_FAIL_IF_RECOVERING
flag but there is no code that clears this flag. Instead of only clearing
SCMD_INITIALIZED in scsi_end_request(), clear all flags. It is never
necessary to preserve any command flags inside scsi_end_request().

Cc: stable@vger.kernel.org
Fixes: 310bcaef6d7e ("scsi: core: Support failing requests while recovering")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ca48ba9a229a..2fc2b97777ca 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -633,10 +633,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	if (blk_queue_add_random(q))
 		add_disk_randomness(req->q->disk);
 
-	if (!blk_rq_is_passthrough(req)) {
-		WARN_ON_ONCE(!(cmd->flags & SCMD_INITIALIZED));
-		cmd->flags &= ~SCMD_INITIALIZED;
-	}
+	WARN_ON_ONCE(!blk_rq_is_passthrough(req) &&
+		     !(cmd->flags & SCMD_INITIALIZED));
+	cmd->flags = 0;
 
 	/*
 	 * Calling rcu_barrier() is not necessary here because the
