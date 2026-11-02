Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793616160;
	b=jq+cgumftSw07f412H7np7Kdzjfuq2vG09hq5xDGbM7nmSkYJfUcAhL/P8KI3iXhahR7
	 X7ApzJdvpz0/n3Bw9mIquHgi8xx4cb54gGreMAfBJuZUQBXJ3z+RicAt/Zy6M/2pVs6kn
	 XXQkv24OuUKQgk+Iad2MjI+3DNyG8pBJE46Dwn3jZY8yMfuSSQXNKhIDqnQapWfUvPfo5
	 763WIPSOcDxsiwQuyrJY4eirk9kHP1GCSFCBBjdK69VscaIMg7/tuImg9oZ4FUeXCM64H
	 +u9QMMguvFeUm7wjptWk2NSBEevU8lzySCm/D/61mYH5y31wOSHXyjIm3zocsbe2Ztg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793616160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
	b=PRj9GTIL4I3BVweAumDUbVYzp78IBHI15QF0Mkxt8lz+oPMdAqNbn45uRJlSQFV/oeV7
	 4ZRdS0aHlBhDcsAvlT+UyQo+IJ6JSJDGlSvdgMMkRdkzgYRGb2j6mRMNt6CbNGkiGQwvt
	 EHLGIruM12wJDX1xHDONcuKwa7d6LKrxybt4+Vx0V0bjMxv5ITE7iieN2GgCdD8cq/ann
	 j521Y0ToQWRutTDHJvGebIIIQZs1+12qvTAPqyMdRj9ivpA8O5F2vhnQ9641QJELnRRvr
	 a+3U8Z1p8gWnZauWGDyjSXOVIEJC0gdKSNSS8W09EliL2cPhGRoPsnd1omqdpHNmb0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a9IMkU1P;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254860A6F4F
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 10:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0254860A6F4F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a9IMkU1P
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso3665332a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 02:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793616158; x=1794220958; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
        b=a9IMkU1PBMw0aZJkr4vlmYRMTKJKENy07bbqu0F/GTo7Ra8mDds4hFqVRdBkgOH9Tl
         kqWWm3QNGfo9+ASMtX5tpuQsHP+hkq7YVjr7iRcdyWsx0AbDncwo2XAndDToL+sJXpvk
         1cpbbTFpFhbiu/ET8uMDCKj1cmIlz1IzZh9RTMO0cE22WK4U/66NqLUENwLi2rj2KOYb
         s3SrL4LA0FJg1JBZcAgHMiCivwFxTJVrP/SHssnt6N3JgHZI4IqaMSpwhjHv+VNtqoy/
         3zWX8HmiG9O8cIl90UwtzZBotjW/JhL599RUhr2k71GA3rzuCDpVcJbqLssLhhlsTuRu
         ziYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616158; x=1794220958;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
        b=bZVZUrMrbh5bA7/q4xTArhpdzwZNUCUTUzEHt3VSqayft5gO/0ATFylk5w/dPdQTUs
         klZ68xY8L5VtWv6jCReyTIbVrzPNeAlBPVUzxf7EVMFoLrlo/veUfgY19I+yan1DTaPX
         FEKyELm8n4F4QQMqwb9aUgYtqvyz9vIjKtmQrunTuORKlF0wsTJalXETB03rqzjI/WZU
         k9jxQJlfe5KwS0lvThCU3IiujVNP8lTnarIGwroMFUsWnsjmfwellDDG/XrX5JaTzPom
         swlDh/eNQZx6ryr8hb81c+T9q/AEAeyrNHthXiU18mE0GW6HjwlR1tyldaLSY8z37gSG
         5csg==
X-Forwarded-Encrypted: i=1; AKwUvBxRtU4D/5FASnqsDdGZEGjZNwNLsWx7Ay80kZX7RJzIqkbH8u6Fye8Vdxu2y+9q3XwK3HyPM4pZ/DkZ@vger.kernel.org
X-Gm-Message-State: AFq9FYJw+Fv7UEaTAcwEP+E7AwDFrTPq0mQ28L0X54DsmRVdaIGbtF9K
	Yx3awG+/z600fhkKHt8xm/7rN71V9Bw4kqaa7RCWRBRD5omK+2tPqHRK
X-Gm-Gg: AYBFou2F9ItqW6/CsZM2iCHYny9WizJottfd+JERh2kDL2z6p6kyPmgfaMJ38YMwav4
	458byn8VkdDiyyftfN2FZyMNPshhs39jWf+PQxJN5I0Z6/WDBd1oMWKGiai4ZYJlqxM+ESVYVe7
	u3GyQQIhzxZ6daxG55Qc7aXHJUVABdvLiHOs205Gw0807c2KmCVU9juxhb44mNz4ZAunh71LVrR
	600DAGurcU4yKbIgJUwNCYewwCfUb7/MIx+EwcYbAWftR6mX0hrEBxXPlV6Zy1RYE73IrDahL45
	KRjKHMzL1RL0rDFnWreUO5Mzb97VVKKDANsnZIe+/k14t2wENkDeClpedCbEgr6EnFBFKwfan/J
	81tNnjRojcdTitFF42iExFx0XkE1yW3/qKzsmtuXwlr4gDM3cwoble97DhWs+KAPNYn1QUwz2Y8
	iCfFVJJ9/PUaXqb488EjXTvAbMrfoOxCkSDnZUbMXI/7rrazr1i0FiC2e9a1p49EjzNq8r8TU1A
	vssVkX6hSm1Rbsj1qUX2/FZJONf+rg8p+W4xARQdwBT4R7wLHMPKfl+whIpY+58OEe0/lsnTacd
	YyagJDnJzXDUie7YtCwYl0xnVjPNf+LaP+KYZFy6FbVjxb86mRq3d0UyPt7AXbape5uDXn00P62
	q1E5xioFqNnqdv52YAQs24ocSMOYthieYwhl3S+5ZbsQsnj+Qxg22CrVt3Cm1FXDRIBgtG0hxfA
	wwtI558UYKm41a66A5IfiLKsrmgAsu1oMSOT43Ay9jVb98tLpaBC8dMSmHTgu6lfY=
X-Received: by 2002:a17:907:6d20:b0:c46:75e7:25af with SMTP id a640c23a62f3a-c4ca7a0dcb0mr776863566b.11.1793616158273;
        Mon, 02 Nov 2026 02:42:38 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabc18ec5sm368948866b.12.2026.11.02.02.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 02:42:37 -0800 (PST)
Message-ID: <6f97dc68-b2e1-494a-b0f8-13c36fd84044@gmail.com>
Date: Mon, 2 Nov 2026 11:42:36 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: Fix shift-out-of-bounds in sg_build_indirect()
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <mkp@kernel.org>,
 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <e68a2050-dc97-4531-95e2-29f4d1a109cb@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e68a2050-dc97-4531-95e2-29f4d1a109cb@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 10:04, syzbot wrote:
> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> Writing an invalid value such as 0 or a negative number to
> /sys/module/sg/parameters/scatter_elem_sz, or setting it at module load
> time, causes a shift-out-of-bounds bug during subsequent device operations.
> In init_sg(), scatter_elem_sz is checked against PAGE_SIZE, but because
> PAGE_SIZE is unsigned, the comparison is unsigned and bypasses negative
> values. When opening a device via sg_open(), the driver calls
> sg_build_indirect() to allocate scatter-gather buffers. In
> sg_build_indirect(), scatter_elem_sz is read into the local snapshot
> variable num. Because PAGE_SIZE is unsigned, comparing num against
> PAGE_SIZE also results in an unsigned comparison that bypasses negative
> values. Furthermore, even if the condition is met, the code updates the
> global scatter_elem_sz and scatter_elem_sz_prev variables but leaves the
> local snapshot variable num unupdated before get_order(). As a result, an
> invalid value such as 0 remains in num and is passed to order =
> get_order(num). Calling get_order(0) is undefined and underflows to 52 on
> 64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 <<
> 64. Shifting a 32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds
> warning:
> 
> UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1887:13
> shift exponent 64 is too large for 32-bit type 'int'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>  sg_build_indirect+0x559/0x870 drivers/scsi/sg.c:1887
>  sg_build_reserve drivers/scsi/sg.c:1997 [inline]
>  sg_add_sfp drivers/scsi/sg.c:2177 [inline]
>  sg_open+0x1128/0x18a0 drivers/scsi/sg.c:349
>  chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>  do_dentry_open+0x816/0x1380 fs/open.c:996
>  vfs_open+0x3b/0x340 fs/open.c:1101
>  </TASK>
> 
> Fix this by casting PAGE_SIZE to int in both init_sg() and
> sg_build_indirect() so that the comparisons are signed and negative values
> do not bypass the check, and by updating the local snapshot variable num to
> PAGE_SIZE when num < (int)PAGE_SIZE in sg_build_indirect() before
> get_order() is called.
> 
> Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Link: https://syzkaller.appspot.com/ai_job?id=1d412b83-5bbc-4d73-b690-4c798d45cee4
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e..46117d1a1 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1667,7 +1667,7 @@ init_sg(void)
>  {
>  	int rc;
>  
> -	if (scatter_elem_sz < PAGE_SIZE) {
> +	if (scatter_elem_sz < (int)PAGE_SIZE) {
>  		scatter_elem_sz = PAGE_SIZE;
>  		scatter_elem_sz_prev = scatter_elem_sz;
>  	}
> @@ -1875,9 +1875,10 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>  
>  	num = scatter_elem_sz;
>  	if (unlikely(num != scatter_elem_sz_prev)) {
> -		if (num < PAGE_SIZE) {
> +		if (num < (int)PAGE_SIZE) {
>  			scatter_elem_sz = PAGE_SIZE;
>  			scatter_elem_sz_prev = PAGE_SIZE;
> +			num = PAGE_SIZE;
>  		} else
>  			scatter_elem_sz_prev = num;
>  	}
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
Hi Martin, Doug,

A gentle ping on this patch. Patchwork currently shows it as deferred.
Is there anything you would like me to change, or should I simply leave
it pending?

Thanks,
-- 
Krystian Kaniewski
