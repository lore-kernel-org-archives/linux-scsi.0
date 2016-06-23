From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 7/8] mmc: block: register RPMB partition with the RPMB
 subsystem
Date: Thu, 23 Jun 2016 09:17:52 +0300
Message-ID: <576B7F10.2000508@intel.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
 <1464817292-5407-8-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1464817292-5407-8-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 02/06/16 00:41, Tomas Winkler wrote:
> Register eMMC RPMB partition with the RPMB subsystem and provide
> implementation for the RPMB access operations abstracting
> actual multi step process.
> 
> V2: resend
> V3: commit message fix
> V4: Kconfig: use select RPMB to ensure valid configuration
>     Switch back to main area after RPMB access
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> ---

<SNIP>

> +static void mmc_blk_rpmb_add(struct mmc_card *card)
> +{
> +	struct mmc_blk_data *md = dev_get_drvdata(&card->dev);
> +	struct mmc_blk_data *part_md = mmc_blk_rpmb_part_get(md);
> +	struct rpmb_dev *rdev;
> +
> +	if (!part_md)
> +		return;
> +
> +	mmc_blk_rpmb_set_dev_id(&mmc_rpmb_dev_ops, card);
> +
> +	/* RPMB blocks are written in half sectors hence '* 2' */
> +	mmc_rpmb_dev_ops.reliable_wr_cnt = card->ext_csd.rel_sectors * 2;

This looks like it does not support 8KB writes added in v5.1 spec.  Can that
be supported?

> +
> +	rdev = rpmb_dev_register(disk_to_dev(part_md->disk),
> +				  &mmc_rpmb_dev_ops);
> +	if (IS_ERR(rdev)) {
> +		pr_warn("%s: cannot register to rpmb %ld\n",
> +			part_md->disk->disk_name, PTR_ERR(rdev));
> +	}
> +}

<SNIP>

