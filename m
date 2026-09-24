Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B47471406
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 11:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790248216; cv=none; b=KJ7OtIkcOEbWtQaqnLTpFRiaBUfzM9WsqDX2LNvaSSlvuIqVsdXUnmwfr8raGa/agzy1R2bcAFMzql9VjVhcoQt85OSVL5V/AjbAv1mzbn044itiLvUA8FyGhsWx5R6t6vB1E+VTDGoKoJ4jQLa3q/Lar1/AFPCSLap3bZiBSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790248216; c=relaxed/simple;
	bh=5TzvpgQufuDcWKEln5K2rCfHrrFpYW9ObVTZmGTTsbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E3dhy4FIfAWaGDA4X0vOId8B8peWaCZGRTe2Cq0E/kI+A6qXDY3VtEb7GF/KhJjF5eaAFo2duvHDnHk6eUb2mEn3gnjLlgg5UWcCrmHANPx+dE0giIdCjIcdTw2+ZWLUu7hr9RkCAeo4MPtUxz4XcBSKEW/47Ws7EFv0WZrERa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXlx0NkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXlx0NkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6DE1F000FF;
	Thu, 24 Sep 2026 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790248214;
	bh=51/JH8bkrirgH99/2zbpvZTjHCUsjCf6gDBB1IyOQk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PXlx0NkBUgXY/0bsgiiKXnrve7ciAF9y0S1S/KiAbGfznfZBLicKIGcMjFjtOL1vV
	 wdvRw4b1540uoixBX7CYGR7f3jcUqggwWBwmXjTFrpuPQU6bACzD3zPTIsSBH2WPLt
	 6M1OHtheypETil7oplsjAuYHSC4rf1ZDa2LvQjUIpi6GNixH4Xbup0SSStqVFmSdIb
	 jLV8m4o1z1GItKSjTWzgRKmFfchhwAiZIT+GI+sFJ3EBEbRNxB2ra+LNavx5oKS2HC
	 dCL2HMkWBTkt0NHCaJplX8d1X3Gp8dl4+OTMIWWRfnOYwG6ul/1sTVZfA+6RgvgJr/
	 ZegwQAK1zFTPQ==
Date: Thu, 24 Sep 2026 13:10:10 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v5 09/10] scsi: scsi_debug: Map the region written by
 WRITE ATOMIC (16)
Message-ID: <arUFEnJj0BX_gFQW@ryzen>
References: <20260921154015.2971990-12-cassel@kernel.org>
 <20260921154015.2971990-21-cassel@kernel.org>
 <3049af11-b93e-4849-8cf6-463a27792ae5@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3049af11-b93e-4849-8cf6-463a27792ae5@linux.dev>

Hello John,

On Mon, Sep 21, 2026 at 04:50:31PM +0100, John Garry wrote:
> On 9/21/26 16:40, Niklas Cassel wrote:
> > @@ -6246,7 +6247,16 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
> >		}
> >	}
> > +	if (lbp)
> > +		sdeb_meta_write_lock(sip);
> > +
> >	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
> > +	if (unlikely(lbp))
>
> Is this supposed to be called if ret <= 0?
>
> > +		map_region(sip, lba, len);
> > +
> > +	if (lbp)

It does not have to be skipped: SBC-6 4.7.4.6.2 allows a device to map a
deallocated LBA at any time, and resp_write_dt0() and resp_write_scat()
also call map_region() without looking at the result, so I will keep it
unconditional.

Looking at this, I did however find another bug in resp_atomic_write().
While scsi_debug does fail a short WRITE ATOMIC (16) with DID_ERROR,
a short write will currently modify the logical blocks up to the short
write. I will add a fix for this in my series.


Kind regards,
Niklas
