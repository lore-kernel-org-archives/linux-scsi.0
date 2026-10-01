Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BFC457E52
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 06:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835135; cv=none; b=YweTDRAl9QJqAD1wTJCMzrgg2/3O3EdozN7JyXJODSt/2KUmD333bs/YUlLBhr9ipo1VGcKFIIBg9DW6TWvhGaTha4Y6BvL4oLF1RnHvjoaetOf35ccKJZKcjBRD33XBKIYQ4M1AXFIOhko0FWKUwJGzmSjq05tBUoUx4CgCj+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835135; c=relaxed/simple;
	bh=OgzBsM1JA4iQunu+Kx2XkRq0fCFr3hYwq5VUH7QKHsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRMl/Dr/+oJv9xuHIeAITuOS3jkWdmrTbqrHXv03fCQl6WLCtdWU9Mwlxq2uCGkNrTyic0ZmPrnbeMh7OS0F05i/S+h3DKNkodKWOFgsyJjP4ZtW01pINamXf5Sr83IsZt9CzafzynzqSHrXp0s6orOZWj80KTxPzPXWgzmubv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F88PohOu; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F88PohOu"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cec4226c70so50017995ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 23:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790835133; x=1791439933; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OgzBsM1JA4iQunu+Kx2XkRq0fCFr3hYwq5VUH7QKHsM=;
        b=F88PohOuSLflNqgiDJ0r5rx0Y6H3ckZZH0hbjrRMoS3nh9/a++qwpRc1kUcu4Pb56Q
         xx8gXpNjHgcHoCpcq/UalorW5D/S2hVsj8HODObscFrWlIMcZ6N9oYZXigYH6gsGSRJk
         CI1dbXdzDi+ihqDZlE3LEPY5KU93p5F8eikyYAjU7F6vOx7ITEnNsKy5O+7RnwIoUDV+
         aQ5IjwUS0OyO4Riji4aerILOcxxymGBhpThn+2b0xZqos8FVny6UzbrLzAxM40STloGC
         RAytSX+uqOa/St+NTyoaLv/E8gYxvCV/gajmj5KjVoB5d1F9GDrNXnlOgwLaHr+1gjr/
         7SsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790835133; x=1791439933;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OgzBsM1JA4iQunu+Kx2XkRq0fCFr3hYwq5VUH7QKHsM=;
        b=0NLYTVdjatUulYQQut1fSGZHUGGXOEIKSuZ8A4fI2ZjZBVLtGCHyXr9yVcgPG+lVct
         p5EGwTjwhP4ZCN0yh7Vqmpl7NVJb4ItcQNcbx/oFXlBJb7pN8OSTYmlkMhMW0MJkuCZL
         Tfb8nBHfHwyEJh2tKrMl8vtswu/tq+bFAbEbUN4VN9eztHTViPBz32vVV8NVsi/cIVt1
         mBOwPrGpYzmxdcHe1mghjUzEUgo6ffO4nqwJXXZJAXoMAEQ+07SQAipkS0mVCYzp+7n+
         xDRd7zcXC6O3MSLhQkgbmkXLSBkAQDpGaz3dSr4M9lN9vvrSBMrJNFLJhjsSgImu67cu
         tlzg==
X-Gm-Message-State: AFq9FYIiWKIBdtSfP8L/u2BXhZz9Pl6lVp3tOkXJPNDXhOFcU3tnBmUy
	PWESV1wVFXQywJUfJ9+FpbxGjyUqKxUJPUpaz9XOYIcb7597uoX+mKGbRaieCBT3qJ/7mV9F1gM
	/oMqz5gDai5U/g9fNbZarMg==
X-Received: from pgbfq9.prod.google.com ([2002:a05:6a02:2989:b0:cc7:a60d:9a9b])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2c10:b0:2df:ab36:f145 with SMTP id d9443c01a7336-2e2e4bd212cmr32095185ad.68.1790835132740;
 Wed, 30 Sep 2026 23:12:12 -0700 (PDT)
Date: Thu,  1 Oct 2026 14:12:10 +0800
In-Reply-To: <20260929100946.693962-5-larisa.grigore@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com> <20260929100946.693962-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001061211.4142384-1-stanleyjhu@google.com>
Subject: Re: [PATCH v7 04/12] ufs: host: Add common Hibern8 TX FSM polling helper
From: Stanley Jhu <stanleyjhu@google.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>, NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	Fabio Estevam <festevam@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
	Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	Pedro Sousa <pedrom.sousa@synopsys.com>, Hannes Reinicke <hare@suse.de>, 
	Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com, 
	eballetb@redhat.com, echanude@redhat.com, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 29, 2026 at 12:09:38PM +0200, Larisa Grigore wrote:
> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
> enter Hibern8 into ufshcd_check_hibern8().
[...]
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
