Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65675C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC8F206D9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 06:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgEDGpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 02:45:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:51738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgEDGpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 02:45:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 250CFABBD;
        Mon,  4 May 2020 06:45:13 +0000 (UTC)
Subject: Re: [PATCH RFC v3 29/41] snic: use reserved commands
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-30-hare@suse.de> <20200502031916.GC1013372@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6347ffc6-48ca-789b-7765-cbcf928c3458@suse.de>
Date:   Mon, 4 May 2020 08:45:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200502031916.GC1013372@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/20 5:19 AM, Ming Lei wrote:
> On Thu, Apr 30, 2020 at 03:18:52PM +0200, Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Use a reserved command for host and device reset.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/snic/snic.h      |   4 +-
>>   drivers/scsi/snic/snic_main.c |   8 +++
>>   drivers/scsi/snic/snic_scsi.c | 140 +++++++++++++++++-------------------------
>>   3 files changed, 66 insertions(+), 86 deletions(-)
>>
>> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
>> index de0ab5fc8474..7dc529ae8a90 100644
>> --- a/drivers/scsi/snic/snic.h
>> +++ b/drivers/scsi/snic/snic.h
>> @@ -59,7 +59,6 @@
>>    */
>>   #define SNIC_TAG_ABORT		BIT(30)		/* Tag indicating abort */
>>   #define SNIC_TAG_DEV_RST	BIT(29)		/* Tag for device reset */
>> -#define SNIC_TAG_IOCTL_DEV_RST	BIT(28)		/* Tag for User Device Reset */
>>   #define SNIC_TAG_MASK		(BIT(24) - 1)	/* Mask for lookup */
>>   #define SNIC_NO_TAG		-1
>>   
>> @@ -278,6 +277,7 @@ struct snic {
>>   
>>   	/* Scsi Host info */
>>   	struct Scsi_Host *shost;
>> +	struct scsi_device *shost_dev;
>>   
>>   	/* vnic related structures */
>>   	struct vnic_dev_bar bar0;
>> @@ -380,7 +380,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>>   int snic_abort_cmd(struct scsi_cmnd *);
>>   int snic_device_reset(struct scsi_cmnd *);
>>   int snic_host_reset(struct scsi_cmnd *);
>> -int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
>> +int snic_reset(struct Scsi_Host *);
>>   void snic_shutdown_scsi_cleanup(struct snic *);
>>   
>>   
>> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
>> index 14f4ce665e58..f520da64ec8e 100644
>> --- a/drivers/scsi/snic/snic_main.c
>> +++ b/drivers/scsi/snic/snic_main.c
>> @@ -303,6 +303,7 @@ static int
>>   snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
>>   {
>>   	int ret = 0;
>> +	struct snic *snic = shost_priv(shost);
>>   
>>   	ret = scsi_add_host(shost, &pdev->dev);
>>   	if (ret) {
>> @@ -313,6 +314,12 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev *pdev)
>>   		return ret;
>>   	}
>>   
>> +	snic->shost_dev = scsi_get_virtual_dev(shost, 1, 0);
>> +	if (!snic->shost_dev) {
>> +		SNIC_HOST_ERR(shost,
>> +			      "snic: scsi_get_virtual_dev failed\n");
>> +		return -ENOMEM;
>> +	}
>>   	SNIC_BUG_ON(shost->work_q != NULL);
>>   	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%d",
>>   		 shost->host_no);
>> @@ -385,6 +392,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   
>>   		goto prob_end;
>>   	}
>> +	shost->nr_reserved_cmds = 2;
> 
> Not see .can_queue is increased by 2 in this patch, please comment on
> the reason. Otherwise, IO performance drop may be caused.
> 
snic is requiring a tag for both LU reset and Host reset.
We do require one tag for SCSI EH, and I'm setting aside another one for 
ioctl commands.
Will be adding a comment here explaining things.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
