From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] remove MULTI_LUN config option
Date: Wed, 3 Sep 2003 14:21:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030903142117.A5715@beaverton.ibm.com>
References: <20030902021145.GC1941@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:8383 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261271AbTICVVg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2003 17:21:36 -0400
Content-Disposition: inline
In-Reply-To: <20030902021145.GC1941@krispykreme>; from anton@samba.org on Tue, Sep 02, 2003 at 12:11:45PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: linux-scsi@vger.kernel.org

Anton -

On Tue, Sep 02, 2003 at 12:11:45PM +1000, Anton Blanchard wrote:

> Hi,
> 
> We already have a module_param to limit how many LUNs we scan, so I
> think we can remove the config option. It means one less config option
> to worry about.
> 
> Anton
> 

> diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	Tue Sep  2 10:20:06 2003
> +++ b/drivers/scsi/scsi_scan.c	Tue Sep  2 10:20:06 2003
> @@ -68,11 +68,7 @@
>  
>  #define MAX_SCSI_LUNS	512
>  
> -#ifdef CONFIG_SCSI_MULTI_LUN
>  static unsigned int max_scsi_luns = MAX_SCSI_LUNS;
> -#else
> -static unsigned int max_scsi_luns = 1;
> -#endif

The above defaulted to 1 because there are broken devices (unknown what
vendors and models) that hang when anything other than LUN 0 is probed.
Defaulting to 1 means such systems might no longer boot.

There was a post from Alan (or Doug L?)  about this some time back.

-- Patrick Mansfield
