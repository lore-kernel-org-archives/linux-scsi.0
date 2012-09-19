From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Wed, 19 Sep 2012 08:59:21 +0100
Message-ID: <1348041561.2479.14.camel@dabdike.int.hansenpartnership.com>
References: <1348006256-23551-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1348006256-23551-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-09-18 at 15:10 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> The qla2xxx firmware actually expects the task management response
> code in a CTIO IOCB with SCSI status mode 1 to be in little-endian
> byte order, ie the response code should be the first byte in the
> sense_data[] array.

Is this also true on Big Endian Hardware?  Because the fix you have
assumes that the TIO IOCB with SCSI status mode 1 should be CPU
endian ... that doesn't look right since this is passed directly over
the PCI bus (and the PCI bus is little endian), so shouldn't the correct
fix be to replace cpu_to_be32 with cpu_to_le32?

James

>   The old code erroneously byte-swapped the
> response code, which puts it in the wrong place on the wire and leads
> to initiators thinking every task management request succeeds (since
> they see 0 in the byte where they look for the response code).
> 
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Arun Easi <arun.easi@qlogic.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 5b30132..41b74ba 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1403,7 +1403,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
>  	ctio->u.status1.scsi_status =
>  	    __constant_cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID);
>  	ctio->u.status1.response_len = __constant_cpu_to_le16(8);
> -	((uint32_t *)ctio->u.status1.sense_data)[0] = cpu_to_be32(resp_code);
> +	ctio->u.status1.sense_data[0] = resp_code;
>  
>  	qla2x00_start_iocbs(ha, ha->req);
>  }
