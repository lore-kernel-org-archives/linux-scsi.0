Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634BF347FFA
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763546968; cv=none; b=NqfPl0POsBAEJtXKRFbqpj0iakGPbdZX2N6Xl4ux/mR/LlKeOv6EXNBGaT1es/E5zvliANj4Q+SwSYLRyB5m6G7SxcFwrHwoHZ7pRGKRa5jMOYsXKWrknuS3prf3L5X13okRfKvAoBaH+vJQ1gzFS17yQ7wpaddzGJil3DQRppo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763546968; c=relaxed/simple;
	bh=OJvuqh8SyRe//eizJsEe1K247PQ8bD47X5Q22nudA1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ltg0GgXHs9fzUEgRMb/hYtR7qZEbnZljslpM3YiPsjimJqC//r3qIHj0sF93zoZgdPv8jPkUxcZawdiro7Bn3UMY1rFyw8z9PGubx0IBI0g+xTsvE4z9xLFDPAgr459ptBp7CDA72Dxtc0jaaU1q9Qt+pPwWtm2gCO74L1AE7+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Me68I3F7; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Me68I3F7"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b72b495aa81so839077866b.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 02:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763546963; x=1764151763; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZmwnZeJsVmH4Emd6Sk7OTkRxBmCW6aXF7g1I/Zjods=;
        b=Me68I3F7En431raJbedjbBOoq/VSyrLNPSHh1NDSm7hS35yUH6C/wWOVtLpKfCtyKl
         pgezovtS+J6QjL9ajtb55htcb981QToFRQ+otMIJfwMjjV11g4S/+ihLcnAz/y8U6bMQ
         vvXmi1cN/61t0y6wCN8KE5mqZ1KQunNOGGjztAYvEIM9rtm2yLoN1BWHaoGQB0l04TCm
         cnIlJieWZmh52VixvgLDVLIKN7Oy65N1tNxRLoCQ5ndqdmyKOMCwQZUDSWQdLd5mGVUn
         Hr8IR746a3flbusR85EkV3KQPqkp5ZhtLalhLau2pCQSTiay13R7j/1/SFqpcCg/+jVE
         uPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763546963; x=1764151763;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZmwnZeJsVmH4Emd6Sk7OTkRxBmCW6aXF7g1I/Zjods=;
        b=RZAQsSfIITDjaqSaIMbqMpmIyJLp74IY8rODOoSYivAqkUuR+X+/y01jdeBjASRiSS
         p5OzCCUMvt6NSphlkvpOqxs7EyntsHESwxUdaBw2TF32jKYDDxUWGu/tAtpzdBL2Dbvy
         4UjF53f7g/W0n56WxhQ0TuZ8DVJp5/kvxC80ZB/830Oyxr5i0sOV6cKWtFPAXV11Zzvm
         Ds1yORsMAhxT0BPpRH4TDGb/lNyRFizZMaZmGQEtzu4Z+CG9LvlgpJoSACfP4U/ZA6Hh
         VGlWDZFqXt5LtfINItjDITnz+9+X+aMCC9bFCWEQsfRLEKeV/1FVBlvCacX2324TlCB6
         ay4w==
X-Forwarded-Encrypted: i=1; AJvYcCUqkpTUVVHkzj988//LSaq8T7A1I3Ic6LcVuck22+1d6NWIn27NH+sMAQEQCWsXEwQWMeyZohjNAZnm@vger.kernel.org
X-Gm-Message-State: AOJu0YyMQhoil2ukEgGq1Liy61OFlkjNs8Jj/J0HIW4xVIYc6F8cEtSu
	i6tBBGFyfQxul7w0po8s3iq0szu9hGZhcZdU1pDhwX8fetHtGRDOaMaaXVTG2ckm414=
X-Gm-Gg: ASbGncvXRnyEaG2LbGrgwaX8gKRwKMxY345VmOtXtpyfGcMu1FEtErhHwg68iqws09c
	lRBO3lJZOh7njGuoG+Dhtt0LzROzf61dKX9E2kMVqOSmTgYhIpDACcDRLjvhHlquMbilZDNac+P
	2HXJHYeNzaBNNwa+hVT1anOCGn+jw/tT17k2FKS14KF0vFS6JD50w3g1iXpKal8l/S7o/qpEh34
	d7OwMRAodCWG3NsxEwc13NvsLPoFjkaUe59P3MblhHr4J8m0K45uAJFUwQTyhv9iSgjCBkVL9nL
	ggmQwGheP6ZBEmTU6QBPfAzaSvDslICr1eiuaZ2rkR2dS9i10tG9KHiXBcDeQtLqWTrW5pZtf3R
	FuX74XU/Y0rJFd/biuRCsWfVx3tKQTRc5PWeXL8HqI3PCcx9C8OoHvBykJITm5tJfKcAG5KTl4d
	OXMOhJ3O/ZzH6Y7FaZbcOHLrkZ
X-Google-Smtp-Source: AGHT+IHL60A5nBupA1OyvdeZdvK8rVJqcdAj2UJ8GMSSqilZDEkvpcYDaNSL65+yyn9lVOsemK499g==
X-Received: by 2002:a17:907:1c81:b0:b72:d2df:641c with SMTP id a640c23a62f3a-b736795d498mr2006941666b.49.1763546963352;
        Wed, 19 Nov 2025 02:09:23 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fda8bc8sm1594056066b.49.2025.11.19.02.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 02:09:22 -0800 (PST)
Date: Wed, 19 Nov 2025 11:08:01 +0100
From: Petr Mladek <pmladek@suse.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Corey Minyard <corey@minyard.net>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Sagi Maimon <maimon.sagi@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-mmc@vger.kernel.org,
	netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
	ceph-devel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 19/21] scsi: fnic: Switch to use %ptSp
Message-ID: <aR2XAYWTEgMZu_Mx@pathway.suse.cz>
References: <20251113150217.3030010-1-andriy.shevchenko@linux.intel.com>
 <20251113150217.3030010-20-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113150217.3030010-20-andriy.shevchenko@linux.intel.com>

On Thu 2025-11-13 15:32:33, Andy Shevchenko wrote:
> Use %ptSp instead of open coded variants to print content of
> struct timespec64 in human readable format.

I was about to commit the changes into printk/linux.git and
found a mistake during the final double check, see below.

> diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
> index cdc6b12b1ec2..0a849a195a8e 100644
> --- a/drivers/scsi/fnic/fnic_trace.c
> +++ b/drivers/scsi/fnic/fnic_trace.c
> @@ -215,30 +213,26 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
>  {
>  	int len = 0;
>  	int buf_size = debug->buf_size;
> -	struct timespec64 val1, val2;
> +	struct timespec64 val, val1, val2;
>  	int i = 0;
>  
> -	ktime_get_real_ts64(&val1);
> +	ktime_get_real_ts64(&val);
>  	len = scnprintf(debug->debug_buffer + len, buf_size - len,
>  		"------------------------------------------\n"
>  		 "\t\tTime\n"
>  		"------------------------------------------\n");
>  
> +	val1 = timespec64_sub(val, stats->stats_timestamps.last_reset_time);
> +	val2 = timespec64_sub(val, stats->stats_timestamps.last_read_time);
>  	len += scnprintf(debug->debug_buffer + len, buf_size - len,
> -		"Current time :          [%lld:%ld]\n"
> -		"Last stats reset time:  [%lld:%09ld]\n"
> -		"Last stats read time:   [%lld:%ld]\n"
> -		"delta since last reset: [%lld:%ld]\n"
> -		"delta since last read:  [%lld:%ld]\n",
> -	(s64)val1.tv_sec, val1.tv_nsec,
> -	(s64)stats->stats_timestamps.last_reset_time.tv_sec,
> -	stats->stats_timestamps.last_reset_time.tv_nsec,
> -	(s64)stats->stats_timestamps.last_read_time.tv_sec,
> -	stats->stats_timestamps.last_read_time.tv_nsec,
> -	(s64)timespec64_sub(val1, stats->stats_timestamps.last_reset_time).tv_sec,
> -	timespec64_sub(val1, stats->stats_timestamps.last_reset_time).tv_nsec,
> -	(s64)timespec64_sub(val1, stats->stats_timestamps.last_read_time).tv_sec,
> -	timespec64_sub(val1, stats->stats_timestamps.last_read_time).tv_nsec);
> +			 "Current time :          [%ptSp]\n"
> +			 "Last stats reset time:  [%ptSp]\n"
> +			 "Last stats read time:   [%ptSp]\n"
> +			 "delta since last reset: [%ptSp]\n"
> +			 "delta since last read:  [%ptSp]\n",

Both delta times are printed at the end.

> +			 &val,
> +			 &stats->stats_timestamps.last_reset_time, &val1,
> +			 &stats->stats_timestamps.last_read_time, &val2);

I think that this should be:

			 &stats->stats_timestamps.last_reset_time,
			 &stats->stats_timestamps.last_read_time,
			 &val1, &val2);

>  	stats->stats_timestamps.last_read_time = val1;

The original code stored the current time in "val1". This should be:

	stats->stats_timestamps.last_read_time = val;

> @@ -416,8 +410,8 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
>  	jiffies_to_timespec64(stats->misc_stats.last_ack_time, &val2);

Just for record. Another values are stored into @val1 and @val2 at
this point.

>  	len += scnprintf(debug->debug_buffer + len, buf_size - len,
> -		  "Last ISR time: %llu (%8llu.%09lu)\n"
> -		  "Last ACK time: %llu (%8llu.%09lu)\n"
> +		  "Last ISR time: %llu (%ptSp)\n"
> +		  "Last ACK time: %llu (%ptSp)\n"
>  		  "Max ISR jiffies: %llu\n"
>  		  "Max ISR time (ms) (0 denotes < 1 ms): %llu\n"
>  		  "Corr. work done: %llu\n"
> @@ -437,10 +431,8 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
>  		  "Number of rport not ready: %lld\n"
>  		 "Number of receive frame errors: %lld\n"
>  		 "Port speed (in Mbps): %lld\n",
> -		  (u64)stats->misc_stats.last_isr_time,
> -		  (s64)val1.tv_sec, val1.tv_nsec,
> -		  (u64)stats->misc_stats.last_ack_time,
> -		  (s64)val2.tv_sec, val2.tv_nsec,
> +		  (u64)stats->misc_stats.last_isr_time, &val1,
> +		  (u64)stats->misc_stats.last_ack_time, &val2,

So, this is correct!

>  		  (u64)atomic64_read(&stats->misc_stats.max_isr_jiffies),
>  		  (u64)atomic64_read(&stats->misc_stats.max_isr_time_ms),
>  		  (u64)atomic64_read(&stats->misc_stats.corr_work_done),


Now, I think that there is no need to resend the entire huge patchset.

I could either fix this when comitting or commit the rest and
you could send only this patch for review.

Best Regards,
Petr

PS: All other patches look good. Well, nobody acked 7th patch yet.
    But I think that the change is pretty straightforward and
    we could do it even without an ack.
