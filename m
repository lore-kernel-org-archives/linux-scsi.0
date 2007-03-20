From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular
	SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 14:11:07 -0500
Message-ID: <1174417867.3522.35.camel@mulgrave.il.steeleye.com>
References: <20070320185632.GB22866@dmccrory-d810.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48942 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934029AbXCTTLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 15:11:17 -0400
In-Reply-To: <20070320185632.GB22866@dmccrory-d810.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2007-03-20 at 11:56 -0700, Andrew Vasquez wrote:
> Commit 840c2835a1c867281d27158378a9d34f593a7664 ([SCSI] make
> scsi_wait_scan always modular) broke configurations where
> SCSI_SCAN_ASYNC is selected for non-modular builds.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index f3bc0f4..eb25abe 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -226,6 +226,7 @@ config SCSI_LOGGING
>  config SCSI_SCAN_ASYNC
>  	bool "Asynchronous SCSI scanning"
>  	depends on SCSI
> +	select SCSI_WAIT_SCAN

This can't really be right.  Async scan is always compiled in, so the
module is always required ... this parameter just determines what the
boot time default is, but it can be overridden by the kernel command
line.

What's the actual problem you're trying to fix?

James


