From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/19] scsi_debug: Remove a set-but-not-used variable
Date: Fri, 25 Aug 2017 17:53:30 +0200
Message-ID: <6e387b21-055e-455f-9067-0e50af0cb155@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-19-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43189 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933881AbdHYPxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:53:33 -0400
In-Reply-To: <20170823214009.15015-19-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> This patch avoids that gcc reports the following warning when
> building with W=1:
> 
> drivers/scsi/scsi_debug.c:2264:15: warning: variable ?pcontrol? set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_debug.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3be980d47268..77a0335eb757 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2261,7 +2261,7 @@ static int resp_ie_l_pg(unsigned char * arr)
>  static int resp_log_sense(struct scsi_cmnd * scp,
>                            struct sdebug_dev_info * devip)
>  {
> -	int ppc, sp, pcontrol, pcode, subpcode, alloc_len, len, n;
> +	int ppc, sp, pcode, subpcode, alloc_len, len, n;
>  	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
>  	unsigned char *cmd = scp->cmnd;
>  
> @@ -2272,7 +2272,6 @@ static int resp_log_sense(struct scsi_cmnd * scp,
>  		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, ppc ? 1 : 0);
>  		return check_condition_result;
>  	}
> -	pcontrol = (cmd[2] & 0xc0) >> 6;
>  	pcode = cmd[2] & 0x3f;
>  	subpcode = cmd[3] & 0xff;
>  	alloc_len = get_unaligned_be16(cmd + 7);
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
