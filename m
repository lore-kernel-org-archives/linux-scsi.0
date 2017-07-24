From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset
Date: Mon, 24 Jul 2017 18:24:14 +0200
Message-ID: <30be74a1-9b59-094e-8afb-5655a051ed6d@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43895 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752513AbdGXQYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 12:24:21 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6OGO1qp049410
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:24:21 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bwegfrvve-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 12:24:20 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 17:24:19 +0100
In-Reply-To: <1498638793-44672-10-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>



On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
> When issuing a host reset we should be waiting for all
> ports to become unblocked; just waiting for one might
> be resulting in host reset to return too early.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/s390/scsi/zfcp_scsi.c | 27 +++++++++++++++++++++++----
>   1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index 0678cf7..3d18659 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -311,13 +311,32 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> 
>   static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>   {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> -	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> -	int ret;
> +	struct Scsi_Host *host = scpnt->device->host;
> +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];

Oh, only realized when reading the later "[PATCH 14/47] scsi: Use 
Scsi_Host as argument for eh_host_reset_handler" that this part already 
anticipates parts of that later patch. Seems not fully topically 
separated patches to me, if this one is only about the fc_block_scsi_eh 
aspect in zfcp_scsi_eh_host_reset_handler().


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
