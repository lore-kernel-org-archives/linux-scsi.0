Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9172BE629;
	Thu,  5 Feb 2026 19:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770319485; cv=none; b=qldoDcKFxko+NN4WHvPsj8rHfIJEUaSTDKOGW6a3LQxjK3F2NYxq3D9GFP3CGNtGyz3TXyd1lyOeItlW7AoLUq9pxJRdzvetsRWzdzpC7mUu8GQAZX1fe2ndqBaGmVcX9L7haoE8Dej27M6/t+HwkIl7nD1yXQbd85vBYYjMBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770319485; c=relaxed/simple;
	bh=DCqOuOW1zh9oQXmIZrwwP7pi8FgCeO4C23MyGCwMBKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPyv+z//iRTi0FDVfa9LejArDXjU7756YU14wa7NLS4O1visSK1ok70Y8XwZCQvNSFdmZl6BAXdsl7FC8T6Hug2BpzwZPxKlraMMIBcbXDdELy5zRhqJ0jebX8jbZ+os+0uUkzIXeEuX/9k93uN8q3ab3JTQVYvRFXwFWOdqcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=fRy9MmnB; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="fRy9MmnB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+SYqMu+RR2nCNVh1RNByYxA+l2fsT58P8/htWp+vtkU=; b=fRy9MmnBFf3iSDZ0MNXdHP5eeW
	zKKErOwGEVWlkdik25Q/zU03k9mvix5CSvPgjuJgZJEJZsDHPoXrra8YB/dWJIo+SglI2JZ5yrMoQ
	kdp+0FT7ojG+yy/v87cNBkKjmqBXeb3lGjZH/hlRYsDGlSlxOK1For39A0ftGmh2f5fPvEKgBTbgB
	DjB5GAm5CD+hJZuFOfxP3RNwpI16WKo6GtgbYCJmh9hvpI/Y+bg0WJIDqCcIys22zbYcPJW+v+389
	2AKCnLYqT/+Mtnj1x3xpMTw7DEZFFtNwTqE1ntSoMSZQxNWv1b/UZl+u3vTlsTwfq7kD1Xauo4JKO
	8qCB30Fw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vo500-00000003N06-3HaJ;
	Thu, 05 Feb 2026 19:26:44 +0000
Date: Thu, 5 Feb 2026 19:26:44 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260205192644.GT3183987@ZenIV>
References: <20260205162624.117957-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205162624.117957-1-activprithvi@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Feb 05, 2026 at 09:56:24PM +0530, Prithvi Tambewagh wrote:

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

Just pass it LOOKUP_FOLLOW | LOOKUP_DIRECTORY and be done with the manual
"is it a directory" tests in any form...
