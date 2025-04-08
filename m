Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409152566FC;
	Tue,  8 Apr 2025 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744155767; cv=none; b=AlWIx/8sa6FhX3JOPPKMh7rUYR37tfclo7lNQc1VndCjO3yxilufZ5xBTTxWvPmIscIIJqNOZb2w5DgDrt0qF0xP0Ecp0F1W7D+PwnqTVPs8JTavF9+Kyt85yvAKy9Mx8yFQartZs+nBvuxifRP7haE982nWfw5qs5bC5+57uRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744155767; c=relaxed/simple;
	bh=wSqMvhAGTeafnDX9pFLvgcwuEtdegr7pOcXNA+niwH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNNUJ3yAI/si1+qoK84bacO8KiUIMDouqO1Ba0EMuaUN3Qx5B9zbxzZUFBqjM6lmzFXHN24oDvbX5wsD99DJTdnm4eRBcGC2MlkSUMYacwGiX2zW7bmRnjW1Vv+HenToDkdyMl2SFnPlw9tv9ibtTGLZClLM6MPZJ/qqetOvb+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwPQLMj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwPQLMj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7147C4CEE5;
	Tue,  8 Apr 2025 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744155765;
	bh=wSqMvhAGTeafnDX9pFLvgcwuEtdegr7pOcXNA+niwH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TwPQLMj3oNqdTdsHAY57cATCM9d0oR+E7mFU3kEW+TVKpHoYaL7vlOxeh08T7df4X
	 9hv1+CkSjoH+CqUTFRiNATcJfEeuLQn0g/+70kJKSu2SAGKzfkmPnD6GOhNfZ5Ux7F
	 g2J7B5zOfbMqeywRDKlymoLdaa2A9VRDB7HcY4W6XQ9tJgYUtAZeTOAysZdja4gIzB
	 ZWPLRV7fYykP8IQyt276EIoCY8zLIJfVBudXU00YDdCfKJBJxwyw3s1gFUjG8XHqiL
	 9/S95jhfeGqyQOlCxC5wGV4VlOkuQzNVR0J9OZzaTY3CjZflYBNG4P+VrG7x5Q6Qph
	 5Osj+uGTHX4cQ==
Date: Tue, 8 Apr 2025 16:42:42 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: sli4: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202504081642.6A3104D@keescook>
References: <20250408102843.804083-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408102843.804083-2-thorsten.blum@linux.dev>

On Tue, Apr 08, 2025 at 12:28:40PM +0200, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers; use
> strscpy() instead.
> 
> Since sli_config_cmd_init() already zeroes out the destination buffers,
> the potential NUL-padding by strncpy() is unnecessary. strscpy() copies
> only the required characters and guarantees NUL-termination.
> 
> And since all three destination buffers have a fixed length, strscpy()
> automatically determines their size using sizeof() when the argument is
> omitted. This makes any explicit sizeof() calls unnecessary.
> 
> The source strings are also NUL-terminated and meet the __must_be_cstr()
> requirement of strscpy().
> 
> No functional changes intended.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
