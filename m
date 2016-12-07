From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 20/22] qla2xxx: Allow relogin to go through if remote
 login did not finish
Date: Wed, 7 Dec 2016 13:05:24 +0100
Message-ID: <884223e6-5856-057a-2f36-796cf6d0ae16@suse.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-21-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:38792 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbcLGMFv (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 7 Dec 2016 07:05:51 -0500
In-Reply-To: <1481056251-2310-21-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On 12/06/2016 09:30 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    |  2 ++
>  drivers/scsi/qla2xxx/qla_init.c   | 14 ++++++++++++--
>  drivers/scsi/qla2xxx/qla_isr.c    | 25 +++++++++++++++++++------
>  drivers/scsi/qla2xxx/qla_os.c     |  2 +-
>  drivers/scsi/qla2xxx/qla_target.c |  2 ++
>  5 files changed, 36 insertions(+), 9 deletions(-)
> 
[ .. ]
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 8137238..3e089c3 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4512,7 +4512,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
>  			fcport->flags |= FCF_FABRIC_DEVICE;
>  			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
>  
> -			memcpy(&fcport->port_name, e->u.new_sess.port_name,
> +			memcpy(fcport->port_name, e->u.new_sess.port_name,
>  				   WWN_SIZE);
>  		} else {
>  			ql_dbg(ql_dbg_disc, vha, 0xffff,
Misplaced hunk, maybe?
Seems like a genuine fix, and unrelated to the rest of the path.
Please move to a separate patch (or merge with the original introducing
this issue, if possible).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
