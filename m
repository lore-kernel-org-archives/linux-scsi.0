From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/8] hisi_sas: add v2 hw slot complete internal abort
 support
Date: Wed, 24 Aug 2016 14:59:53 +0200
Message-ID: <5b7f8fb5-3682-06d4-9466-da38d0fe1d19@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-6-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-6-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> Add code in slot_complete_v2_hw() to deal with the
> slots which have completed due to internal abort.
> 
> The status codes have the following meaning:
> - STAT_IO_ABORTED: the IO has been aborted due to
> internal abort, whether by device or individual
> abort command
> - STAT_IO_COMPLETE: internal abort command has
> completed successfully for device or individual
> abort command
> - STAT_IO_NO_DEVICE: internal abort command has
> completed for device but cannot find any IO
> - STAT_IO_NOT_VALID: internal abort command has
> completed for single command but could not
> find the command
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index fec1675..bf9b693 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -227,6 +227,13 @@
>  #define CMPLT_HDR_RSPNS_XFRD_MSK	(0x1 << CMPLT_HDR_RSPNS_XFRD_OFF)
>  #define CMPLT_HDR_ERX_OFF		12
>  #define CMPLT_HDR_ERX_MSK		(0x1 << CMPLT_HDR_ERX_OFF)
> +#define CMPLT_HDR_ABORT_STAT_OFF	13
> +#define CMPLT_HDR_ABORT_STAT_MSK	(0x7 << CMPLT_HDR_ABORT_STAT_OFF)
> +/* abort_stat */
> +#define STAT_IO_NOT_VALID		0x1
> +#define STAT_IO_NO_DEVICE		0x2
> +#define STAT_IO_COMPLETE		0x3
> +#define STAT_IO_ABORTED			0x4
>  /* dw1 */
>  #define CMPLT_HDR_IPTT_OFF		0
>  #define CMPLT_HDR_IPTT_MSK		(0xffff << CMPLT_HDR_IPTT_OFF)
> @@ -1569,6 +1576,30 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
>  		goto out;
>  	}
>  
> +	/* Use SAS+TMF status codes */
> +	switch ((complete_hdr->dw0 & CMPLT_HDR_ABORT_STAT_MSK)
> +			>> CMPLT_HDR_ABORT_STAT_OFF) {
> +	case STAT_IO_ABORTED:
> +		/* this io has been aborted by abort command */
> +		ts->stat = SAS_ABORTED_TASK;
> +		goto out;
> +	case STAT_IO_COMPLETE:
> +		/* internal abort command complete */
> +		ts->stat = TMF_RESP_FUNC_COMPLETE;
> +		goto out;
> +	case STAT_IO_NO_DEVICE:
> +		ts->stat = TMF_RESP_FUNC_COMPLETE;
> +		goto out;
> +	case STAT_IO_NOT_VALID:
> +		/* abort single io, controller don't find
> +		 * the io need to abort
> +		 */
> +		ts->stat = TMF_RESP_FUNC_FAILED;
> +		goto out;
Hmm. This will cause the SCSI EH to kick in.
And then, according to the description abort has succeeded, it's just
that for some reason the associated command couldn't be found.
So couldn't this be due to a race condition, and the command has in fact
been aborted correctly (and the code is just too slow acknowledging it)?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
