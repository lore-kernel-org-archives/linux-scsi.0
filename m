From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [patch] [SCSI] be2iscsi: cleanup a min_t() call
Date: Tue, 29 Nov 2011 12:55:13 -0800
Message-ID: <50725EF61B96174EB1803401F1A2E3733CD830D13F@EXMAIL.ad.emulex.com>
References: <20110926062337.GD11832@elgon.mountain>
 <4EC6B1C2.108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4907 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756710Ab1K2VAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2011 16:00:50 -0500
In-Reply-To: <4EC6B1C2.108@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, dan.carpenter@oracle.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Looks good.

Acked-by: Jayamohan Kallickal <Jayamohan.kallickal@emulex.com>

Thanks
Jay

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Friday, November 18, 2011 11:28 AM
To: Dan Carpenter
Cc: Kallickal, Jayamohan; James E.J. Bottomley; linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] be2iscsi: cleanup a min_t() call

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

