Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC740845;
	Wed, 20 Mar 2024 11:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710933407; cv=none; b=rRQ5Hh0PSOT/bdNZSunkxCHFsmM2rjWHR2awBd0vm+idF9ZB1MAWkgNTfJ4HbeKMDIKgOSGJpZt8G81ayIdZNUdtCf1bQrAmOXieBtLBn8EEi3JzD4TO7tWKhfWKvDJzt0XcMOlK1oBDsNE6z2mtNWKZHDhr2FhfJr/5Q9U1tcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710933407; c=relaxed/simple;
	bh=OuMJXMCcdPs8LS2hgN1qyNdI1UCukP/OplYUzFGoB5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkSI2L8BC7Rs/UFCsFWr1l3CWOL2S0jVu0gWw6allL48WSQ9pSt6jgK0dzo/kK4+i6wkcPdJoUNmutiMtbgvXg+AFopWrOC8UUVc4WyLiaek7G1ZfF4uWW7crE9KbVsiwmlt/rA6t0RqTNiPtdqsrD02bv43gieTyKskhZy/kpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rgy7sqpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rgy7sqpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08096C433C7;
	Wed, 20 Mar 2024 11:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1710933406;
	bh=OuMJXMCcdPs8LS2hgN1qyNdI1UCukP/OplYUzFGoB5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rgy7sqpi7oQEgrgtrTMk3wAn95XPg/HIlRFpGVOwYX5g3AL6txa5bMZh9jN5novJK
	 RbFEI5za5QTX6JDR85DjvF+SxFff6yMEqWIRSOui5YjW5t8BdYIlj237dVXdCyVow0
	 m1GZCSLPVIUILr5p9RnJKi91gEFknZv6hJWnIHok=
Date: Wed, 20 Mar 2024 12:16:43 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Wetzel <Alexander@wetzel-home.de>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sg: Avoid sg device teardown race
Message-ID: <2024032031-duller-surgical-c543@gregkh>
References: <20240318175021.22739-1-Alexander@wetzel-home.de>
 <20240320110809.12901-1-Alexander@wetzel-home.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320110809.12901-1-Alexander@wetzel-home.de>

On Wed, Mar 20, 2024 at 12:08:09PM +0100, Alexander Wetzel wrote:
> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
> calling scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi device request_queue.
> Which will already be set to NULL when the preceding call to
> scsi_device_put() removed the last reference to the parent scsi device.
> 
> The resulting NULL pointer exception will then crash the kernel.
> 
> Link: https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
> ---
> Changes compared to V1:
> Reworked the commit message

What commit id does this fix?

thanks,

greg k-h
