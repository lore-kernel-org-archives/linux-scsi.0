Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1FE3815DD
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770735615; cv=none; b=qErHTnc4peappCOvXQpDIFY0amEsxQsPd82mcSw1UyVyn2ahPnEhe7aqsxnD7oFTamp2tcyi0hgHtc1aOElPQJF5LDLSp7zp5obgDc0At205IPu1CKlqkAoGs2LpsGPQZZc+F+LZY66CJZZYPbcN1i15D09KczrnkivT53BxdD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770735615; c=relaxed/simple;
	bh=P5N4ABjZx124VekI186qd2AD4yXfKDQt9Vo1Fag6vHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aS3OS6kz7VJ3EfC3MSKPDcKcXWkzazsW0Q4E7qOXv/bdAY4M/8aV6qytP7otqZLLUenn32sV/Ru1ozUyQaiSBFZZzjr+q/DfWJKwIEbBPw22TbN0+IK2TYCc//4i4cvuh3yAU66LrknMaxCrhOViU9+o2FRlTIObi1/z6+0BZJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFoRBQUK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFoRBQUK"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a929245b6aso36971935ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 07:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770735614; x=1771340414; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v436SyFigxsHrmhj471D+104SnMzTMwy4MIHa73zImY=;
        b=gFoRBQUKg+Jbo78iDrELjJ0UCZCUblkzS9MxRPdPYY/sbzRniiq1YIPrnkjYGTzhe/
         22vgvcKY9UueLO/JyQz19mU9CeAdK05ffCOZyY2NXjSSm9wQ6j1P3zvo4pjttVaYo9bJ
         8NYcXQQTnYonQTIlzzRdwR3DHf8b1HIS+cvuWnXROFtqohoGlfkmfQHL52rr0It3rXsp
         ILYBHiGc9WK0eIJMjup0tl3t90UmZ0msyQAAtcrZN26Wh4cBlyvoff/bZhCQ+eoIKTI7
         sdqK3T9oqX4LaxhgNT9KrmcFAFudrlMSOEmRylnCa6AzZvWcMHmd82YrdsAHkIrfjNm/
         I97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770735614; x=1771340414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v436SyFigxsHrmhj471D+104SnMzTMwy4MIHa73zImY=;
        b=q9u4+WYMayNRuwUK9AXZ3rGLoUocsbHybYC5vAbm8liUbp6IK5qB7ezMCfkXYIb+8X
         qWEALWSQzJKAk5gOZc98LiTI0yrEg+8j1S8nWV8VkxllsRTgEr+ZtVkA7M0VHPbo9fgJ
         YS6/lJhR0roqqf4eXi7znCTQKjrvCl0N8/sUwaIiTA1bvw8ccrqewPtWAFwTi5ynMS0k
         wj/xkM4gtsIkNJMM3x760U0uxPyzvGzRrnXxmjeQWynu5Gwkl4KdHBrae+2AcHNFx1iW
         l5oUJmYTr1wWeQXaGa72tYqQsSMDOQwillCTy7PnOmtP4+qG3Ip/hnBblPtkaGbyU0kz
         PPOg==
X-Forwarded-Encrypted: i=1; AJvYcCUY5O5KzW+FEa+wQPmKh9bgQDWUKg8fwV0Pwd0ze19Tns4Ai4SHHmGZk7E9KKWuyDsqF9kx/XBO29K4@vger.kernel.org
X-Gm-Message-State: AOJu0YzvZ4NWDQgFca8PDYA2/hNLf5RJMNckNR3RX957xFV8G8QXf7vc
	1fj9Yw1x114y/1C3ZWJp9upyiilCRPXXZqdOEClG3yYUTZDpyG/Hde8P
X-Gm-Gg: AZuq6aKkr5/35c46Uv9NR8c0744OxlcftZ0d1RLecVT6vt1a3P2U/8cap5bhEqXl9cD
	/0+HBIJbmgsLxeFO/EOAzj/9/Z/GPWcDkSzsDt/oYPmIdOFru6QryuITG93KMlPJYPZrl7V4BZx
	O8CaWF2Jc87rM2wf8agCuVBY6Sof2aXroc/l7rFYq0Kp2AXvT2lVNrumD6mIGlqLOWwYteacVk7
	RDvX+awPlJbGyeq2XFsl9h567iri6xkNaNgz9AkH2bTyInHHrlOcDyscsfTSO0dIjRzmPxXcqDV
	Qxxy2uHmjJJm4ExN9Q2b3+ZA7NTP8cAWgSShQrJj7DOFqcIWpzqzeMmye8P03hXHDwA8bS2fC45
	MKQNRTxObbrNxi9xV+MqSVpTwdQsisT6X6afl8BQEEjqj4/Z6MfLjXtVLZ7k81Ayy1p2cJYZIwj
	hFGk8vBeE7BgQ6PLketDITZXv+JN/SbjhLaA==
X-Received: by 2002:a17:902:e742:b0:2a0:d629:9035 with SMTP id d9443c01a7336-2a951643629mr163927435ad.3.1770735613704;
        Tue, 10 Feb 2026 07:00:13 -0800 (PST)
Received: from inspiron ([111.125.237.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aa3ec42e2asm149045835ad.53.2026.02.10.07.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:00:13 -0800 (PST)
Date: Tue, 10 Feb 2026 20:30:03 +0530
From: Prithvi <activprithvi@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260210150003.s55mbwdpgbamjtso@inspiron>
References: <20260205162624.117957-1-activprithvi@gmail.com>
 <20260205192644.GT3183987@ZenIV>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205192644.GT3183987@ZenIV>

On Thu, Feb 05, 2026 at 07:26:44PM +0000, Al Viro wrote:
> On Thu, Feb 05, 2026 at 09:56:24PM +0530, Prithvi Tambewagh wrote:
> 
> > +	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> > +	if (r) {
> >  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> >  		goto unlock;
> >  	}
> > -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> > -		filp_close(fp, NULL);
> > +	if (!d_is_dir(path.dentry)) {
> > +		path_put(&path);
> >  		pr_err("db_root: not a directory: %s\n", db_root_stage);
> > +		r = -ENOTDIR;
> >  		goto unlock;
> >  	}
> > -	filp_close(fp, NULL);
> > +	path_put(&path);
> 
> Just pass it LOOKUP_FOLLOW | LOOKUP_DIRECTORY and be done with the manual
> "is it a directory" tests in any form...

Hello Al,

I sincerely apologise for the delayed response. I was testing the change you 
suggested, however, whenever I tried testing my patch against the latest 
commit where syzbot reported this bug (commit 3a8660878839faadb4f1a6dd72c3179c1df56787
of upstream repository) it gave me a build failure immediately without any
debug log, just the message:

syzbot tried to test the proposed patch but the build/boot failed:

failed to run ["make" "KERNELVERSION=syzkaller" "KERNELRELEASE=syzkaller" "LOCALVERSION=-syzkaller" "-j" "48" "ARCH=x86_64" "bzImage"]: exit status 2

The issue seems to occur multiple times when a patch is tested against the 
latest commit where syzbot reported the issue while it doesn't occur on that 
latest commit of the upstream repository.

However, testing the change on the latest commit of upstream reprository 
(commit 72c395024dac5e215136cbff793455f065603b06) gives a positive result 
that the reproducer doesn't trigger any issue.

Reference: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#mbf32aeb54c4cae609d3b6176ad8dcd99bfc51ad2

IIUC, since the reported failure appears to be unrelated to the change and is working
successfully on latest commit of upstream, I wanted to confirm if v4 based on 
these findings is acceptable.

What do you think?

Thank you,
Prithvi 
