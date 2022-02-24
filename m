Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DE9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 18:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiBXSTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 13:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiBXSTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 13:19:51 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1323F1E2FFF;
        Thu, 24 Feb 2022 10:19:19 -0800 (PST)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4Ldt6Hj4z67wql;
        Fri, 25 Feb 2022 02:14:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 19:19:17 +0100
Received: from [10.47.86.126] (10.47.86.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 24 Feb
 2022 18:19:16 +0000
Message-ID: <1231b97e-88aa-1e1b-4fec-9728ce066284@huawei.com>
Date:   Thu, 24 Feb 2022 18:19:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/8] scsi: remove the cmd field from struct scsi_request
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Bart Van Assche" <bvanassche@acm.org>
References: <20220224175552.988286-1-hch@lst.de>
 <20220224175552.988286-4-hch@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220224175552.988286-4-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.126]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2022 17:55, Christoph Hellwig wrote:
> Now that each scsi_request is backed by a scsi_cmnd, there is no
> need to indirect the CDB storage.  Change all submitters of SCSI
> passthrough requests to store the CDB information directly in the
> scsi_cmnd, and while doing so allocate the full 32 bytes that cover
> all Linux supported SCSI hosts instead of requiring dynamic allocation
> for > 16 byte CDBs.  On 64-bit systems this does not change the size of
> the scsi_cmnd at all, while on 32-bit systems it slightly increases it
> for now, but that increase will be made up by the removal of the
> remaining scsi_request fields.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

I had just finished going through the v1 of this patch and this seems 
identical, so, FWIW:

Reviewed-by: John Garry <john.garry@huawei.com>

Just a minor comment below (feel free to ignore).

> ---
>   drivers/ata/libata-scsi.c           |  4 +++-
>   drivers/block/pktcdvd.c             |  6 +++--
>   drivers/scsi/scsi_bsg.c             | 23 +++++++++---------
>   drivers/scsi/scsi_debugfs.c         |  4 +---
>   drivers/scsi/scsi_error.c           | 28 +++++++++++-----------
>   drivers/scsi/scsi_ioctl.c           | 37 +++++++++++++----------------
>   drivers/scsi/scsi_lib.c             | 19 +++++++--------
>   drivers/scsi/scsi_logging.c         |  5 +---
>   drivers/scsi/sd.c                   | 28 +---------------------
>   drivers/scsi/sg.c                   | 30 +++++++++--------------
>   drivers/scsi/sr.c                   | 24 ++++++++++---------
>   drivers/scsi/st.c                   | 12 ++++++----
>   drivers/scsi/ufs/ufshpb.c           | 22 ++++++++---------
>   drivers/target/target_core_pscsi.c  | 12 ++++++----
>   drivers/usb/storage/cypress_atacb.c |  1 -
>   drivers/usb/storage/isd200.c        |  4 ++--
>   include/scsi/scsi_cmnd.h            |  7 +-----
>   include/scsi/scsi_eh.h              |  4 +---
>   include/scsi/scsi_request.h         | 11 ---------
>   19 files changed, 113 insertions(+), 168 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index ed8be585a98f7..c8283bd4ffd15 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1022,7 +1022,9 @@ void ata_scsi_sdev_config(struct scsi_device *sdev)
>    */
>   bool ata_scsi_dma_need_drain(struct request *rq)
>   {
> -	return atapi_cmd_type(scsi_req(rq)->cmd[0]) == ATAPI_MISC;
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +
> +	return atapi_cmd_type(scmd->cmnd[0]) == ATAPI_MISC;
>   }
>   EXPORT_SYMBOL_GPL(ata_scsi_dma_need_drain);
>   
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 2b6b70a39e760..42c284b2d7f93 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -693,6 +693,7 @@ static void pkt_rbtree_insert(struct pktcdvd_device *pd, struct pkt_rb_node *nod
>   static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
>   {
>   	struct request_queue *q = bdev_get_queue(pd->bdev);
> +	struct scsi_cmnd *scmd;
>   	struct request *rq;
>   	int ret = 0;
>   
> @@ -700,6 +701,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
>   			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
>   	if (IS_ERR(rq))
>   		return PTR_ERR(rq);
> +	scmd = blk_mq_rq_to_pdu(rq);
>   
>   	if (cgc->buflen) {
>   		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
> @@ -708,8 +710,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
>   			goto out;
>   	}
>   
> -	scsi_req(rq)->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
> -	memcpy(scsi_req(rq)->cmd, cgc->cmd, CDROM_PACKET_SIZE);
> +	scmd->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
> +	memcpy(scmd->cmnd, cgc->cmd, CDROM_PACKET_SIZE);
>   
>   	rq->timeout = 60*HZ;
>   	if (cgc->quiet)
> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index b7a464383cc0b..f8b65bd75ee10 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c
> @@ -13,6 +13,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
>   		fmode_t mode, unsigned int timeout)
>   {
>   	struct scsi_request *sreq;
> +	struct scsi_cmnd *scmd;
>   	struct request *rq;
>   	struct bio *bio;
>   	int ret;
> @@ -33,19 +34,19 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
>   
>   	ret = -ENOMEM;
>   	sreq = scsi_req(rq);
> -	sreq->cmd_len = hdr->request_len;
> -	if (sreq->cmd_len > BLK_MAX_CDB) {
> -		sreq->cmd = kzalloc(sreq->cmd_len, GFP_KERNEL);
> -		if (!sreq->cmd)
> -			goto out_put_request;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->cmd_len = hdr->request_len;
> +	if (scmd->cmd_len > sizeof(scmd->cmnd)) {

You might be able to move this check earlier (before the request 
allocation), but no big deal.

