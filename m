Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E17262A;
	Tue, 28 Jul 2026 03:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209509; cv=none; b=l2Rys8DXl8l73hh737fsLhp4NMIhpJM93VIVgxkIZ7iBbJJlrGdYvakDEL4f3qU766Ccx/4Hx69bk2TQcT+iaUvEucxECgRzBrwn62DA4Gj5rlL6vdkC7fhQgpHxjEq5kd49k6QOR1l6enBkayPuZ1DME6sbRqfFJ6Ft2IRUVWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209509; c=relaxed/simple;
	bh=7SeYj8fAWHtEQcjvE2wqur1n7VyyRxxjUvS+osB4aaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JhmnZi3j4wa5M3HsNPvAppb/Sv/4usOgKcshmY5J+4vx6rGQU1Jh7HgPiLmfVXZJIDlfh3NY361YtRN/BcZtNAnAcvaoZpjcwotwLR6Xyhy3BgyBh7xCbvyDGus6NMSvwwWxIB/xIbYZCAVi6k+KInKvFZNKmAlX+p5cRil4ITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2KB8O+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2KB8O+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D71F000E9;
	Tue, 28 Jul 2026 03:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785209507;
	bh=OXnap+YbqLo6p8Ii5hoRcnhiAWPweqWyLuugC9tbTks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C2KB8O+LmeYwAK9T1Aq0LJ34lXFgOWM/vaLTSmiNcuMJYt48ZWM2EUK4PaX9lfAjv
	 HPDOXpO1aQk11csxN7P2X7IbYw6qFLQtrtL/CBKTpfBBv7rVpQVS7tS7wJuP/vYCSZ
	 RBFymBo721WbPBBFhPaHaeaAyXjfSWvB11KYg9twHDW6xv2MiOH6vS8faIf0g92Znk
	 wSfcTpKd6prDVjvX8Kx1XnCWQjC0I2xnA02/0GzTZefxkNeN38UgFHqA7KRLPZe4I/
	 F+Yh7q/sTP8iupsbkSSC2r7qE8tCuL+lo7gNEJg8NPTEP/Qi0zL0ofKQEk3lGloErx
	 eUZS8GutPap0w==
Message-ID: <b5ca79f0-cf1d-4a44-98fb-cb470f01a102@kernel.org>
Date: Tue, 28 Jul 2026 12:31:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Igor Pylypiv <ipylypiv@google.com>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
 <20260721064027.2081195-2-dlemoal@kernel.org> <amfCVx43BCYFWFFY@ryzen>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <amfCVx43BCYFWFFY@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 05:40, Niklas Cassel wrote:
> Might be a quite subtle difference, but I think it is much clearer if you
> would instead write this as:
> 
> 		if (timedout_scmd && qc->scsicmd == timedout_scmd) {
> 			host_byte = DID_TIME_OUT;
> 			action = SCSI_EH_DONE;
> 		} else {
> 			host_byte = DID_REQUEUE;
> 		}
> 		ata_scsi_qc_done(qc, true, host_byte << 16);
> 
> 
> Because that more clearly highlights the special case.
> (And is more in line with my suggested comment, so it also makes it easier
> to corroborate the comment with the actual code.)
> 
> The special case is if timedout_scmd is non-NULL AND is the deferred QC.
> 
> For all other cases, if timedout_scmd is non-NULL but is not the deferred
> QC, or if the timedout_cmd is NULL, we want to requeue.

I added all your suggested comments and code changes and added the patches to
for-7.2-fixes.

-- 
Damien Le Moal
Western Digital Research
