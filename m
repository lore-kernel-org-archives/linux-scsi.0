Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F8E5223;
	Sat,  6 Jul 2024 09:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720256543; cv=none; b=aL8eCZnYzurXV8xYjMU5QMPhAMyrGrrg5Nkj8CQGb4S1cXzpeIhg1BPgjwA4OwC3B9pYnFc9Ten2pVyTCP3rfKnFC8l9pnNDL4ggbOGyvcYk+5Eb5hcbhA+bHDauWyYrG8MXT6qdC7V3GmbWCY6X+011FPlVMU1egh2O1D5nNXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720256543; c=relaxed/simple;
	bh=xaOwYE0kWCuzWKljtJQTKtbuEDyxjJnNFk/qGda5DhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMF/BTDdtRIu1BCqzk5Hcs7RzujNSDmiDznb/8fQuHL7aFUYBinEtveebqvWYUZJZFcvKIcNOkwx7w6Pnh2nDqpLZb6k9b35/z4cRSNK1rYGf0jUnuVCLaRzmkh/gXWWnLyCc7xFOGqcERi5iz5PLWmS7MVDqzNmGbTPXhLBOG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RITWw7jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RITWw7jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0138C2BD10;
	Sat,  6 Jul 2024 09:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720256542;
	bh=xaOwYE0kWCuzWKljtJQTKtbuEDyxjJnNFk/qGda5DhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RITWw7jX3y0OeYsKUEgQnEWRNZ+LDgHCbgkyMTJtoeOcKr7SBaacF8QW9B+/uBKi2
	 wmTa4+d/BMMUvNJheEiMNW20j5mqkTLMxWrMPsqok6zipLqjIUgcSNOE8RuzR405Av
	 IM8XssF105YOe6rH8mpJtwcCoGnJUnJETfyNWoPQ=
Date: Sat, 6 Jul 2024 11:02:18 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "oneukum@suse.com" <oneukum@suse.com>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>,
	Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>
Subject: Re: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Message-ID: <2024070622-alarm-kissable-f446@gregkh>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
 <2024070649-nuzzle-movable-f383@gregkh>
 <C5231A8D-C529-4BAC-9E2D-32F00321A294@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C5231A8D-C529-4BAC-9E2D-32F00321A294@live.com>

On Sat, Jul 06, 2024 at 08:56:05AM +0000, Aditya Garg wrote:
> 
> Hi Greg
> 
> > On 6 Jul 2024, at 1:43 PM, gregkh@linuxfoundation.org wrote:
> > 
> > On Fri, Jul 05, 2024 at 11:21:06AM +0000, Aditya Garg wrote:
> >> From: Kerem Karabay <kekrby@gmail.com>
> >> 
> >> This simplifies running code on shutdown for USB drivers.
> >> 
> > 
> > Sorry, but this does not explain why this is needed at all :(
> > 
> > Where did this change come from?  What problem does it solve?  Why
> > should we take it?
> > 
> 
> Currently there is no standardized method for USB drivers to handle
> shutdown events. This patch simplifies running code on shutdown for USB
> devices by adding a shutdown callback to usb_driver. It also implements the
> new method to existing "USB Attached SCSI” driver that required shutdown
> 
> Is this good enough?

It's a good start, yes.

But as you say "also" that means you should split this up into at least
2 changes, right?

> > I think I know the answers to these questions, but you need to document
> > it here as to why it is needed (please read the kernel documentation for
> > how to write a good changelog text and subject line.)
> 
> The subject looks fine to me. If you think it can be improved, suggestions shall be appreciated.

When you split the patch up, the subject lines will get better.

thanks,

greg k-h
