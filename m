Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92422BE7BA;
	Mon, 11 Aug 2025 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911250; cv=none; b=H1TVsyIWQp7jJnxA0jIwkw3mOocErA2gGbRxEbxEZenxujXshguqZ+evqH1JiJsbZnJVf1O6gHmEg1tPdDv1KqagA7pa8f4INK1dBPbsKVj2rJZa236tbiAoRw3crzmPLZ+VpcEmAa83oIS4OBw+aB1yuaJOqrt55CBgQ2NShMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911250; c=relaxed/simple;
	bh=pBbxrF/v4p+dPGARecY4kudNE5BRKDJf4leCspsoL70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A38kfp/t3b3XNlPLtoA1ua3TUbSe90ntliVPpbu+0RCyKPP2fkJTQYmDDpv97975zQ8RqNHTqsSCepRzsg1zdJTOVyNwA8+xvL6NTO2VJMrZmIXC2NuQZl00VVkMPX3X8myp3eQ9Y4c0WnNk5SKuzaR4XHL/4HMV5MScpjdygeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+XqGTl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+XqGTl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB942C4CEED;
	Mon, 11 Aug 2025 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754911250;
	bh=pBbxrF/v4p+dPGARecY4kudNE5BRKDJf4leCspsoL70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A+XqGTl7tBrIfAFiVBnLA1HwIWXtrucrrkz2iFzHTo+6GWeFwdOzWsZUC4qU2ac+t
	 hu6Sf+sJsRlyUZS7E4dP3zQ3joNEM6z2FROM49wTE0VB1e4dxMkvmnblX4PiUeJ+Ip
	 U+Bw7B1upueQcdILjC/mAoZ/05Gur1IoHIsdUjts=
Date: Mon, 11 Aug 2025 13:20:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Shivani Agarwal <shivani.agarwal@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com, linux-scsi@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>, Viswas G <Viswas.G@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ajish Koshy <Ajish.Koshy@microchip.com>,
	Jack Wang <jinpu.wang@ionos.com>, stable@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Tapas Kundu <tapas.kundu@broadcom.com>
Subject: Re: [PATCH v5.10] scsi: pm80xx: Fix memory leak during rmmod
Message-ID: <2025081141-voltage-tribesman-350d@gregkh>
References: <20250811052035.145021-1-shivani.agarwal@broadcom.com>
 <7c7aedbf-389d-4e5a-83d0-33c51cda1d8a@web.de>
 <CANTE3ihiPx2GZDcUWcO-YR8h-tNrsCtJ=jH7Kzd08Y8qDxZk9A@mail.gmail.com>
 <7010c6e0-009c-49d7-9621-b20ff5122602@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7010c6e0-009c-49d7-9621-b20ff5122602@web.de>

On Mon, Aug 11, 2025 at 12:50:24PM +0200, Markus Elfring wrote:
> >> May curly brackets be omitted here?
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.16#n197
> > 
> > Thanks, Markus. I agree with you and have no objection. However, for
> > the stable branches, we usually keep the patches unchanged.
> 
> I am unsure how many source code adjustments would be supported
> also according to coding style concerns.
> 
> 
> > I think it would be good to remove these curly braces in the Linux
> > master branch as well. Should I go ahead and submit a patch for the
> > master branch too?
> 
> Corresponding refinements would be nice.
> https://elixir.bootlin.com/linux/v6.16/source/drivers/scsi/pm8001/pm8001_init.c#L1311-L1316


Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
