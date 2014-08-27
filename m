From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] be2iscsi: Fix the sparse warning introduced in previous
 submission
Date: Wed, 27 Aug 2014 15:50:20 +0200
Message-ID: <53FDE21C.70803@suse.de>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934253AbaH0NuW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 09:50:22 -0400
In-Reply-To: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 08/08/2014 06:59 AM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>
>   commit 73af08e11c6638e2abd6b1fa13cdab58c2bbdbf8
>   Author: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>   Date:   Mon May 5 21:41:26 2014 -0400
>
>    be2iscsi: Fix interrupt Coalescing mechanism.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.h | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/=
be_cmds.h
> index cc7405c..4e8cb61 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -26,9 +26,9 @@
>    * The commands are serviced by the ARM processor in the OneConnect=
's MPU.
>    */
>   struct be_sge {
> -	u32 pa_lo;
> -	u32 pa_hi;
> -	u32 len;
> +	__le32 pa_lo;
> +	__le32 pa_hi;
> +	__le32 len;
>   };
>
>   #define MCC_WRB_SGE_CNT_SHIFT 3	/* bits 3 - 7 of dword 0 */
> @@ -624,11 +624,11 @@ static inline struct be_sge *nonembedded_sgl(st=
ruct be_mcc_wrb *wrb)
>   /******************** Modify EQ Delay *******************/
>   struct be_cmd_req_modify_eq_delay {
>   	struct be_cmd_req_hdr hdr;
> -	u32 num_eq;
> +	__le32 num_eq;
>   	struct {
> -		u32 eq_id;
> -		u32 phase;
> -		u32 delay_multiplier;
> +		__le32 eq_id;
> +		__le32 phase;
> +		__le32 delay_multiplier;
>   	} delay[MAX_CPUS];
>   } __packed;
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
