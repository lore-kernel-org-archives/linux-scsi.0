Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F8979C0;
	Wed, 10 Jul 2024 01:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720576183; cv=none; b=ltVb5zuKfjPaU/MgNm3BcyUYUqe8yyDA0njWQkex2KWymHcS/8gpprxaN0hONEGSa8b+LocUxbtrpjQoxz2VEgF6hMOqoixMiQaK76ABYywrowyg+00eHE54SNUdcFf/aiwc2vWJYf6qUzWXMSOPmBg9UKLvMjVWLZT60UYAvEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720576183; c=relaxed/simple;
	bh=hD4LrztM6N9+rwV/yVX+lKNIMz5a4kUkTDbd+sFYw3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qg6eNHbIbmfqufFPd/zV+SHq+M/NTrifkSnIBIhPMna0pA43VbKwnTr2bwkMLOcMNyfCyJsiCKcooNXt5eBMan1G/pX+yRN3f6fozfzdbOm8MiyBAv32/H0LQORh7XMFpnMDHF9AJgjX7VSQ6cVkxsk/L7FwMtMX1YdULa1ojOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NE207wwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NE207wwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7534C3277B;
	Wed, 10 Jul 2024 01:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720576182;
	bh=hD4LrztM6N9+rwV/yVX+lKNIMz5a4kUkTDbd+sFYw3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NE207wwxzpMle/bQPfHJVKud6rOkVPB4B99dxMeAxuothw/TWo6bebO3D1fjk1NqE
	 2FDmsUkmdrpVIVMIS7mpEf9JDfZ5fxGJjlxnumxWGD425CrZv4LBj/VNyebzaXWwZK
	 3fq2SQuf5rGOJKW+JsOwWzEEYVVwAVNefl6ekA+YQ7qP27k16YUrGw3OkK790sKsQj
	 vcv8Y3ASG7gR6+AmphqRUqQ8G1NRtEFk5V9y3FjOJBWRSWYxmXxeIQFvuz+CNj4SVh
	 SiU7+/sIb0scil/g5UHME8ErzegKyJ3MpQ8VI2UhpGkx5SC5QE3oRnol91tkVzAJ1z
	 I9odHWU8vzPpQ==
Date: Wed, 10 Jul 2024 09:49:34 +0800
From: Peter Chen <peter.chen@kernel.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] usb: add missing MODULE_DESCRIPTION() macros
Message-ID: <20240710014934.GA2914204@nchen-desktop>
References: <20240618-md-drivers-usb-v2-1-e9b20a5eb7f9@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618-md-drivers-usb-v2-1-e9b20a5eb7f9@quicinc.com>

On 24-06-18 08:18:26, Jeff Johnson wrote:
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
> ---
> Changes in v2:
> - Updated drivers/usb/core/usb.c description per Alan
> - Link to v1: https://lore.kernel.org/r/20240611-md-drivers-usb-v1-1-8b8d669e8e73@quicinc.com
> ---
>  drivers/usb/chipidea/ci_hdrc_msm.c | 1 +
>  drivers/usb/class/usbtmc.c         | 1 +
>  drivers/usb/core/usb.c             | 1 +
>  drivers/usb/mon/mon_main.c         | 1 +
>  drivers/usb/storage/uas.c          | 1 +
>  5 files changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> index 7b5b47ce8a02..1661639cd2eb 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -303,4 +303,5 @@ module_platform_driver(ci_hdrc_msm_driver);
>  
>  MODULE_ALIAS("platform:msm_hsusb");
>  MODULE_ALIAS("platform:ci13xxx_msm");
> +MODULE_DESCRIPTION("ChipIdea Highspeed Dual Role Controller");

MODULE_DESCRIPTION("MSM ChipIdea Glue Layer Driver");

Peter

>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
> index 311007b1d904..6bd9fe565385 100644
> --- a/drivers/usb/class/usbtmc.c
> +++ b/drivers/usb/class/usbtmc.c
> @@ -2592,4 +2592,5 @@ static struct usb_driver usbtmc_driver = {
>  
>  module_usb_driver(usbtmc_driver);
>  
> +MODULE_DESCRIPTION("USB Test & Measurement class driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index a0c432b14b20..0b4685aad2d5 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -1150,4 +1150,5 @@ static void __exit usb_exit(void)
>  
>  subsys_initcall(usb_init);
>  module_exit(usb_exit);
> +MODULE_DESCRIPTION("USB core host-side support");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
> index 824904abe76f..af852d53aac6 100644
> --- a/drivers/usb/mon/mon_main.c
> +++ b/drivers/usb/mon/mon_main.c
> @@ -419,4 +419,5 @@ static void __exit mon_exit(void)
>  module_init(mon_init);
>  module_exit(mon_exit);
>  
> +MODULE_DESCRIPTION("USB Monitor");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index a48870a87a29..9b8f578eef53 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1280,6 +1280,7 @@ static void __exit uas_exit(void)
>  module_init(uas_init);
>  module_exit(uas_exit);
>  
> +MODULE_DESCRIPTION("USB Attached SCSI driver");
>  MODULE_LICENSE("GPL");
>  MODULE_IMPORT_NS(USB_STORAGE);
>  MODULE_AUTHOR(
> 
> ---
> base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
> change-id: 20240611-md-drivers-usb-86999d57ed16
> 
