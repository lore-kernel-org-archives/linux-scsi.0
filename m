Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1A6155326;
	Thu, 13 Feb 2025 20:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739478970; cv=none; b=RAs9KZbEClfSISkFfostw1x2JuM5+9GGNvREhaQqiV0P5ivvxrxi6y1bcerp/J6fMOrZBSAbDDcYUImu70LxS58iUj/ObZ2VYIjSldbiPeAy7kKSsmi7NW60LU0Hyo+41jpZm2BTqo7dfLy1r7z/FkEkgrDDTKH55A5QN9yxWOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739478970; c=relaxed/simple;
	bh=oX1uoiCGEUJDBlnpsxvP7WtXlzAb8xSRF+PCSJzW3HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFRW9+EXQH7fwnlj8woBWpVNwP63Fo5VoqN1Pd4ctzgEdyz8BnSykokiWgF2e3aOyz6Lz04zp/cgHA54KbDe7UdDTBR4q5iCi2Hlm3oXcxhTNozfzbbBYtQTvRKw9SSukSPPUcrKslZ5N8NjvEGkJumvLIdDgYq+kl+j/Syg1gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ss6lNFee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ss6lNFee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3C5C4CED1;
	Thu, 13 Feb 2025 20:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739478969;
	bh=oX1uoiCGEUJDBlnpsxvP7WtXlzAb8xSRF+PCSJzW3HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ss6lNFee8NJ6X2HPeDZUmwsO9sWAG8MgVCkxhAAFIairGVlS72q0/ZJxjmOlIFrDN
	 okRZfXmeyRJBgz0pnyrkeEsnbAjgckC6dQb42ulCzTHKk/mxWT4/lICPX0rDeSlrjn
	 6H4pLsWqrFzTEHIwXKDTgDaYLNm0uQh9G+QjfeJbiXOVGBQkbvKqyBX3eCkbE9qixb
	 2Cj8BEA6aWteVMLOCwjd1QEdprr4xsctvezoaEr5WUj0zcyZFKoEAOi+VVD3WkYoUl
	 t5gYt1/HuN/62jtfNFOiEPxecE8KKFo9/EPC9VE1JtjcpP7IYEDg1z3h6HUbjMXp0L
	 wHLu1sa+FcNpQ==
Date: Thu, 13 Feb 2025 12:36:09 -0800
From: Kees Cook <kees@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, storagedev@microchip.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202502131235.D4C0CD2@keescook>
References: <20250213195332.1464-3-thorsten.blum@linux.dev>
 <065b6317-8da8-42ec-8084-1a5058c0798a@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <065b6317-8da8-42ec-8084-1a5058c0798a@acm.org>

On Thu, Feb 13, 2025 at 12:34:55PM -0800, Bart Van Assche wrote:
> Something I should have noticed earlier: this code occurs inside sysfs
> write callbacks. The strings passed to sysfs write callbacks are
> 0-terminated. Hence, 'buf' can be passed directly to sscanf() and
> tmpbuf[] can be removed. From kernfs_fop_write_iter() in fs/kernfs.c:
> 
> 	buf[len] = '\0';	/* guarantee string termination */

Oh, good point! Yeah, ignore my last email. Yes: tmpbuf can be dropped
entirely. :)

-- 
Kees Cook
