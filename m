From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/8] hisi_sas: fail tmf task prep when port detached
Date: Wed, 24 Aug 2016 15:00:12 +0200
Message-ID: <9fe62988-55dd-d89f-10d0-eeb6aa2fea96@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-7-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-7-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> When the port is detached we cannot execute a TMF,
> as there can be no device attached to the port.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 280a19d..73f581f 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -204,7 +204,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
>  		return rc;
>  	}
>  	port = device->port->lldd_port;
> -	if (port && !port->port_attached && !tmf) {
> +	if (port && !port->port_attached) {
>  		if (sas_protocol_ata(task->task_proto)) {
>  			struct task_status_struct *ts = &task->task_status;
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
