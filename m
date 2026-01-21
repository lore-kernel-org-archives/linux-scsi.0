Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454373A7836
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020174; cv=none; b=BDDN2DSGfc4UMiIz/shJyE/jrGEQJnM/vruylK+aDYk+Bde6PD+KthstM5na6wX6xMmvLdK/sW6aDEDJNl4mTLKKS77XNBA+a/vwpPBFeIBy8E1P7FljJfV/VBDE9pcAGGP8exUFCl8IYOvoQf7rKcmYWb7X74a2cjb7pGl6mDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020174; c=relaxed/simple;
	bh=rXG5ZKvyvWBHHACzLV8wPF9nuPc1igUArEv0FBWhhds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dp7xbhkH+7RAzdrZevCFnz+3l5Tpeto6efHeZT3dNxU3lgbl/CrMC4Www18odc5gaFmxxZYL1IYsMF5V6kruKqQW3didFN/4GIqasAAuKM5uQg0Ca3hLVekYiBJvIzSK7HaXsrvDjEwA3ZdPWv3R/TZFkMu0tttkFk0WPVK3Sck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EwDqE+KA; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwDqE+KA"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-81e9d0cd082so174862b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 10:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769020170; x=1769624970; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tc2r2HxnJJlwpaCSqhrItmuiSzit6sO0uRPjBjoXBAU=;
        b=EwDqE+KA27Jc3Uqnl/XyGQy4encmWk6WZyAQFwLpBnyofdExoWnbyXMjUYoye8Gxu7
         6q7SABpPMN6AMu3LiMk50qXnpz5Wq/KoroGwU7taimXhY/xtlQ2yLf5O/qxpYGxtCi14
         7Nn6M855h4vW3GRH9Ii2U4tTX1YuEO3J+tTvb1lP9Mp9rYudL8nZw1aAd7ZgwCwn0qiM
         STZkZVQ5tHh7C2AV3D7sMze97ajBCwY8RCMRuZkWes8TeYkS8+fQywsVVCoayf7HEEb4
         FZGmccBnS7Ux0J+N2kABXmcQq+lIZKEeZDsp1hKfWpjTFbPX9BTV/ShqFxrpZ1ske37A
         fTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769020170; x=1769624970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tc2r2HxnJJlwpaCSqhrItmuiSzit6sO0uRPjBjoXBAU=;
        b=kEpRA5ejhnjrMNOpS9TGM3v+nn+JvAuRGbyBHohisUxgGKnkAehI1zgdsvDDTOzf03
         jrwe580JowW8OiENcSCLzEB+dBsyjvLEIoy3yQZDc0fzGJ3OpFo8EfVtzNyZRI0YYNXk
         YQ7XbilwgMAKPxhpm7ZpZRIGFAFV3NpDVjhNtH6UZL0O7woucBJGJlzdt6ifmJSHhXd1
         EB5o3wR0mjRWvOao/O9/lELKgsOkrnGKPHeg+FvO+f0heh4NutSslLmpVY34r+ZeqnIM
         eAFjoGYwMQq+WQtG+6yNRW2KyxRqOGNN+ZFhME0MKb17tsbPyen+CNUbX7tBWbsjLvyO
         S7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXomDxS9PNHIzAwHW2jORWf7611KUyC+27Joe4HH800FMHwr3wtYIERBZlarxBylbs1te+NuE7yvqwy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw27wkcnF680tLi1DdwHutNQp78z7k0Idp59lzJ/WJSmQvYa8bk
	VXCDr1MczqcGVOvpMe35t+grrVMMPZAg9y9lC7poZAPG0GbkCVZf3pzI
X-Gm-Gg: AZuq6aJKtODEGOPrGehHw7eJ7F0FnZj6T6kGPkInr3W+62CcIQ1Kw3kdVgIkUZzTDVW
	w+qzIns3jdm/niaXIPo3YIyOKaXoziX7OSxDZY77URcsOlnF+c6nHXaF9FIudkODFs70GFIreJS
	gu+lxKGX1SkiDh/23PApiu/efhIApQNgoE8ECWs92ffgWf45NwWmtGRAEyU8oVtGzJ2tTnUIDF8
	mMalq5vDNI7bJ2m8I5DQHXIc7imfoXTmzMvlJcUsSt2XQMkkwtmPQY7HxdfQ6rDy+sjt5YG5y9m
	qr3GckOSCFf6OjS7/0LpVGPh5+5YS8lVuZbtMyBr+pFtb2vnAMmzSlYsGSKdgtOf7NCtF/UKKnw
	N+n1d8pgqm/7ANbpkgPI8ElQISgPmaknEG1uinTpNqX2dPBN2kEp9Uo5QG0WyKMB2va4ml1vou6
	KZesyJ5elpjfE=
X-Received: by 2002:a05:6a21:3395:b0:366:19e9:8a3c with SMTP id adf61e73a8af0-38e00bf6c7bmr19050575637.2.1769020170290;
        Wed, 21 Jan 2026 10:29:30 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf37a7b0sm12838994a12.33.2026.01.21.10.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 10:29:30 -0800 (PST)
Date: Wed, 21 Jan 2026 23:59:20 +0530
From: Prithvi <activprithvi@gmail.com>
To: a.hindborg@kernel.org, leitao@debian.org
Cc: bvanassche@acm.org, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@lst.de, jlbec@evilplan.org,
	linux-fsdevel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260121182920.hfen6vsf5o27wi3z@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
 <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
 <20260121175136.2ku57xskhwwg7syz@inspiron>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121175136.2ku57xskhwwg7syz@inspiron>

On Wed, Jan 21, 2026 at 11:21:46PM +0530, Prithvi wrote:
> On Tue, Jan 20, 2026 at 05:48:16AM -0800, Bart Van Assche wrote:
> > On 1/19/26 10:50 AM, Prithvi wrote:
> > >   Possible unsafe locking scenario:
> > > 
> > >         CPU0
> > >         ----
> > >    lock(&p->frag_sem);
> > >    lock(&p->frag_sem);
> > The least intrusive way to suppress this type of lockdep complaints is
> > by using lockdep_register_key() and lockdep_unregister_key().
> > 
> > Thanks,
> > 
> > Bart.
> 
> Hello Bart,
> 
> I tried using lockdep_register_key() and lockdep_unregister_key() for the
> frag_sem lock, however it stil gives the possible recursive locking
> warning. Here is the patch and the bug report from its test:
> 
> https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m3203ceddf3423b7116ba9225d182771608f93a6f
> 
> Would using down_read_nested() and subclasses be a better option here?
> 
> I also checked out some documentation regarding it and learnt that to use
> the _nested() form, the hierarchy among the locks should be mapped
> accurately; however, IIUC, there isn't any hierarchy between the locks in
> this case, is this right?
> 
> Apologies if I am missing something obvious here, and thanks for your 
> time and guidance.
> 
> Best Regards,
> Prithvi

Hello Andreas and Breno,

This thread is regarding a patch for fixing possible deadlock in 
__configfs_open_file(); here is its dashboard link:

https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797

Firstly, flush_write_buffer() is called, which acquires frag_sem lock, 
and then it calls the loaded store function, which, in this case, is
target_core_item_dbroot_store(). target_core_item_dbroot_store() calls
filp_open(), which ultimately calls configfs_write_iter() and in it, 
the thread tries to acquire frag_sem lock again, posing a possibility of
recursive locking.

In the initial patch, I tried to fix this by replacing the call to 
filp_open() in target_core_item_dbroot_store() with kern_path(), since 
it performs the task of checking if the file path exists, rather than 
opening the file using configfs_write_iter(). This also avoids acquiring 
frag_sem in nested manner and thus possibiliy of recursive locking is 
prevented.

After checking I found 3 functions where down-write() is used, which, 
IIUC they might contribute to recursive locking:

1. configfs_rmdir() - calls down_write_killable(&frag->frag_sem)
2. configfs_unregister_group() - calls down_write(&frag->frag_sem);
3. configfs_unregister_subsystem() - calls down_write(&frag->frag_sem);

Bart suggested that this can be a fals positive and can be solved using
lockdep_register_key() and lockdep_unregister_key(). However, on trying
this approach, the possibile recursive locking warning persisted, it can 
be found here:

https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m3203ceddf3423b7116ba9225d182771608f93a6f

IIUC, we can then use down_read_nested() and lock subclasses here; but,
according to documentation:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/locking/lockdep-design.rst#n230

I learnt that to use the _nested() form, the hierarchy among the locks 
should be mapped accurately; however, from the lockdep documentation, 
my understanding is that there isn't any hierarchy between the locks 
in this case.

Your guidance on whether the kern_path based fix is the right direction here, 
or if there is a more appropriate way to handle this from a configfs or VFS 
point of view would be very valuable.

Thank you for your time and guidance.

Best Regards,
Prithvi
