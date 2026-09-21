Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0F4B5CA2;
	Mon, 21 Sep 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003861; cv=none; b=D0gqQcvfrJDpPLzOsVq/3Cn8ang1RmNRW71q2AgEgyRrFY9e2iElf+JwigMzSphrG20qmn1kxOpiZooxtAlv/Pm9bi9dY4bBTLvObXm9+tQTYfUrWp9STsv5Q7+6P18nodA+tQVcoDpr6jryqmzgujmng2MHwgFV2mUonW0z+q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003861; c=relaxed/simple;
	bh=oO4Q4vKG+lsS0mYrQN/KPkiOEmGda5hzCFp19jIW3S8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=maOFm97LinDEhUD9uwQjfrA8j2YjeFG5F7/7GhEb/T9S/PMfPb1KHd76MgUx6Q6VNDZp/QyKbJkFXyZjIYbm5az4cG5WDyOiJG5wxWeJVCxtXDK5tze/3iQe1a9noD1DPApDj1wWVgR5zX/7pymq8v5mnlR4Qvg72db7a/s7aIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByM/Cqvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByM/Cqvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34DD1F000FF;
	Mon, 21 Sep 2026 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003859;
	bh=eFebAGvl97gWvUUihD7DJR70n3PAhvkIbV5S28OCT1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ByM/Cqvv6ANjlZ7mKRhVKjWXseHhq+lPz458Z5tfopzRhtTsdKCRqYXzRPGOhLtoC
	 8KiW3EQEOIaSj9MhiXqNL+0F6C9Ssi1WdaFWQJBnaWGr5qaMRp3eO2GkewN6zaHAFR
	 w9LZhuh9u+LzmQyCqJ0t3EG1kmVh+Esmw8vucFx5l/1c6VDaSh0lFQm+cUfvUJ6o3G
	 9noNaJi2GQNmm7DviW23MMsoeIetBkGs3dwKj3IGuai+8hDQb9QUmskIAPaSTrHana
	 sJVp/fWuc2Lf4Bn87ISn4XaJPvQMKQZ9a6CcEZnoR+wnTDE6HLrb5y0OcnoHwhX37a
	 YZZfCgu1YlEjA==
Date: Mon, 21 Sep 2026 17:17:36 +0200
From: krzk@kernel.org
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	stable@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] scsi: zorro7xx: put SCSI host on remove
Message-ID: <arFKj506cRh4H_z6@quoll>
References: <20260918180201.3624568-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918180201.3624568-1-lgs201920130244@gmail.com>


On Sat, 19 Sep 2026 02:02:01 +0800, Guangshuo Li wrote:
> zorro7xx_init_one() obtains a SCSI host through NCR_700_detect(). The
> probe failure path drops the host reference with scsi_host_put(), but
> the normal remove path does not perform the corresponding cleanup.
> 
> As a result, the SCSI host reference remains allocated after the
> device is removed.
> 
> Call scsi_host_put() after all users of the SCSI host have been torn
> down to release the reference acquired during probe.
> 
> This issue was found by manual code inspection.
> 
> Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/scsi/zorro7xx.c | 1 +
>  1 file changed, 1 insertion(+)
> 


You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem, how to document usage of LLM and how what you should not
do if this was posted in a good faith.

Best regards,
Krzysztof



