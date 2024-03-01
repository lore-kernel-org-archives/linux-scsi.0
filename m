Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4069310
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 07:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709276684; cv=none; b=cnKCJjIdx8fGteHjZjXqqbzgRgW3C6FAHF4GHepiggQZ+KMBF9vb5nrV30jhNboUnDCpB53ZXuBmMAdtxGUyYMuPokDTm912xy8aD1TbmlJCgVgaaRrVayRp2ATe6jV75fWomhv19tnP8Btrwx1ofpY9Kl/29awiUx7vMcn4Ax0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709276684; c=relaxed/simple;
	bh=o9pz1fk2aOp4FTnpNEe6vcQsleQQatyQgwaGbA6imWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbkQQynFuUlxmNf0/9Yxt7M9rKpRnei+Teue/71CMxBnNikdeLsR8oOaherFhwBeq29hsTpPb9x5WPVasSwKdijReExiIp92FR+Z2uRVn/FO0fDapEvsEBaI1IK3ZVAncdSJ3V8mu4FkJg0Wj7ARmqXUrBWpDRrLCrTzbnJ29XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=0Ak2i4vO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="0Ak2i4vO"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dc1ff58fe4so15479445ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 23:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1709276681; x=1709881481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6I9y5UTmAvN64WBQDc3/nGiscexf4NuEbldIfBdk9l8=;
        b=0Ak2i4vOzdAv0MP8yo+m3lZ7xbl3HfICbqJKOeS9d9HIBLn+UphKWhJ5gCaMHGBUEu
         QSE9i7OOcyu9dYkl9oxjSAxOlRirf7CZM4sTDmCah1/aIz8tNh4kRAS5YnAP1N3lfKPz
         mckq/T64wArfSq61QNUPOh+EK56Em/vn+2UhvOZJdqSCB6wRBP4Zkgdk633I9iuTs109
         x5omRlk/ZrsXK+ZDjDectUijBwwmqXbFpp0BCrZEjhYt8ylxu84vW/ucHqQ/KC1Rld4t
         F0euM8eZM+xYN8vzpY+pvktScKJ3eDiEbqN9h3UKXbncxGHxVeIUqyLOwUaTQ+Cq/L8/
         SNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709276681; x=1709881481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6I9y5UTmAvN64WBQDc3/nGiscexf4NuEbldIfBdk9l8=;
        b=T4jxe+nfTa7ezK53ujMIGwCoAvxU7slASxal5hsCCXYIwtG0qFV1Vn+5kdIriTK2IQ
         vJRAb+71mmA5mJ/aVrbo2CKYZllSxBdWyQPSc54jCspwusKh7Q+Ok3pkBTSySlNMS4tc
         wKpSYSUBPT+eaCXn7cbhTHyO5W80WLCZpWx8rQU8d51/O0qhlV8nbp7ehfH0iGRNkugV
         SrhG6JZyQMntLADWk9IB9x4yGcjw62M7ikmo/DfnFZfXIhehqBZsNX6inSXtcj7GGltK
         Sl6Q3DXRJUceqNj9rLPSSVELNOPvk7RzUpccuyR1ica0dUuLb/UnbDW7ME0YQvarPzU7
         W/6w==
X-Forwarded-Encrypted: i=1; AJvYcCXpvjCcZ3BtERwOFhYHcIe0cftiI/vAypEJC4ItHYqBiwaycDIwT9lusZDYSi/YtmGkjOY6f4Ba+xzROBLARORLZu9pbOUcCwPW9A==
X-Gm-Message-State: AOJu0Ywy73W7WDXAD/51AMNRYoNrWD3dc4l4wPmCGONRPjRvtBGSvJnv
	17TvELE6GY3A0L664yY9CBw8fxyi2TAHzX7cx++ne8MkYGpg/2WfarREPOzGb9U=
X-Google-Smtp-Source: AGHT+IG1evhX78/me7PET0oAJgA3nxqOzq5iUYRGdsuy0iEq8MCjfjuExh8MPjsu4Icqji+9or42Vw==
X-Received: by 2002:a17:902:c947:b0:1dc:3e49:677d with SMTP id i7-20020a170902c94700b001dc3e49677dmr1048143pla.26.1709276681293;
        Thu, 29 Feb 2024 23:04:41 -0800 (PST)
Received: from localhost.localdomain ([8.210.91.195])
        by smtp.googlemail.com with ESMTPSA id e5-20020a170902784500b001dcdf24e32csm1999601pln.111.2024.02.29.23.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 23:04:41 -0800 (PST)
From: Lei Chen <lei.chen@smartx.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Lei Chen <lei.chen@smartx.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: make module parameter scmd_timeout writable
Date: Fri,  1 Mar 2024 02:04:21 -0500
Message-ID: <20240301070422.1739020-1-lei.chen@smartx.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an scmd times out, block layer calls megasas_reset_timer to
make further decisions. scmd_timeout indicates when an scmd is really
timed-out. If we want to make this process more fast, we can decrease
this value. This patch allows users to change this value in run-time.

Signed-off-by: Lei Chen <lei.chen@smartx.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3d4f13da1ae8..2a165e5dc7a3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -91,7 +91,7 @@ module_param(dual_qdepth_disable, int, 0444);
 MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
 
 static unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
-module_param(scmd_timeout, int, 0444);
+module_param(scmd_timeout, int, 0644);
 MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
 
 int perf_mode = -1;
-- 
2.43.0

