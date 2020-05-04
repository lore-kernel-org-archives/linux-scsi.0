Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47717C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32CA1206E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgEDKWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 06:22:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgEDKWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 06:22:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D8A66AC53;
        Mon,  4 May 2020 10:22:01 +0000 (UTC)
Subject: Re: [PATCH RFC v3 06/41] virtio_scsi: use reserved commands for TMF
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-7-hare@suse.de> <20200504092543.GC1139563@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2957db37-3aca-ece5-23b1-0bceba45e10b@suse.de>
Date:   Mon, 4 May 2020 12:21:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504092543.GC1139563@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/20 11:25 AM, Ming Lei wrote:
> On Thu, Apr 30, 2020 at 03:18:29PM +0200, Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Set two commands aside for TMF, and use reserved commands to issue
>> TMFs. With that we can drop the TMF memory pool.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/virtio_scsi.c | 105 ++++++++++++++++++---------------------------
>>   1 file changed, 41 insertions(+), 64 deletions(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 0e0910c5b942..26054c29d897 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -35,10 +35,10 @@
>>   #define VIRTIO_SCSI_MEMPOOL_SZ 64
>>   #define VIRTIO_SCSI_EVENT_LEN 8
>>   #define VIRTIO_SCSI_VQ_BASE 2
>> +#define VIRTIO_SCSI_RESERVED_CMDS 2
>>   
>>   /* Command queue element */
>>   struct virtio_scsi_cmd {
>> -	struct scsi_cmnd *sc;
>>   	struct completion *comp;
>>   	union {
>>   		struct virtio_scsi_cmd_req       cmd;
>> @@ -86,9 +86,6 @@ struct virtio_scsi {
>>   	struct virtio_scsi_vq req_vqs[];
>>   };
>>   
>> -static struct kmem_cache *virtscsi_cmd_cache;
>> -static mempool_t *virtscsi_cmd_pool;
>> -
>>   static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
>>   {
>>   	return vdev->priv;
>> @@ -108,7 +105,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
>>   static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>>   {
>>   	struct virtio_scsi_cmd *cmd = buf;
>> -	struct scsi_cmnd *sc = cmd->sc;
>> +	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
>>   	struct virtio_scsi_cmd_resp *resp = &cmd->resp.cmd;
>>   
>>   	dev_dbg(&sc->device->sdev_gendev,
>> @@ -406,7 +403,7 @@ static int __virtscsi_add_cmd(struct virtqueue *vq,
>>   			    struct virtio_scsi_cmd *cmd,
>>   			    size_t req_size, size_t resp_size)
>>   {
>> -	struct scsi_cmnd *sc = cmd->sc;
>> +	struct scsi_cmnd *sc = scsi_cmd_from_priv(cmd);
>>   	struct scatterlist *sgs[6], req, resp;
>>   	struct sg_table *out, *in;
>>   	unsigned out_num = 0, in_num = 0;
>> @@ -557,8 +554,6 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>>   	dev_dbg(&sc->device->sdev_gendev,
>>   		"cmd %p CDB: %#02x\n", sc, sc->cmnd[0]);
>>   
>> -	cmd->sc = sc;
>> -
>>   	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
>>   
>>   #ifdef CONFIG_BLK_DEV_INTEGRITY
>> @@ -590,17 +585,17 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>>   static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
>>   {
>>   	DECLARE_COMPLETION_ONSTACK(comp);
>> -	int ret = FAILED;
>>   
>>   	cmd->comp = &comp;
>> +
>>   	if (virtscsi_add_cmd(&vscsi->ctrl_vq, cmd,
>>   			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf, true) < 0)
> 
> virtscsi uses dedicated ->ctrl_vq to send TMF, and ->ctrl_vq isn't
> nothing to do with vqs(->vqs[]) for sending IO request.
> 
Indeed, you are right.
We should be handling this by adding a virtual LUN corresponding the the 
ctrl_vq and allocate commands from there.

Will be updating for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
