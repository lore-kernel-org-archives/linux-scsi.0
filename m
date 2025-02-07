Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAC2238D29;
	Fri,  7 Feb 2025 15:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738941002; cv=none; b=S6B68K72EM04gCvcKSaIB3IIj3/l0kLafv2P24jsKnmwZQSbbzZR7tkNeyOjXvD6lvGhwDXaEVn3CAFPaZZ45Gi8yZNXS1kkTG6tB8sOjX3tfgJemS855l6/uRRmOZgOzcVGpHKeE/YLLV/as5X2vliGnLqHnhXCLPWrAwMRxlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738941002; c=relaxed/simple;
	bh=/6ag9Z18UPkK2iecfBhx20hHyPdWHRNmV7uzzAfaVG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERwQMOsfGvDN0ETbEFhm+5n0x5r8AD8on58L416uNJEg5M0ZaszeMnfXVgBptMiZF68GvqWK7SqI36TLXW30BwzLgmcPwz5ETXP8K2ObztJLnT8PZC4HU/4S9LA3dIhBnFvmKwJFVLjATb8j/BXSvMFaCX9fZFSvcQUEbVT6h9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/y053Qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/y053Qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD753C4CED1;
	Fri,  7 Feb 2025 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738941001;
	bh=/6ag9Z18UPkK2iecfBhx20hHyPdWHRNmV7uzzAfaVG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z/y053QhZxE4EcBYvoSc0yCsavOKSNaN+/Net2TzY31XlLhyvM+hcLoT1FhH7WPnN
	 U1URH9Apue433WDhPLoKxptgtH++v/VIIHH1vnQEiOP0R90lnY7P6LrhQ6RB/2da+1
	 wR4CrZyqNFOV5/AlFdfC9t9lnqAymM91DOXuiE/A=
Date: Fri, 7 Feb 2025 16:09:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, arun.easi@cavium.com,
	bvanassche@acm.org, jhasan@marvell.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com, markus.elfring@web.de,
	martin.petersen@oracle.com, nilesh.javali@cavium.com,
	skashyap@marvell.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Message-ID: <2025020721-silver-uneasy-5565@gregkh>
References: <2025020658-backlog-riot-5faf@gregkh>
 <20250206192000.17827-1-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206192000.17827-1-jiashengjiangcool@gmail.com>

On Thu, Feb 06, 2025 at 07:19:59PM +0000, Jiasheng Jiang wrote:
> Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> used/freed.

"Potentially" being freed.  It will not be used.  And this is only for
an error path that obviously no one has hit before.

Please explain this much better.

thanks,

greg k-h
