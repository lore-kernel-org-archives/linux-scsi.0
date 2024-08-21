Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EAB178378
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 21:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275933; cv=none; b=BdttTYkOOrOLAihZqLiGorPE+iLuJlAseurbHpx1NgRfXfeRqEdUF20Hd+iT0bNr9mYkp0Qk5u1+gRhItl/FC1oooih5XNfIGMDigyH7v1wYT0x31EJC96ZbhX88X8FYh62ZkNwK6FvGiBJIxTWtRd0LsxK9sheyQjJQqyMk16U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275933; c=relaxed/simple;
	bh=G2ZYzUM9xPfjHf7MaE5c1ZAlligmTgj92iLVFjxn+BE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrPC904xjmjddy5/2HmkKlVx7k+LIQd0daKMczxr4nr92QShM/AZrwqH+LaWBP+2OwjnjI35OQEU5MCHinKQdPdOuIL6VSemqwaj8T+zYJ9m+sAnknQcHtA3yGIPmlDP+b8GFG8TSlgEHKtVW8x7bDnccBrh8TgworM3osrOURY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone; spf=none smtp.mailfrom=mary.zone; dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b=uh/OfoMR; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mary.zone
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mary.zone
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mary-zone.20230601.gappssmtp.com header.i=@mary-zone.20230601.gappssmtp.com header.b="uh/OfoMR"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42809d6e719so696145e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 14:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mary-zone.20230601.gappssmtp.com; s=20230601; t=1724275928; x=1724880728; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e8/UWu+nkogk+rrCqpk1JaTQfdH+a2mQFoDGBlja3Pc=;
        b=uh/OfoMRQ0N16C462jwQuK76cIxkdK5U8HxQbJgt6EgShlHzRRZUV8LQkQGEzoImbV
         SuE11IqpQWJ+gOXlPjFfmeyG1qiJJbFAwX204Xw3tshleNipwZ+DUHAyjGq7PXDsiPGy
         9q6YhJgeXp935es4psJDFi6bqL7nCTuIuHs1sziOiLLpdc0QjyZEn/l424p03bMH/Jsy
         IZ5aMhAHTIjPzAI5kwhWLOj8kg/FVX9heJrtsyzEHNHG/lCq1h5IWc/zBssB/VIRinED
         5TYzl36azXCoKZhVBwirTPbBOtrVZmiD9W5QKRunM1RExyhFJWA/BrQWOgB/f6QHdZhe
         KN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724275928; x=1724880728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8/UWu+nkogk+rrCqpk1JaTQfdH+a2mQFoDGBlja3Pc=;
        b=tRFsJsoVX0Mov+ERFV138UC6C4SgJhVtUCqyyXgNdx1bDoP6StcGq5SOlO2p3HuuSE
         pMNKxKdtrs5YlhKvtwM6WFd7DTyK3ovmBMOZmqagOXBrsX9QrlVu2P6vHaQo6iXcgcfK
         GNuaKsFqVK+LetbE/qCN8ygJE16HNwJ9aUt1ykyRBxClg3Dr9JRY7Luu4Yl/dVBfKRbI
         i+zm4wW2diDDnCNDD/yipP0LahGRxGx6qNUgL3rZLJfJQGyeFWL/XgvvyIeXk6RFbjr+
         vq3dKFWMcxRrnaItrGoqXG+4JXvd8oJiazpEflQbtu/8iDIHnlIO6Q3c8mgWPgz9eGiU
         W3Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXddI/hLXciG/X+V0uMP+Zv+CM7+P/Prqm9O9X1y6ObMFSXZHXfcSZ+Bqm/XSSRcScMib0SnO7I+/x8@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2qYftN6KAB/c0DnAOh+SeOM9LkpdoW4Dl4LRZw192Fn6xmF4
	dP6ngW0qo2L4+le4qSfxastGmg6re3MN2rSkG1z/6clyGfA3z7ezoGNEer0fLC8=
X-Google-Smtp-Source: AGHT+IHKJLdclZTFijLA7DW5BcP/iaYLqoD8ipe3pdpTBJexDaFe7tQ5JwO0ExnL7fnrsWAfryPdzA==
X-Received: by 2002:a05:600c:5486:b0:426:5f8f:51a4 with SMTP id 5b1f17b1804b1-42abd22ffd0mr25332835e9.12.1724275928297;
        Wed, 21 Aug 2024 14:32:08 -0700 (PDT)
Received: from kuroko.kudu-justice.ts.net (2a01cb040b5eb100cb3bcc29e5f2b7ed.ipv6.abo.wanadoo.fr. [2a01:cb04:b5e:b100:cb3b:cc29:e5f2:b7ed])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730815b7e3sm23778f8f.53.2024.08.21.14.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 14:32:07 -0700 (PDT)
Date: Wed, 21 Aug 2024 23:32:06 +0200
From: Mary Guillemard <mary@mary.zone>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Message-ID: <ZsZc1jYL8wSZZYSw@kuroko.kudu-justice.ts.net>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
 <20240819120852.tdxlebj7pjcxjbou@thinkpad>
 <ZsOJKMg8xlpdgoi5@kuroko.kudu-justice.ts.net>
 <20240820060946.ktiysu7sn7qgbwx4@thinkpad>
 <223cc3ca-9214-4ba1-a3c8-2d672aef52f9@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223cc3ca-9214-4ba1-a3c8-2d672aef52f9@acm.org>

On Tue, Aug 20, 2024 at 02:50:58PM -0700, Bart Van Assche wrote:
> On 8/19/24 11:09 PM, Manivannan Sadhasivam wrote:
> > On Mon, Aug 19, 2024 at 08:17:10PM +0200, Mary Guillemard wrote:
> > > On Mon, Aug 19, 2024 at 05:38:52PM +0530, Manivannan Sadhasivam wrote:
> > > > On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
> > > > > +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
> > > > 
> > > > How can this be the deciding factor? You said above that the issue is with
> > > > MT8183 SoC. So why not just use the quirk only for that platform?
> > > 
> > > So my current assumption is that it also affect other Mediatek SoCs
> > > that are also based on UFS 2.1 spec but I cannot check this.
> > > 
> > > Instead, we know that if MCQ isn't supported, we must fallback to LSDB
> > > as there is no other ways to drive the device.
> > > 
> > > UFS_MTK_CAP_DISABLE_MCQ (mediatek,ufs-disable-mcq) being unused upstream,
> > > I think that's an acceptable fix.
> > > 
> > 
> > If you use this quirk, then you need to use the corresponding DT property. But
> > using the 'mediatek,ufs-disable-mcq' property for 2.1 controller doesn't make
> > sense as MCQ is for controllers >= 4.0.
> > 
> > > Another way to handle this would be to add a new dt property and add it
> > > to ufs_mtk_host_caps but I feel that my approach should be enough.
> > > 
> > 
> > No need to add a DT property. Just use the SoC specific compatible as I did for
> > SM8550 SoC.
> 
> Mary, do you plan to implement Manivannan's feedback?
> 
> Thanks,
> 
> Bart.
>

Hello Bart,

I think that considering Peter's reply, explicitly checking for the
MT8183 controller isn't required.

I also think it could be required for at least the MT8192 and MT8195
considering they are apparently also based on UFS 2.1 spec [1].

However, if you want me to add an explicit check, I will happily send a
v2.

Thanks,

Mary.

[1]https://corp.mediatek.com/news-events/press-releases/mediatek-announces-new-mt8192-and-mt8195-chipsets-designed-for-next-generation-of-chromebooks


