From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: Use vsprintf extension %pad
Date: Mon, 6 Mar 2017 14:34:03 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1703061433370.1895@administrators-macbook-pro.local>
References: <f6a0331e574df0ab1c9dad61571b92c17971ae99.1488825093.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6a0331e574df0ab1c9dad61571b92c17971ae99.1488825093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: QLogic-Storage-Upstream@cavium.com, kbuild test robot <lkp@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 6 Mar 2017, 6:32pm -0000, Joe Perches wrote:

> Using %llx for a dma_addr_t can lead to format/argument mismatches.
> Use %pad and the address of the dma_addr_t instead.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index d9d7a86b5f8b..8e2a160490e6 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2456,8 +2456,8 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
>  	}
>  
>  	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
> -	    "BDQ PBL addr=0x%p dma=0x%llx.\n", qedf->bdq_pbl,
> -	    qedf->bdq_pbl_dma);
> +		  "BDQ PBL addr=0x%p dma=%pad\n",
> +		  qedf->bdq_pbl, &qedf->bdq_pbl_dma);
>  
>  	/*
>  	 * Populate BDQ PBL with physical and virtual address of individual
> 

Looks good.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
