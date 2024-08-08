Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3999218C925
	for <linux-scsi@vger.kernel.org>; Thu,  8 Aug 2024 12:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723121884; cv=none; b=TiSM6kLBbuwC/Zqspuzj5+c1WHJ7cdXGybrHZXeTiZm7admuAqFF9/TrmKkAOjFw+a8cT8kVypXBhtmv2VvK4mUsDTik7LDcm3QlSdAYs0RZReatUS9Qlx7K53SzHIyCooDuIBitRhn7Ns3Bv6jftVbLsFafQpoSgKhzKWjNpIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723121884; c=relaxed/simple;
	bh=8Fx02ZeVvlacdTyi+Vsr7I38+MSCpSvrhtXjm1L7UYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NeMHS2yWdOFdq60AGYYHPt3YpIfsTO1KekjHMZS2EDZTM/ckkQb26WghrwzZe5jh/XlQZJ8EpVYmPAtpGQ2IcsY6ZTozt0djh9d/XvqwhtTItflo4hKjf+oP3gRDkke3KL/lJbJd7uu8spT29vO9iXf9surhsO/WGrSRZZTahkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LHPVB0wG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LHPVB0wG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fc49c0aaffso8624075ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 05:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1723121882; x=1723726682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPbGhFYXBq9HfDXscnGRou+mE1HRUEoxNIwtJnyaTaE=;
        b=LHPVB0wGs5qqOimrnkzsje/vh48rjO6RzmnvQH+Iu5rhaP0EtE2uGWagmlJpqWBuVe
         vrZ3c0vsSdjfbE2/vBngcBT7u7thmJqQAB83td7biOOvAG6xNh3nRKNW5avju5zaxohE
         0R8xcVVzj0XGz39D3MiOHf0jRK2zMdXhs1AXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723121882; x=1723726682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPbGhFYXBq9HfDXscnGRou+mE1HRUEoxNIwtJnyaTaE=;
        b=kEPL2vpJ0zHnndkn+eEh0lF5aJ4VvxZC4t+Mwd10RbsQdUVNQyGXLbIGtzACWGsJCv
         FqOr8WfbcoP74e8agDvGaP1e9Qn/gl8yA2NtvrfnvWr0HZCVIDUAVR2gbhH87hiiqfLn
         wHiZCgujTZFpzowsX4/6baCsSsEnnmpNSyHHa4XDmMQoKpmBs8gvN2YeVQ61ItRBTCap
         bwgpsl9IIT0Btgnxd1hwS5IZ2ZKy8nlyhfweaxf7hWq3LtSl8G4N6SERGPT0qU334szK
         TRfLRvT1pjH7+BhZFNlNSdd2/yjZp/QgXFwzcmqBHkabT505xgYMVwjxIlJtEyAgPdY+
         htUg==
X-Gm-Message-State: AOJu0YxnesfpkjIRlo+W03lgLTyTCxodkSoGFIcHdZgxwrp03+L9R3Qq
	looZFtOwF6eaFvXzQfQHUCAdAtwi2+Oz82abtFTswgniFsQOUSlCSmaDM3aZVtmBpluJ6C7Eh0l
	HGMKcy3XForMD/i+IYvPNMTE55DkwCc19Z9USZeKmBIwKW+IPdcYREzjVSFC/LHMX1wRnHPL+eb
	qmjtO+0+xA+NHxJ2A1Wi3T7a2WBITUvcZix9vz1CATKE1SEg==
X-Google-Smtp-Source: AGHT+IHiILTfLegTklq1jebkDqQD8xJublKrr+ZGw0+Sr3jY7DoaPME7MjVRld7edkwcz4UQOBWbjQ==
X-Received: by 2002:a17:902:f683:b0:1fd:8677:6160 with SMTP id d9443c01a7336-200952487eemr20970285ad.15.1723121881937;
        Thu, 08 Aug 2024 05:58:01 -0700 (PDT)
Received: from localhost.localdomain ([115.110.236.218])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff590608b2sm123283325ad.152.2024.08.08.05.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 05:58:01 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/3] mpi3mr: Driver version update to 8.10.0.5.50
Date: Thu,  8 Aug 2024 18:24:18 +0530
Message-Id: <20240808125418.8832-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
References: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update driver version to 8.10.0.5.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index cbb6e4b2d447..875bad7538f2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -57,8 +57,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.9.1.0.51"
-#define MPI3MR_DRIVER_RELDATE	"29-May-2024"
+#define MPI3MR_DRIVER_VERSION	"8.10.0.5.50"
+#define MPI3MR_DRIVER_RELDATE	"08-Aug-2024"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.31.1

