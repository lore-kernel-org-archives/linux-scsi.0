From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iser-target: Add missing target_put_sess_cmd for ImmedateData
 failure
Date: Sun, 25 May 2014 10:52:52 +0300
Message-ID: <5381A154.4040302@dev.mellanox.co.il>
References: <1400873569-3606-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:45422 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaEYHw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 03:52:56 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so6735514wev.17
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 00:52:54 -0700 (PDT)
In-Reply-To: <1400873569-3606-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>

On 5/23/2014 10:32 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch addresses a bug where an early exception for SCSI WRITE
> with ImmediateData=Yes was missing the target_put_sess_cmd() call
> to drop the extra se_cmd->cmd_kref reference obtained during the
> normal iscsit_setup_scsi_cmd() codepath execution.
>
> This bug was manifesting itself during session shutdown within
> isert_cq_rx_comp_err() where target_wait_for_sess_cmds() would
> end up waiting indefinately for the last se_cmd->cmd_kref put to
> occur for the failed SCSI WRITE + ImmediateData descriptors.
>
> This fix follows what traditional iscsi-target code already does
> for the same failure case within iscsit_get_immediate_data().
>
> Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index b622783..52c5ab8 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -1209,6 +1209,8 @@ sequence_cmd:
>   
>   	if (!rc && dump_payload == false && unsol_data)
>   		iscsit_set_unsoliticed_dataout(cmd);
> +	else if (dump_payload && imm_data)
> +		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
>   
>   	return 0;
>   }

Thanks Nic!

Tested-by: Sagi Grimberg <sagig@mellanox.com>
