Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2C95383;
	Thu,  5 Jun 2025 00:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749083746; cv=none; b=JH9po2oJqOqGWGedxQ0vE/neioolUiYYIYy6nSie02aSYyDepiJgnyMc2X81/clVEC/3hEyp+E9t0PxHsLsfzzl2VTAS1gYchhPbk8Y8DpJpnQXQw6URzmqOm3r74AlrtIQw79zMzgkfeaKmigypviXRZ6FkyKuy6I32hK3PhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749083746; c=relaxed/simple;
	bh=sTgIeR2mhahdKJPKUuCYlvjmkROTvWGfwQHeezaHDxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSG3oPAUet/UsbPcVM5qDHXQPVF7Pout3YBAUUO8AHWW3QaSznnUJT3FC854eFxEEw04UgGfx5cH59dRbY7uMAxwuUjxvdCkcLl89C3CkINTQ6G/tgbB62OvmrfhAoACRllIUpw2x7f6dkckn4msxfo5SxwBimTrn3WOkUjHKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WY4cJIws; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WY4cJIws"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-70e23e9aeefso3801797b3.2;
        Wed, 04 Jun 2025 17:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749083744; x=1749688544; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jzlg608/Z0EJ3N4+1QOkK0KW1pbKr4cLV7RawPaqUX8=;
        b=WY4cJIwsRlWFERWuC0LKGghJt9wluxgWCAJ01ftBrrVIRnGT/johAb9pf7D4oQw/9s
         zMR3T/M7UoLZVrqaTQUYoMHt6409ksquUHokDOWT9JO07s3EuNWaL9vHdzDFDUNaz4io
         iGytnULpWlq0qDOfBYOoVG894rFDYphU9E26TiaKT1a6U+lc8n5T3sBFQ0jWGwjhg70c
         tGAP4zOqUjjVhQLlzanrVr7gfSO01PXaM7Gs9+a74Ieze4pzMemAFF1AiXAb8etTzVsn
         7Lyd2RuU9UcWwUPbec0mf6bZSJbJ3iK3/ZhwnTZK8VeXVBvWYZUNoW1g0eYsJ005395A
         VYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749083744; x=1749688544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jzlg608/Z0EJ3N4+1QOkK0KW1pbKr4cLV7RawPaqUX8=;
        b=HrI7gaCP/G95EmZYTx42OPkaXqdsOQRpk8mRQRzy6azrlBxS1MkMfRI7VgY5MJlJQb
         ReB0SQlI7Q6VdVbJjS/NW0M3DlSW7sLsDx0e83lsLrCRLva938V7QIKdS4CjciZbcDiu
         Bnxp2yYoSzErP0K6hUALcKnmUGHU3G5k3oCAwhGhgCQzfbz90cNNQEZ+UuoXLm42H6Ml
         WS7fVHnv+1I4D2qlyDAMXWa+yWdvCGGCpssIHe7LS0tBS6glaEWCB6CE3tY98NuvGinF
         VQ0s9BFnpPRK5vqOqEy0IPI/X0/3qfk5My+6yFi3Pil5LO+2rPtAcd97JdRKaNIV6G9r
         L7UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDxY8iL5yGoh6HNkuMols2gpawqmw1qam+yCj4o5iNKO7kTLNBcOtyDmPNt2IF06SU4npD/R3i2it/O8o=@vger.kernel.org, AJvYcCWvMjmsmIZQXGl+Q3hsJNbCdfwepE+O1FGigeuDIcBlz48zgzw/rl1i25XV1sMtswHEXh2tt5cco6zaGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwavFOF0+OxFI1S4XU+Fw96/R1LaDaOENPnIyNx7xhyPHc6SLJd
	pmsVUcQgblhN6qC4BmzO1LKsZWsaisZ1rMjwaQsGuySe5geqRm73Hyqz
X-Gm-Gg: ASbGncvGrPQfQvkwAB1ZfyzqWhADilF3s9TPDm1GMniC45Bq3S8BBkEpWFa+0pnD671
	qP9QGLkOUdwnwhncTbOvggS1crFykFOH6AT1xEAlD3uSIqINPO3HXox6NQBO3Knj39EFxHXfOHD
	jRzNXZs5PnQ3YlZAoUqYmlJ5wKp6aeFRn15qBmb3N8+y2IXs3ru5pnTM/j6iEhuACKMm4D+zkJQ
	8J0oT6xawEDyfSA1Ys+FUZhSIv+AqagVu6Zv7oMuYFIJ8pbMTDLcCPtp43/Jev+3Xra4JLd3+R4
	X1qcXcKY+tcdJhDdKTi0yS/WPs/hPOhjOUDExYEsqWOCPWFFHuyEEkr/3cHUV5L/5yZirUTuhis
	yLvgYiNhJpvU=
X-Google-Smtp-Source: AGHT+IHdaGroBvdNNA/E1lgaGvOoY3GpK51u8/yEH3ZyI1tpqMCcQTTZ/pQVxBkvuoMcaBf3H1aNdw==
X-Received: by 2002:a05:690c:4910:b0:70e:5eda:4940 with SMTP id 00721157ae682-710d9f91156mr65639557b3.25.1749083743726;
        Wed, 04 Jun 2025 17:35:43 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-710e91e15b4sm1424357b3.15.2025.06.04.17.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 17:35:43 -0700 (PDT)
Date: Wed, 4 Jun 2025 20:35:42 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH] scsi/fcoe: simplify fcoe_select_cpu()
Message-ID: <aEDmXvKAvJfjMrCk@yury>
References: <20250604234201.42509-1-yury.norov@gmail.com>
 <0959d3c2-b849-4826-8edf-d72a89fbadff@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0959d3c2-b849-4826-8edf-d72a89fbadff@acm.org>

+ Tejun, Lai

On Thu, Jun 05, 2025 at 08:13:53AM +0800, Bart Van Assche wrote:
> On 6/5/25 7:42 AM, Yury Norov wrote:
> > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > index b911fdb387f3..07eddafe52ff 100644
> > --- a/drivers/scsi/fcoe/fcoe.c
> > +++ b/drivers/scsi/fcoe/fcoe.c
> > @@ -1312,10 +1312,7 @@ static inline unsigned int fcoe_select_cpu(void)
> >   {
> >   	static unsigned int selected_cpu;
> > -	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
> > -	if (selected_cpu >= nr_cpu_ids)
> > -		selected_cpu = cpumask_first(cpu_online_mask);
> > -
> > +	selected_cpu = cpumask_next_wrap(selected_cpu, cpu_online_mask);
> >   	return selected_cpu;
> >   }
> 
> Why does this algorithm occur in the FCoE driver? Isn't
> WORK_CPU_UNBOUND good enough for this driver? And if it isn't
> good enough, shouldn't this kind of functionality be integrated in
> kernel/workqueue.c rather than having the above algorithm in a
> kernel driver?

(I'm obviously not an expert in this driver, and just wanted to cleanup
the cpumask API usage.)

It looks like the intention is to distribute the workload among CPUs
sequentially. If you move this function out of the driver, someone
else may call the function, and sequential distribution may get
broken.

If sequential distribution doesn't matter here, and the real
intention is just to distribute workload more or less evenly,
we already have cpumask_any_distribute() for this.

Thanks,
Yury
