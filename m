Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3423839BD;
	Tue, 28 Jul 2026 10:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233245; cv=none; b=r86aFaPeqmcMNkaYR7RoPGP7j1ZeojIV/ziO3cZ+pp+Dx7a45Qa7Rji04jcWIF2Bv2GBpF8LHjayDGlqp2Wy+TnXr7Jn455pfDRy/0RSSJ7+maWqbefKZN6JvUavIOXhII/wGG/Rm0tWUudLdPkzdM/vLj98bhaegmMyTlP2PN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233245; c=relaxed/simple;
	bh=3kPfm0VeQYjHjxFvUgHQvUYkz6jfx9BCNEBK7kGLx2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmIskuwrkwmxP5MHD8HH3H7g66NWqQ3haDWyrAIZ1jTwuEhy95MqjQiCjipf2DfmZbHNzQI8DbbYd9FkVhCn8oRwx+3ou1Yied6CdbklayxUx3oPL8flbM2iRnxFn9dA3649PwDDvNa1Bc++YbOQhMdYJytFlfM3YTNas5xR3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFLWOYgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFLWOYgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E811F00A3A;
	Tue, 28 Jul 2026 10:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785233243;
	bh=rV42LR27D2MsXO/suncZBIQ1wrLvwAMvs+7ekNnjqSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dFLWOYgkCDTCzuC3HOEsfDRLGH8HmUFWNTXGVd875CrUPUuxw1Wtr0gqkJb7QpLv3
	 ZEgjfjByeShv3Q8kYJJJdyMgb0r8fUg5j/ejtCm00VM7VcT9NQz76YRonuhTuCZaca
	 nadJr84E3ovSmQQK62DCLUfyzJjB6SDIAw/Jq/42hXrAid4QEky8lcQKFFt2fP0gaU
	 eWuKAZBcgIz6dvjaGd6IYJgf+firIG8g4nleFzuECX+JXLmWKKA9gGJe4+p5VJrLxI
	 lJSf4NKnXglIA0ROgVQ4HH23I+LEEXrSXnQ9gL1AzI0f/HlDgtuUlNQJ2C+bOx5Jp8
	 mOgS/2wcsIZnw==
Date: Tue, 28 Jul 2026 12:07:18 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <amh_ViYTvYXVZs6U@ryzen>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
 <20260721064027.2081195-2-dlemoal@kernel.org>
 <amfCVx43BCYFWFFY@ryzen>
 <b5ca79f0-cf1d-4a44-98fb-cb470f01a102@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5ca79f0-cf1d-4a44-98fb-cb470f01a102@kernel.org>

On Tue, Jul 28, 2026 at 12:31:45PM +0900, Damien Le Moal wrote:
> On 7/28/26 05:40, Niklas Cassel wrote:
> > Might be a quite subtle difference, but I think it is much clearer if you
> > would instead write this as:
> > 
> > 		if (timedout_scmd && qc->scsicmd == timedout_scmd) {
> > 			host_byte = DID_TIME_OUT;
> > 			action = SCSI_EH_DONE;
> > 		} else {
> > 			host_byte = DID_REQUEUE;
> > 		}
> > 		ata_scsi_qc_done(qc, true, host_byte << 16);
> > 
> > 
> > Because that more clearly highlights the special case.
> > (And is more in line with my suggested comment, so it also makes it easier
> > to corroborate the comment with the actual code.)
> > 
> > The special case is if timedout_scmd is non-NULL AND is the deferred QC.
> > 
> > For all other cases, if timedout_scmd is non-NULL but is not the deferred
> > QC, or if the timedout_cmd is NULL, we want to requeue.
> 
> I added all your suggested comments and code changes and added the patches to
> for-7.2-fixes.

Looks good, feel free to add:
Reviewed-by: Niklas Cassel <cassel@kernel.org>

On the two patches in this series.


Kind regards,
Niklas
