Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE369256C83;
	Fri,  1 Aug 2025 14:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754058795; cv=none; b=ZXuNvfNTjCHngfvaMH7KIchZbFkAgqw+2ido9WslLikrqOEBKrzAs8JppWkbVNNNyNCMDm7M+XQQsudKRTJeAoSNU5d4SJ2PdkNrPnJo7IkrP74WCuzRIu5iizcF7KDJ/1TKZvd1v9vg1KKXc0z/O6lyd+XkaTdVdQQbU3m1sV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754058795; c=relaxed/simple;
	bh=Vq/vnd3eA3hMcf+yl1GvhSBdqDUuf+bcB15BiNV+t6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YuWolOuajaHF9SBwSC1DsYxjtOP0CEG82/q8HtwW1ALWMPzSmgm3pSXM8VdpCerM6YC9cQDmXmb5Po07LvffmRxc9VC4N75IsWdbCmfkRJmxfWH8MHMu3xRv9+Og2ENLDYnEuSTda0e5OVsqHerAdhqWlDhTBUAVFS/bmPrLjgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWaXzx9/; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWaXzx9/"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e8e22a585bdso1354852276.0;
        Fri, 01 Aug 2025 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754058793; x=1754663593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1nO1ST/K08QxGlcTra09OvK8J8w/g/UOeppkfZ3CozY=;
        b=cWaXzx9/AfZgpphrZG/+8pRuMMGGmts6EAotMJXaQsOUCkgbI7iLcKz+lBR/rlEysr
         gkf2pNIZ9dwMYD5ET22ZswJooafEqQAPZw1Mrj1s5ogZmZnSLVzQuDnHF/ZvbaFS+XhZ
         c4k2DwRZ3DenH2Gd3IHV2nWHQJ9Tl/Pl9k9HaXibwqN+tssafP/QPtcazyun1qDhmiLp
         qyt0RyFi3+OhrxRriOrGCera9S4esCuTJNpY9PnnHRtGB3RM/Rln2fq81y/FPjFDT2uc
         QMXdyMZJ3FqtC81hwrxNNBmjplg/f0MZ0dD0dS3qNGoBEQFhqbWb0+YQkG8Eat+gcJkg
         oibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754058793; x=1754663593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nO1ST/K08QxGlcTra09OvK8J8w/g/UOeppkfZ3CozY=;
        b=ZWj1Da6jzjq1lwSyuXF/4tB2ddnE8kqFoFvvI3GPULMt+FHNc1juWic7YdbqYTXw5x
         oQXNQJOm3W3Qx6k1bTBlE25KzwBqt2/uAHbTuuZNuPWHHWs2fF7oKq1oZMPONPdU9oGY
         1YN9+iifzVKCJqNEJD+d8ekyBaQ4N+S8pSN+0d1sm4TJVeIkgpxXe2GEoEHcbYuEdZ7S
         y2320FmDk1gHd4LBycrgrzvZXBOagVQwKv79s6sPuHOqDRVMylygpp4cWKbOU0eH7EYk
         IzVcfDL4wOagyzLS1GsFSXzKE5Yen3VsxM6ECFrfUpZFdEKSyDI7Ikd/VlUlhgGUyFuA
         +eBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn48QF+UF3GNJhnB0Gqy+p2/5WFtniSrYcjcw7B9zUyUnCfxvhC5xmKb6kHEQjrsAwvLGRllfDjWsDmTo=@vger.kernel.org, AJvYcCVvAmxmDC02VWPaO7vmTz+3WiEHABh6vRAdmeG7r5kpSGWrJBJ9UakpWGIAOXC3Yu04e+qHdZJhCGbA/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKQns4q4iRjuhh7R6CeicY/wxDXTlM86VBYRvv8TnMfDucZfeW
	dccR67DdXT62f89/SFM6pYxj+sqoNGkc6SJyQ31NNavIu703WU7g64f3
X-Gm-Gg: ASbGncsuJuNqZ9OgO52cWzx/LjwQbb+n41y4eM22KShymQ1DMBvuPCUCQ6aPCYZvbQy
	fY098Guvl5xLZinOBwxS4BqCIdK/xFFBjX3V5P2dkUbTceGerzYLxl1ytTk7ZSheVUMaLwxo13N
	N9n0kY62tYFZw7OrpncavW2z9ryqWACWz/VQvB6nVs58JZ9D2BztAB3dkS4cy4UgTA8HP32qNwN
	UrtLQ/sKyOJU5LvS6EvJE3Dcjfx94KccnbtqE1niZMRqdPomJ+NfuDMW224aW1s+CdR6PtUw5uX
	TQFDFGer7BtyGZl+kwm5Gl1UdxYyR3sTYWS+CIH9odOCcse99aYjNa3HIek/wMYjLl2dPTQoGIQ
	oNtAWRHnbMhF0XGSLFWw866PskAeaVthRMCTC2Wo4Wqdz6NWiqJ4wm9w=
X-Google-Smtp-Source: AGHT+IEr9LkWjrat6RHcsmQVUi4xHy2fvuptaztGZMBoyLBptaeBk5OPICXTljIVl+GeZqgxwqZywA==
X-Received: by 2002:a05:690c:6881:b0:71a:3da0:bc9b with SMTP id 00721157ae682-71a4665c887mr164561667b3.24.1754058792753;
        Fri, 01 Aug 2025 07:33:12 -0700 (PDT)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a423f38sm10545717b3.40.2025.08.01.07.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 07:33:12 -0700 (PDT)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arun Easi <arun.easi@cavium.com>,
	Hannes Reinecke <hare@suse.de>,
	Saurav Kashyap <saurav.kashyap@cavium.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qedi: Fix potential undefined behavior by replacing goto with return
Date: Fri,  1 Aug 2025 14:33:08 +0000
Message-Id: <20250801143308.14346-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If "!qedi->p_cpuq" evaluates to true, qedi->global_queues will be freed
without being initialized, potentially causing undefined behavior.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedi/qedi_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index b168bb2178e9..23e346a3e5fd 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1639,8 +1639,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx *qedi)
 	 * addresses of our queues
 	 */
 	if (!qedi->p_cpuq) {
-		status = -EINVAL;
-		goto mem_alloc_failure;
+		return -EINVAL;
 	}
 
 	qedi->global_queues = kzalloc((sizeof(struct global_queue *) *
-- 
2.25.1

