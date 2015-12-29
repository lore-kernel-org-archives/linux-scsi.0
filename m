From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 11/16] qla2xxx: Add selective command queuing
Date: Tue, 29 Dec 2015 09:30:59 +0100
Message-ID: <568244C3.6030806@sandisk.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:16384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbbL2IbG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 03:31:06 -0500
In-Reply-To: <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/17/2015 08:57 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>
> queue work element to specific process lessen cache miss
>
> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c         |    2 +-
>   drivers/scsi/qla2xxx/qla_target.c      |   13 ++++++++++++-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    4 ++--
>   drivers/target/target_core_transport.c |    5 ++++-
>   include/target/target_core_base.h      |    1 +
>   5 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index cf0fe8e..3e89122 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3302,7 +3302,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *notify,
>   	}
>   }
>
> -void qla_irq_affinity_release(struct kref *ref)
> +static void qla_irq_affinity_release(struct kref *ref)
>   {
>   	struct irq_affinity_notify *notify =
>   		container_of(ref, struct irq_affinity_notify, kref);
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 9a4aed0..d3cd271 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3982,13 +3982,24 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>
>   	cmd->cmd_in_wq = 1;
>   	cmd->cmd_flags |= BIT_0;
> +	cmd->se_cmd.cpuid = -1;

Please use WORK_CPU_UNBOUND instead of -1. That will allow to convert 
the if (cpuid == -1) queue_work() else queue_work_on() constructs into a 
single queue_work_on() call.

Bart.
