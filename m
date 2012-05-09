From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: lock => unlock typo
Date: Tue, 08 May 2012 19:28:44 -0700
Message-ID: <1336530524.8722.61.camel@haakon2.linux-iscsi.org>
References: <20120508102858.GA21528@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120508102858.GA21528@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-05-08 at 13:28 +0300, Dan Carpenter wrote:
> target_stop_cmd() returns with the lock held and IRQs disabled.  The
> intent was to unlock here.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 0d838ab..8bd9ffe 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3769,7 +3769,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
>  	    (cmd->transport_state & CMD_T_SENT)) {
>  		if (!target_stop_cmd(cmd, &flags))
>  			ret++;
> -		spin_lock_irqsave(&cmd->t_state_lock, flags);
> +		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  	} else {
>  		spin_unlock_irqrestore(&cmd->t_state_lock,
>  				flags);
> --

Applied to lio-core, and folding into hch's original commit that
introduced the bug in for-next.

Thanks Dan!

--nab
