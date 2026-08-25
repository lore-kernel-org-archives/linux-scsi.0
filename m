Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D843D668B
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672668; cv=none; b=mwdCmxEvQoYSUUiRXFjAfd4d10yjcN7C4tTf32dvSjwhaW/D6WpEW9UVKjOSahWSEEWxqVuYtrixdpNXxXIjh41l5IUgWzCUoJ6p3RSU8ODjQbMAoGim3XNLVC9ALGfHmBTsml+6PCcc+wSrA/OKUqAm/Xu9+8Q1R+QiPiFP9vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672668; c=relaxed/simple;
	bh=0o7j/btLfkRRehxSj08qbnJMlv5ZaCJ3+akAoXdpzys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlj81D5nzAFaVluGRe22P8kx7MQMkFJ7TiLdzzj1UbOQYQssMkjiGbr+M6t9SUW7cHNIPZ3s2bFp+S2TfBLaY4Vi5l4f62Bw0rJrmeXvSf6rJtvQzymxVlHSnND7RgTc2pssyrQp7ciSZ7AOPQg4bSk+nBw3YlpOa5UGdOFJm8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SQYDP1Ps; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SQYDP1Ps"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cbedf318752so3840538a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672666; x=1788277466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxZeYJe4ZkNJxHRh8oCTLKqjPzDR7yzYZUXqiQJkQnU=;
        b=U0Hk484h8OGIMwvxqF49HFih3uorQf+G/26sr+fjSrbw4jo8v+nojUvly/aKLWefoO
         bwBWNUDs2vJvGYbeJvIMtzfElzCvtVkoxoGIJT1Ytga5EJUA/XEPQDm42AOzDB7W6csC
         Ykw+2hNh7Mytc7A9KJ7Gu2tlZqgj7Dz7agYQJsn4yA69w2z7gBq87RzOc0CcLDRh3eGU
         kKowbjmwGc9Z+zto76XBnSz/m58EVCP6C2pybSB4OkPhXkRcMnm5/yuuSlTEBJyrx0yY
         +qhyuleAyk+nPnVBO7wh963ClbYcbuPmmY2dS3g+prkSNPMwZszLc6Xm3ZZKLTd/cU9Z
         cWFw==
X-Gm-Message-State: AFuF++kEw3IDu4hbyvqa+VtKQDhd0vRtaa3vRT5Ig3RxSnpBIq/6VzTQ
	z2eyLflKgLAekgFy8gGLPq/1pkTsEaenckur6XLyGqLcaqOvIVI0NZISVmmbZ+FQ2LeR2oqsRwt
	Gre+DhTLPJSetbgjZRmnP0Bq7AII9mPFtPxQjJk6LBTUQZF4sxYYAFHURC26sLclB0MZGT3gwdz
	ei0+d2swLi5VYtocn+tjmwuX+SpLoMb5CZqs/guuzuZj+Cb5YD2U+SYfg3VuHI2llPAXV7ckTZa
	XZwBCfTHYN/Il9vD0qfAiZJ
X-Gm-Gg: AR+sD10x9h6DGibnSz+gEQrPryU4dj73VJK3Nq3SuGrMiLdL9vxhYsm2PCvdWzkP4vl
	53Ry1F8gencADlwnglLRz8ob24e95QQdgyVopMNkxycs6/wtiYUNPhF5QRJvO1BEPnKKFhPdySV
	Bs8Kpwed9lpvs1d3IIjeBoyeP+1XonaoW6tAQtisuRmLeNrcgOPObZbq/NcZS2uYK2m9evlnUOf
	nvpka5WXRix9y4/MhFvIOKrTQY67YFyo57CvETTgi+cjrpPx5ldr70TpK+Fzgdb1KJJGynUwPPa
	/+UuvnucHbp6PI9UjA/lUJ1N03Zo1QfB2K7vzzLiL5NPUbvwV/0fhXXDjbIYgCDXJgj9mNgw1W9
	JfV/ChTdKcg9HDBULRJiugC4casxZbOu3YBNLFMrRj2hcCoBTq0TzZUpmVftp82ZHjuRm+Uirn7
	4l0+VlwjmtxNyvGhfiVW/sKnKHmbBzu31VM/zz30o90CE=
X-Received: by 2002:a05:6a20:3d8d:b0:3cd:7ba2:e669 with SMTP id adf61e73a8af0-3cd911b2b8amr15495268637.10.1787672666327;
        Tue, 25 Aug 2026 08:44:26 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc199e6c929sm1195264a12.8.2026.08.25.08.44.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:26 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so15456a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672664; x=1788277464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qxZeYJe4ZkNJxHRh8oCTLKqjPzDR7yzYZUXqiQJkQnU=;
        b=SQYDP1PsZVrJQm79jJRwczjtwutFmCwgmw1gfqAGhjFYtlX2Zh1GQQijwPDpYbdLOj
         +C6MeA4+4eRv1KP5TFH8GuYJ9f9+AZVddWIaj3DgIjCNsvNUgenyxE3o9eLSU6UcO8Zs
         sbyfglAWHhBm8DmUF9iAGrOpBlJTgZvz3wyQs=
X-Received: by 2002:a17:90b:380b:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3966d13a242mr226466a91.1.1787672664428;
        Tue, 25 Aug 2026 08:44:24 -0700 (PDT)
X-Received: by 2002:a17:90b:380b:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3966d13a242mr226344a91.1.1787672663869;
        Tue, 25 Aug 2026 08:44:23 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:23 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 04/17] mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 26 Aug 2026 02:33:58 +0530
Message-ID: <20260825210411.301535-5-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The target device lookup takes a reference, but it is only dropped
inside a branch that also requires the SCSI target data to be set up.
When it is not, the reference is leaked.

Drop the reference whenever the lookup succeeded.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index a4fe10a05cb3..94b992acb233 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2745,10 +2745,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 	if (block_io) {
 		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
-			stgt_priv = (struct mpi3mr_stgt_priv_data *)
-			    tgtdev->starget->hostdata;
-			atomic_inc(&stgt_priv->block_io);
+		if (tgtdev) {
+			if (tgtdev->starget && tgtdev->starget->hostdata) {
+				stgt_priv = (struct mpi3mr_stgt_priv_data *)
+				    tgtdev->starget->hostdata;
+				atomic_inc(&stgt_priv->block_io);
+			}
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 	}
-- 
2.52.0

