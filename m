From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization issue fix
Date: Fri, 23 Jun 2006 23:55:53 -0700
Message-ID: <20060623235553.2892f21a.akpm@osdl.org>
References: <20060623210121.GA18384@in.ibm.com>
	<20060623210424.GB18384@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:13797 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932916AbWFXG4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jun 2006 02:56:00 -0400
In-Reply-To: <20060623210424.GB18384@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: linux-kernel@vger.kernel.org, fastboot@lists.osdl.org, linux-scsi@vger.kernel.org, ebiederm@xmission.com, mike.miller@hp.com

On Fri, 23 Jun 2006 17:04:24 -0400
Vivek Goyal <vgoyal@in.ibm.com> wrote:

> 
> o cciss driver initialization fails and hits BUG() if underlying device
>   was active during the driver initialization. Device might be active
>   if previous kernel crashed and this kernel is booting after that using
>   kdump.
> 
>
> ...
>
> o If crash_boot parameter is set, then ignore the completed command messages
>   sent by device which have not been issued in the context of this kernel.
> 
> Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
> ---
> 
>  linux-2.6.17-1M-vivek/drivers/block/cciss.c |    7 +++++++
>  1 files changed, 7 insertions(+)
> 
> diff -puN drivers/block/cciss.c~cciss-initialization-issue-over-kdump-fix drivers/block/cciss.c
> --- linux-2.6.17-1M/drivers/block/cciss.c~cciss-initialization-issue-over-kdump-fix	2006-06-23 14:04:55.000000000 -0400
> +++ linux-2.6.17-1M-vivek/drivers/block/cciss.c	2006-06-23 14:08:12.000000000 -0400
> @@ -1976,6 +1976,13 @@ static int add_sendcmd_reject(__u8 cmd, 
>  			ctlr, complete);
>  		/* not much we can do. */
>  #ifdef CONFIG_CISS_SCSI_TAPE
> +		/* We might get notification of completion of commands
> +		 * which we never issued in this kernel if this boot is
> +		 * taking place after previous kernel's crash. Simply
> +		 * ignore the commands in this case.
> +		 */
> +		if (crash_boot)
> +			return 0;
>  		return 1;

Looks like this is working around a driver problem rather than fixing it
properly ;)

