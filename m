From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/3] megaraid : use dev_printk when possible
Date: Mon, 01 Jun 2015 09:10:24 -0700
Message-ID: <1433175024.4861.11.camel@perches.com>
References: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	 <20150601154003.23309.70647.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150601154003.23309.70647.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-06-01 at 10:40 -0500, Bjorn Helgaas wrote:
> Use dev_printk() when possible to make messages more useful.
[]
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
[]
> @@ -268,7 +268,7 @@ mega_query_adapter(adapter_t *adapter)
>  		raw_mbox[2] = NC_SUBOP_PRODUCT_INFO;	/* i.e. 0x0E */
>  
>  		if ((retval = issue_scb_block(adapter, raw_mbox)))
> -			printk(KERN_WARNING
> +			dev_warn(&adapter->dev->dev,
>  			"megaraid: Product_info cmd failed with error: %d\n",
>  				retval);

Wouldn't these be a bit redundant with a "megaraid: " prefix now?
Perhaps it'd be nicer to realign arguments too.
