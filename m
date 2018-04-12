From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: reduce the time granularity of
 qla2x00_eh_wait_on_command
Date: Thu, 12 Apr 2018 17:00:09 +0800
Message-ID: <69351cce-2d2f-11d6-27b6-01d0d90a2e59@oracle.com>
References: <1523350115-4026-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523350115-4026-1-git-send-email-jianchao.w.wang@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Would anyone please take a review on this ?

Thanks in advance
Jianchao

On 04/10/2018 04:48 PM, Jianchao Wang wrote:
> If the cmd has not be returned after aborted by qla2x00_eh_abort,
> we have to wait for it. However, the time is 1000ms at least currently.
> If there are a lot cmds need to be aborted, the delay could be long
> enough to lead to panic due to such as hung task, ocfs2 heartbeat,
> etc, just before scsi recovery works.
> Change the granularity to 1ms, even though more context switches
> would be introduced, but it should be ok as it is not hot path.
> 
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 5c5dcca4..9f52ad9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1072,7 +1072,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
>  static int
>  qla2x00_eh_wait_on_command(struct scsi_cmnd *cmd)
>  {
> -#define ABORT_POLLING_PERIOD	1000
> +#define ABORT_POLLING_PERIOD	1
>  #define ABORT_WAIT_ITER		((2 * 1000) / (ABORT_POLLING_PERIOD))
>  	unsigned long wait_iter = ABORT_WAIT_ITER;
>  	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> 
