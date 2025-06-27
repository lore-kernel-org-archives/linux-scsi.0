Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D102949F3
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 19:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053856; cv=none; b=thL3HeUdi2NhhcnWPzHyD0xHgq7IoilI1OP8XdxfSwnJ4URLKRiifNuXaqt5gCVC623qbV4HBPPn/Kw8caPhTIAb9mjyw2aqaURrrlS+HaZ5TL6FvH9mRHp8IZ6Mi4EVw7bZMqgfSwBaikFNunmGvtn9rB+kNN3fJm7dN4InfkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053856; c=relaxed/simple;
	bh=7scot/otsCZWfhionpx+oiUHlFeRZLTEHjzJBT1mbDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RbgNGpwPRQnH+DU7iIl20+mpsVce5zYmT71kmps5IvwwGqQ6D+1E/rJt21wR9HMWMXM+BnnNvlgFi/PhgyEMcGE5Cmajjq8pWh6NNtBm99I3NLO76UKlCAD7dgIyFc/Kgc2dRuo9wK27t4amhcgyjDjNG/6qDhawr7o52D8RRZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Z70HelxP; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z70HelxP"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af51596da56so497690a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751053853; x=1751658653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrAr7GxdF6AOrkM/hv3ArFP9XhZfc+XhzG/M9Z6/0SY=;
        b=Z70HelxPj1NbxP5R/A0gzu85I55V8V8wUHQrhRo2D8eYADkX7bvJeSSGI2CQQqsOJ8
         eceL+YPtaKEkcOhlpEOAOm6AdqFkkp8hqyVse6T1N1+MsOECldQ6rVVlhFRZfX6k+Nix
         5Ch01XYRJgK7iOnfIX6mQBbCfptMd0v4WVAD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751053853; x=1751658653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrAr7GxdF6AOrkM/hv3ArFP9XhZfc+XhzG/M9Z6/0SY=;
        b=IFbS053yDsAu+VMOv4RE3iJU4+WE+JS/UgCVGsxgGdPp0BDoYtEW5fPlR0C6Y+wCTr
         B5uIdp8GrA8t3Em4ivBY6pYJD8rMOrgbp0ZIuzRrHfOXJxGvC5WHFvr5JxDPbJAwKBS8
         qbwkjiaWpRB7iMDNw8/QPGXV1c32PGi+ZDCQTbN1/qdp0iJ+jnVpPt2UbwBpCdX4w4NB
         ycur2XWTEFhKulCgJMtk4WlKb58s0wlrkgopTspMXqOP3ogES4bNX9QZJDJ67vmiHjWR
         ejXiE0EhCLWs01q4ck319pbnLN0CV/xx1WgJrsf/cGyRNRUf4yO26I06Zr5i//lQqGTX
         gEmw==
X-Gm-Message-State: AOJu0Yxbzfnf0nSw8+FzM8ihAUUfaaUGAinXPwPX8naWr4wSa9ojXwEH
	yOiyqpNr4LqFEBUQsk9+gblbyEv0P4c3wDbDZm53vg5cK3MIq3Pl+q4bdKpIGJ+gx8hwF5gv5OZ
	rC6L5E90+zL2DFTYCCACwbgjv3qd6zz2zlhN0noonYYEu4KL7NPVOg8LSxfL+aBSIc0ALXnkJes
	NwczyAqzaCWveHCkgr0RTYoQyCNVvrj0aoZJ5rqVL8r/PqFVJepA==
X-Gm-Gg: ASbGnculWNSi+AAfBqRFhCnQZoFbQP+LX/pHUn11dXJLGLqijSBh1kkY2XSfGSfRnnI
	H86r01lZOpK/wDzRv2/80TxS73WqCPjeOO2tw8BPbm4KZyLtyIgfWKWP6PrSvoEMhf0xG/Fj0v1
	A6MiwD/5EKCyd6QgbEuYCBQQ+TPT391eMF84Dfbv1AxvcPnV0lgonyMDvXgayq0w16gsvZIVoRx
	VIxCJuar6kTBpU/c6DQaP4eV5OZp+OTQSBE9bcH5Ti8zG8yMWL07a7DwddxgOFslWINEzLoFFLw
	fkuzqvhv9V+0bgDUkqjaaOvkYzi1x1Tq9dYb735A2XN/h5CfwgjGdhF5VtDWDBr+KUcujNTMjuh
	xpbOoCZr/Wf5l311kmbK6XmtJljPruFQ=
X-Google-Smtp-Source: AGHT+IFA9T5q2PuUq6ThjccrtRNDleV+A/eLjWeXBPzrH7ODaHqabMYPpLpcKYeRv1116D0Or1OgFg==
X-Received: by 2002:a17:90b:3b47:b0:311:d670:a10d with SMTP id 98e67ed59e1d1-318c92ee549mr5632581a91.26.1751053853339;
        Fri, 27 Jun 2025 12:50:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f247csm23485175ad.79.2025.06.27.12.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 12:50:52 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v1 1/4] mpi3mr: Fix race between config read submit and interrupt completion
Date: Sat, 28 Jun 2025 01:15:36 +0530
Message-Id: <20250627194539.48851-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "is_waiting" flag was updated after calling complete(), which could
lead to a race where the waiting thread wakes up before the flag is
cleared, may cause a missed wakeup or stale state check.

Reorder the operations to update "is_waiting" before signaling completion
to ensure consistent state.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1d7901a8f0e4..0186676698d4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -428,8 +428,8 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 				       MPI3MR_SENSE_BUF_SZ);
 			}
 			if (cmdptr->is_waiting) {
-				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;
+				complete(&cmdptr->done);
 			} else if (cmdptr->callback)
 				cmdptr->callback(mrioc, cmdptr);
 		}
-- 
2.31.1

