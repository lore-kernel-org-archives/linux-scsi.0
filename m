Received: from mail.he1.boomer41.net (mail.he1.boomer41.net [178.63.148.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC521A3160
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 20:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.148.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771014545; cv=none; b=s4ZrqyIugljoLhNh+gNl+UjmEtThPfNAzNgT94gqsI/NS8tds1WsibKELUq5rU52RngdU7sKxqvsVElBtROxpVnSBG+m+noa4PbH73SIW/d2yjmDqyEjhCEryl33WRQZV2ZCR6VpJrXW5xof+5oA4Bju7HApGq/pCQccVy1qW+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771014545; c=relaxed/simple;
	bh=/FE3/9yOICUiQ1S12sgiSZGbkhRYK+UZVR5kSe22ZMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CymaTq+cqdtrzAe7C6DU5poHf4cQ5vQ6t770bQT5LTIukKLcQyNM262FImWiLQBh1x3tqYq+T7+1oq6/wD1gfv3080xqRM7662gQzaNf3VasuVH1ax1RbsquC2qnFH85XOKEwTgruxSyRtNj/RyLNdHm0WCs31kOXkfAJmEY0XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net; spf=pass smtp.mailfrom=stephan-brunner.net; dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b=LqGw5lch; arc=none smtp.client-ip=178.63.148.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b="LqGw5lch"
Date: Fri, 13 Feb 2026 21:29:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stephan-brunner.net;
	s=mail; t=1771014542;
	bh=/FE3/9yOICUiQ1S12sgiSZGbkhRYK+UZVR5kSe22ZMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LqGw5lchnL+y+n4t8hn+H+4GfgfiWZO/0Rj43CP1cNN1xxhc1DMfI3ldq6gZz/YxY
	 v6+byOj5e0+2lKwe9nanAqFlugXRwXi6G/rR4UmHDi+oRZgHexVgF48d1NKaFn4QYw
	 Hy21BHB3bFffsNvkaCKklXM1cLkXiRGrPaIO7vWXbSsOejCurdNOiN0zJDejPUsOSm
	 RBcN9yWbgHC+icOwuw6FDXIXBz++Q3XqPiRZhBqvujL3OyR7n5tPUCF7FpyiDrgC5F
	 2K/SaYf3kuW4SBF2Ni5b18yBZQkJgH6JDDwML62kqbRE6wNETVKa3eTn/Wb4tvrTFk
	 1EPzyDI/G5AMquKKeRcqGnbWLA0Bs7fIFhGspmjx1tiqPCVk3Dwa2SgRIF4y8dtp7D
	 O4EDr1B3vd/xI0wRNj/+qV/DquAIFJN6qJP6HkoqqKLcmgGoMTqEf6R+bb+IOnMr3T
	 xRjAQejOHV02ggziNi93P5Y4A5FudpNeczpVL5jwa+L7EYUVjzH/Ad/d1xSgvDguWz
	 ViKMZmi3AdcL0EP503CmsZdo9ZXoc8XP/J2ynQuMB+G/BQzTxB0afH0sfzvkXS9VO5
	 eE/GN2U4sm9SU6bxv/zTINJVunDbuFrwfcOiveNvLzDQE/A+CwJ9lfpI23vxHR/9UT
	 aOJQDLEJBFfHox/qt1361ZEU=
From: Stephan Brunner <s.brunner@stephan-brunner.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi: Log spin up retries as standalone messages
 instead of continuations
Message-ID: <aY-Jjr5UYIMwrAIY@stephan-brunner.net>
References: <ea0a0facf69c1b3029292897d4b8cf90cab0d0aa.1771012198.git.s.brunner@stephan-brunner.net>
 <cf29eaeec0557ea2c3800746d1b34a74c56337d8.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf29eaeec0557ea2c3800746d1b34a74c56337d8.camel@HansenPartnership.com>

(resent because I forgot to include CCs, sorry)

On Fri, Feb 13, 2026 at 12:06:20PM -0800, James Bottomley wrote:
> So that might be the place to investigate.  However, in reality
> KERN_CONT is always going to be a bit of a mess because other printk
> messages can cut across it (which is what might be happening above).

It's not that I'm seeing these messages on a busy system.

I'm running on my normal notebook with a chinesium USB to SATA dongle
thingy. I only "hot-plug" a Samsung 870 EVO. Interestingly enough,
only one needs to "spin up", the second 870 doesn't log anything about
spinning up at all.

The logs are, in fact, complete. There were no other printks happening
in the middle there. This happened on 6.18.9, with the Arch Linux kernel
(completely vanilla kernel). They really appeared like this in dmesg.

I'll test again on mainline to see if the dmesg continuation bug still
happens.

> The reason for the compact messages is complaints from the array/JBOD
> people about just how much message spew they get in the 1,000 disk
> case.  Admittedly they've all likely moved on long ago to SSDs, so
> perhaps the legacy spinning rust use case doesn't occur at that scale
> any more, but I think we'd like to see that looked into before making
> the messages way more verbose.

See above, my chinesium USB SATA dongle thingy does "spin up" for one
Samsung 870, while the other one does not do it?!

I'm unfortunately too little into the SCSI subsystem or SCSI itself to
actually know what's going on. Always thought this was a legacy quirk.

As for the spammyness of verbose messages: Makes sense.

--
Stephan
