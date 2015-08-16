From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [patch] cxlflash: off by one bug in cxlflash_show_port_status()
Date: Sat, 15 Aug 2015 21:52:24 -0500
Message-ID: <EC66FD3E-7BCB-4647-BAB7-875942932DAE@linux.vnet.ibm.com>
References: <20150814203525.GA27158@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150814203525.GA27158@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Brian King <brking@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On Aug 14, 2015, at 3:35 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> The > should be >= or we read one element past the end of the array.

Dan - Good catch!

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> 
> Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapter')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapter')
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 0720d2f..fd70101 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -539,7 +539,7 @@ static ssize_t cxlflash_show_port_status(struct device *dev,
> 	u64 *fc_regs;
> 
> 	rc = kstrtouint((attr->attr.name + 4), 10, &port);
> -	if (rc || (port > NUM_FC_PORTS))
> +	if (rc || (port >= NUM_FC_PORTS))
> 		return 0;
> 
> 	fc_regs = &afu->afu_map->global.fc_regs[port][0];
> 

