From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.5 scsi-misc-2.5 remove scsi_host_hn_list
Date: Wed, 13 Nov 2002 00:25:30 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021113002530.A684@infradead.org>
References: <20021112104759.A21739@eng2.beaverton.ibm.com> <20021112122431.A23657@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021112122431.A23657@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Nov 12, 2002 at 12:24:31PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

> +MODULE_PARM(scsihosts, "s");
> +MODULE_PARM_DESC(scsihosts, "scsihosts=driver1,driver2,driver3");
> +#ifndef MODULE
> +int __init scsi_setup(char *str)
> +{
> +	scsihosts = str;
> +	return 1;
> +}
> +
> +__setup("scsihosts=", scsi_setup);
> +#endif

With rusty's new module loader this is probably obsolete :P

> -void __exit scsi_host_hn_release()
> +void __init scsi_host_hn_init(void)

What about calling this scsi_host_init()?  That way we can stuff in any
other initialization private to hosts.c if needed without having a
misleading name.

Otherwise the patch looks really nice.

