From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with
 active signals
Date: Tue, 9 Oct 2018 21:58:59 -0700
Message-ID: <f75e6879-65b2-2912-df6d-27133c0da779@acm.org>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/9/18 8:23 PM, Nicholas A. Bellinger wrote:
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 86c0156..fc3093d2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2754,7 +2754,7 @@ static void target_release_cmd_kref(struct kref *kref)
>   	if (se_sess) {
>   		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>   		list_del_init(&se_cmd->se_cmd_list);
> -		if (list_empty(&se_sess->sess_cmd_list))
> +		if (se_sess->sess_tearing_down && list_empty(&se_sess->sess_cmd_list))
>   			wake_up(&se_sess->cmd_list_wq);
>   		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>   	}
> @@ -2907,7 +2907,7 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
>   
>   	spin_lock_irq(&se_sess->sess_cmd_lock);
>   	do {
> -		ret = wait_event_interruptible_lock_irq_timeout(
> +		ret = wait_event_lock_irq_timeout(
>   				se_sess->cmd_list_wq,
>   				list_empty(&se_sess->sess_cmd_list),
>   				se_sess->sess_cmd_lock, 180 * HZ);

Since this patch addresses two different issues (performance improvement 
+ fix for a hang), I think it should be split in two patches.

Thanks,

Bart.
