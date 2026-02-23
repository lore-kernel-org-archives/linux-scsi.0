Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF6031690A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 03:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771818496; cv=none; b=XmGy+N4j63IJs/zci9g/EzXlW5rBPgSeZZiX9FYoGWumAjHJ4DzcKz9YvT09b2UL/2vj+I2WQU+peAlFzHfvvsG+lfcWXkHrxfEpXPgONW9wiazwLFBIDTlIt009oRaiRzFN1WeBAIBjhMqJ7EwKbIhq3iPIJHDm0eb2Ym9R15o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771818496; c=relaxed/simple;
	bh=SF93mBnv6b6pLe/1HBoftNRah+ZLiF1OcBwwqbvPe6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ft51bIm+XC/aLNS6AUp+bndGKpxl1k4l7Gxo3+58fIbVA7h9e7O9KDBlXOLcAholOoXdTXf57vERkXJr8aIV6II93F8APF4o9oyjac3hZldsUGYfUjILLQbPCT9C39fTyaWuY3M4fNzGXwWokzEU0KgU8X/izRM9Vwz/fWTzjgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kn+WqJAI; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kn+WqJAI"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c61343f82d7so1290164a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 22 Feb 2026 19:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771818494; x=1772423294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4rzQ0T621GZSjBat75RSIcrNnampDyhuho7rtv7pj0=;
        b=kn+WqJAIJ/4YHgC84EqeJVuE0n4c+IV1m44Cj81aoaJ0joDEls+GVbdMq6YNMXCLWY
         ALy6uiwRdoGfNuImrkaPD1T9XhkN5x/5XyJGQHrwiigHgKHkveltqmgeOMPDbChCdN3O
         f9kqH9az3Z/5mBBfDeOq0ARYAqcVBGfY05GRGe8qWxXkI0Wwu9pKh8i6is9+Yp9c64Eg
         w7pEnjyiUBmsyVdGR7sRb41Ohqb/ypkDF5rleXmrcFluW4yYHewuYGsEn/7dC3XLpcSF
         ZgzlHW1JRLHIUekk2DT0AMN/A3nBYosdPEwvh+xFcEjII2ziyKIZLFIo1VFyMAFUc4mT
         sNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771818494; x=1772423294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4rzQ0T621GZSjBat75RSIcrNnampDyhuho7rtv7pj0=;
        b=JKjXTzWBHko+Ae8bFVyFZaZ0RWUXLebUmJZrXGzaLtF8GeG11NhEnWoR5A2nbrKiP5
         H/5v9ou4Y5ueMMck2dH/uIX9feqBp9h+19mnxxpGd6AdT8KwNMFqcO9YJQ06OcEUH0t1
         VoHjlbWjpv6g+mzxJpCQa2vl91lAB3a1MTvfmfLMZjcaSlCZpRDsRd5h3fk1klRj4Yao
         MYZyxFs2vI2I0QxJYFxAZC2pNmLD9FcIxFv6I5ULt9rEM7Bh+kC5XR4+l0w3yYs3unrV
         y3uMKwUJUY2vlsnyf4CFzYdfx0oUOlI5QOIN5ZrGpSKGbycLfqLvBCSvcvnj7I5mPt3O
         PsFA==
X-Gm-Message-State: AOJu0YxXvmVmPthelMdKYJtVBmRbWUafYkvoeYpVrV9tK6xSsFkuBNlO
	mNnrQd3FxnCHrcGm35dpRv7meLlhUE3t1alq9YZuLbt7aRMHl0yku5jE
X-Gm-Gg: ATEYQzy1q/hCsl3FRr7NmPNUhrc5n93J62EaQJxOk4fpMxD6KpN4yXOTdu6lIgxzSpq
	uDXMa5yImOjEsdbjp13sKb0/T4c/3k4go1HGJhSBWnpxw15imM5ywZV5z6xQ9y97efTc0F11Ry/
	VZ9NJizewShDWNT85I7UbOZmcyaeE/F7zxO0de6DKgthVpvSRR1bvQvS/tloxNgMB+E5Zwe8h3t
	I6pD5gGf+IJey66FUj7kSRZu/qUtnR7Y108bcuN+hP/53YafjIayUZHDqIlhnvwSUUgooeZJdhk
	KY4Cy+fb4V1dNi3/6IsGBg8w2YSb9I2Lnzx70LPrJmDLysULCCdQm1vVdBojx56kMiR79g1WwWy
	jyuDg8RoVueo41D6dUGdeFF+qlTU8quxFVcNXPR9NktFOC0wyM28ZTFzCy+6AfkW1mXmgrLi57e
	qNppsun69aWaEeTfAHCuaBL/E=
X-Received: by 2002:a17:902:ecc6:b0:2aa:d7fe:8603 with SMTP id d9443c01a7336-2ad74419e3emr70224515ad.8.1771818493881;
        Sun, 22 Feb 2026 19:48:13 -0800 (PST)
Received: from inspiron ([111.125.235.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad75027641sm67314185ad.64.2026.02.22.19.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 19:48:13 -0800 (PST)
Date: Mon, 23 Feb 2026 09:18:05 +0530
From: Prithvi <activprithvi@gmail.com>
To: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
	viro@zeniv.linux.org.uk
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260223034805.yhzmheiwndxtj5zu@inspiron>
References: <20260216062002.61937-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216062002.61937-1-activprithvi@gmail.com>

On Mon, Feb 16, 2026 at 11:50:02AM +0530, Prithvi Tambewagh wrote:
> In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
> function is called, which, here, is target_core_item_dbroot_store().
> This function called filp_open(), following which these functions were
> called (in reverse order), according to the call trace:
> 
> down_read
> __configfs_open_file
> do_dentry_open
> vfs_open
> do_open
> path_openat
> do_filp_open
> file_open_name
> filp_open
> target_core_item_dbroot_store
> flush_write_buffer
> configfs_write_iter
> 
> target_core_item_dbroot_store() tries to validate the new file path by
> trying to open the file path provided to it; however, in this case,
> the bug report shows:
> 
> db_root: not a directory: /sys/kernel/config/target/dbroot
> 
> indicating that the same configfs file was tried to be opened, on which
> it is currently working on. Thus, it is trying to acquire frag_sem
> semaphore of the same file of which it already holds the semaphore obtained
> in flush_write_buffer(), leading to acquiring the semaphore in a nested
> manner and a possibility of recursive locking.
> 
> Fix this by modifying target_core_item_dbroot_store() to use kern_path()
> instead of filp_open() to avoid opening the file using filesystem-specific
> function __configfs_open_file(), and further modifying it to make this
> fix compatible.
> 
> Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
> Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> Changes since v3:
>  - Add LOOKUP_DIRECTORY flag in call to kern_path() so as to check presence 
>    of directory checks more efficiently
> 
> v3 link: https://lore.kernel.org/all/20260205162624.117957-1-activprithvi@gmail.com/T/#m175d152067817dd6e9dc1821b6fbf626e47a4007
> 
> 
> Note:
> I checked out and found that when I try to test on commit 3a8660878839faadb4f1a6dd72c3179c1df56787
> (latest commit on which bug dashboard reports the bug on, in upstream repository) 
> syzbot uses, in its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"
> 
> Ref: https://syzkaller.appspot.com/x/.config?x=e854293d7f44b5a5
> Syzbot Reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m62bc76de5549460ae98e843bb120712548489794
> 
> While when #syz test (i.e. on HEAD commit of upstream) is used, it uses, in
> its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 14.2.0-19) 14.2.0"
> 
> Ref: https://syzkaller.appspot.com/x/.config?x=99ac58566e9eb044
> Syzbot reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#me8b79610e4c18a8d8a7d8d6bc249d1c7cf2f8819
> 
> However in both cases it uses:
> 
> gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Probably due to mismatch in compiler version which syzbot actually uses and 
> whats present in kernel config, the build fails for the first case. However, 
> the patch succeeds in fixing the bug in second case.
> 
> Earlier for v1 patch (sine v2 patch involved minor change to commit message 
> and v3 involved adding a missed out Reviewed-by tag) patch the kernel builds 
> as well as testing succeeded since syzbot used this in its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"
> 
> as well as used the compiler:
> 
> gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40 
> 
> Changes since v2:
>  - Add Reviewed-by tag received from Dmitry Bogdanov, which was accidentally
>    left to be added in v2 patch.
> 
> v2 link: https://lore.kernel.org/linux-scsi/20260122154051.64132-1-activprithvi@gmail.com/T/#u
> Reference for Reviewed-by Tag: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/#mb22d0fc06e747e2b2df8320a15afd2a0670fd0e7
> 
> 
> Changes since v1:
>  - Update commit message to reflect the fact that same file, which code was 
>    currently operating on, was tried to be opened again, leading to 
>    acquiring the same semaphore in nested manner & possibility of recursive
>    locking.
> 
> v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/
> 
>  drivers/target/target_core_configfs.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index b19acd662726..f94c242eff97 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  					const char *page, size_t count)
>  {
>  	ssize_t read_bytes;
> -	struct file *fp;
>  	ssize_t r = -EINVAL;
> +	struct path path = {};
>  
>  	mutex_lock(&target_devices_lock);
>  	if (target_devices) {
> @@ -131,17 +131,14 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  		db_root_stage[read_bytes - 1] = '\0';
>  
>  	/* validate new db root before accepting it */
> -	fp = filp_open(db_root_stage, O_RDONLY, 0);
> -	if (IS_ERR(fp)) {
> +	r = kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
> +	if (r) {
>  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> +		if (r == -ENOTDIR)
> +			pr_err("db_root: not a directory: %s\n", db_root_stage);
>  		goto unlock;
>  	}
> -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> -		filp_close(fp, NULL);
> -		pr_err("db_root: not a directory: %s\n", db_root_stage);
> -		goto unlock;
> -	}
> -	filp_close(fp, NULL);
> +	path_put(&path);
>  
>  	strscpy(db_root, db_root_stage);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
> 
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> -- 
> 2.34.1
> 

Hello everyone,

Just a gentle ping on this v4 patch; it incorporates Al Viro's suggestion 
from v3 to use LOOKUP_DIRECTORY flag in kern_path(). Kindly let me know if 
anything else is needed from my side or any feedback is to be addressed.

Thanks,
Prithvi
