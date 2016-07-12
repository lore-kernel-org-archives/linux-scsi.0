From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] libata-scsi: do not return designator for serial
 number
Date: Tue, 12 Jul 2016 14:49:25 -0400
Message-ID: <20160712184925.GG3190@htj.duckdns.org>
References: <577d8249.a10c420a.da50c.ffff953e@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <577d8249.a10c420a.da50c.ffff953e@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 07, 2016 at 06:12:12AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> SAT (as of sat4r05f.pdf) does not require this vendor specific
> designator. Besides, we already have the Unit Serial Number VPD.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfec66f..9f478ad 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2210,14 +2210,6 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
>  	rbuf[1] = 0x83;			/* this page code */
>  	num = 4;
>  
> -	/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
> -	rbuf[num + 0] = 2;
> -	rbuf[num + 3] = ATA_ID_SERNO_LEN;
> -	num += 4;
> -	ata_id_string(args->id, (unsigned char *) rbuf + num,
> -		      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
> -	num += ATA_ID_SERNO_LEN;
> -

If it isn't actually broken, I don't want to change it.  It's a
userland visible change which is gratuitous.

Thanks.

-- 
tejun
