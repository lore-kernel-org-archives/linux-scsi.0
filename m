From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Wed, 15 Feb 2017 16:42:56 +0000
Message-ID: <1487176942.2666.1.camel@sandisk.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46696 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdBOQn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 11:43:28 -0500
In-Reply-To: <20170215021230.11181-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <F980CD4560F7DB4EA28BF683EFF351F9@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "hch@lst.de" <hch@lst.de>

On Wed, 2017-02-15 at 11:12 +0900, Damien Le Moal wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1f5d92a..d05a328 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1790,6 +1790,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  {
>  	int result = SCpnt->result;
>  	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
> +	unsigned int sector_size = SCpnt->device->sector_size;
> +	unsigned int resid;
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
>  	struct request *req = SCpnt->request;
> @@ -1820,6 +1822,24 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  			scsi_set_resid(SCpnt, blk_rq_bytes(req));
>  		}
>  		break;
> +	default:
> +		/*
> +	 	 * In case of bogus fw or device, we could end up having
> +	 	 * an unaligned partial completion. Check this here and force
> +	 	 * alignment.
> +	 	 */
> +		resid = scsi_get_resid(SCpnt);
> +		if (resid & (sector_size - 1)) {
> +			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
> +				"Unaligned partial completion (resid=%u, sector_sz=%u)\n",
> +				resid, sector_size));
> +			resid = round_up(resid, sector_size);
> +			if (resid < good_bytes)
> +				good_bytes -= resid;
> +			else
> +				good_bytes = 0;
> +			scsi_set_resid(SCpnt, resid);
> +		}
>  	}
>  
>  	if (result) {

An additional concern: what if the size of the Data-Out buffer is not a
multiple of the logical block size? Shouldn't we round down (good_bytes -
resid) instead of rounding up resid?

Thanks,

Bart.
