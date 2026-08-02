Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF52399340;
	Sun,  2 Aug 2026 10:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785666964; cv=none; b=JEdwN9JRQcwO20AozkKNys/i/SQEf+CKImzGxRpu5H70uYQ3Nh/13ZyR60pgt2eP6ZpJmYJxQOYtTHmXy8BTcNrUjFPA9ZYj2AHEiiv0WnG5auYqeqi5wj7FLdnjy1E/2rKYHkZWS2nDkGsz1znysV6SBCVJP3Ie3HswBliwefE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785666964; c=relaxed/simple;
	bh=HpftB9eOKYRrNaINVAgr5pJgyqzb//F5PCZgf3D2Uj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzOwLCO7A6YfTkhnERxbKj5kaB6X0A3qv6aIZffHhCoXlYsIa4WnCIKS8zh1GSdyv2pGeOgu/jtgiRuL8Y93/BxEhkAYOnfxSRczSsdflZOkuTJtCfhCG+lbq6t524LhdIoUnoCOk1kp7W4lp82GVYNDA0WhneWO141qGrV4jmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7oPHj11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7oPHj11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456661F000E9;
	Sun,  2 Aug 2026 10:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785666963;
	bh=bvyZHr6KTcjImKIR7iQx7rbXMdz7uI78AruPO1Jx7ZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W7oPHj11cJjHqRURgj66CfDAK+iJLzIQ0SVo6Na5wjNpgMaRHGBzV6SPFQpnH1kv/
	 O+mwo8MTQnaWA3VQXTVIWWWj9lATAshgZd/QVWXt3kItPqvOsCfoaQqUB2TgNf3xKx
	 FdBapng0FgWHWzf2ZlxFFLzoKJexGvKsDZ/Ky5Q38kYnP7BdpevxCwKhGs1og79RbK
	 VMiCDUyuy/gTJQufhpq9cz6X9Sb7mCtM7yrXgt8YdtuzRXaeLdmM48x4niwQuTzGYy
	 4DvZm5Z3mIzQAEG4mS2hy684oqD3/hD+SGFMNBJD6R0ADuAOkPn/Sp5XQit8imMriE
	 m2u+B37ARRQzQ==
Date: Sun, 2 Aug 2026 18:35:57 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] common/scsi_debug: don't slow down I/O
Message-ID: <am8Yg5NMbLuIOfBd@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
References: <20260723142856.108193-1-hch@lst.de>
 <20260723142856.108193-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723142856.108193-2-hch@lst.de>

On Thu, Jul 23, 2026 at 04:28:44PM +0200, Christoph Hellwig wrote:
> scsi_debug by defaults delays I/O and doesn't support multi-page I/O.
> Flipping these defaults speed up each test using scsi_debug by more than
> an order of magnitute on my test systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/scsi_debug | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index c3fe7be623fa..91665547bc0c 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -59,7 +59,9 @@ _get_scsi_debug_dev()
>  		let physical=physical/2
>  		let phys_exp=phys_exp+1
>  	done
> -	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
> +	opts="sector_size=$logical physblk_exp=$phys_exp"
> +	opts="${opts} lowest_aligned=$unaligned dev_size_mb=$size"
> +	opts="${opts} delay=0 clustering=1 $@"
>  	echo "scsi_debug options $opts" >> $seqres.full
>  	modprobe scsi_debug $opts

While this is syntactically correct, especially when leaving $opts unquoted.
But as this patch is trying to to improve code readability, so how about:

local opts=(
    "sector_size=$logical"
    "physblk_exp=$phys_exp"
    "lowest_aligned=$unaligned"
    "dev_size_mb=$size"
    "delay=0"
    "clustering=1"
)
opts+=("$@")
echo "scsi_debug options ${opts[*]}" >> $seqres.full
modprobe scsi_debug "${opts[@]}"

Thanks,
Zorro

>  	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
> -- 
> 2.53.0
> 
