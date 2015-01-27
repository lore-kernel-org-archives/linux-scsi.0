From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/17] ibmvscsi: Fix bidi command test
Date: Tue, 27 Jan 2015 14:10:48 -0800
Message-ID: <54C80CE8.40506@linux.vnet.ibm.com>
References: <54C2390A.3000700@sandisk.com> <54C23A2F.1090005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45063 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760124AbbA0WKz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 17:10:55 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Tue, 27 Jan 2015 17:10:54 -0500
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7CBF538C8026
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2015 17:10:51 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0RMApo727394292
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2015 22:10:51 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0RMAnql017856
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2015 17:10:49 -0500
In-Reply-To: <54C23A2F.1090005@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>

On 01/23/2015 04:10 AM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index acea5d6..cf26b33 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -765,16 +765,18 @@ static int map_data_for_srp_cmd(struct scsi_cmnd *cmd,
>  				struct srp_event_struct *evt_struct,
>  				struct srp_cmd *srp_cmd, struct device *dev)
>  {
> +	if (scsi_bidi_cmnd(cmd)) {
> +		sdev_printk(KERN_ERR, cmd->device,
> +			    "Bidirectional commands are not yet supported\n");
> +		return 0;
> +	}
> +

Is there a particular problem this solves, or is this simply a change to
use the bidi API in place of checking sc_data_direction for
DMA_BIDIRECTIONAL?

-Tyrel

>  	switch (cmd->sc_data_direction) {
>  	case DMA_FROM_DEVICE:
>  	case DMA_TO_DEVICE:
>  		break;
>  	case DMA_NONE:
>  		return 1;
> -	case DMA_BIDIRECTIONAL:
> -		sdev_printk(KERN_ERR, cmd->device,
> -			    "Can't map DMA_BIDIRECTIONAL to read/write\n");
> -		return 0;
>  	default:
>  		sdev_printk(KERN_ERR, cmd->device,
>  			    "Unknown data direction 0x%02x; can't map!\n",
> 

