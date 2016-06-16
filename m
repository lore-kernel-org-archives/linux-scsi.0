From: walter harms <wharms@bfs.de>
Subject: Re: [patch] bfa: clean up some bounds checking
Date: Thu, 16 Jun 2016 14:20:13 +0200
Message-ID: <5762997D.3020302@bfs.de>
References: <20160616104434.GB24067@mwanda>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160616104434.GB24067@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 16.06.2016 12:44, schrieb Dan Carpenter:
> This code is supposed to search ->adapter_hwpath[] and replace the
> second colon with a NUL character.  Unfortunately, the boundary checks
> that ensure we don't go beyond the end of the buffer have a couple
> problems.
> 
> Imagine that the string has no colons.  In that case, in the first loop,
> we read one space beyond the end of the buffer and then exit the loop.
> In the next loop, we increment once, read two characters beyond the end
> of the buffer and then exit.  Then after the loop we put a NUL character
> two characters past the end of the buffer.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is from static analysis and not tested.  Caveat emptor.
> 
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
> index d1ad020..dfb26f0 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -106,10 +106,17 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, void *cmd)
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
the idea is to have a string like aa:bb:something
and kill everyhing after the second ':' ?
/*
	a few word may help here also inside the code
*/


second: maybe we can us strchr here ?
	s1=strchr(iocmd->adapter_hwpath,':');
	if (s1 != NULL ) s1=strchr(s1,":");



re,
 wh
