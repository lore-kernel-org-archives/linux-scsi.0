Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8AF3596F;
	Sat, 12 Jul 2025 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752331392; cv=none; b=FUuxNnKl1XGlh8OeqyF5TbRD10apyJU3w4FRzhUxhv9ae6brArXKUMhHczM0aa2Irfi87nJI9mZndIwawNT2LmtE/Jt85/jpJnydraZOkLBMCzI3E20PxcOPLXNBfF2lkn/PHdM4TwdgdXKLO2jXXzIzieEGp72dHPEwz0MGsCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752331392; c=relaxed/simple;
	bh=b20godMt7Kn73aKFSXnOJwBU6ATKcjtax66vQr74/X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMypbzOwkxBYBBe5ivwq6nVf2S+w4rqvdW1wZ+TFpPzLiSjkdf9mriXww7T8cLvz6M3ZEMiQ6Hw0YIHCTPoeHwqhAgk6JaIGKLRfVkY4XsLHRc4LRDGKIBU/TULOI10aGlwkerFFT8AW47eSPsHfY3faaEvLofEHJOgQsRIw0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnSRzRW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnSRzRW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDD5C4CEEF;
	Sat, 12 Jul 2025 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752331391;
	bh=b20godMt7Kn73aKFSXnOJwBU6ATKcjtax66vQr74/X8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cnSRzRW4K+btvuzXI8rVM3O3qk+dgMS7zVIa3qCEfiUJQXw3Jd5UDCShD7rkHwpY+
	 k4AHEkdmkNq3Qhc5Ib0N5i8XkMEKtZ2a02rQX7e8UumArGsBzzt/Yi/NhF7vPZpCd0
	 TgBpcRG86w4VpIVRmLeW9x0jNQEvWVpLxtA0Iyeg=
Date: Sat, 12 Jul 2025 16:43:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>
Cc: liyihang9@huawei.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, linux-kernel-mentees@lists.linux.dev,
	shuah@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi_sas: use sysfs_emit() in v3 hw show()
 functions
Message-ID: <2025071244-widely-strangely-b24c@gregkh>
References: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>

On Sat, Jul 12, 2025 at 05:28:03PM +0300, Khaled Elnaggar wrote:
> Replace scnprintf() with sysfs_emit() in several sysfs show()
> callbacks in hisi_sas_v3_hw.c. This is recommended in
> Documentation/filesystems/sysfs.rst for formatting values returned to
> userspace.

For new users, yes, but what's wrong with these existing calls?  They
still work properly, so why change them?

thanks,

greg k-h
