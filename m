From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 11/16] qla2xxx: Add selective command queuing
Date: Tue, 29 Dec 2015 09:38:11 +0100
Message-ID: <56824673.5000708@sandisk.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:11607
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbbL2IiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 03:38:17 -0500
In-Reply-To: <1450382231-4259-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 12/17/2015 08:57 PM, Himanshu Madhani wrote:
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 9a4aed0..d3cd271 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3982,13 +3982,24 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>
>   	cmd->cmd_in_wq = 1;
>   	cmd->cmd_flags |= BIT_0;
> +	cmd->se_cmd.cpuid = -1;

A second comment about this patch: this initialization code must be 
moved to the target core (transport_init_se_cmd()). Otherwise the cpuid 
member variable won't be initialized when target_complete_cmd() is 
called for another target driver than tcm_qla2xxx.

Bart.
