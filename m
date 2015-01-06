From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost-scsi: Add missing virtio-scsi -> TCM attribute
 conversion
Date: Tue, 6 Jan 2015 23:07:41 +0200
Message-ID: <20150106210741.GA14536@redhat.com>
References: <1420575485-16447-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbbAFVHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 16:07:51 -0500
Content-Disposition: inline
In-Reply-To: <1420575485-16447-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>

On Tue, Jan 06, 2015 at 08:18:05PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> While looking at hch's recent conversion to drop the MSG_*_TAG
> definitions, I noticed a long standing bug in vhost-scsi where
> the VIRTIO_SCSI_S_* attribute definitions where incorrectly
> being passed directly into target_submit_cmd_map_sgls().
> 
> This patch adds the missing virtio-scsi to TCM/SAM task attribute
> conversion.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Cc stable as well?

> ---
>  drivers/vhost/scsi.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 01c01cb..d695b16 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -911,6 +911,23 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
>  	return 0;
>  }
>  
> +static int vhost_scsi_to_tcm_attr(int attr)
> +{
> +	switch (attr) {
> +	case VIRTIO_SCSI_S_SIMPLE:
> +		return TCM_SIMPLE_TAG;
> +	case VIRTIO_SCSI_S_ORDERED:
> +		return TCM_ORDERED_TAG;
> +	case VIRTIO_SCSI_S_HEAD:
> +		return TCM_HEAD_TAG;
> +	case VIRTIO_SCSI_S_ACA:
> +		return TCM_ACA_TAG;
> +	default:
> +		break;
> +	}
> +	return TCM_SIMPLE_TAG;
> +}
> +
>  static void tcm_vhost_submission_work(struct work_struct *work)
>  {
>  	struct tcm_vhost_cmd *cmd =
> @@ -936,9 +953,10 @@ static void tcm_vhost_submission_work(struct work_struct *work)
>  	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
>  			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
>  			cmd->tvc_lun, cmd->tvc_exp_data_len,
> -			cmd->tvc_task_attr, cmd->tvc_data_direction,
> -			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
> -			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
> +			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
> +			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
> +			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
> +			cmd->tvc_prot_sgl_count);
>  	if (rc < 0) {
>  		transport_send_check_condition_and_sense(se_cmd,
>  				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
> -- 
> 1.9.1
