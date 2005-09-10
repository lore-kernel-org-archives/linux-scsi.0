From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] aacraid: add name to driver template
Date: Sat, 10 Sep 2005 17:51:39 +0100
Message-ID: <20050910165139.GB3662@infradead.org>
References: <1126212619.7479.22.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52916 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751027AbVIJQvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 12:51:40 -0400
Content-Disposition: inline
In-Reply-To: <1126212619.7479.22.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Thu, Sep 08, 2005 at 01:50:19PM -0700, Mark Haverkamp wrote:
> Received from Mark Salyzyn from Adaptec.
> 
> This permits the system log to report the Adapter's branded name rather than
> the generic 'AAC' that it currently reports.
> 
> Applies to the scsi-misc-2.6 git tree.
> 
> Signed-off-by: Mark Haverkamp <markh@osdl.org>
> 
> 
> Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
> ===================================================================
> --- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:04.000000000 -0700
> +++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:27.000000000 -0700
> @@ -765,6 +765,7 @@
>  	
>  	pci_set_master(pdev);
>  
> +	aac_driver_template.name = aac_drivers[index].name;
>  	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));

this is broken. it overwrites the name every time a host is allocated.
Especially it does this on a live template.  Just implemented ->info

