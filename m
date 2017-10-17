From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: integer overflow in aic7xxx (was [bug report] Linux-2.6.12-rc2)
Date: Wed, 18 Oct 2017 00:58:05 +0300
Message-ID: <20171017215805.f77s7ahesjga3w2z@mwanda>
References: <20171017215249.nker3qoexzim4q45@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20654 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935002AbdJQV6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 17:58:15 -0400
Content-Disposition: inline
In-Reply-To: <20171017215249.nker3qoexzim4q45@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org

Argh...  My script chose a stupid subject.  Sorry for not catching that.

regards,
dan carpenter

On Wed, Oct 18, 2017 at 12:52:49AM +0300, Dan Carpenter wrote:
> Hey,
> 
> This code is older than git is so it probably doesn't matter.  But just
> for laughs does anyone know what this should be?
> 
> 	drivers/scsi/aic7xxx/aic7xxx_core.c:4807 ahc_init_scbdata()
> 	warn: integer overflow (literal): u32max + 1
> 
> drivers/scsi/aic7xxx/aic7xxx_core.c
>   4794  
>   4795          /*
>   4796           * Create our DMA tags.  These tags define the kinds of device
>   4797           * accessible memory allocations and memory mappings we will
>   4798           * need to perform during normal operation.
>   4799           *
>   4800           * Unless we need to further restrict the allocation, we rely
>   4801           * on the restrictions of the parent dmat, hence the common
>   4802           * use of MAXADDR and MAXSIZE.
>   4803           */
>   4804  
>   4805          /* DMA tag for our hardware scb structures */
>   4806          if (ahc_dma_tag_create(ahc, ahc->parent_dmat, /*alignment*/1,
>   4807                                 /*boundary*/BUS_SPACE_MAXADDR_32BIT + 1,
>                                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This is "0xffffffff + 1" which has an integer overflow so it's a
> complicated way to say zero.
> 
>   4808                                 /*lowaddr*/BUS_SPACE_MAXADDR_32BIT,
>   4809                                 /*highaddr*/BUS_SPACE_MAXADDR,
>   4810                                 /*filter*/NULL, /*filterarg*/NULL,
>   4811                                 AHC_SCB_MAX_ALLOC * sizeof(struct hardware_scb),
>   4812                                 /*nsegments*/1,
>   4813                                 /*maxsegsz*/BUS_SPACE_MAXSIZE_32BIT,
>   4814                                 /*flags*/0, &scb_data->hscb_dmat) != 0) {
>   4815                  goto error_exit;
>   4816          }
>   4817  
>   4818          scb_data->init_level++;
>   4819  
> 
> regards,
> dan carpenter
