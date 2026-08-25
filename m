Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79F33938C
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672693; cv=none; b=V8Uek+zD94z3Ry/ynfiMSaFnxz1Ou3GNniOiaOKfUQTDoOLVCVhjmZ3z473avVYTDkIYw6B4/fgti/XzgNoZBLnqRKTw+Jb7PBcBJSOb7GUnCG8wcg9wIwJ75PPGVGMFPoVICoirx0vaIPwwhaXwzD0eaCKoy60MxHDFnLXQr1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672693; c=relaxed/simple;
	bh=lWNRT0dpGzEI2oqvV2myzUTDYGU1H1BmMwV9TYb+68Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yk/Jkpe2MCCbdE+WU0ozeqv6TZFVZ8fpfeh2bNblfy1wZA/bLA3o6PgNupdgw+RKgzbCAmffYzLWNDRc+ByACZGoq4O9ekww2HbvFLBdQUU7rzbro3bKm22ayQTdbTGt01fYZ7WyGiwm6W/noxwaRu7p//+AcsgzhFGilw8XMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E2dDc1VG; arc=none smtp.client-ip=209.85.210.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E2dDc1VG"
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-8486672f03cso6278b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672691; x=1788277491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ps459r/Uwin9/wh7kL89gnryTD3GIvOk4wve4H59T28=;
        b=gFzlwWAb/ooy4ggRTcpiEUMaHPU/xFy9d3C5bsVsH0QI1ZZFbAC2UkII8O5U9DzCfT
         liNqdbhjHcyAf+Vai23QJaiZG6xhFLAt5gqYtEiL5PP2uQ303Svj5UsCOY3VM27syiyQ
         VaeYhRXe/CHE3c7oNe+GVZUGACZF+U/dI1Xv7uvjMBYN50WacAT+O5r+pXtUI8y6D1N1
         GpxGPAai/+FOklZPO8e6PNu0VTaANT1krEy4C3tyY/l+j1IHUJ5lUDX0ID9gFWi7upMg
         eUIWbZThG4VUy02VOpti1Vn8Hw9ZguNd6PaGKwa2SAxkimt5mP6Py1soOorA1/FT5yDN
         VWSg==
X-Gm-Message-State: AFuF++nEmoqW235SUN9SXU+2YWNNApRq8f2fj0nAml94t1UH1Bz/BC9F
	FzVqOe1s1Hxp5ME5cpIKpWJoaBm80wBhF42IGWTjoMJyKslhJGE+jEJ12WuB176tPua61o1FMLp
	1grYkB3QIUKeLXUkyWJHATHEycgDYov+bCJJQoEotR+0oV+e9Qgpj/6B6H6x3InFLSvcgDJW/2m
	bhamLz3TQ20PSDh6jGwuu+Qgph8BXtyfMMJlKp5PBpdM2Pll9yItkVrVrFcWS2WAMQjDn/BSIGW
	ceK2X8J9gGM6ulNMK9/2GwC
X-Gm-Gg: AR+sD10PSg2tdGsjUWcdbVoNckXe6yK/XuSP87KsYlJddm1Xu6GYrtquq6bdnkZjsJs
	m+qD+7W4fe2MwIBQ/0tQ16FJWgOwfcaQ32BQcLytB6ORPqROuJIG5+81qRgI2wzXqhLy10niHTP
	cpLtipPH1+LNr3R8rk8fs3p2ME+A3oa1R3rxNlgLd1eu0oVPq5PM4GYIZ98uDUIOYUsJC88ihHC
	oRaTbj3sDdGQUlRJnl3GiGu+lMwQ1lutDp7fMGd6gt5kYEzDux/9cQUPiVaYmeEq/aqre2y39I4
	NL9Ie4yoc6gKM335dV+rOTvIallInIMVKtl/N+UOdOD2T1b5sz9FiTIHdwErUuVl+636ZJNyial
	GL3oEYFTA9rlanim6OeEe9R9ESK+PnEnFdNbKjoqu5leovJnfsVfY8EPov3yS0B3bu2z6Eg4e39
	De7XyTqQtWEcAkB5IlG0QymyWpbNsBHvay76oz26m05Q4=
X-Received: by 2002:a05:6a00:bd03:b0:845:cf73:c1d8 with SMTP id d2e1a72fcca58-8520ba55d99mr44525402b3a.14.1787672690881;
        Tue, 25 Aug 2026 08:44:50 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8535cf5068csm30784b3a.6.2026.08.25.08.44.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:50 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dc085b0a7so9377523a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672689; x=1788277489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ps459r/Uwin9/wh7kL89gnryTD3GIvOk4wve4H59T28=;
        b=E2dDc1VGUZ2A/wkcMjhDeuGT4ZH3+BV9aPA5B+5AyzNQC8faWw4PpfXNFRVUAzmNy9
         ymFp6y9acmupsoIvqnGaX3jWFlHRdN6ZtyojMM5ytcdCI8N2MedOgOEJXLhn2zUpMDLG
         AAreSkQ//QKRrYrH5LI/8EeOPwEhTKXGD5fys=
X-Received: by 2002:a17:90b:448c:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-3966d8a71b5mr2381a91.15.1787672689266;
        Tue, 25 Aug 2026 08:44:49 -0700 (PDT)
X-Received: by 2002:a17:90b:448c:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-3966d8a71b5mr2244a91.15.1787672688279;
        Tue, 25 Aug 2026 08:44:48 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:47 -0700 (PDT)
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
Subject: [PATCH v2 09/17] mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 26 Aug 2026 02:34:03 +0530
Message-ID: <20260825210411.301535-10-chandrakanth.patil@broadcom.com>
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

The device removal handshake looks up the target device to update its
state but never drops the reference that the lookup takes.

Drop it once the state has been updated.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2a35f146fe69..9aeec6146acb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2536,6 +2536,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
-- 
2.52.0

