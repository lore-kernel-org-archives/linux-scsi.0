Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795108151;
	b=Vs5qn8sm/UXQe2GNa7wLwaWG7ScXV2hBvbTcsCPZOkGHdKuyLWSlBay7Lq9sv9TzDGEn
	 aft9XJ/fogCmJP9Qgqds/s9btdpRS77B2XYNSfpykTHVbrdQQSLTwBNjQY4KE3vLlCnhB
	 bvKmjxM9JjlIWD0RUpoYzMkZv5EpCmt5aIGkJLj6I1KqNaj9MXgO3AYB30R6F0yIb3cZr
	 0884oIktmquZD6tVhcQq/foCduxcVUI4zcBAfqzGlQ2x0FVIQl4vic/qe/e8wYHf2PvkF
	 HH+lg7TbN7I7sPlTIvhtxvVc0H2o3OWufR67ch1x6uHr3d28v52uFTVWLrk+CmjzC/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795108151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=+J9B5x5CJ2GgYpJNi/eyfCmiUuk3TgTy4lgVddwqdZA=;
	b=1YnAsZyb+U0/GCLVMlOR9qQ26rvlTsT//xYPU7xNrXBTr25gfmDpits44wVxrPSpEIqA
	 9lHEHUzRWvyBruNDCbA4cjo39ZZcvnjnLx0JVOqANf8fsLu6JsaF3T5XLu4j9uDhSdyCF
	 K1g2O8b/QGTEMjgB2LDEA0Se8GlfH3oaB2eAKGgfx+Am0YSHAqVt8kX1L9jwG2VEVXYrr
	 sj2/FuGudfJ7QWEEklDKvw+PoNAVdh7AEsgT5j15Smzx253SBs2toqiAB9nkpfRGMm6/J
	 hvHCS2zXPPcF+vEc51oKZwIrEeoTG+TlPls1y6axkjZfgAFipVl/8iqNLegHgEsFdaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5MJ02Oz;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDC760A382B
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:09:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DDC760A382B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B5MJ02Oz
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-384c78aa0dbso773222eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 09:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795108149; x=1795712949; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+J9B5x5CJ2GgYpJNi/eyfCmiUuk3TgTy4lgVddwqdZA=;
        b=B5MJ02OzukHzdq9o2dte5/8i2PYsjDvoc/mabadbviIFFCnrltp5/vcU3ERjNfxt/d
         cceuRxgWADTmbiiDighentaJTXg/h2S36R9yM1IYQtTXDZu81aLAdQTrE6MllP2CfLDG
         YsKZDKlROjz2fmitZrC23DKMOD7mJZN7qXXNSRzceBWwcOxSx4pVWo/MibVFG9xBuJX8
         W0RgcVi32FN/5zIpO+De/P+GURS/r+9WOAVPNxQrXYtyxjfwrZQl1KEuEBmPA1qshBTC
         7pVwnoSSRT3BDnkAFMY/4ZrXHkeomc1re3MdhmWAQ99XuG+vOBRAx1SedU+mvyS8eNo/
         NQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795108149; x=1795712949;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+J9B5x5CJ2GgYpJNi/eyfCmiUuk3TgTy4lgVddwqdZA=;
        b=NQ1cAiUICLVIbFwgdj/sY3vmb91LMPBUwiww07GbnzytkdoatXMzrm6qQgF5rLbuFz
         Lp24lFFYWqw/QG35Q0q1ZUJgXxBpMMvlj2WoVX3HCZvB6mRJEWQxrcGPtmHdoRNSSJei
         o/e+2xfszRwBmxRe3bKGp2sNWaYFi/XJY1i7gcAggneSjsMYGkDDMmnuYHz9qu+j1Bp5
         97Sv5bOzoBrXlDKugsWw49FFGTKG2O+t2tALmFwh08GXrRrqVmXmQj1wEbQl0vSv6Osb
         Awk9+9T0j1N1xwK4whT99mdroVpEdjdLzGOqwb23bygGMHY6PSoLAbH579XLvV3YLm9b
         BzoQ==
X-Gm-Message-State: APuU4Z8dW/GFnFe2z0Mna4bEUQvVvA38WL7GzVMlVjCU0yALVn3h6ggB
	pnMvJyLnGhMy6Jrx2z4rzO4M6AhrsXGGnTs+nht6eneNccBC4oLd8CEkQ/vsuJoY2tkoQkAH+0D
	P26b/wxNsWQ==
X-Received: from dyji33.prod.google.com ([2002:a05:7300:7a21:b0:36c:9a6e:5413])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:9e08:b0:379:7bb6:9c4b
 with SMTP id 5a478bee46e88-38281bfc037mr5432157eec.39.1795108149205; Thu, 19
 Nov 2026 09:09:09 -0800 (PST)
Date: Thu, 19 Nov 2026 09:09:05 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170905.1530613-1-irogers@google.com>
Subject: [PATCH] scsi: pm8001: Fix abort completion status in pm8001_mpi_task_abort_resp()
From: Ian Rogers <irogers@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

In pm8001_mpi_task_abort_resp(), the IO_NOT_VALID branch assigns
TMF_RESP_FUNC_FAILED (enum tmf_resp, 5) to ts->resp (enum
service_response) instead of ts->stat, leaving ts->stat at 0. In
addition, switch (status) has no default case, so any other non-zero
firmware abort failure status leaves both ts->resp and ts->stat at
their zero-initialized values (SAS_TASK_COMPLETE and
SAS_SAM_STAT_GOOD), causing sas_execute_internal_abort() to falsely
treat a failed abort as TMF_RESP_FUNC_COMPLETE.

Set ts->resp = SAS_TASK_COMPLETE and ts->stat = TMF_RESP_FUNC_FAILED
for both IO_NOT_VALID and default failure statuses, matching libsas
and hisi_sas expectations.

Found via Clang -Wassign-enum on an x86_64 allyesconfig build.
Verified by building drivers/scsi/pm8001/pm8001_hwi.o with LLVM=1 W=1
(-Werror) and -Wassign-enum, and with a standalone C reproducer under
ASan/UBSan; not runtime-tested on physical PM8001/PM80xx hardware.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 55a01e533fd1..b8c59c152d89 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3478,7 +3478,12 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case IO_NOT_VALID:
 		pm8001_dbg(pm8001_ha, FAIL, "IO_NOT_VALID for tag %#x\n", tag);
-		ts->resp = TMF_RESP_FUNC_FAILED;
+		ts->resp = SAS_TASK_COMPLETE;
+		ts->stat = TMF_RESP_FUNC_FAILED;
+		break;
+	default:
+		ts->resp = SAS_TASK_COMPLETE;
+		ts->stat = TMF_RESP_FUNC_FAILED;
 		break;
 	}
 	spin_lock_irqsave(&t->task_state_lock, flags);
-- 
2.56.1.708.g77570a6a1d-goog

