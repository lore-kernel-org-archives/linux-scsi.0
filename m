From: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Subject: RE: [patch] bfa: clean up some bounds checking
Date: Fri, 1 Jul 2016 13:12:58 +0000
Message-ID: <SN1PR11MB042975C2DD9F663AD3D1551D90250@SN1PR11MB0429.namprd11.prod.outlook.com>
References: <20160616104434.GB24067@mwanda> <5762997D.3020302@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0139.outbound.protection.outlook.com ([104.47.32.139]:60864
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbcGAPqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 11:46:35 -0400
In-Reply-To: <5762997D.3020302@bfs.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "wharms@bfs.de" <wharms@bfs.de>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

    Both the approaches (i.e., using a loop or the strchr()) look fine to me.

Thanks,
Sudarsana

-----Original Message-----
From: walter harms [mailto:wharms@bfs.de] 
Sent: 16 June 2016 17:50
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>; Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>; James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>; linux-scsi <linux-scsi@vger.kernel.org>; kernel-janitors@vger.kernel.org
Subject: Re: [patch] bfa: clean up some bounds checking



Am 16.06.2016 12:44, schrieb Dan Carpenter:
> This code is supposed to search ->adapter_hwpath[] and replace the 
> second colon with a NUL character.  Unfortunately, the boundary checks 
> that ensure we don't go beyond the end of the buffer have a couple 
> problems.
> 
> Imagine that the string has no colons.  In that case, in the first 
> loop, we read one space beyond the end of the buffer and then exit the loop.
> In the next loop, we increment once, read two characters beyond the 
> end of the buffer and then exit.  Then after the loop we put a NUL 
> character two characters past the end of the buffer.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is from static analysis and not tested.  Caveat emptor.
> 
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c 
> index d1ad020..dfb26f0 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -106,10 +106,17 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, 
> void *cmd)
>  
>  	/* set adapter hw path */
>  	strcpy(iocmd->adapter_hwpath, bfad->pci_name);
> -	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
> -		;
> -	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32; )
> -		;
> +	i = -1;
> +	while (++i < BFA_STRING_32) {
> +		if (iocmd->adapter_hwpath[i] == ':')
> +			break;
> +	}
> +	while (++i < BFA_STRING_32) {
> +		if (iocmd->adapter_hwpath[i] == ':')
> +			break;
> +	}
> +	if (i >= BFA_STRING_32)
> +		i = BFA_STRING_32 - 1;
>  	iocmd->adapter_hwpath[i] = '\0';
>  	iocmd->status = BFA_STATUS_OK;
>  	return 0;


I do not see the use case but i assume
the idea is to have a string like aa:bb:something and kill everyhing after the second ':' ?
/*
	a few word may help here also inside the code */


second: maybe we can us strchr here ?
	s1=strchr(iocmd->adapter_hwpath,':');
	if (s1 != NULL ) s1=strchr(s1,":");



re,
 wh
