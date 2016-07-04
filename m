From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 1/2] libata-scsi: improve TRIM translation
Date: Tue, 5 Jul 2016 00:26:46 +0300
Message-ID: <81c8e53e-83b4-7929-14a7-38b9c49a1971@cogentembedded.com>
References: <577accd7.46c0620a.65070.ffffec83@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577accd7.46c0620a.65070.ffffec83@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/04/2016 11:53 PM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> Define TRIM_RANGE_SIZE and TRIM_RANGE_NUM so that the corresponding
> functions can be more generalized. Also, conform SBC by rejecting

    Conform to SBC, perhaps?

> WRITE SAME (16) commands with number of blocks that exceeds the limit
> that is defined in the SATL.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index bfec66f..80d732c 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> @@ -3305,7 +3308,10 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>  		goto invalid_param_len;
>
>  	buf = page_address(sg_page(scsi_sglist(scmd)));
> -	size = ata_set_lba_range_entries(buf, 512, block, n_block);
> +	if (n_block <= TRIM_RANGE_SIZE * TRIM_RANGE_NUM)
> +	  size = ata_set_lba_range_entries(buf, TRIM_RANGE_NUM, block, n_block);
> +	else
> +	  goto invalid_fld;

    CodingStyle: indent with a tab, not spaces.

[...]

MBR, Sergei

