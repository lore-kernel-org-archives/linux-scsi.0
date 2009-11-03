From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH] pcmraid: fix endianness problems
Date: Tue, 3 Nov 2009 11:29:44 -0800 (PST)
Message-ID: <alpine.LNX.1.10.0911031116170.13870@rslab159.pmc-sierra.bc.ca>
References: <1257268514.9427.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54463 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588AbZKCUfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 15:35:07 -0500
In-Reply-To: <1257268514.9427.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, anil_ravindranath@pmc-sierra.com

James,

Yes. We can remove these spurious cpu_to_le32 wrappers for 8 bits.
I had already submitted a patch dated: Sep 24 to address this. The subject 
of the mail/patch was:
PATCH 1/1] pmcraid: Fix ppc64 driver build for using cpu_to_le32 on U8 
data type

In addition to below, I have made one more similar change as well -

pmcraid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2009-11-03 11:22:49.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2009-11-03 11:25:06.000000000 -0800
@@ -1076,7 +1076,7 @@
 
 	ioarcb->data_transfer_length = cpu_to_le32(rcb_size);
 
-	ioadl[0].flags |= cpu_to_le32(IOADL_FLAGS_READ_LAST);
+	ioadl[0].flags |= IOADL_FLAGS_READ_LAST;
 	ioadl[0].data_len = cpu_to_le32(rcb_size);
 	ioadl[0].address = cpu_to_le32(dma);
 

On Tue, 3 Nov 2009, James Bottomley wrote:

> There's a compile problem with pcmraid on BE platforms because the flags
> machine mailbox register is only 8 bits wide:
> 
> drivers/scsi/pmcraid.c: In function 'pmcraid_request_sense':
> drivers/scsi/pmcraid.c:2259: warning: large integer implicitly truncated to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_build_ioadl':
> drivers/scsi/pmcraid.c:3025: warning: large integer implicitly truncated to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_build_passthrough_ioadls':
> drivers/scsi/pmcraid.c:3395: warning: large integer implicitly truncated to unsigned type
> drivers/scsi/pmcraid.c: In function 'pmcraid_querycfg':
> drivers/scsi/pmcraid.c:5322: warning: large integer implicitly truncated to unsigned type
> 
> The fix, I think, is just to remove the spurious cpu_to_le32 wrappers
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 86d158e..ef4102e 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -2256,7 +2256,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
>  
>  	ioadl->address = cpu_to_le64(cmd->sense_buffer_dma);
>  	ioadl->data_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
> -	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
> +	ioadl->flags = IOADL_FLAGS_LAST_DESC;
>  
>  	/* request sense might be called as part of error response processing
>  	 * which runs in tasklets context. It is possible that mid-layer might
> @@ -3022,7 +3022,7 @@ static int pmcraid_build_ioadl(
>  		ioadl[i].flags = 0;
>  	}
>  	/* setup last descriptor */
> -	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
> +	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
>  
>  	return 0;
>  }
> @@ -3392,7 +3392,7 @@ static int pmcraid_build_passthrough_ioadls(
>  	}
>  
>  	/* setup the last descriptor */
> -	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
> +	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
>  
>  	return 0;
>  }
> @@ -5319,7 +5319,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *cmd)
>  		cpu_to_le32(sizeof(struct pmcraid_config_table));
>  
>  	ioadl = &(ioarcb->add_data.u.ioadl[0]);
> -	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
> +	ioadl->flags = IOADL_FLAGS_LAST_DESC;
>  	ioadl->address = cpu_to_le64(pinstance->cfg_table_bus_addr);
>  	ioadl->data_len = cpu_to_le32(sizeof(struct pmcraid_config_table));
>  
> 
> 
> 
