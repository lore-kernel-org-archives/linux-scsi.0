From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Return an error for WRITE SAME with ANCHOR==1
Date: Wed, 16 Oct 2013 13:50:33 -0700
Message-ID: <1381956633.19256.639.camel@haakon3.risingtidesystems.com>
References: <1381790963-14657-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37239 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab3JPUmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 16:42:00 -0400
In-Reply-To: <1381790963-14657-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

On Mon, 2013-10-14 at 15:49 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Per SBC-3, since we report ANC_SUP==0 in VPD page B2h, we need to return
> an error (ILLEGAL REQUEST/INVALID FIELD IN CDB) for all WRITE SAME
> requests with ANCHOR==1.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Applied to target-pending/master.

Thanks Roland!

--nab

> ---
>  drivers/target/target_core_sbc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 4714c6f8da4b..d9b92b2c524d 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -263,6 +263,11 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
>  			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
>  		return TCM_INVALID_CDB_FIELD;
>  	}
> +	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
> +	if (flags[0] & 0x10) {
> +		pr_warn("WRITE SAME with ANCHOR not supported\n");
> +		return TCM_INVALID_CDB_FIELD;
> +	}
>  	/*
>  	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
>  	 * translated into block discard requests within backend code.


