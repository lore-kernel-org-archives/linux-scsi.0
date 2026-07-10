Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B4B34E760;
	Fri, 10 Jul 2026 08:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673321; cv=none; b=IVkG0pqMpjJVPwim4xQajQWk1cME5ARo+cCDrYd91prHxX8bZZ2lu0+ff6egjYForsOMCKKJY/2uk9r64UT/03iG/EoUMxow+R9vT6QbQSTMEGU22Z3S4e+vTI2bDQ23K5+6q0P7gm/ScZMNOIhwv2BjANEjXwZP5QuP6ORmu4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673321; c=relaxed/simple;
	bh=V6E+KYHikAIZQEBXlJKFSX8kwlVldwe2QdSBxDSYvZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZ/ITA81UaIkTjbuwcTi1pmOG4QjRWADpKNnq0rHQjcCT9y0wG9f1KElbkqhTwZ+6bDmDRwCgxOZBYe0JlPl1kkPVUH6o4f45aQRNblDxKnQICJVxe2JsNMoGXlVk5a2t8JETYA/gEu1UyQkC8DwmaDzflgHFI59xP7rTqt3+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+1ezhey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+1ezhey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B721F000E9;
	Fri, 10 Jul 2026 08:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673319;
	bh=FcDk+pAi9IDjDcq9wSOzEIHRBnoIUxUD72RTHXfnpeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M+1ezheyU5lb/yw2Z543TFilkg7ucDEA95Gc8l26y3TuDH0I5GIdD6p8dHw52WKCO
	 KOqN3nptVlg9dU6DvneZdlvFu5OG4hzOoCnmsbRFkfbw8rTgK8gozS2ewOGu12FyPt
	 K/a6mJKPgpjB1Jo1VltbD/scdqKQfhDOqnG+WWaqrHYrQy/4iF4n05FMNwZKUTTy3U
	 M2PQOdRgApKwLlBXMySuVDy+9cV7VW7WHtPeRqsO+geKKvy1rCYgcrsZecwa4hlX3i
	 s0XAApArZKXG8ojcA+fXtLwI6EyP3EHj6yCQjTlxU4eWl90ClC1BugGli5+RRAEAa6
	 +YbkYI2kOtNlg==
Date: Fri, 10 Jul 2026 10:48:35 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Message-ID: <alCx41Qlh4TStKmB@fedora>
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-2-dlemoal@kernel.org>
 <20260710002431.3148D1F000E9@smtp.kernel.org>
 <724b4a01-e396-4cc0-be2a-9860f42d803f@kernel.org>
 <alCoB5FOGJTljbjU@fedora>
 <43c999f5-84bd-45f1-8194-cc80a535ef0a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43c999f5-84bd-45f1-8194-cc80a535ef0a@kernel.org>

On Fri, Jul 10, 2026 at 05:29:56PM +0900, Damien Le Moal wrote:
> On 7/10/26 17:06, Niklas Cassel wrote:
> 
> Yes, it seems that nothing blocks new commands until scsi_eh_scmd_add() as that
> is the function setting the host state to recovery.
> 
> So back to the drawing board. A simple requeue will not cut it.
> 

My thinking is that if we set ATA_QCFLAG_RETRY and call
ata_qc_schedule_eh(qc, ...).

We should end up in:
https://github.com/torvalds/linux/blob/v7.2-rc2/drivers/ata/libata-eh.c#L4075-L4082

And this function will only run from EH itself, so obviously new
command will be blocked at this time.

And, if EH itself requeues the command, there should not be any
race between scsi_timeout() and scsi_complete() (since scsi_timeout()
will only add the command to the list of failed commands if SCMD_STATE_COMPLETE
is not set).


Kind regards,
Niklas
