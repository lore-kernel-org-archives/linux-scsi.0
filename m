Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D62E36ED;
	Wed, 23 Jul 2025 20:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753303626; cv=none; b=upolhwJzD5JN9N+OGtRfUmWtLZTKcNmUiPbXT68sjZ5rRRZcN7Z0hVvRUyLVZ7Fe3o0V6YhS0BLQBQj1IxqUD3NjdTfDW6s2m0aeOwbhNuQy2q6gENvPloPAAdxc37QgHxTLXE5NDJV5Jvoux53zkKz2thWNIYEbcTNAfFPHZnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753303626; c=relaxed/simple;
	bh=OjUPhi+LcJyuofMTWpELs4PhGSyOThB/fLEGJqrhy+c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=M3vLNHeBm/s4jHFRluDzKKYCTwtx31XyTHUQCwkMDZW0npUBXHabo56UDVPNt/1Sz1l+c15ev4QMAllApe2ZkfiR1rSff14hKhGJ9CV7wlYrsJnMPDbsZqiyOIeyyYG2zZptBFmLC9otvdXqJwrePSkrBpXlL3lf+ygQ705xSlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d71pD1Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d71pD1Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B930C4CEE7;
	Wed, 23 Jul 2025 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753303625;
	bh=OjUPhi+LcJyuofMTWpELs4PhGSyOThB/fLEGJqrhy+c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=d71pD1Nn9qnsTAiGDi5j1+ES8SrmLX3zT/qto1UDuHDeTL+QD0tpYGyuRdW5TW0m8
	 6HC3pq9mv110ddX557yHuEQw2+pD7vLWSMQYjqDOPUyYtL/EH21G6VERX7U0XulYgH
	 42pbQq7+63XU9jfTW99TtxtLpnXrYpT+qX2hfDzYkFjW7aLH3WEgODmNDGxCKiMwga
	 9LXnH5VKsZIUdoDtlSYSjDO/73GP/M94/wKD6cqc9rj+zmJrLF9qrIZSo47EGnCta+
	 tiSzS8F/b20xpPXA1I4R+l3Tw/a8ucx9B4BKN4mRi2RvOHFXEu9hrkxzlvf8HyPKML
	 2eYqbFaCq4rSA==
Date: Wed, 23 Jul 2025 15:47:04 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] scsi: Fix typos
Message-ID: <20250723204704.GA2910768@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c116cf4fbe4ba7515d265dd3a1a272dcfecccb1.camel@HansenPartnership.com>

On Wed, Jul 23, 2025 at 04:39:14PM -0400, James Bottomley wrote:
> On Wed, 2025-07-23 at 15:26 -0500, Bjorn Helgaas wrote:
> ...

> >  			 * Device's PID has changed. We need to
> > cleanup
> >  			 * and re-login. If there is another device
> > with
> > -			 * the the newly discovered pid, send an scn
> > notice
> > -			 * so that its new pid can be discovered.
> > +			 * the newly discovered PID, send an scn
> > notice
> > +			 * so that its new PID can be discovered.
> >  			 */
> 
> so pid was inconsistently capitalised in a comment, but now scn looks
> like it should be capitalised as well, so I think we can live with the
> inconsistency rather than have tonnes of patches trying to capitalise
> all the TLAs.

The motivator for this particular hunk was the doubled "the":
s/the the/the/

It looks like this comment is the only place in the file "PID" was
capitalized, so I probably should have left it or lowercased just that
one.

> I could go on, but I'm not sure it's worth the time.

No problem, I'll ignore drivers/scsi.

Bjorn
