From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/2] libata-scsi: reject WRITE SAME (16) with n_block
 that exceeds limit
Date: Tue, 12 Jul 2016 15:55:09 -0400
Message-ID: <20160712195509.GD10377@htj.duckdns.org>
References: <577d3d97.24f0420a.c2bbd.ffffd426@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34566 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbcGLTzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 15:55:13 -0400
Content-Disposition: inline
In-Reply-To: <577d3d97.24f0420a.c2bbd.ffffd426@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jul 07, 2016 at 01:19:05AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Currently if a WRITE SAME (16) command is issued to the SATL with
> "number of blocks" that is larger than the "Maximum write same length"
> (which is the maximum number of blocks per TRIM command allowed in
> libata, currently 65535 * 512 / 8 blocks), the SATL will accept the
> command and translate it to a TRIM command with the upper limit.
> 
> However, according to SBC (as of sbc4r11.pdf), the "device server"
> should terminate the command with "Invalid field in CDB" in that case.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfec66f..a1f061a 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3305,7 +3305,11 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>  		goto invalid_param_len;
>  
>  	buf = page_address(sg_page(scsi_sglist(scmd)));
> -	size = ata_set_lba_range_entries(buf, 512, block, n_block);
> +
> +	if (n_block <= 65535 * 512 / 8)
> +		size = ata_set_lba_range_entries(buf, 512, block, n_block);
> +	else
> +		goto invalid_fld;

This triggers compiler warning about @fp used w/o initializing it.  I
reverted the patch.  Can you please update the patch?

Thanks.

-- 
tejun
