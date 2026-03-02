Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F108936C9DB
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 12:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454443; cv=none; b=czdkGLrTewy7EetnZ2CJ00yrpAAQIyLUkaA3iBUWAWhUF4u6Lqc3HeNQs+CRUXWqFx/kGWSSte3gtTwrbQix1dyV4jg4Dr9hdCGSXJQO55xkZRFEL6P1a8+gfpZS6PqIOkHud6AQCXQAZknUbgw1p7TyEEe/2g3Z/1m25hD+e+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454443; c=relaxed/simple;
	bh=cGQv2ztvi5jIkl576TfXg/XFJLJeV0yo94W/lsVxk9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OpdS7VeYV4wGwrZpEXOM4q10Xx+unT2cd+IK50CIJePRQc6zn2p5Tvu/OobbPQjJ0/+sK2KH2CYsJMAnnNaqlKzfn+2gRQViodMFD/XJg7czJTdNFdZtjb/5Ds9+EIuncKzf0itJ7SFdchfBLSHdXXqr4FShHGXgze2z1+aBQCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhpRGMSP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhpRGMSP"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82746ed8cb1so2126353b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 04:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772454441; x=1773059241; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASWnQPLO3rtKQNOUBxn8c+Zg8CdQWeT2KYTxFtlRXPM=;
        b=EhpRGMSPRU4P5qYcUjoO0gC/DMy0/4U9dOehxufCGLSi95Lwb2Vs1r5J2OP/9qSEq8
         zj9+hpgk9yK7h5VSbqr2q80jqIt3NF93xjk3+2M/t26Ymr9BmgCm+9nAAIoZgZ4NP/l7
         QMyFM4Kc4VIbmyuzL6ia9eeFJG21LFDqoyQV2PMzL2WCOwoIxFVsgWikYx4TnUZv2s6Y
         D9XzQsdKA6rvQT9n/8IR1KH8kLptlFuXD2Y+Yj+z1GId+0ZQ3uu//65BW5wDGzDllz+l
         EAqBfbE3nJK0/2Rvenx6UWs8ZDf7H0A3x4u3+Hx4WnlMUT5hX7grQGUj/JKc5MnciUY/
         B+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772454441; x=1773059241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASWnQPLO3rtKQNOUBxn8c+Zg8CdQWeT2KYTxFtlRXPM=;
        b=DJ2ceDkurC4oIIWlCx73x6BA5UbiR3hGZ/keock1b8HY0YJbEmzpveVXT6Z8yro72+
         fGaOSW+9J6gkJVSVFbipC9VQlV5lS1ut6VqIieewZvrmBb/zsE9rYQAN7LRiWwhGDtHv
         bhMc94SMkusfPQXoM4iE7M50/YkPhWTj4h3IZHY9bycO+OFCYczehjkDZEZiaBbJtwBJ
         kQQ/ZEgk+ngJNd+JeoxCUqi6XwIFJmzGeXO40QJ3H4N9RIrZ5+06Ov12k2NmuECh6HNH
         IjKzBXSE6ZTMscXo3PeinN38+3lwq+1fuXoLrR3NgVcPYK0uCQ80tgi/kAYf+RmILMck
         DaIA==
X-Forwarded-Encrypted: i=1; AJvYcCXNuy4CupDlyGkn2UjbL+mzbGQPUUsWuEwmgKMd2iOl70Tqq183QIaNYGogd/NEiYjg80PE2MN/6uiI@vger.kernel.org
X-Gm-Message-State: AOJu0YwsoqEN5mY/2YCoVQbMPhPdiTDio3TcuglDt5zxgHpcKzCwrrZe
	1qVRzWAPN2Io//NLGXX8ezYNvKmtnvid47gio/Obz+Lvv6CAxBpdSk1Y
X-Gm-Gg: ATEYQzxpR35Pdb6xx9eCkqQs4YjuXczVpVF6nPiIhAPZoRvu9MKMPxUuGs7xBuWtkHO
	dYacicJk4nYX5Ye5RVvsXVerbaGTG/foCacKBOa5+dakZb4wypvjweKlXF2kHdDWa+ZorYXW202
	Mw6mnYgVau4JcZRcMOMrx+ahrfbfIa+hvFM740YQV2a5X5+k9hDLE1KLnrXOv240FS7Og1xQCeC
	oZOtsQ0zxB0a5Bj5c1psmm3Kw189QODo8WBI+P2T6HlzX5NMMm7RtSHoLqXnhjCTjGin9a0+38H
	H5QP5xegSqyXb0ODGottWacZ1HmaVk1LxIFHQkN8T7xICjt9bQnmNgbsLGcuZLg5P7guJbSeI6o
	zsPoKoBMkejMUHRcKPxo0lzW/Et9XfdHhY4C/qOyVy3RCowAxwvDyammVHYFvyyhAKowEWqihpQ
	VaGhu8OA0pLvD24QFe+8+g5e5LKRWtuEu9ZrKuzLR1m5VRQ0SI
X-Received: by 2002:a05:6a20:729c:b0:38d:e87c:48ca with SMTP id adf61e73a8af0-395c39e0f08mr12933027637.1.1772454441192;
        Mon, 02 Mar 2026 04:27:21 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([103.50.21.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35977bf69bcsm4002488a91.7.2026.03.02.04.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 04:27:20 -0800 (PST)
Date: Mon, 2 Mar 2026 04:27:15 -0800
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org, pankaj.raghav@linux.dev, bvanassche@acm.org,
	dlemoal@kernel.org, Swarna Prabhu <s.prabhu@samsung.com>
Subject: Re: [PATCH 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
Message-ID: <aaWCI69aQAWEgjv7@5163NRD-SPRABHU.ssi.samsung.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
 <20260219043741.276729-3-sw.prabhu6@gmail.com>
 <bd5605d1-3f2e-49ca-9807-e4819a8ddfee@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd5605d1-3f2e-49ca-9807-e4819a8ddfee@oracle.com>

On Fri, Feb 27, 2026 at 08:35:32AM +0000, John Garry wrote:
> On 19/02/2026 04:37, sw.prabhu6@gmail.com wrote:
> > From: Swarna Prabhu <s.prabhu@samsung.com>
> > 
> > Now that block layer can support block size > PAGE_SIZE
> > and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
> > fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
> > > PAGE_SIZE in scsi_debug.
> > 
> 
> Surely the sd driver or block layer should be catching non-compliant HW,
> right?

Yes, the sd driver and block layer will catch any non compliant HW.
> 
> The scsi_debug driver should minic HW, and there is nothing in any SCSI
> specs which mentions that the sector size needs to be limited to 64KB or the
> like - am I correct? The useful thing about scsi_debug is that we can
> pretend to be broken* HW and see if the upper layers catch it.
> 
> *broken for Linux or non-compliant wrt spec
>

As you pointed, the SCSI spec doesn't restrict the sector size to be
limited to 64 KiB. Earlier block layer had limitations on block size
upto PAGE_SIZE. With that limitation being addressed and sd driver
change, sd driver and block layer can handle large block sizes
correctly. By allowing large sector size on scsi debug we allow 
emulation of spec compliant HW. 

Thanks
Swarna

> > Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> > Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> > ---
> >   drivers/scsi/scsi_debug.c | 8 +-------
> >   1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > index c947655db518..4c6feee87f05 100644
> > --- a/drivers/scsi/scsi_debug.c
> > +++ b/drivers/scsi/scsi_debug.c
> > @@ -8495,13 +8495,7 @@ static int __init scsi_debug_init(void)
> >   	} else if (sdebug_ndelay > 0)
> >   		sdebug_jdelay = JDELAY_OVERRIDDEN;
> > -	switch (sdebug_sector_size) {
> > -	case  512:
> > -	case 1024:
> > -	case 2048:
> > -	case 4096:
> > -		break;
> > -	default:
> > +	if (blk_validate_block_size(sdebug_sector_size)) {
> >   		pr_err("invalid sector_size %d\n", sdebug_sector_size);
> >   		return -EINVAL;
> >   	}
> 
