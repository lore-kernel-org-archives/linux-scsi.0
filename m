From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ufs: select CONFIG_NLS
Date: Tue, 22 Mar 2016 07:43:19 -0400
Message-ID: <1458646999.2408.3.camel@linux.vnet.ibm.com>
References: <1458217819-2802119-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:37703 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbcCVLn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 07:43:29 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Tue, 22 Mar 2016 05:43:27 -0600
In-Reply-To: <1458217819-2802119-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2016-03-17 at 13:29 +0100, Arnd Bergmann wrote:
> A recent change to ufshcd introduced a call to utf16s_to_utf8s,
> a function that is provided by the NLS module, so we get a link
> error when that is not present:
> 
> drivers/scsi/built-in.o: In function `ufshcd_read_string_desc':
> :(.text+0x124d0): undefined reference to `utf16s_to_utf8s'
> 
> This adds a Kconfig 'select' statement to avoid the build error.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: b573d484e4ff ("scsi: ufs: add support to read device and
> string descriptors")
> ---
>  drivers/scsi/ufs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 5f4530744e0a..097894a1fab5 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -37,6 +37,7 @@ config SCSI_UFSHCD
>  	depends on SCSI && SCSI_DMA
>  	select PM_DEVFREQ
>  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
> +	select NLS

This looks like a bad solution: CONFIG_NLS is nothing more than a menu
selector for the NLS subsystem.  The problem is that selecting it will
allow a kernel to be build with NLS and without NLS_DEFAULT which is
going to cause all sorts of interesting problems on boot.  I think you
really mean depends on NLS here.

James


