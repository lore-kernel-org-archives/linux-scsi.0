Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743A23A1B5
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 00:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723312; cv=none; b=GPMEVdIcosSXyji3wbzIWANhC8MFzmjbEHiA9138SxNMq1ZrHbEjU6Sk3ld0MjizdG6/K/gI9uKGuXH+P1ttz0u1JTNkBsFDbGIms+DWvgSkTKZgpGrVLRYDACAYMhZCHJvyNJlCljyOqgMSNma2IG5E5n2ObE70rOL0mMTSlIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723312; c=relaxed/simple;
	bh=fAdeoJ6erRi1bDajkUh1Wce9ATtkIHIIZvzpZpna5G8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiZSymYuEqlBCDMHWeg1c+sLx6lpq7sFRBt2PmqjZq5eRqtX2aLSAX6MfRvLxWZgko3I+3CKIzzap+Sv+cv+EyktbSMhMqnACmDkPaB+7zfLgftagDqaiu8nZOy4xkZGYLvRIM/Ungrg+D9syKc+3/Ff0Uk2mrGHl9T9b6CQk/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxWIcn/S; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxWIcn/S"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so5461347b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 16:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764723311; x=1765328111; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XG7F8aa94DLW62wyIfa6XJrxB3wigGeIVatF9ICOIwo=;
        b=dxWIcn/SRod3kVMkoMG8HZUeCcGlyQd763RgWIWvUQfipgIX3qdGfLrbQms8FUFE60
         6O9jnCHjB2SRkBDQAGOp3q4o5YHwOowS122DFEs+V6YlBiyEG7mFR7zzHvXbk6kkq0rs
         gPH/zl7fu5LnTcsl3cPHWTZuNubMs++e5jtrTxgQCS/sUGdvDfFeuwHv1p07rjfgShrf
         euhP1k9GHhlPzLlHZhgo5GI2ldEgqNZaOdUT5PZ6zZKrLv6DIwloXF9OmADBAKl5DTK1
         AdHMEBEBMkStDMsi8RAtleh4twtWPsNuxHB3X8LZIFJ2pI2myBG+BQ5OYzzP8WaXz3BT
         5f0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764723311; x=1765328111;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XG7F8aa94DLW62wyIfa6XJrxB3wigGeIVatF9ICOIwo=;
        b=WAJ/w7Ps0S9hamYA1nYUc926BZptCVv4uulUl9LvWHyu5SDgN+8bIxwN+wV1/FZGId
         fTHIufJ0keL5sa/1Yh9QhiezALXiyczdqobjnOR2MAUK/a7FSi4WwCeO/4CNC1rDkOYN
         4C/4HW5kTt5VH72o2J2mHhKLP/rJS9Jr3l7MKah7e9mnjzyp6JuYL+jLJrcJ4HetGPCQ
         nlJq8cYBVO3hXc2r63ZTJwlBjpRGay5uJzfiVI9MbzWGZm0+wvK8hJecV0KQrQkPN1A0
         BYv5KknaQ1uJzaBeHzbjrBZCZI53w0zrKKpaVZd5PFxLq8G9BJ/VgYhSusGL3hFBwKIG
         Otow==
X-Forwarded-Encrypted: i=1; AJvYcCXLykxs2ntAWhB5pfV0trjjtnOZ6RM/A8OhIXiavvuCeksiC68DV3syp2zzxTJ2+IoyXs+T3GDvZgII@vger.kernel.org
X-Gm-Message-State: AOJu0YxTxWRf9LYKuNZ+A0OgmZiboINVhaMDb5Hh5GYBOenFYtN2hL1q
	pwY/+gn9ru3Rx6A6R+NQHtdwVwXuzYpl0E+K/qjEvGQD5DwCm28xvoMi
X-Gm-Gg: ASbGncuINZvb7Y+02/qgPqrw5Otykq/JpbwwepYzkHkpesMb3xSDFWNSxWab9ftuRa6
	idoz//Z0veqMuqj2maDbY2j6P23NdWk4kxYlOiAKu5FUlNo2OzatK+89p3wQK+mPHwpdIDgoQxO
	00qiW8ceyaDryubvpjTo/jRJATv0TKNe+GFAbqwpCFL/IJ6bZgYwVin7jC4FY7HKLUR+5eoFiTC
	Xva6czjlrvGBghP65cI9MWAXyGi+mZSCugO4KDAyo6Uykv277CZUdGbIId8ytuYwemflH0V7ADf
	wGauEg8JSxtNsuqHQyU3BUCSzJoVgSU0l3IIIEtU1cOE1bq2TYPqGxZJez/zt3yFk8U0ps2fJMH
	6ROGrIVEhMCK+W30BPKn/jQ8Qok0xwrBbBY/Ce60m1C0qK6q6alffDYNUS+YyPymsB/6hym+rqV
	FXN25IIgnn6sog3unoel2XPTaEPW0EMFpb2N7h+g==
X-Google-Smtp-Source: AGHT+IGWklPVoYjXKlvgCnKOUGR6esruo0sywKQ+Jd+CLFYA92MbRsvu3QcO1E0qhMVZ4AIV6oyYdg==
X-Received: by 2002:a05:6a00:c8e:b0:7b9:7f18:c716 with SMTP id d2e1a72fcca58-7e00a2c7cabmr526629b3a.1.1764723310595;
        Tue, 02 Dec 2025 16:55:10 -0800 (PST)
Received: from deb-101020-bm01.eng.stellus.in ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6c47sm18205020b3a.18.2025.12.02.16.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:55:10 -0800 (PST)
Date: Wed, 3 Dec 2025 00:55:08 +0000
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org, kernel@pankajraghav.com,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 1/2] scsi: fix write_same16 and write_same10 for sector
 size > PAGE_SIZE
Message-ID: <aS-KbGW4fQAqua3O@deb-101020-bm01.eng.stellus.in>
References: <20251202021522.188419-1-sw.prabhu6@gmail.com>
 <20251202021522.188419-3-sw.prabhu6@gmail.com>
 <5f04b355-769c-41b2-b3e4-32ca69429dc3@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f04b355-769c-41b2-b3e4-32ca69429dc3@acm.org>

On Tue, Dec 02, 2025 at 02:28:47PM -1000, Bart Van Assche wrote:
> On 12/1/25 4:15 PM, sw.prabhu6@gmail.com wrote:
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 0252d3f6bed1..c3502fcba1bb 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -895,11 +895,20 @@ static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
> >   static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
> >   {
> >   	struct page *page;
> > +	struct scsi_device *sdp = scsi_disk(rq->q->disk)->device;
> > +	unsigned sector_size = sdp->sector_size;
> > +	unsigned int nr_pages = DIV_ROUND_UP(sector_size, PAGE_SIZE);
> > +	int n = 0;
> >   	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
> >   	if (!page)
> >   		return NULL;
> > -	clear_highpage(page);
> > +
> > +	do {
> > +		clear_highpage(page + n);
> > +		n++;
> > +	} while (n < nr_pages);
> > +
> >   	bvec_set_page(&rq->special_vec, page, data_len, 0);
> >   	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
> >   	return bvec_virt(&rq->special_vec);
> > @@ -4368,7 +4377,7 @@ static int __init init_sd(void)
> >   	if (err)
> >   		goto err_out;
> > -	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
> > +	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, get_order(BLK_MAX_BLOCK_SIZE));
> >   	if (!sd_page_pool) {
> >   		printk(KERN_ERR "sd: can't init discard page pool\n");
> >   		err = -ENOMEM;
> 
> Have the above changes been tested? 
 
  Yes, the test details are included in the cover letter

  Thanks
  Swarna
