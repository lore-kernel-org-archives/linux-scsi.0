From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/1] mpt3sas: Ignore unaligned completion length for
 ZBC_IN
Date: Mon, 13 Feb 2017 18:57:17 +0000
Message-ID: <1487012224.2719.3.camel@sandisk.com>
References: <20170213051152.27741-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58270 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdBMS5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 13:57:20 -0500
In-Reply-To: <20170213051152.27741-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <44A903E230F74742933E336EFB79397F@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

On Mon, 2017-02-13 at 14:11 +0900, Damien Le Moal wrote:
> The ZBC_IN command (REPORT ZONES) reply length is always a multiple of
> 64B and thus may not be aligned on the device LBA size.
> For this command, retry due to the unaligned completion length is
> incorrect so do not check alignment of the reply length.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 0b5b423..f04b872 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4723,8 +4723,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>  	 * then scsi-ml does not need to handle this misbehavior.
>  	 */
>  	sector_sz = scmd->device->sector_size;
> -	if (unlikely(scmd->request->cmd_type == REQ_TYPE_FS && sector_sz &&
> -		     xfer_cnt % sector_sz)) {
> +	if (scmd->request->cmd_type == REQ_TYPE_FS &&
> +	    scmd->cmnd[0] != ZBC_IN &&
> +	    sector_sz && xfer_cnt % sector_sz) {
>  		sdev_printk(KERN_INFO, scmd->device,
>  		    "unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
>  			    xfer_cnt, sector_sz);

Hello Damien,

What software generated a ZBC_IN request with type REQ_TYPE_FS? Shouldn't
all ZBC_IN requests be assigned type REQ_TYPE_BLOCK_PC?

Thanks,

Bart.
