From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] g_NCR5380: Stop using scsi_module.c
Date: Sun, 25 Sep 2016 16:50:23 -0700
Message-ID: <20160925235023.GC7312@infradead.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
 <1474743545-4731-4-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474743545-4731-4-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
> +{
> +	struct Scsi_Host *sh = NULL;
> +
> +	sh = generic_NCR5380_hw_init(&driver_template, pdev, base[ndev],
> +				     irq[ndev], card[ndev]);
> +	if (!sh && base[ndev])
> +		printk(KERN_WARNING "Card not found at address 0x%03x\n",
> +				base[ndev]);
> +	if (!sh)
> +		return 0;
>  
> +	dev_set_drvdata(pdev, sh);

Any reason not to move the dev_set_drvdata into generic_NCR5380_hw_init?
That would also allow to properly propagate the error down to the
caller, which would be useful for the PNP case.

Otherwise this look great to me.
