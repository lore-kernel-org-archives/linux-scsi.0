From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla4xxx: assign correct address for iscsi_cls_host
Date: Fri, 02 Mar 2012 13:24:46 -0600
Message-ID: <4F511E7E.5030100@cs.wisc.edu>
References: <1330682131-28116-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37792 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2CBTY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Mar 2012 14:24:57 -0500
In-Reply-To: <1330682131-28116-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 03/02/2012 03:55 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 281328d..d57f6eb 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -834,7 +834,7 @@ static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  static void qla4xxx_set_port_speed(struct Scsi_Host *shost)
>  {
>  	struct scsi_qla_host *ha = to_qla_host(shost);
> -	struct iscsi_cls_host *ihost = shost_priv(shost);
> +	struct iscsi_cls_host *ihost = shost->shost_data;
>  	uint32_t speed = ISCSI_PORT_SPEED_UNKNOWN;
>  
>  	qla4xxx_get_firmware_state(ha);
> @@ -859,7 +859,7 @@ static void qla4xxx_set_port_speed(struct Scsi_Host *shost)
>  static void qla4xxx_set_port_state(struct Scsi_Host *shost)
>  {
>  	struct scsi_qla_host *ha = to_qla_host(shost);
> -	struct iscsi_cls_host *ihost = shost_priv(shost);
> +	struct iscsi_cls_host *ihost = shost->shost_data;
>  	uint32_t state = ISCSI_PORT_STATE_DOWN;
>  
>  	if (test_bit(AF_LINK_UP, &ha->flags))

We should just merge the iscsi_cls_host and libiscsi host. This is fine
for now.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
