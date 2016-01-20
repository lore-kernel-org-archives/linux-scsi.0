From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: qla2xxxx: avoid type mismatch in comparison
Date: Wed, 20 Jan 2016 08:10:32 -0800
Message-ID: <569FB178.9050101@sandisk.com>
References: <1603472.f34vvTrhuN@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0085.outbound.protection.outlook.com ([207.46.100.85]:28592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933838AbcATQKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 11:10:43 -0500
In-Reply-To: <1603472.f34vvTrhuN@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Alexei Potashnik <alexei@purestorage.com>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 01/20/2016 02:47 AM, Arnd Bergmann wrote:
> A recent bug fix added code that does
>
>          bool logged_out = (status & 0xFFFF);
>          if (logged_out == CTIO_PORT_LOGGED_OUT)
> 		...
>
> This looks wrong because we are comparing a boolean with an
> integer constant, ang gcc warns about it accordingly:
>
> drivers/scsi/qla2xxx/qla_target.c: In function 'qlt_do_ctio_completion':
> drivers/scsi/qla2xxx/qla_target.c:3587:20: warning: comparison of constant '41' with boolean expression is always false [-Wbool-compare]
>          (logged_out == CTIO_PORT_LOGGED_OUT) ?
>
> The correct fix is presumably to make that variable an 'int'.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 71cdc0796465 ("qla2xxx: Delete session if initiator is gone from FW")
> ---
> The patch introducing this is currenly in linux-next through the target-updates/for-next
> branch.
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index c7ab9e69c881..8075a4cdb45c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3580,7 +3580,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
>   		case CTIO_PORT_LOGGED_OUT:
>   		case CTIO_PORT_UNAVAILABLE:
>   		{
> -			bool logged_out = (status & 0xFFFF);
> +			int logged_out = (status & 0xFFFF);
>   			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
>   			    "qla_target(%d): CTIO with %s status %x "
>   			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
>

Hello Arnd,

Please read the e-mail thread that is available at 
http://thread.gmane.org/gmane.linux.scsi/108899/focus=108943. That 
thread namely makes it clear that the above patch is not the proper way 
to fix that code.

Thanks,

Bart.
