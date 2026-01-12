Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3AB3242B8
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 08:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205848; cv=none; b=TmO68xe1ca1vnSaUyqitpvnstkvYk1OES9AE8p+X2IBBIGPzr9v/geuRYTpIqvCNvY0RQg0A9CNSV21am+cCQLoMv6JfVLqHRcv4gMLCiWT0g7veLAeASYSU6pFcnj6uGikuvHr6Ts8XoZEIop1jkuqHuXdestuEMzOgZl+Abbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205848; c=relaxed/simple;
	bh=ZAp//Qqf8AsB1z40gK9VeVf7pcSRuIl7w1IIS6vAQbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0RrpGPXKQN40cGw41CpDI31Q+8Tj/mtnKfd1IDxyio8WfVcQ22TyLKFAon9N73+V+K5VEXearecHDmqwO4g1Z/TcEQ7awBsd/fkxsBKjoBatzo5Hz+xv8kJClcbmIrhknWrtQcyOajPKXPhdPNezgDMWKRj99IUZU7skj1nsns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=B6445efu; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B6445efu"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5636b2fde95so448910e0c.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205846; x=1768810646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NIWRVgk1V++UNcLproALPrKOBFaxgpKcPlDsQBbUPu4=;
        b=iViDWICODYtiUEriOmnVwDOF80oM+KX64h4BkRRtOxKllWbAPNzBNiiL8SllMM0PgL
         pu0L9snaUNKEkQNixfVoGTbJ7Buqz67oPzWqc4BUBbZQDwuUKcytH96Jym3u91/nO1kn
         /Pk4pnx84iNg+y9vFoFTC3pkYU1zgF8ebLKfmGCDHMbXgtnrh1Ipn+ldDQz86TzSwf3w
         BlxKz8CBkKOEwAb3yn/D5JQX3TsjHAePmizDWUPn8JBgN5MSMWSFpoxTPbOWhscfw6AO
         gQh23RVjpYYQlAiypb4rTrHd7pQUNHm4wn0bMzAldsrMpfevJ/zlS+jEMxnyBDbpkU7x
         jPgQ==
X-Gm-Message-State: AOJu0Yxf28caeIWr4Tay3hdx32BNTyUd1S+/8eX2Kn0584I0nvRwSw12
	jULh1J+dC7ku0dkXKLkrViTkAs7BXIEUyw2N25uUEYbH7ZiPOpdwSmKr6/Mh0u6ji3E0stXYQZt
	+16jxa8kcj64IZcn3Q9/7t8jNc5+8cIJAl3o83GpRHdT+uZKeSKcaOcHHlEmrep7WEZQs/JvXiD
	LENymPoIJnVPgP8khOr77VkpBfKDZpYwXAN5DrOnZhFZpmm2YoZvuVlnNWS0YWLrjsEKvewomqE
	COBgT4ROG0vf+8F
X-Gm-Gg: AY/fxX7LBvKyOoY7+F1nAU1pQcO/lcLSMRwNm2WBjOwMNssBOCgENlKigMGCw2tB2Zk
	PJoPqV3wbhX3FBblSpP8KoMdwn+5QYMrrcaAKjXYBURQ9wTkSFfaPIQGZTpp4KMJ6GukW8gpM4s
	rWaxVUq6VTlWvumXTakCpZu4vUN+8tjKXZObyUTZKeKnVCSYwc2kQU/svDXhEt3QvwatAlFk3it
	rHXRoZtp/WoQLb9rC63qhz0blkIiD+yhsSnGOMIr653Oa5qX57Jfl/ocZ7au9o0f39fv5BI3m1x
	NmuQiqBlWO00fBdDqxHDUe6zHZUj5dhI9iLj/MBNzByP/lt/yA8Wc2vjKtXM04df43JGFHJwrem
	P68uXW42EktGdYfsx96J92IGr2q63d47Jq0LiS+OSF5gqdTMzMt6DDB+wWMopp+Gpz8vDH9zRQK
	4kf/7Qyzl/V0FvIT8EeE5mwtU8VI42DZ6aQEv9/frVa1Q5Thg=
X-Google-Smtp-Source: AGHT+IFyM0u5fIK0Bnbu66KiRQcjCGt22porS1ZWBmoHoq1g/6Cekyu1VvdvOZF38TV1grXmvsWzD5pvdNzX
X-Received: by 2002:a05:6122:d15:b0:544:75d1:15ba with SMTP id 71dfb90a1353d-56347d61e20mr5085937e0c.8.1768205846256;
        Mon, 12 Jan 2026 00:17:26 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-56369552576sm1154254e0c.6.2026.01.12.00.17.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jan 2026 00:17:26 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c5d203988so1248332a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 00:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768205844; x=1768810644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIWRVgk1V++UNcLproALPrKOBFaxgpKcPlDsQBbUPu4=;
        b=B6445efueJotlefVDJELl8x9MKp9Ck07DJwlUFCV7n06uJUdge7kb6qc3kBhSjtlns
         0Xnj7PRzT4zAHfFEao+smmRtcDKPSTlCL1+ihmyh3YDAh17RWHfbZ7KRZMz/ub9sJXGQ
         P5EZmlma/Yke5uG8DVmWw2ZpPgKiFTei6viNs=
X-Received: by 2002:a17:90b:4e:b0:330:82b1:ef76 with SMTP id 98e67ed59e1d1-34f68c62a25mr13630803a91.28.1768205844151;
        Mon, 12 Jan 2026 00:17:24 -0800 (PST)
X-Received: by 2002:a17:90b:4e:b0:330:82b1:ef76 with SMTP id 98e67ed59e1d1-34f68c62a25mr13630775a91.28.1768205843654;
        Mon, 12 Jan 2026 00:17:23 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8b1526sm16808659a91.14.2026.01.12.00.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:17:23 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 7/7] mpi3mr: Driver version update to 8.17.0.3.50
Date: Mon, 12 Jan 2026 13:40:37 +0530
Message-ID: <20260112081037.74376-8-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update driver version to 8.17.0.3.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 58db60e13c13..3c70f570ee0c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
-#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
+#define MPI3MR_DRIVER_VERSION	"8.17.0.3.50"
+#define MPI3MR_DRIVER_RELDATE	"09-January-2026"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.47.3

