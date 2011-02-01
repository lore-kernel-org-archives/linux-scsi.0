From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
Date: Tue, 01 Feb 2011 17:45:13 -0600
Message-ID: <4D489B09.9010906@cs.wisc.edu>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-17-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294062595-30097-17-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/03/2011 07:49 AM, Tejun Heo wrote:
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 75a85aa..4339196 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4276,7 +4276,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
>
>   	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
>   		 phba->shost->host_no);
> -	phba->wq = create_workqueue(phba->wq_name);
> +	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
>   	if (!phba->wq) {
>   		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
>   				"Failed to allocate work queue\n");
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2c0876c..2cd0a77 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -356,7 +356,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
>   				"Can't create request queue\n");
>   			goto fail;
>   		}
> -		ha->wq = create_workqueue("qla2xxx_wq");
> +		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
>   		vha->req = ha->req_q_map[req];
>   		options |= BIT_1;
>   		for (ques = 1; ques<  ha->max_rsp_queues; ques++) {

I think these are used in the main IO path, so would you also want 
WQ_HIGHPRI | WQ_CPU_INTENSIVE to be set? I think qla2xxx was using this 
in a path they expected to have high throughput/low latency, and from 
the interrupt handler they would try to queue the work on the same cpu 
the isr was answered on. With the new workqueue code could you possibly 
get queued onto a workqueue that is doing other work for other drivers?

Should qla2xxx be using the blkiopoll framework instead of a workqueue 
or will workqueues still provide the same performance when setting 
WQ_HIGHPRI | WQ_CPU_INTENSIVE?
