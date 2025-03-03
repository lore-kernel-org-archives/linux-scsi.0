Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7DF213227;
	Mon,  3 Mar 2025 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741027552; cv=none; b=U9uPqn6fcwDiHcOk/RSXIINjc0tSkKc2kBDnYfEqTmKHQEayyaf/uifvw/sNXoJ3EUyXpWr/QWhwvbjVH4WoLLcRdi+KB5mfS1udGVbtXv9E47jShtnkXaEPUWkTBL1JZ3vgITArUbyRwqpB6KxoEJNvTty5cP3Os5mCdDssIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741027552; c=relaxed/simple;
	bh=KY75FiOFUJ6zbCLSW6Srr3X3GhxxlNhwePK6WSrFNN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WqQCwlEi+0cklkcMU1/Ld21zcmvXxvEGSVQf0yQJKnc1z19PcXIOmvW/X9GE2bW24ShbMW1mp76gzY1rEVdCmkM7zMrcRbTJ1D9rJ3VJ3Rv+mEFDdSQsdzr3cKFO+aKjVsU0M0t+LJYl7FtyXSOoCJP1CGY8FSYcnmj1BPSB9Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oy6O6jcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oy6O6jcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E50C4CED6;
	Mon,  3 Mar 2025 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741027551;
	bh=KY75FiOFUJ6zbCLSW6Srr3X3GhxxlNhwePK6WSrFNN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oy6O6jcPC89LAHXHxjVJj3qBaXwwX0Ud5Gbshcz55Qt1+/7sZiknf8e8BLp/kdDaP
	 6bKdWOunufJrmiqw+BhNbdm5JPTDWzeKhCUPWSTWBBQzy7fG2nIgh4rtVwDFcvkgv8
	 TfJ956KoPlFTlinjAsF+y+684qfQhw8uVC5ZK9cNnA82tXxgYicEGEN/9VJLMgV/xE
	 rfI8HRhqqxnmTqgvlUHMPNwrmffbyiHpEcvyrEHp1hO9qdOz1w6spCHXTIoLHzj9Kd
	 nh+EzYhGUAN2WdxdqiJz7K3sQtrqH6LmczADHrv5oX+e3MVhqlApEfndmhe1gGuftQ
	 ZSGswaroXuAvw==
Date: Mon, 3 Mar 2025 10:45:48 -0800
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202503031045.1E2D5BE@keescook>
References: <20250302225641.245127-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302225641.245127-2-thorsten.blum@linux.dev>

On Sun, Mar 02, 2025 at 11:56:41PM +0100, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead. The destination buffer db_root is only used with "%s"
> format strings and must therefore be NUL-terminated, but not NUL-padded.
> 
> Use scnprintf() because snprintf() could return a value >= DB_ROOT_LEN
> and lead to an out-of-bounds access. This doesn't happen because count
> is explicitly checked against DB_ROOT_LEN before. However, scnprintf()
> always returns the number of characters actually written to the string
> buffer, which is always within the bounds of db_root_stage, and should
> be preferred over snprintf().
> 
> The size parameter of strscpy() is optional and since DB_ROOT_LEN is the
> size of the destination buffer, it can be removed. Remove it to simplify
> the code.
> 
> Compile-tested only.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Link: https://github.com/KSPP/linux/issues/105
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
