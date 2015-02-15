From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 4/8] target: Perform PROTECT sanity checks for WRITE_SAME
Date: Sun, 15 Feb 2015 19:22:31 +0200
Message-ID: <54E0D5D7.2050305@dev.mellanox.co.il>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com> <1423884463-16797-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59909 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbbBORWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Feb 2015 12:22:36 -0500
Received: by mail-wg0-f51.google.com with SMTP id y19so25411922wgg.10
        for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2015 09:22:35 -0800 (PST)
In-Reply-To: <1423884463-16797-5-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>

On 2/14/2015 5:27 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds a call to sbc_check_prot() within sbc_setup_write_same()
> code to perform the various protection releated sanity checks, including
> failing if WRPROTECT or RDPROTECT is set for a backend device that has
> not advertised support for T10-PI.
>
> Also, since WRITE_SAME + T10-PI is currently not supported by IBLOCK +
> FILEIO backends, go ahead and fail if ->execute_write_same() is invoked
> with a non zero cmd->prot_op.

So this is OK, for now... But I don't see any reason why we shouldn't
support T10-PI in write_same as well...

>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_file.c   | 5 +++++
>   drivers/target/target_core_iblock.c | 5 +++++
>   drivers/target/target_core_sbc.c    | 8 ++++++++
>   3 files changed, 18 insertions(+)
>
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index c2aea09..9f1ed77 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -494,6 +494,11 @@ fd_execute_write_same(struct se_cmd *cmd)
>   		target_complete_cmd(cmd, SAM_STAT_GOOD);
>   		return 0;
>   	}
> +	if (cmd->prot_op) {
> +		pr_err("WRITE_SAME: Protection information with FILEIO"
> +		       " backends not supported\n");
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	}
>   	sg = &cmd->t_data_sg[0];
>
>   	if (cmd->t_data_nents > 1 ||
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 3efff94..303299e 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -464,6 +464,11 @@ iblock_execute_write_same(struct se_cmd *cmd)
>   	sector_t block_lba = cmd->t_task_lba;
>   	sector_t sectors = sbc_get_write_same_sectors(cmd);
>
> +	if (cmd->prot_op) {
> +		pr_err("WRITE_SAME: Protection information with IBLOCK"
> +		       " backends not supported\n");
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	}
>   	sg = &cmd->t_data_sg[0];
>
>   	if (cmd->t_data_nents > 1 ||
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 1bb8b4a..87cbbe2 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -37,6 +37,9 @@
>   #include "target_core_alua.h"
>
>   static sense_reason_t
> +sbc_check_prot(struct se_device *, struct se_cmd *, unsigned char *, u32, bool);
> +
> +static sense_reason_t
>   sbc_emulate_readcapacity(struct se_cmd *cmd)
>   {
>   	struct se_device *dev = cmd->se_dev;
> @@ -254,6 +257,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
>   	struct se_device *dev = cmd->se_dev;
>   	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
>   	unsigned int sectors = sbc_get_write_same_sectors(cmd);
> +	sense_reason_t ret;
>
>   	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
>   		pr_err("WRITE_SAME PBDATA and LBDATA"
> @@ -295,6 +299,10 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
>   	if (!ops->execute_write_same)
>   		return TCM_UNSUPPORTED_SCSI_OPCODE;
>
> +	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
> +	if (ret)
> +		return ret;
> +
>   	cmd->execute_cmd = ops->execute_write_same;
>   	return 0;
>   }
>

