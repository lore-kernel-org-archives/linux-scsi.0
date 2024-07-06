Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F923BE;
	Sat,  6 Jul 2024 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720269412; cv=none; b=nCEgxN3LCvWhbFkc1p8+G7s2l5+HpGDqPAvB0maJ6cAiECTgFiJpUf8vwRwQ1h9wnlT/WgTTBbg2hQpkFVXZoA77ehF2CvFQ0gIOlEo0bwJqm0Xvc9ni32B0z5tFYUNyE06Ryk7p/tASB9QYsqu/LcqWHIbAPnZUQ3ze+7/8V+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720269412; c=relaxed/simple;
	bh=lxra33GzXUDZrV4YFPw6xGWJtMtZEXzprX662gKlxKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USphTaxGttG9VWV0Bvvp9AULYn7KUGlqoHBG3ZOb0Bc2zeNrEdmn9no0FaWmJtgPuC75VwlICjhwur2/NulH8ta2qkZ7tLePa8JO66AcQuW/yxPopIMr6hPk8YxC+wW4loi78Ur4W7BPfle8j405VzBKB0kJBUUiDn67NnawHOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6mHXN/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6mHXN/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E753CC2BD10;
	Sat,  6 Jul 2024 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720269412;
	bh=lxra33GzXUDZrV4YFPw6xGWJtMtZEXzprX662gKlxKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E6mHXN/tWSyNaaVN4pIwuNQLV65SA0Txuwn/0ThSxm1pECwIWAn9cC9T5/GV/Xvsv
	 kdLx9FcZDMP+4BeGXPzkWcVKwrVwBCPhHilyp4CkHjYZg5ytmmIvVJpt82R3zg++VF
	 WJu+nuNQLl5VZdttrUNs5s0wFFviUgokqiuxny5Q=
Date: Sat, 6 Jul 2024 14:36:44 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "oneukum@suse.com" <oneukum@suse.com>,
	"stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
	Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Message-ID: <2024070612-squealer-wackiness-c885@gregkh>
References: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
 <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>

On Sat, Jul 06, 2024 at 12:03:23PM +0000, Aditya Garg wrote:
> From: Kerem Karabay <kekrby@gmail.com>
> 
> Currently there is no standardized method for USB drivers to handle
> shutdown events. This patch simplifies running code on shutdown for USB
> devices by adding a shutdown callback to usb_driver.
> 
> Signed-off-by: Kerem Karabay <kekrby@gmail.com>

Where did Kerem do this work?  Any reason why they aren't submitting
these themselves?  Not that this is a problem, just trying to figure out
what went wrong with the development process here.

thanks,

greg k-h
