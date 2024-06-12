Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 65B2628366
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718216178; cv=none; b=U0ITRfe4m4eK0FIOxc3z/RtxM5MVxy9McunoMGmSaHHQKr3SgKf+InFcCKFhfzwyyNh10/iyj9yT59TEe2jh1AyUImzPciZfUrh6/qC3SrqGnPqmG9iiTKB0gIHbZ0SSvvVB7ag7BfNAgMD64XFjTNQNhrRAGE9VlFgcHy+0FII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718216178; c=relaxed/simple;
	bh=Fegv2307vxylDdMBcSU8WOxyIWy1vn+xS4tfkkD5nVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK5MCBANY2o7+nuA71oYLHX/jtwFg+q6totgRnOn3rJV8uBMzsip9j47WBZFafUHVKX4cNPxNDvoKyaPfrXxWGP9TbGgU3c2tgO5G1RnlTKfnB2pZ33QeH/JUzA4aaYRgfdelVNosON+AB8jfFbOsI5Y8TaOxzjCabavn2V6i+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 232816 invoked by uid 1000); 12 Jun 2024 14:16:15 -0400
Date: Wed, 12 Jun 2024 14:16:15 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Peter Chen <peter.chen@kernel.org>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
  linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
  usb-storage@lists.one-eyed-alien.net, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: add missing MODULE_DESCRIPTION() macros
Message-ID: <183a4d6a-30ad-4dce-b54d-3624aba36ac9@rowland.harvard.edu>
References: <20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com>

On Tue, Jun 11, 2024 at 07:37:20PM -0700, Jeff Johnson wrote:
> With ARCH=x86, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/core/usbcore.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/mon/usbmon.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/class/usbtmc.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/storage/uas.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/usb/chipidea/ci_hdrc_msm.o
> 
> Add the missing invocations of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
> This is the remaining one-off fixes in usb.
> 
> Corrections to these descriptions are welcomed. I'm not an expert in
> this code so in most cases I've taken these descriptions directly from
> code comments, Kconfig descriptions, or git logs.  History has shown
> that in some cases these are originally wrong due to cut-n-paste
> errors, and in other cases the drivers have evolved such that the
> original information is no longer accurate.
> 
> Let me know if any of these changes need to be segregated into
> separate patches to go through different maintainer trees.

> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index a0c432b14b20..65f9940bc7e8 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -1150,4 +1150,5 @@ static void __exit usb_exit(void)
>  
>  subsys_initcall(usb_init);
>  module_exit(usb_exit);
> +MODULE_DESCRIPTION("USB support library");
>  MODULE_LICENSE("GPL");

I would change this to "USB core host-side support", or something more 
along those lines.  It's not just a library because it does include 
several drivers (such as the USB hub driver).  And it's host-side rather 
than device-side -- that's a separate module.

Alan Stern
