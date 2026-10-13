Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7693E5A32
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849189; cv=none; b=mOu2Urx1W9CKAd83edCkcicY3XXxo+DZmJjwJBFOexvF/VWMH1OAP+bZyBLk6JnMOmaoB0S4EEciZb37H+zNyUOTzoKipDL9aNEUALvggGaSkpLgRB8O8zSNd3dNE7u7aTdyjfB9HN9yoqbBu131uXVp7/ibd0PFmbZM03XklTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849189; c=relaxed/simple;
	bh=t76J3sqz2qJ+fPRoPE+QfAZhVmcccI7sNL95DAb3XLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dfQkDUOK32MKZ4UINYy0mUk9C0uFIomCpVsMCLJyLFUrwtvlLKd1E2pZWhA1eWL1p2y6uOtdjiujBhowBZnUwkSJ7XcgVY7zmAINk89xqmM2ilN5w1dK7nIoqEo14u6A0X8a6KfcoZKJI1C4P/27hi5bOQRQl19Ddc081ksXCCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rLKIlmuC; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rLKIlmuC"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso6003310eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849187; x=1792453987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qCO5VIn7/AVovHGm5p+1CL9DNwCT8zaieYbXwRxck7w=;
        b=rLKIlmuCeeLrGnid6NzGEf4DXJsMnxV5smuODVgTrivkWZ6UWtqYFLIUWYWbsgktnq
         IXuL4ytqYGZ4pa9uYqvJhAu7tyJKJ8M5soTbixbjgeI8LMvJoOX+oMo5g2gGT0vGcwTm
         7zSZoXJlU8yDK7gPRa0Xji1WszjRyq9YvbKEpcab8hT0zANiAV3+GZJXM74O5tl7oW9G
         h0sJwebS/2Adua65EpT2dwqPghIiWxkLALRe8LVVi7+QSL6vZcMHiJP/zOaMHAQpbgWc
         Z4ytedLMS5FhqR4QXO0kkuNPnvD1x5Bgche2lTfXzK8REyKFz7XqEw+0rja53/CMT19r
         Dtbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849187; x=1792453987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qCO5VIn7/AVovHGm5p+1CL9DNwCT8zaieYbXwRxck7w=;
        b=fpymmdvJMxcVfI/r4wGCHZis+EhKELdUEHcNXrylFl8h0mWhZzzbyWJexR59jctlEC
         nGqqJG7MnUoz6/nzM4k44TX9pIcTlwKj1DgzwpzR0obmNHRtcO7acBlajdCCVmLsa1PD
         oxtyjUCwfna06RLl4H0graV7qwRMnaL0atmEzrInwCBib0CZNjkEmUMxL6EOoBleM+E9
         9Ia7t03GtbvU7Zz0+rvQVB3BcXV6icQeXfUdkF3NoJ30rmE3tEe3ju3QOpIrKpZpn0V7
         TDSsDzbQQgSdGpcjNACwo5ML/5s8iZp3Bgm8K2YYwrgvWltz4DJsUGYLfjOasKNbjMg9
         0QDw==
X-Gm-Message-State: AFq9FYLCCWD5QdydJUY5uYt9vK5KwrqMZk4w37okuHGT5hoIozCKjOzD
	obeYYXRpINZvDcGD3J3z7BiCZ+hi1p9ZKBBu/Ji/7GheL2EvLcjSzEvQvWJUxObv
X-Gm-Gg: AYBFou3ieutb88F/H9MZpi62TXyvqFzuHVPO3eWrKA+D6goozq334s6q1QxQZXvzuTw
	Uk20U1mrhx/YMsVJ1eSXfX+RIn4G/xX3BlyCXu9WdEVFTr8VwMyzthxP3COruSdQSYs5KNZMCtf
	BL37YNtPz7Q/91wVt3W6KOHpwWoO3MUoGHRMMTRgANx/kZPWBI5l3hurADCA8tLSsXBhKXLFX1+
	c5Hm47MjiLOoxOrH63ohSbViGGzPpeq/CGVWXzHqv0loy0wMjxqyftV2nnS7FnDJYTjju+UJhDb
	NVFBrj1+RBFV1yW6l/jBO1kmTJaLj2rHYkP9c1d8nw0cTGzlV8mwU/LCpqw9y9SUpKKTH5sILC1
	Tm3586W210+UCzC0E85jOd2HG3cAm1BiYNG0rS2gZFUXYDMS5O8EWw1lj/aZqmber/+67e3+SKJ
	Wt6v6x+mfc9LMtWjTfQ5oad0j2wwYe4s8bO81K3wRi9o8KTNNP/oHcMvfi7jj3Dbt1zdYMPCG6A
	DeJdlsQ7LvN14C1KahQQx7k/7ZuKIXhPnWz87dDcGNdQgHvYBO/KUoHHQ==
X-Received: by 2002:a05:7300:3b09:b0:351:1aac:31c0 with SMTP id 5a478bee46e88-3537df974e0mr20434210eec.17.1791849186677;
        Mon, 12 Oct 2026 16:53:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:06 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 1/8] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
Date: Mon, 12 Oct 2026 17:16:41 -0700
Message-Id: <20261013001648.62289-2-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lpfc_cmpl_ct_cmd_vmid, there is an early call to lpfc_ct_free_iocb
when cmd is SLI_CTAS_DALLAPP_ID.  Within lpfc_ct_free_iocb the
cmdiocb->rsp_dmabuf will be freed.  This means any ctrsp ptr
dereference for SLI_CT_RESPONSE_FS_RJT or even ctrsp->ReasonCode and
ctrsp->Explanation when handling a CT LS_RJT response is a
use-after-free.

Remove the early lpfc_ct_free_iocb call for SLI_CTAS_DALLAPP_ID.
There already is a free_res label that calls lpfc_ct_free_iocb so
there doesn't need to be an early lpfc_ct_free_iocb at the start of
lpfc_cmpl_ct_cmd_vmid.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0734ab3be3e3..f709e5087577 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3576,8 +3576,6 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int i;
 
 	cmd = be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
-	if (cmd == SLI_CTAS_DALLAPP_ID)
-		lpfc_ct_free_iocb(phba, cmdiocb);
 
 	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
-- 
2.38.0

