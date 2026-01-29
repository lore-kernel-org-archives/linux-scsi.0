Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F665341046
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769694594; cv=none; b=udGHrdy31ddFrL0WCG2SVXMK7JHNr6dVXPBDuEsMlgdW9Zf40Ejh0kywFNFd7I1EkGMtZ9vyIbrRtxvxb1Lz888kNirNFqLxTLU8FSXYXMhsHQ2MKNWING2GSzcoNO8VtOCQk98y/W6E6AgKV+CrQ+qOo/abNhLSZfc0f/JnniY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769694594; c=relaxed/simple;
	bh=2xZSRJHHmdboCugVEUKL+Afar9NGlC9UFADcCPB8rOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJWoC2NRfYIwLTSn5fOpTE/kSkupaZmNjy231G4xKVTK8S+F2Jc/vs3eQzYjOJh5c4VDy3+Ora9mYarEi38gFatzYaf/xO6Zt+jA37TZLAnfl5cj25h3smFnyB/Gl+jtKH/HxbIeJ0RABPUwNGGFJcGdG++sN1LRtmM6QP1Hx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RGkdnfNY; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGkdnfNY"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso831932b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 05:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769694591; x=1770299391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qa6Pc/7YQxTkk1AR/CK47HEuWzh3zruMmwF2wm/H0lA=;
        b=RGkdnfNYKv+wa33NKm86JeRBY1qbJ/rLJ3/METsgCdIjQ3B8/Jw6QyhrbtShvxmdhv
         Z3ChhnaKuxr04lnp8oXGiDVt//f5LfnBHFqoCo/XZlr+zcv4E5lRzWOk3hDIavmW/m7R
         aWsbg2VIpDqqsmod3lXML6zd6RNjyIw0IGc64CZxDWYUcE3snh6FYcfiPzzPXYxWOR97
         JqglYWLaiyOpZC7Oujc9QpCxnhF5hrKKdYwmNqKyZOq02uD2g/DABG1yXhHI2fft1Nb2
         dygRdO7YeDRrVRVjpKvuznL8ZjKRxu6DwYgHwqyYi2ugf2HJokcW+CjTK1SH6FVoDmO2
         xRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769694591; x=1770299391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qa6Pc/7YQxTkk1AR/CK47HEuWzh3zruMmwF2wm/H0lA=;
        b=QD7/7Y8T7ibYGQZI55hzLs2QAIveAEkHh2io0O6pABUUaFpJAyGZmQ0UVfCgodDTqM
         pixVmQ1Qg1fZAh2QYswCPXcDvGpWcP2vCE42ToxIXCkpWWICSwdyAmAmTXSfqmdJbBQc
         nWRzNwIpVZdjYomw9UmNi6IuwQHKehYf0kgrjCEccNlFtDQLe497W8GUwofKzLXWT74A
         gnjMn6yA/2LrXN3Q3j00EcvuEqnRoTiN+yag9iHNidlRoziAndZFP1gLDqHv5OWbqBTf
         We/WAXI/xsoaGzV7S3gV/a+ftiS+uMzHDYg22V0rvMWx95/hfBlPnUYib9m2Mm5PjL+V
         XjSg==
X-Gm-Message-State: AOJu0YxCVL8blcZ4fxan2tMSrEDdci12yJ90/RTG9pf90WNik0vzDk09
	tahhheMNDmq58Ff0gxF0qy+CYUo5dvS+tZIYQJrXnbGZcSHZ1OVD7rRT
X-Gm-Gg: AZuq6aL7WfRxu5AQKxYLp35ayW2IOlgXt2+8oWMVaJuPz8/82ENnivBzRGAHdzUjXjw
	yKz7eOHIHiXs0V2O1xjEPm7GAFPb6ZH68rbTQRrlN8faV3G6gsRNBGCrxPrDp6QoNCKIo8z+EHD
	897L6gN+h7g8DDYcIiyAXR5aps3gQ9HeqG3ECDAiYgHddtxRstGDylaoCfLBRAUbs2yX3KYOj2y
	OMaU77s4Yi9UwlQJraEipQt04Xxf8BFb8NVLBK7vF8TUjmTr0b1thMRvnRozoMopWKmF13VnJQ7
	l3zuCzAZyDJVvjwTLkLpm6hRBx1dGoeGfnyU9KEmD3GEvYZ+nV3VrEmEw3fVvSmYd/yM7p3c83O
	OV8g1SHArq+5ZNDblqy/HxIx34rGTxjYp0lWJo4QAHo9xbILcbj99Bc39O6aeliOMj6Pd0h+5mE
	RHNHHLjtiXdT4=
X-Received: by 2002:a05:6a21:6009:b0:350:3436:68de with SMTP id adf61e73a8af0-38ec6583a23mr8026625637.53.1769694590569;
        Thu, 29 Jan 2026 05:49:50 -0800 (PST)
Received: from inspiron ([111.125.210.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b3eef44sm53768715ad.11.2026.01.29.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 05:49:50 -0800 (PST)
Date: Thu, 29 Jan 2026 19:19:42 +0530
From: Prithvi <activprithvi@gmail.com>
To: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260129134942.nooyuvarh6vr32eu@inspiron>
References: <20260122154051.64132-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122154051.64132-1-activprithvi@gmail.com>

On Thu, Jan 22, 2026 at 09:10:51PM +0530, Prithvi Tambewagh wrote:
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
> ---
> Changes since v1:
>  - Update commit message to reflect the fact that same file, which code was 
>    currently operating on, was tried to be opened again, leading to 
>    acquiring the same semaphore in nested manner & possibility of recursive
>    locking.
> 
> v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/ 
> 
>  drivers/target/target_core_configfs.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index b19acd662726..f29052e6a87d 100644
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
> @@ -131,17 +131,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  		db_root_stage[read_bytes - 1] = '\0';
>  
>  	/* validate new db root before accepting it */
> -	fp = filp_open(db_root_stage, O_RDONLY, 0);
> -	if (IS_ERR(fp)) {
> +	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> +	if (r) {
>  		pr_err("db_root: cannot open: %s\n", db_root_stage);
>  		goto unlock;
>  	}
> -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> -		filp_close(fp, NULL);
> +	if (!d_is_dir(path.dentry)) {
> +		path_put(&path);
>  		pr_err("db_root: not a directory: %s\n", db_root_stage);
> +		r = -ENOTDIR;
>  		goto unlock;
>  	}
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

Hello all,

Just a gentle ping on this thread

Thanks,
Prithvi
