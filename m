From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: fix wrong order of opcode and itt in iscsi_handle_reject
 prompt
Date: Thu, 09 Jan 2014 00:50:54 -0600
Message-ID: <52CE46CE.2030903@cs.wisc.edu>
References: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/08/2014 08:21 PM, Vaughan Cao wrote:
> This patch makes reject messages show right value for opcode and itt, which
> is converse previously.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index e399561..27547ff 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1013,13 +1013,13 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected "
>  				  "due to DataDigest error.\n",
> -				  rejected_pdu.itt, opcode);
> +				  opcode, rejected_pdu.itt);
>  		break;
>  	case ISCSI_REASON_IMM_CMD_REJECT:
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected. Too many "
>  				  "immediate commands.\n",
> -				  rejected_pdu.itt, opcode);
> +				  opcode, rejected_pdu.itt);
>  		/*
>  		 * We only send one TMF at a time so if the target could not
>  		 * handle it, then it should get fixed (RFC mandates that
> @@ -1059,8 +1059,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  	default:
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected. Reason "
> -				  "code 0x%x\n", rejected_pdu.itt,
> -				  rejected_pdu.opcode, reject->reason);
> +				  "code 0x%x\n", rejected_pdu.opcode,
> +				  rejected_pdu.itt, reject->reason);
>  		break;
>  	}
>  	return rc;
> 

Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
