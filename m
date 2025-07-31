Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1123C2AF07
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 11:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753962526; cv=none; b=E5pIo52alk6ncMB8wz0aro6thftC3eO9NAyr5MZTJLGUEzOnrcwefoWDKfH9o9+tk3L/yKNeb0d405ZmYIP41kgkL0wwtDHREZ8/F6pj5OdTry3Q6D5fzwe6QokejO7FInAsJmuG0h6qyyMcEXL8NPw5W/4p1ixXuRTXsYrqdfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753962526; c=relaxed/simple;
	bh=Xqu63g49oubRpsWjwsnfClI07X5l6m7msQPsWmmgxC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WL5+hSNe0xK2wwbAU9S5kHYg9gyOo8Vjc7Yvsm2dWygiAv8/hN0f6xwI+B3sLI8Sa0vItznQAIhXhU8ainM3iWZidbbB8UxV7ik7TbN2z4hKALGUFxELuSDTLH+m5hdoDl1kaWnBUV9WInaTb13Fa6WpDMjtd0Kpf6AjPPWZ3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dE51/9ZE; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dE51/9ZE"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b271f3ae786so685788a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753962524; x=1754567324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hkN0tI9B20gWFLyUHNfhvSFfOgY2x76YeStrLafG1M0=;
        b=dE51/9ZEucG1sLW0XyvpfYNMcuGl1NmqsceW7DOSnTkj7s0DQQrG39ywJhyBlJp+4N
         2M25APBOsD9kivcSG/+Gzlkl+wnJcWG6QRgKDPTH4sPBqn9VKnA5hQoHI0f1w4TpbTP/
         EGv08vu1Ivk2DJLDALwGmuHhysPxcrFBoe6euwpnzmjljTf9uwHqCJcwZGtts1RrKA+E
         T9+FpJ3AEP0pqi9iOCNO/7b/9D40wBlfSoNVp1KOqaGATzsWwZMLFiHd5t2M0I1+pTYb
         K6L9Dnmh3Ecd4GFCofD9vk1d7SWMKhhO8RGT2htxKIBrVHR/QCjpGjNMV67G0ZyjEPjf
         sFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753962524; x=1754567324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkN0tI9B20gWFLyUHNfhvSFfOgY2x76YeStrLafG1M0=;
        b=MeIvjviPboAOfmSgfw+FfY4uunD84fGwK3S5KumEieE7RhO9+Jkdq++tdPsfNIl5sY
         q9IYbe5/uDHEH3uuHuxLxfCEaN+2CxJEm5CwwxolaX5mxEYtnUCBw6V4qy7PZAimTGp8
         MC/LKZhkEpaG1uQ0TJw4nmlYQ7C8/XMznhktuveqf+BWEWduOVeL70P3mNQ/5cvoYpeN
         b3R5LBp1JocNk0eX5Z2LlLg0CQ2+OMLFcs08jKVqe6EfHEWSfAZHUkXE4sW7nJmshhEw
         xn25e6YsqK4arMl+VSF8WxDWD416nz95VJbp/5ozhnifaqAPJ9BPj45UsDq/1KkwGaa8
         w75w==
X-Forwarded-Encrypted: i=1; AJvYcCXaBDRwzLslZ2igowdgiGHSCIxb4HtP1V5mtHDkySNNdfKUoD0lMBiSwX0D3gta+W/NjtPtaiwqqXI9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9ClU7lxdHcUc3ey4eh5QbT3cKglfG1Rwm0EvT+tcilQ++pa3r
	LPj0/TBd81sQs9vZep6JuFlCRkEv5fDwkCNJ96TY0MuIIzofg1yuKXG0MOjv+FnR68w=
X-Gm-Gg: ASbGncskuA0bgOxJAHEVrga8mZds761qDrge3J6H4vkaTpw7JSr5zmCJCKW54hW6k/g
	IUYe10fYGQrNgp33YUw9jhBh8soTIn0vKm+V4a/sUWmdvGEx1gRYhybxhFBl2emMN1e+5Pxrmjj
	eEN9gFhj+HB+4YDaBgVmlXAznWJlaLHXurrqjkymfpXovG/cG66/cuhcowgj9jDGUUdurKo5h/c
	SYp9b03mHLqSzbfyJGuQKDEvLK2nMrwwq/sn+IWgeuRg4c5HRLZJHOwR+SGGOctlZGFV8hHoH8t
	E1sDoWdERT0EJ2kh0sSVd2zGOJum+gOkisZnOcb5boZZ5X68BQdj5zIgj7TuH7Ho63kHk4C03Ru
	51aZTtrjfGfkk1B4fjKptj3f9xzGJiU6LVZEJF/NNpOTU
X-Google-Smtp-Source: AGHT+IGrG4jwWLL+fMJTai+FsxthmxLYiFBUGHsgwdEYcHLxx+ldiinVCD17Tcs33DG72yK/NKzseg==
X-Received: by 2002:a17:90b:57c5:b0:31f:12d:ee4f with SMTP id 98e67ed59e1d1-31f5de6b9b2mr10171787a91.23.1753962524306;
        Thu, 31 Jul 2025 04:48:44 -0700 (PDT)
Received: from H7GWF0W104 ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da565bsm4597298a91.4.2025.07.31.04.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 04:48:42 -0700 (PDT)
Date: Thu, 31 Jul 2025 19:48:32 +0800
From: Diangang Li <lidiangang@bytedance.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Friedrich Weber <f.weber@proxmox.com>,
	Mira Limbeck <m.limbeck@proxmox.com>,
	Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
Message-ID: <20250731114832.GA97414@bytedance.com>
References: <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
 <3b2a6cfe-5bf3-4818-8633-c200d8e6f122@kernel.org>
 <4cb58e56-d9e2-4868-84ad-8b7253148228@proxmox.com>
 <75412b1b-3f39-4f6a-93ce-823c15a19bf3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75412b1b-3f39-4f6a-93ce-823c15a19bf3@kernel.org>

On Tue, Jul 22, 2025 at 06:37:50PM +0900, Damien Le Moal wrote:
> On 7/22/25 6:32 PM, Friedrich Weber wrote:
> > On 14/07/2025 04:48, Damien Le Moal wrote:
> >> On 7/10/25 5:41 PM, Friedrich Weber wrote:
> >>> Thanks for looking into this, it is definitely a strange problem.
> >>>
> >>> Considering these drives don't support CDL anyway: Do you think it would
> >>> be possible to provide an "escape hatch" to disable only the CDL checks
> >>> (a module parameter?) so hotplug can work for the user again for their
> >>> device? If I see correctly, disabling just the CDL checks is not
> >>> possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
> >>> used to disable RSOC, but I guess that has other unintended consequences
> >>> too, so a more "targeted" escape hatch would be nice.
> >>
> >> Could you test the attached patch ? That should solve the issue.
> >>
> > 
> > Thanks for the patch! The user tested it on top of a 6.15.6 kernel and
> > with the SAS3008 HBA, and indeed:
> > 
> > - under 6.15.6, hotplug fails with the log messages mentioned in my
> > first message,
> > - with your patch on top, hotplug works again.
> 
> OK. Will post a proper patch then (tomorrow).
> Thanks for testing.
>

Hi Damien,

Are you planning to post a formal patch to upstream?
 
> 
> -- 
> Damien Le Moal
> Western Digital Research
