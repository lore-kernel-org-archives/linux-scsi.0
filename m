From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] qla2xxx: Remove check to return DID_NO_CONNECT
 when FC device is lost.
Date: Sat, 12 Feb 2011 10:52:13 -0600
Message-ID: <1297529533.3026.8.camel@mulgrave.site>
References: <1296256677-11572-1-git-send-email-madhu.iyengar@qlogic.com>
	 <1296256677-11572-2-git-send-email-madhu.iyengar@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab1BLQwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Feb 2011 11:52:20 -0500
In-Reply-To: <1296256677-11572-2-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: madhu.iyengar@qlogic.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Fri, 2011-01-28 at 15:17 -0800, madhu.iyengar@qlogic.com wrote:
> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c194c23..5dc548b 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -562,7 +562,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
>  	}
>  	if (atomic_read(&fcport->state) != FCS_ONLINE) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
> -			atomic_read(&fcport->state) == FCS_DEVICE_LOST ||

This looks like you're actually *not* returning DID_NO_CONNECT when the
device is lost ... what are you returning instead, and why is this an
important bug fix?

James


>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
>  			goto qc24_fail_command;


