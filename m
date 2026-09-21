Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751114B3364;
	Mon, 21 Sep 2026 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003749; cv=none; b=CsZ57i9VTJe2YaPOj7tRyhMq57pFZK/tCvravBSLF30iqZzIiFRaXVmTma/h/UV0L53ksFwmcsLL+E7q6kU7VF84Zr1LFPA38Dzv+c/bSWMEYC+OMS/bMAHpLIzWN4x+WMciYWbNykyaN8RG1Z27+lZkWr1RWEYWQZbwq9V7Dww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003749; c=relaxed/simple;
	bh=3h2Vf7MQ6gbPIAHlTb6Tf0jJ1oiG9fyeFNnXc+/BghA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vvbwl1yk9JVxx3dCGO+kG9OV6CDyx3m0pCSGbSmH1CHmFc09hiKdn3GMNAVVs7sagShGkoUbSmhbyATL1UqVz+SUctdO1Ny+6WrmEI665pWiHA3b69od7Y1cUknhiUIfZdGU9eBCQNFICLtEQRIH8D6V+A9Fdsy9Yh7DjO5NTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAp0/rUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAp0/rUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F711F000FF;
	Mon, 21 Sep 2026 15:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003747;
	bh=q9yFLU7Unm1OdMVHZt4OUgFFo5ERQU/PMsBOuAHW9rA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAp0/rUuz54gT2hKVndjcni1Hod4P0YhEmuKoK3Dz0Y0xT+siz4EQfqiAqlbeiBPE
	 l6CApescfzkefaBt+jmRVsemHIh14aSUkUxkXRW0JS7Wy5AzQT2UzoiyNinOpkZzib
	 +Pp7Kwk7MsEet7SMmbNf/99ya5xx7mhSYigrM2g5xMvkX7v8gug+bFDX6O6sfWfZ6O
	 cyRwE1NGYo9cpsPXiNdVxPjqLRMvwJri2iqIzDl19D27nrlR7y4G3Bg/Fx5fscfLWP
	 CUHsP2gZPqmsLdFeS3zQ7ay4utLVlXmXHvhDRU2V9pGHBk4JqN9K764rj/JP5Go4zh
	 kdh8HjE0ZRYXQ==
Date: Mon, 21 Sep 2026 17:15:45 +0200
From: krzk@kernel.org
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>, 
	Robert Love <robert.w.love@intel.com>, James Bottomley <James.Bottomley@suse.de>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
Message-ID: <arFKHueZaSQAOSbc@quoll>
References: <20260919173405.3718408-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260919173405.3718408-1-lgs201920130244@gmail.com>


On Sun, 20 Sep 2026 01:34:05 +0800, Guangshuo Li wrote:
> fc_rport_recv_plogi_req() creates an rport before allocating the frame
> used for the PLOGI LS_ACC response.
> 
> fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
> rport list. If fc_frame_alloc() fails while handling a PLOGI from the
> directory server, the function returns without starting the rport state
> machine or dropping the initial rport reference.
> 
> Since the directory server rport is not present in the discovery list,
> there is no later teardown path that can find the object and release
> that reference. The allocated fc_rport_priv is therefore leaked.
> 
> Record when the failed frame allocation leaves an unlisted directory
> server rport behind and drop its initial reference after releasing the
> rport mutex. Keep the existing lifetime unchanged for ordinary rports,
> which remain owned by the discovery list.
> 
> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.
> 
> Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
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



