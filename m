Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B74B4C98
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 00:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765498717; cv=none; b=hYmiEwD4mQRznRHU9cfuwIhmywgr6yh9imrbzYHoHd/Yw52kWu82/yxDv1kG0zMEZ9gm+5/t5sO4cAQThjYzWbW4e9qISl67wkjDKABzbcjZVrIULSrm3q19e7nHyiUuexxs4l1kM9axJ6F/xn6YjwCtKvNx/Z4aCf6joZHtpC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765498717; c=relaxed/simple;
	bh=15plplR1cpoC1A9LV/Rm8Q8427okt8l5fnZ7s1FyvqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oP4qxUpybL1Cz/meNn6bvfig1RAg1lcf91n1Ki5+II3RKl8luPIGqYVzVOpeLPbI7sCkNlR0srAtYf6KLeXoXDtpFysWu/HpZnAwqpIc7xXPzHgkjNXCTZu6xG8ExQhBx3nvIL2XWEG4/HbKm4Dum3f/H/XT9iFpi04TbjuR6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AoPys7vE; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoPys7vE"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso797796b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2025 16:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765498715; x=1766103515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yFOUupdoY2IBfYz7cj82tulz4y4RQmCbBpdYyUmCwTM=;
        b=AoPys7vEeSoAffjp9/oj9p75d2tyt6/5c3af4WyGguDhFYcpxNV3/b0NTg3l8iDACl
         QLtsj2sZL27auY3FtjXe1Wp5u3n+tJcpf4V8X4b+p3PSXMBXHNSSA/xrb2+hjrW9jI3A
         6Ad6+7UcCxHJ8U8HPjNc1ZRY+0kFasOBC+erjBdUziCMgCXPq3cQftIVrPb89v5GlGUZ
         vZRg1s4naLnw6Hx8VleUdnCTlt0s2Gw2ZeHimoeRtlwQHnd2sdHnfC9tESnj25B+z6z0
         0GgkisBW5Q7zuI9/Q+4fLiUGOKTfzEVYEiKkINTVADDDF/r/L5hA+tsJBIpngGAtbeGl
         3n6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765498715; x=1766103515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFOUupdoY2IBfYz7cj82tulz4y4RQmCbBpdYyUmCwTM=;
        b=m9ZBMwgVy/uEqCcsKN1BsRVjA5ySNOezaK5bDwPgeGa7uucXxxpFl3k9NcNzdHEvFm
         rws8H8Ye27nXvRHPM8ODQEpg5x2uGFFY//1I64S8wjUB6raPC68D4NX7EKv6nwE3eY+L
         1n6GFWA8SVTuL4cFjtGp/HYwCJ0svpxvuvp9ENxea/E6KO+Riw3vq+RPkG1ydRv/gXtd
         rbPsGPGiu9k9SfAkAmtbQFpkm3IFSytqJ7QwRnIdKq03tlw6Xdz3jJ9+ZCFm42dqApMA
         wxieXjLAFsnes3mVXd0+4L32SENM554418cYTuv/6iEVBPVQKw1lhFQJZ6oKlDBKk5zd
         XzYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx6XHJrWMoFeYDGvxnSzIWejy39/V/jeEmupgGoXiIy06/eTFQNHHIZar9nEvhLgJ1mETTYcTz1/gd@vger.kernel.org
X-Gm-Message-State: AOJu0YwOI/oBBew53QAK2+ebnmZ0kbxxzCzF0qWc2B/XJhYMo/Xlvafo
	AkNp64fKVVlu2B6hvITJYoveon+9oHC8Pdj9xyZI0VZ3v3jsVsSGalWJ
X-Gm-Gg: AY/fxX6T6aniCVYVYRMJ+hAdoQdbZlUNHN/pHcHoLWwJoYnf/cpQ9K4j1q1WK2OjnVr
	PztlpHl2Uq7zUuyLmP7rUrTnuOn2F2B5XhxjWXBWVdXsIMpuzqOr9aekiVAfuWTdqwpJykZ+BJj
	5xEL6T/jT8pv0yDHX7n9vJgOwwH1/tYBIrVfD9CQMpWHoikMIFUB0NsyWshu+y9Bbq+WszDC7cT
	ztUoKzEf2nsnXDm1wWxGDXuK7745VA/S2DW/62m45YK0zY39n1OJl46zYZNFhqEz+cTVfyZsuYl
	y0c9GaRY3jWDmL1Q7iJpkzzbm+ctcDAcL5EQWTAVzzZ4MxEP+hb+xypHcehmagDNT+sU/hpmcVt
	FCMgyuT3G6ocdGvfLHkg9ZHCSYYbUeEzCdGNNoB+ayLZ/lF2Ao1Hc1bhYcYJf8HZE7/Zm9skEAW
	qHJHbtbHTe/8tAgfGxclnYnl67t3yu7iq87KWCUg==
X-Google-Smtp-Source: AGHT+IHG4WpRXnDDRth18q2xYvJnOxY5tkZ71c7eprKcSWvdKv4QOXY/t1xL+XMRFPUhk6/CFbFasw==
X-Received: by 2002:a05:7022:6707:b0:119:e569:f258 with SMTP id a92af1059eb24-11f349a4809mr289828c88.1.1765498715317;
        Thu, 11 Dec 2025 16:18:35 -0800 (PST)
Received: from deb-101020-bm01.eng.stellus.in ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2b46f5sm12255150c88.5.2025.12.11.16.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 16:18:34 -0800 (PST)
Date: Fri, 12 Dec 2025 00:18:33 +0000
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, bvanassche@acm.org,
	linux-kernel@vger.kernel.org, mcgrof@kernel.org,
	kernel@pankajraghav.com
Subject: Re: [v1 0/2] enable sector size > PAGE_SIZE for scsi
Message-ID: <aTtfWdFUARToPhD3@deb-101020-bm01.eng.stellus.in>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
 <ec5f42bd-a26a-4416-b967-f67090e9a423@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5f42bd-a26a-4416-b967-f67090e9a423@kernel.org>

On Tue, Dec 09, 2025 at 05:56:05PM -0800, Damien Le Moal wrote:
> On 2025/12/09 17:41, sw.prabhu6@gmail.com wrote:
> > From: Swarna Prabhu <sw.prabhu6@gmail.com>
> > 
> > Hi All,
> > 
> > This is non RFC v1 series sent based on the feedback received on RFC
> > v2 [1] and RFC v1 [2]. This patchset enables sector sizes > PAGE_SIZE for
> > sd driver and scsi_debug driver since block layer can support block
> > size > PAGE_SIZE. There was one issue with write_same16 and write_same10
> > command, which is fixed as a part of the series.
> > 
> > Motivation:
> >  - While enabling LBS on ZoneFS, zonefs-tools tests were being skipped
> >    for conventional zones when tested on nvme block device emulated using
> >    QEMU. Hence there was a need to enable scsi with higher sector sizes
> >    to run zonefs tests for conventional zones as well.
> 
> This is super confusing: there are no conventional zones with NVMe. And why
> would a problem with NVMe require scsi patches ?
> 
Agree with you. NVME Zoned Namespace require sequential writes.

Our initial goal was to enable LBS on Zonefs. Running zonefs tests
on a scsi device covered both conventional and sequential zone based
tests. So we had to enable higher sector sizes on scsi device and while
doing so fix the issue seen with WRITE SAME commands with higher sector
sizes.

Thanks
Swarna

