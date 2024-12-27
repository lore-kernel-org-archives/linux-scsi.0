Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59DA442F;
	Fri, 27 Dec 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735262872; cv=none; b=SOFPqL+Cjnx4B78/ixIEMkHz6ZPutl8xUNegtou2qCGjJpbU5QOFvzTQGDURdzqE7V+XGdlXQOk8Y5OL89bdwn09UbPtw8zqk6G0u3GrmglT338k34ZViH6e6GvPCZxsX2MOBuoIl3cg9ioRyZB+ElVmoP6+QMD0iejWKhJ2QDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735262872; c=relaxed/simple;
	bh=U3WxbmtOqNbzwCdhemqrrlNwdagYGt2KndqXfmZDqrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXIxY8QT23/1Q82jsU2LaOlnQi84nGSojf4LCT1SRFR1Ur9NB/F2zHKSgVeYkajwpASUbK/CzdqKTPej7To7UudOhcEWTsK3OmlKKPdTcXgv37SGLSim2kuwAtV843+IPvukd6VtyDCjO6GGuExolBRzEEuJw2pux/oWidmqBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKVHktCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKVHktCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF2EC4CED1;
	Fri, 27 Dec 2024 01:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735262871;
	bh=U3WxbmtOqNbzwCdhemqrrlNwdagYGt2KndqXfmZDqrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vKVHktCihu2L1kZcRmgGMBbjP3xh2Q1GiLgPwRMhrPGZ3tyWqyzvo1LQidlkm8do2
	 fvvtdJoPvC/V0FyqbAnhZUnnQivbitA9byWQYEXZdvydoNv42hFoodYKF/oK5xjKGk
	 JSK3b7g/fQtwFIPpemBJIurWo+rf3OU6wzxGqMuI/fQ4B1LnVOy7QVRW9DuZo3DkQD
	 Y2+GpUgoZIfQNz7qFqa3BpRGqCnCqil0NZM1sgIDJYDp4tCIVc/b7TdjwmpFcaqHcK
	 bzeGvwtcjMY7cSwXLOIOxdKDttzjOVo9yZG3/XcDo61FDLPV25roe/M8hzqK2HTTEn
	 nFVydl0cuMJLg==
Date: Thu, 26 Dec 2024 17:27:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [linux-next:master] [x86/crc32]  55d1ecceb8:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <20241227012749.GA87183@sol.localdomain>
References: <202412251418.8e78094d-lkp@intel.com>
 <20241225213241.GA1939@sol.localdomain>
 <Z2y/cmuCmv22DiHo@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2y/cmuCmv22DiHo@xsang-OptiPlex-9020>

On Thu, Dec 26, 2024 at 10:29:06AM +0800, Oliver Sang wrote:
> > Thanks.  Unfortunately, the issue does not reproduce for me when following these
> > commands.
> > 
> > The kernel does panic from not being able to find the rootfs, both before and
> > after.  That seems to be caused by the rootfs from the job script not being
> > available on the 01.org server, as indicated by the following output:
> > 
> >     /usr/bin/wget -q --timeout=3600 --tries=1 --local-encoding=UTF-8 https://download.01.org/0day-ci/lkp-qemu/osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz -N -P /home/e/.lkp/cache/osimage/pkg/quantal-i386-core.cgz
> >     Failed to download osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz
> >     cat: '': No such file or directory
> > 
> > It doesn't print the error information from wget, but I checked and it is HTTP
> > error 404 Not Found.  Thus, there seem to be bugs in lkp where (a) it links to a
> > non-existent rootfs, and (b) errors downloading the rootfs are not fatal.
> 
> sorry for this. I just made the upload. the issue should be gone now.
> 

I retried it and the rootfs downloads now.

I still see some error messages during boot which suggest the rootfs is broken:

    ls: cannot access /boot/config-*: No such file or directory
    ...
    mkdir: cannot create directory `/var/lock/lkp-bootstrap.lock': File exists
    ...
    chroot: failed to run command `trinity': Permission denied

Anyway, this all seems unrelated to the reported issue which occurred before
mounting the rootfs, based on the provided dmesg.xz.

In 10 boots the issue still doesn't reproduce for me, following the 'reproduce'
script as closely as possible.  Note: for "gcc-12" I used gcc commit
08f1bd108806 from the gcc-12 release branch, and for QEMU I used v9.1.2.

And I don't think my commit can be the root cause, especially when the x86 CRC32
code is disabled.  So I'm afraid there's nothing I can do here.

- Eric
