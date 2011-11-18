From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch] [SCSI] be2iscsi: cleanup a min_t() call
Date: Fri, 18 Nov 2011 13:28:02 -0600
Message-ID: <4EC6B1C2.108@cs.wisc.edu>
References: <20110926062337.GD11832@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47498 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1KRT2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 14:28:15 -0500
In-Reply-To: <20110926062337.GD11832@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 09/26/2011 01:23 AM, Dan Carpenter wrote:
> "sense_len" was declared as int type but actually it only stores a
> u16 value that comes from hardware.  The cast to u16 in min_t()
> confuses static analysis because it truncates the int to u16 so I've
> fixed the declaration to reflect that "sense_len" is just a u16.
> 
> Also there was a call to cpu_to_be16() which I've changed to
> be16_to_cpu().  The functions are equivalent, but obviously the
> hardware is big endian and we're doing the min_t() comparison on CPU
> endian values.
> 
> This whole patch is just a cleanup and doesn't affect how the code
> works.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Compile tested only.  Sorry.
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 57fea38..344af8d 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1104,7 +1104,6 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
>  	struct be_status_bhs *sts_bhs =
>  				(struct be_status_bhs *)io_task->cmd_bhs;
>  	struct iscsi_conn *conn = beiscsi_conn->conn;
> -	unsigned int sense_len;
>  	unsigned char *sense;
>  	u32 resid = 0, exp_cmdsn, max_cmdsn;
>  	u8 rsp, status, flags;
> @@ -1147,9 +1146,11 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
>  	}
>  
>  	if (status == SAM_STAT_CHECK_CONDITION) {
> +		u16 sense_len;
>  		unsigned short *slen = (unsigned short *)sts_bhs->sense_info;
> +
>  		sense = sts_bhs->sense_info + sizeof(unsigned short);
> -		sense_len =  cpu_to_be16(*slen);
> +		sense_len = be16_to_cpu(*slen);
>  		memcpy(task->sc->sense_buffer, sense,
>  		       min_t(u16, sense_len, SCSI_SENSE_BUFFERSIZE));

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

