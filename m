From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0
 emulation support
Date: Thu, 15 Nov 2012 12:39:17 -0800
Message-ID: <1353011957.11597.5.camel@haakon2.linux-iscsi.org>
References: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
	 <1353010439-4600-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353010439-4600-4-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 20:13 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds support for emulation of WRITE_SAME w/ UNMAP=0 within
> iblock_execute_write_same() backend code.
> 
> The emulation uses a bio_add_page() call for each sector, and by default
> enforces a limit of max_write_same_len=0xFFFF (65536) sectors following
> what scsi_debug reports per default for MAXIMUM WRITE SAME LENGTH.
> 
> It also sets max_write_same_len to the operational default at setup ->
> iblock_configure_device() time.
> 
> (hch: Move unmap logic into iblock_execute_write_same_unmap + add
>       check for single sector SGLs in iblock_execute_write_same)
> (mkp: Update comment for 0xFFFF magic constant)
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_iblock.c |   91 ++++++++++++++++++++++++++++++++---
>  1 files changed, 84 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 53f4501..5abbd55 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c

> +static sense_reason_t
> +iblock_execute_write_same(struct se_cmd *cmd)
> +{
> +	struct iblock_req *ibr;
> +	struct scatterlist *sg;
> +	struct bio *bio;
> +	struct bio_list list;
> +	sector_t block_lba = cmd->t_task_lba;
> +	unsigned int sectors = spc_get_write_same_sectors(cmd);
> +
> +	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
> +		pr_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
> +			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
> +		return TCM_INVALID_CDB_FIELD;
> +	}

<SNIP>

Forgot to remove this now redundant check for max_write_same_len.

Dropping now..
