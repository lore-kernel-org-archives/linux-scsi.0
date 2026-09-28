Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B940F75C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790579714; cv=none; b=gqIh3+StC0xle2pW9fBp08yyEEjssPVoJ7eujvK9Ed1KMuQ4vKvoi7GoL2ZGoStYmDAiBk5KhK+FeS1FTCGh6At/1NvP08dw99af09q6/Gx+ae73uuXizi9a/kecsthkpC9O3uPMMuqub/sO6guWbRgLbjuHPxeKcAwk96jBjUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790579714; c=relaxed/simple;
	bh=OJO5ab2L+vrGLa5uFAfg6AG2/WxQWecyw1tlkp6HS6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgiUfTG40WErznbdWhPgaMHal1Y5weQ+gkGU/Lci6NPWfxc+TNoFHmzgA7R+yhP2URnYaPdNbFE5SnDeHHFopcYkSBWn5CNrRNsNynrPDLHHDC+3hvw5LJgbnmkD6tN8KfB6xtvqqChnQ4oR6NT4YNAPbw3o+S9aXEDuLsKmXe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jw2cEEyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jw2cEEyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18D51F000FF;
	Mon, 28 Sep 2026 07:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790579713;
	bh=OJO5ab2L+vrGLa5uFAfg6AG2/WxQWecyw1tlkp6HS6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jw2cEEyMiQRZ5umkkvLreHHRDl+0RMkBhqanAKBvXMl8rSE6HdWg4mWEeiSgU5KZb
	 M5wa3VYIrIYPbKkG3V0m/irMotw6/jmV4YxHVx19pp/CrscoiUBl/S+2Al30stRB+L
	 /84lkWCQ85SQsoD2o3dbpWGwsG6Dctxn3dcfzi0SRqoWTVZb667z7zQodEmf7hunFx
	 BeckFA6HkMPMzgb3w/h0/Shzbeiiel/GwqgTL6jEf45IhUtkAihsz8UEpShpE9Tnqd
	 t/d0lc/TCvVugJYC8qiTZgqO+y0QLmlA6vYI1v+Tw4v+mEW7U4gveSMN/dqyQ/yrqZ
	 +OaK5vd92568g==
Date: Mon, 28 Sep 2026 09:15:09 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a write
Message-ID: <aroT_W6PzdiUeUBd@ryzen>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
 <1dac66aa-a4e6-4c79-a914-d5d2699c392f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dac66aa-a4e6-4c79-a914-d5d2699c392f@kernel.org>

On Mon, Sep 28, 2026 at 08:45:30AM +0200, Damien Le Moal wrote:
> On 2026/09/27 7:26, Niklas Cassel wrote:
> > A write whose data buffer is larger than its transfer length leaves a
> > residual that the initiator is entitled to be told about. resp_read_dt0()
> > and resp_write_tape() report it, but the write paths for a disk do not,
> > so such a write completes with GOOD status and a residual of zero while
> > a READ of the same length into the same buffer reports it correctly.
>
> I am not convinced this is correct. resid (residual count) is supposed to
> indicate the amount of data that was *not* transferred. So if the buffer size is
> larger that the command cdb transfer count, all data can be transferred and
> resid should be 0. Which would mean that for this case, the write processing is
> correct but the read side is not.
>
> The SBC and SPC specs are very silent about this though, I do not think that the
> resid is actually standardized. And I do not see a clear definition for it in
> the documentation/code comments.

The definition is in Documentation/scsi/scsi_mid_low_api.rst,
under resid_len: "an LLD should set this unsigned integer to the requested
transfer length (i.e. 'request_bufflen') less the number of bytes that are
actually transferred".

Also in include/scsi/sg.h: "resid; /* [o] dxfer_len - actual_transferred */".

Both measure it against the buffer, not the CDB.

That is also what iSCSI reports: RFC 7143 11.4.5.1 measures the residual
against the Expected Data Transfer Length, which the initiator sets from the
buffer.

And it is what scsi_debug has always done for reads, in fill_from_dev_buffer().
This patch just does the same for writes.


Let me clarify the commit message in v10 to actually reference
Documentation/scsi/scsi_mid_low_api.rst.


Kind regards,
Niklas
