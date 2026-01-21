Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E67349AE8
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769018907; cv=none; b=CW0G10qX7SxAHl305ljNi1iPeBDn6C1jAf2jr/4pMtDy8RqCesVhGbAxi6r4WXxzo1V/si5gKXXd97hnVeeW9bKdrrn8eyxOHBMkJj0YO9O4kEL4SEGkkNd0Wfr4YBFoaMeA8t4B7WRq9mF2thV41lgPdYR3oh9do+jTur9uSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769018907; c=relaxed/simple;
	bh=vVxmaTN6DfAQMnybaHcGPQ0UAXYghYLqHrfg83IBi0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpb5xVvoo0J3nAuj041attbNOEGDuuYKXU1MApB3ovGTBcuaEKrJnPzKnqieV30tRRv4LuLK+l+2EeUozWbFlEfJUOxP0T5fanGmcKE4MrxeADfH0T7P2amuEkOjJVtUEEorJbb2uDoDl5w0RPtV4lnnuQ0rIFcXxoxoL4iYVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9WJEoN5; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9WJEoN5"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a743050256so608515ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 10:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769018905; x=1769623705; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72auvTTn3y/RhhBaaOjOnqHUYFhZMWqSD++rNQfrdXE=;
        b=K9WJEoN5XiF/8kURq1xAFdXXaYeHiUMKlFRahBUe6BqLlf7iR6B/RJcSwlBvlEcwzp
         xlBnFcr5xeSJgaWFzxcR2BC/65DHVIAl3WAIAM9k6mE3u2BIkvUDBnTksJFRC6SLRdgV
         bjZXrQ/JgOk9pR0aJW39Mm3z2Nl3XhiAHi8LVkxeYP+zDIBStH/T36zWiCBRJGxY2SqV
         kWG5Ctyi4M+sCn7c3sd12GtgCvB1dfk04epE/QOYXIk6/mxa9UBjbtEallporwuQeugf
         6kcbxoaLN3E+EXVHjHaLgJko14vIEw1pDOVC0CBqjxTdrAsoJbFVjmtRuy4slh6BG0eH
         +6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769018905; x=1769623705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72auvTTn3y/RhhBaaOjOnqHUYFhZMWqSD++rNQfrdXE=;
        b=QcVQ4/zD931/FY7klL9SyjrVr/KCLq15vH0N24X07Uq4zJfizmh+kgl8TJHiOb0Fgq
         /gDvQhyJKbTpolV0WpaedbphNUqPGrWfOeaYKX2GYFI7uRkWHjTsQo7JC944LJ5dLPww
         7UhCMtmeh3HIREffi5ZhN7HKyVx3a8n3K5Y+31VGGhCfW01c/X6czGO5Aorw062RcqJi
         9j4Zv6qlMaf/LWzEr7Wh1WmQh+EXlgde4LWppIl5XE0+wrl3dJnGPQOzDiyDC0wv/j9N
         NVgT2SipnnY0hILOpJMGWzruRSUVIuHh1zb/0+VlhDtUjwPgK64G9eOQHHsg6Tjg64MF
         BNRA==
X-Forwarded-Encrypted: i=1; AJvYcCUO39Zsr6VUxsJoytZGaCLTbDaeV90o9EYmKOABm2hbUAF0jr6Ucu2JuR5ZX0odhaQKySbd8ZHf/SKf@vger.kernel.org
X-Gm-Message-State: AOJu0YyYBOs7lPHUX433LMZaTadBijElwoc1acmLPG+HXeUMYhl6UIFW
	5Qh8Nb9lHysWzj0gq/BZD22fv/ayP0/hCdepxBQUvGjpPMkcfC2Ib1aT
X-Gm-Gg: AZuq6aJ8X9QDey1urmBmYucc+nsMe7x6BosSEyTpzWgdlQIlvio5u0ZGreX0ABaHuHh
	TayxUGiWPul+TQQtAvz6288tR3DnuF+i0SwunbM+sQRgXDzDh3JR6sMWsSQvALmhg38+DAadmD8
	qQ4dRs0lJdVWEq+qQ49e0yfVK5kjiKd7dMyaLEj2qWx3n2/52hh4qrVR0m0ZYjq3GtJCIeVo83a
	OlMho7g2WLnUXAU1FW43XPtOtR8dyuOb9O7Cfb2RD7dfqNxJD6UcvppD+MswInqtAk4i/+oGv9f
	rMgBiyOk/VamXkf3h0PDwCaFpCJ00s75onlUjCPuGypUxnp+Toh534PSDlmVxmlvuJc7EVlXTGz
	a7brEu8hMNg9wqvTWdp0jDz4IldnTI8NH7bNqrpLcaBCZSHRrQ7Qsn8JuBz7YmdTrUQUREtkZaY
	fzOgiwSbcrWII=
X-Received: by 2002:a17:903:22ce:b0:2a3:e7fe:646e with SMTP id d9443c01a7336-2a768a7e6e7mr60039705ad.5.1769018905199;
        Wed, 21 Jan 2026 10:08:25 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a719406505sm157012105ad.84.2026.01.21.10.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 10:08:24 -0800 (PST)
Date: Wed, 21 Jan 2026 23:38:15 +0530
From: Prithvi <activprithvi@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@lst.de, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260121180815.usbtlsqxqdgriqqs@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
 <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
 <20260121175136.2ku57xskhwwg7syz@inspiron>
 <6927d0f7-5bf5-4035-b1c2-50f3edae4b7f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6927d0f7-5bf5-4035-b1c2-50f3edae4b7f@acm.org>

On Wed, Jan 21, 2026 at 09:59:49AM -0800, Bart Van Assche wrote:
> On 1/21/26 9:51 AM, Prithvi wrote:
> > I tried using lockdep_register_key() and lockdep_unregister_key() for the
> > frag_sem lock, however it stil gives the possible recursive locking
> > warning. Here is the patch and the bug report from its test:
> > 
> > https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m3203ceddf3423b7116ba9225d182771608f93a6f
> > 
> > Would using down_read_nested() and subclasses be a better option here?
> > 
> > I also checked out some documentation regarding it and learnt that to use
> > the _nested() form, the hierarchy among the locks should be mapped
> > accurately; however, IIUC, there isn't any hierarchy between the locks in
> > this case, is this right?
> > 
> > Apologies if I am missing something obvious here, and thanks for your
> > time and guidance.
> 
> This is unexpected. Please ask help from someone who is familiar with VFS
> internals. I'm not familiar with these internals.
> 
> Thanks,
> 
> Bart.

Sure, no problem...thank you very much for your time and guidance :)

Best regards,
Prithvi
