Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD052D8DCF
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769092187; cv=none; b=Ykn4fPruyB6UlbLOicungVQSiXIjocLUTsLM6GJLHoUXIboZA5ycMb3q6zRU1xGFvcWPdf8zkcVcH7NdMY28kldhnl1v5vjgkAaf7ghLGp31K7DPLv2m2Q/1gTb8Q8lhDUGTMvx3gj4FR0py+3UIJvYaZIhQ8Iskmtic/5uz70Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769092187; c=relaxed/simple;
	bh=cz+JlD34fRs/pROTZrvc12hKh4tyzrxS8BcTZwwO9EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udDeam2Lpr1Dv0FBVFcjh1x60Ze5D3g88oC3m90jONJZc3SaAfz5dxS0UQHuXjZqDEzhcKozqNeXKHSANAEx6mdjZoLwCyNkSWi21Bf4YCyro+x+kbPcZF1QD/jGKsNI7y4psWRKP0ZYIPVRrwAKUYCwWcWmYF69IllcwP55X7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZ2GtT73; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZ2GtT73"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-823081bb15fso447524b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 06:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769092183; x=1769696983; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k2bB6UcFN/QmZIeetEeQNfw5hOnI8IdcR9tXmdiu+0M=;
        b=cZ2GtT73IE/jaGvvMsPsZTLe50F1yM+v7+yIoUXsN499U0soDLin9rr9XOMv4QiU92
         2nh0ypIcb4Q9s1k7+cod5dMj4VFVE6d0jhV7dgA9D0mE5mEaoLis9txYihldq2nqAv/s
         kHSjntWak2qaVQXMb4DsV8YTXR76oJs0pylzNKYrzAEDzAm+XfKu6G3uTLN7DO9nQMY0
         zCpLqTRTKygMEOG1mZhEP2Xmd8jNNbWdh/JWtO2179mxnZ/KHcHaVhAUUBrNWGYIz/fQ
         oNylTf3b0pIGlPCUFK1OL+TBS4LLPenWFHwmf+oAdMCzNQhGa5FX86DM2eNq+bf9jXTO
         ooBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769092183; x=1769696983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2bB6UcFN/QmZIeetEeQNfw5hOnI8IdcR9tXmdiu+0M=;
        b=M9Mk88e8FeYVT1nko2vsn1LNlPLnR9oqHiHR/UhKrUbAH8TOkamZmUF4N8owHWFBRT
         QsmSi1Gw+G17Rvq3CIuLcsjJDjQr8ZMdmJy8NbdYQ1HNui8OyxOb6hY3UnyTU6ZxVCjm
         9+0BXn7AKq5/m/k9Vxj3UcPKbNbUCf2eSjaJEYMRL4HoZ1lMgtl9alX1UNMfpC5A3Va5
         KNAx0EcG9CwI6gp3JKns/opUhepEG3RwszwkbnyD8QZm16JKSk0JwTNMDRPP+JSPpkri
         QGvo+wmi7+JoEi3JIOGpjZaFp4HpGda+eEw1fwyFvgTfUbGG8d45+GYRUzgYbOUSdk7p
         l6aA==
X-Forwarded-Encrypted: i=1; AJvYcCWQwML4c0JiBxtBPDNomtSQ8o/W3u4nAheZCJl0Z6BJcsKYpMTp+w3ewuezUrtzHzkmTKsSe1L1a9PA@vger.kernel.org
X-Gm-Message-State: AOJu0YxzvAYPK0oHYKssq7vuOxbPO9WxEdJ7cgk1aWGNg+WoEylg9M0J
	okAXJTWv9SSOr3Q1Hh/iKFnP9qWideEdxrJrHhEMBYEPNTIqQ7QQMvCn
X-Gm-Gg: AZuq6aJuwX2JQtr4cnjPhtADt/PHRjviv6oLcoF34iVhoim59YkK91q6oS48Xvykla4
	lcQB/yqseZPQqNmG46Do4h0Q85Solle/qE9TmHSXfWZ2uqEAaWe3n9YaSJML7u67GoQB4PUW2Nl
	NbwovbIF7dwv5POKTXSYwfIzxJnlvAC9fe1TjSPeq7yOMCLRJraotJ/HgpRy87YBlpEnezz6xaY
	W/MOfavcGyI0n0hF4a6YfD9XFSfyN6P6d/vwwSb86tFO0erbxiSsheqfP3YU4xhFdwhu0WskNnK
	LyS57DetgUVnAFCcFxuTWr6CdT7kbX8BE3c/isZe36migPO7Hy8em/LxV0NZlbZ09iRCfF8j0oS
	AsNVjXInORqKlNWQYfrtfE/fjo+ZHAwz4wZdk/ws931VM5+AzbRA2wCD937KTWx69GF8Gy7z8oi
	wu2D8ZPAQL6ts=
X-Received: by 2002:a05:6a21:3984:b0:38d:eeca:b330 with SMTP id adf61e73a8af0-38e00d1557amr21189377637.40.1769092183005;
        Thu, 22 Jan 2026 06:29:43 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf354b3bsm11023239a12.24.2026.01.22.06.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 06:29:42 -0800 (PST)
Date: Thu, 22 Jan 2026 19:59:33 +0530
From: Prithvi <activprithvi@gmail.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@lst.de, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260122142933.662srnqeqmx7eqk3@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <20260115032012.yb5ylmumcirrmsbr@inspiron>
 <20260122095634.GA15012@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122095634.GA15012@yadro.com>

On Thu, Jan 22, 2026 at 12:56:34PM +0300, Dmitry Bogdanov wrote:
> On Thu, Jan 15, 2026 at 08:50:12AM +0530, Prithvi wrote:
> > 
> > On Fri, Jan 09, 2026 at 12:45:23AM +0530, Prithvi Tambewagh wrote:
> > > In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
> > > function is called, which, here, is target_core_item_dbroot_store().
> > > This function called filp_open(), following which these functions were
> > > called (in reverse order), according to the call trace:
> > >
> > > down_read
> > > __configfs_open_file
> > > do_dentry_open
> > > vfs_open
> > > do_open
> > > path_openat
> > > do_filp_open
> > > file_open_name
> > > filp_open
> > > target_core_item_dbroot_store
> > > flush_write_buffer
> > > configfs_write_iter
> > >
> > > Hence ultimately, __configfs_open_file() was called, indirectly by
> > > target_core_item_dbroot_store(), and it also attempted to acquire
> > > &p->frag_sem, which was already held by the same thread, acquired earlier
> > > in flush_write_buffer. This poses a possibility of recursive locking,
> > > which triggers the lockdep warning.
> > >
> > > Fix this by modifying target_core_item_dbroot_store() to use kern_path()
> > > instead of filp_open() to avoid opening the file using filesystem-specific
> > > function __configfs_open_file(), and further modifying it to make this
> > > fix compatible.
> > >
> > > Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
> > > Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > > ---
> > >  drivers/target/target_core_configfs.c | 13 +++++++------
> > >  1 file changed, 7 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > > index b19acd662726..f29052e6a87d 100644
> > > --- a/drivers/target/target_core_configfs.c
> > > +++ b/drivers/target/target_core_configfs.c
> > > @@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
> > >                                       const char *page, size_t count)
> > >  {
> > >       ssize_t read_bytes;
> > > -     struct file *fp;
> > >       ssize_t r = -EINVAL;
> > > +     struct path path = {};
> > >
> > >       mutex_lock(&target_devices_lock);
> > >       if (target_devices) {
> > > @@ -131,17 +131,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
> > >               db_root_stage[read_bytes - 1] = '\0';
> > >
> > >       /* validate new db root before accepting it */
> > > -     fp = filp_open(db_root_stage, O_RDONLY, 0);
> > > -     if (IS_ERR(fp)) {
> > > +     r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> > > +     if (r) {
> > >               pr_err("db_root: cannot open: %s\n", db_root_stage);
> > >               goto unlock;
> > >       }
> > > -     if (!S_ISDIR(file_inode(fp)->i_mode)) {
> > > -             filp_close(fp, NULL);
> > > +     if (!d_is_dir(path.dentry)) {
> > > +             path_put(&path);
> > >               pr_err("db_root: not a directory: %s\n", db_root_stage);
> > > +             r = -ENOTDIR;
> > >               goto unlock;
> > >       }
> > > -     filp_close(fp, NULL);
> > > +     path_put(&path);
> > >
> > >       strscpy(db_root, db_root_stage);
> > >       pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
> > >
> > > base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> > > --
> > > 2.34.1
> > >
> 
> You missed the very significant thing in the commit message - that this
> lockdep warning is due to try to write its own filename to dbroot file:
> 
> 	db_root: not a directory: /sys/kernel/config/target/dbroot
> 
> That is why the semaphore is the same - it is of the same file.
> 
> Without that explanation nobody understands wheter it is a false positive or not.
> 
> The fix itself looks good.
> 
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com> 

Hello Dmitry,

Thanks a lot for the feedback! I missed out this curcial explanation in the
commit message. I will update the commit message and send a v2 patch for 
the same.

Best Regards,
Prithvi
