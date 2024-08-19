Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEBA13BAC6
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724091437; cv=none; b=LSh0jJ4Lmfflif4C2onZIzuEb97nQfHUBu46SrvAOotBcbbvhUQj5kspqPdf93EfsW5p2UdywUkNPH+a0HrevmaTSAQ6gkZlxg/XI4VMEw4Jf+kfZOgwZY3si56lp9oKinHdKCSVfqV4T06p9o9Z9xl1r6U37otvZYYXacjOd7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724091437; c=relaxed/simple;
	bh=vN9VfRlmGvy3YQFxJIT2Vq5YZXks3hjQLPnt55QuAZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZjJ3JAn9+2qE/zJVkI9jmSHUxFvofAcEwtDKCjQn4fG/nqlYuv10zPYplWeF7AFjut0Sk5S3iIIu8LfrXWVJN1tqiXMsyfNiuTYU7a/sXOkMUSDfB6ngU/Uvv6ryHkEzCrlKQkwWXZB+qqjRYT8ZhBkDoNHp7BTDUMri4H0ZpZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone; spf=none smtp.mailfrom=mary.zone; dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b=YfznrLSX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mary.zone
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b="YfznrLSX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42819654737so36115335e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 11:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mary-zone.20230601.gappssmtp.com; s=20230601; t=1724091432; x=1724696232; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8FoZIbuvwQvPWmR1MSeQfa4tcso/BUCB+N66Db04Kjk=;
        b=YfznrLSXQudQiXlI6skTxnrjPPl1Hyk/NbLFBbRRSWsHD3o0Z0WxtHq2okOsCNd1dS
         cu/q5D5IsUxZSsrrME41K1g3nkVLtKc1jxtusgK1rNfhSaEsnraMB38RgqSCwkyWdeiS
         3i0p+/AAV/f8k5FtQdZJCTAlLSErSArhQZKuiafWZPspGer7CrJKu8IMDfY/Ue8rYkVU
         732lXN6qRufWD4RnBqbCFrC0ieGU/MNQ6bYzzz5uueKzwgKxWAL3pEVoKJa+cznrTCd7
         /QdutixkUljsmrq7TBYNBwX9ygqSWN9GVl+Qch7y1NlQwAczRSz3Nkw3gmrg3QiSAIBu
         BO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724091432; x=1724696232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FoZIbuvwQvPWmR1MSeQfa4tcso/BUCB+N66Db04Kjk=;
        b=ZPpMwEQLbzGHD4MAtFnQ+Jwl2PFwqHiTSj+UBEAMshdRH78tdwDzm81gZ8Z6/eqHWT
         20CvS/xKfgsYrN4Fh8C9iVIFnQgMCXGxNg/+COGRV0VIt4MGfHAbwOBmlHJwKUC7rJF9
         4JspDO1zRmcp7J6G83lTrQWCo6Bk/dZMN1BOtAS01r5N8HLGMdHciYUZfsxmNifnfCk+
         4+f3r2AyHn7dlXlnOlraTN45nMMdWXDC8Z2yCBKBXOO7piXc1L/8hy+y+qQtrYwmPedu
         /lfYWXMXYMv9TY9x3l7bmtp9kWip3iyJ/+a+rfg6o5rZ8l/8wT26jY9erJmkQc+r0o7n
         H5AA==
X-Forwarded-Encrypted: i=1; AJvYcCXJMnjURYPpCXUQkRy81S+V43jyiGUPNeyTiggmETlzJfBLkf9PyF+bVJdWCxqY1oCMUTCs6ONHNa1BFg5MCwt0XnzSRStu8hbAYQ==
X-Gm-Message-State: AOJu0Yx+ufhhHG1DJStR08flHNMsA3eKDEcZ/rm5Cgb8mH2xp+gG54zc
	AG4IjSIuskVXbcwnZWryUzUKmNAGWl0tWu6SnEoWns/7xIepZ0bRLT/qYkJpmB8=
X-Google-Smtp-Source: AGHT+IGJJQZeKISlIF5wMeAHKYv3hXnZmpUjyZu3JRdPGIt4k5Qy/XezBg4IK2DyWAizJBAaMttqCw==
X-Received: by 2002:a05:600c:1c0a:b0:429:e6bb:a436 with SMTP id 5b1f17b1804b1-429ed79be6dmr87170715e9.9.1724091432250;
        Mon, 19 Aug 2024 11:17:12 -0700 (PDT)
Received: from kuroko.kudu-justice.ts.net (2a01cb040b5eb100cb3bcc29e5f2b7ed.ipv6.abo.wanadoo.fr. [2a01:cb04:b5e:b100:cb3b:cc29:e5f2:b7ed])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed648f0csm117277185e9.9.2024.08.19.11.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 11:17:11 -0700 (PDT)
Date: Mon, 19 Aug 2024 20:17:10 +0200
From: Mary Guillemard <mary@mary.zone>
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Message-ID: <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240819120852.tdxlebj7pjcxjbou@thinkpad>

On Mon, Aug 19, 2024 at 05:38:52PM +0530, Manivannan Sadhasivam wrote:
> On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
> > MT8183 supports UFSHCI 2.1 spec, but report a bogus value of 1 in the
> > reserved part for the Legacy Single Doorbell Support (LSDBS) capability.
> > 
> 
> Wow... I never thought that this quirk will be used outside of Qcom SoCs...
>

Yeah I found that by trial and error some weeks ago and noticed your
serie while looking to upstream this change, quite funny to see other
vendors having the same quirk here.
 
> > This set UFSHCD_QUIRK_BROKEN_LSDBS_CAP when MCQ support is explicitly
> > disabled, allowing the device to be properly registered.
> > 
> > Signed-off-by: Mary Guillemard <mary@mary.zone>
> > ---
> >  drivers/ufs/host/ufs-mediatek.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> > index 02c9064284e1..9a5919434c4e 100644
> > --- a/drivers/ufs/host/ufs-mediatek.c
> > +++ b/drivers/ufs/host/ufs-mediatek.c
> > @@ -1026,6 +1026,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> >  	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
> >  		hba->caps |= UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
> >  
> > +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> 
> How can this be the deciding factor? You said above that the issue is with
> MT8183 SoC. So why not just use the quirk only for that platform?
> 
> - Mani
>

So my current assumption is that it also affect other Mediatek SoCs
that are also based on UFS 2.1 spec but I cannot check this.

Instead, we know that if MCQ isn't supported, we must fallback to LSDB
as there is no other ways to drive the device.

UFS_MTK_CAP_DISABLE_MCQ (mediatek,ufs-disable-mcq) being unused upstream,
I think that's an acceptable fix.

Another way to handle this would be to add a new dt property and add it
to ufs_mtk_host_caps but I feel that my approach should be enough. 

> > +		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
> > +
> >  	ufs_mtk_init_clocks(hba);
> >  
> >  	/*
> > -- 
> > 2.46.0
> > 
> > 
> 
> -- 
> மணிவண்ணன் சதாசிவம்

- Mary

