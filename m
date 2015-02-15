From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/8] target: Check for LBA + sectors wrap-around in sbc_parse_cdb
Date: Sun, 15 Feb 2015 10:18:58 +0200
Message-ID: <54E05672.8040401@dev.mellanox.co.il>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com> <1423884463-16797-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423884463-16797-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 2/14/2015 5:27 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds a check to sbc_parse_cdb() in order to detect when
> an LBA + sector vs. end-of-device calculation wraps when the LBA is
> sufficently large enough (eg: 0xFFFFFFFFFFFFFFFF).
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index b26b52f..17259c0 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -982,7 +982,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
>   		}
>   check_lba:
>   		end_lba = dev->transport->get_blocks(dev) + 1;
> -		if (cmd->t_task_lba + sectors > end_lba) {
> +		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
> +		    ((cmd->t_task_lba + sectors) > end_lba)) {
>   			pr_err("cmd exceeds last lba %llu "
>   				"(lba %llu, sectors %u)\n",
>   				end_lba, cmd->t_task_lba, sectors);
>

Can you also please modify the err message as well?

Sagi.
