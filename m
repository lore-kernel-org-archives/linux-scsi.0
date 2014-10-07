From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iser-target: Disable TX completion interrupt coalescing
Date: Tue, 07 Oct 2014 09:58:08 +0300
Message-ID: <54338F00.8050902@dev.mellanox.co.il>
References: <1412561711-31344-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39144 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaJGG6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 02:58:12 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so7174266wgh.7
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2014 23:58:10 -0700 (PDT)
In-Reply-To: <1412561711-31344-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>, Moussa Ba <moussaba@micron.com>

On 10/6/2014 5:15 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch explicitly disables TX completion interrupt coalescing logic
> in isert_put_response() and isert_put_datain() that was originally added
> as an efficiency optimization in commit 95b60f07.
>
> It has been reported that this change can trigger ABORT_TASK timeouts
> under certain small block workloads, where disabling coalescing was
> required for stability.  According to Sagi, this doesn't impact
> overall performance, so go ahead and disable it for now.
>
> Reported-by: Moussa Ba <moussaba@micron.com>
> Cc: Moussa Ba <moussaba@micron.com>
> Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: <stable@vger.kernel.org> # 3.13+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 40969b6..f719112 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -2183,7 +2183,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   		isert_cmd->tx_desc.num_sge = 2;
>   	}
>
> -	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
> +	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);

I Would like to avoid taking the conn_mutex in the IO path.
Care to respin this with avoiding taking the mutex? Or you want me to?
I have a couple of patches in the pipe anyway...

Sagi.
