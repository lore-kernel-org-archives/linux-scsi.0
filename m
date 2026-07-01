Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894BE3769F5;
	Wed,  1 Jul 2026 05:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884292; cv=none; b=HiaOYWWQqW2HTBrkbyTbd1Z/Ko39F+KEQcOftkTrNOCLMl+nq+6ayubvD1gG/V83K5eA3CONgrx6Rz/2MHxO5gWiorlX9tPgvV1V6CvMxKeUA1IwokrEwzz5Vyhtjbo3xQ9WFfweZO2BqJ7rJTzT+BoMhcdUN2bQH0bLZ7LGymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884292; c=relaxed/simple;
	bh=t/54wodLlY7zP0o7pRRAS+rsThTFYzQVaWiOWvz5/pU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLdXY/+nQtOCTlDkD6J2Sh9K9J05s9SMuiggH446010OY9weGAoRqQ4x5IogFdCwcIAnPj4nC8EU9cOkxUcOwy2o7/vre2I9poB+OR/Lg/Xn2mgMhQh1uAr/oLu5JyrXIveYFtLIGSyIND7Izoz4q9KEGuMgXJP2hh8w+8IPdos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOKhgblf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOKhgblf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F31F000E9;
	Wed,  1 Jul 2026 05:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782884291;
	bh=mLb29AuIKiC5pol896XGHQcGodvYsdE59KxrfLut2YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOKhgblfAfgEs+8A2xJmTi8sat/eIyerDVnlgVxBqv7C54ykqzp5zo+QB9CrTFOQj
	 dYu7jHqM9Wvikr9W0V1Up+BRV2xRBdJuKWIdgkVdZGSxFeLTEpAJJJbYvQYGKrRpYO
	 GVo74+JnTUfIU7PxQfAdBLUod8usNb5f98eh5hYI=
Date: Wed, 1 Jul 2026 07:38:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
Subject: Re: [RFC PATCH] usb: storage: uas: limit consecutive device resets
 in error handling
Message-ID: <2026070157-stench-shabby-2519@gregkh>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701040335.810297-1-senozhatsky@chromium.org>

On Wed, Jul 01, 2026 at 01:03:21PM +0900, Sergey Senozhatsky wrote:
> When a UAS storage device experiences persistent wire or hardware IO
> failures, commands time out and the SCSI error handler thread invokes
> uas_eh_device_reset_handler().  If usb_reset_device() succeeds at the
> USB hub level but the underlying drive remains unresponsive, the reset
> handler returns SUCCESS. SCSI EH then requeues pending commands with
> DID_RESET (ACTION_RETRY), causing them to time out again 30 seconds
> later in an infinite loop.  This blocks block layer queues indefinitely:
> 
> [..]
>  sd 0:0:0:0: [sda] tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
>  sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
>  sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
>  sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
>  scsi host0: uas_eh_device_reset_handler start
>  usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
>  scsi host0: uas_eh_device_reset_handler success
>  sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
>  sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
>  scsi host0: uas_eh_device_reset_handler start
>  sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 1 inflight: CMD
>  sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
>  sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 2 inflight: CMD
>  sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
>  usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
>  scsi host0: uas_eh_device_reset_handler success
> [..]
> 
> Introduce a runtime-configurable module parameter 'reset_limit' (default
> 3) and track consecutive resets in devinfo->reset_cnt.  When a productive
> block layer command completes successfully (SUBMITTED_BY_BLOCK_LAYER),
> reset the counter to zero.  If consecutive resets exceed reset_limit,
> abort the loop by completing pending commands with DID_NO_CONNECT and
> returning FAILED.  This allows SCSI EH to offline the unresponsive
> device.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/usb/storage/uas.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 265162981269..a63c66c8bbad 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -32,6 +32,10 @@
>  
>  #define MAX_CMNDS 256
>  
> +static int uas_reset_limit = 3;
> +module_param_named(reset_limit, uas_reset_limit, int, 0644);
> +MODULE_PARM_DESC(reset_limit, "Maximum number of consecutive device resets during error handling before failing");

This is not the 1990's, we do not add module parameters for issues that
should be properly solved either automatically, or on a per-device
basis.

There's no way that ChromeOs wants to attempt to track this module
parameter as a bootline config option, right?

thanks,

greg k-h
