From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
 support
Date: Thu, 15 Nov 2012 06:04:32 -0500
Message-ID: <20121115110432.GD28956@infradead.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352405238-23267-4-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> +	/*
> +	 * Enable WRITE_SAME emulation for IBLOCK, use scsi_debug.c default
> +	 */

Why would we care what scsi_debug.c uses?

> +	dev->dev_attrib.max_write_same_len = 0xFFFF;
>  
>  	if (blk_queue_nonrot(q))
>  		dev->dev_attrib.is_nonrot = 1;
> @@ -375,22 +379,80 @@ err:
>  	return ret;
>  }

> +static struct bio *iblock_get_bio(struct se_cmd *, sector_t, u32);
> +static void iblock_submit_bios(struct bio_list *, int);
> +static void iblock_complete_cmd(struct se_cmd *);

I'd suggest moving the write_same callback below these to avoid
forward declarations.

> +	if (cmd->se_cmd_flags & SCF_WRITE_SAME_DISCARD) {

I'd probably add separate write_same and write_same_unmap members to
the sbc_ops structure.  That'll keep decoding which one is used in the
SBC code, and it'll keep the implementations nicely separated.

> +	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {

This sort of check should stay in the SBC code.

> +	sg = &cmd->t_data_sg[0];

Btw, it seems like we don't bother to ensure the S/G list length
is just one sector for WRITE SAME with either the unmap bit set or not.

Also please add testcases for WRITE SAME including corner cases like
incorrect transfer length to the scsi testsuite to ensure this code
has proper QA coverage.
