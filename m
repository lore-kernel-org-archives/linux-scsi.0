Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50843C433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271C7205CB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGNHjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:39:13 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2471 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbgGNHjM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:39:12 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 364EF8FD5691EF94FDA6;
        Tue, 14 Jul 2020 08:39:10 +0100 (IST)
Received: from [127.0.0.1] (10.47.10.169) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 14 Jul
 2020 08:39:08 +0100
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
From:   John Garry <john.garry@huawei.com>
To:     <don.brace@microsemi.com>, Hannes Reinecke <hare@suse.de>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
Message-ID: <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
Date:   Tue, 14 Jul 2020 08:37:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1591810159-240929-13-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.169]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/06/2020 18:29, John Garry wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The smart array HBAs can steer interrupt completion, so this
> patch switches the implementation to use multiqueue and enables
> 'host_tagset' as the HBA has a shared host-wide tagset.
> 

Hi Don,

I am preparing the next iteration of this series, and we're getting 
close to dropping the RFC tags. The series has grown a bit, and I am not 
sure what to do with hpsa support.

The latest versions of this series have not been tested for hpsa, AFAIK. 
Can you let me know if you can test and review this patch? Or someone 
else let me know it's tested (Hannes?)

Thanks

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/hpsa.c | 44 +++++++-------------------------------------
>   drivers/scsi/hpsa.h |  1 -
>   2 files changed, 7 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1e9302e99d05..f807f9bdae85 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -980,6 +980,7 @@ static struct scsi_host_template hpsa_driver_template = {
>   	.shost_attrs = hpsa_shost_attrs,
>   	.max_sectors = 2048,
>   	.no_write_same = 1,
> +	.host_tagset = 1,
>   };
>   
>   static inline u32 next_command(struct ctlr_info *h, u8 q)
> @@ -1144,12 +1145,14 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
>   static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
>   	struct CommandList *c, int reply_queue)
>   {
> +	u32 blk_tag = blk_mq_unique_tag(c->scsi_cmd->request);
> +
>   	dial_down_lockup_detection_during_fw_flash(h, c);
>   	atomic_inc(&h->commands_outstanding);
>   	if (c->device)
>   		atomic_inc(&c->device->commands_outstanding);
>   
> -	reply_queue = h->reply_map[raw_smp_processor_id()];
> +	reply_queue = blk_mq_unique_tag_to_hwq(blk_tag);
>   	switch (c->cmd_type) {
>   	case CMD_IOACCEL1:
>   		set_ioaccel1_performant_mode(h, c, reply_queue);
> @@ -5653,8 +5656,6 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
>   	/* Get the ptr to our adapter structure out of cmd->host. */
>   	h = sdev_to_hba(cmd->device);
>   
> -	BUG_ON(cmd->request->tag < 0);
> -
>   	dev = cmd->device->hostdata;
>   	if (!dev) {
>   		cmd->result = DID_NO_CONNECT << 16;
> @@ -5830,7 +5831,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
>   	sh->hostdata[0] = (unsigned long) h;
>   	sh->irq = pci_irq_vector(h->pdev, 0);
>   	sh->unique_id = sh->irq;
> -
> +	sh->nr_hw_queues = h->msix_vectors > 0 ? h->msix_vectors : 1;
>   	h->scsi_host = sh;
>   	return 0;
>   }
> @@ -5856,7 +5857,8 @@ static int hpsa_scsi_add_host(struct ctlr_info *h)
>    */
>   static int hpsa_get_cmd_index(struct scsi_cmnd *scmd)
>   {
> -	int idx = scmd->request->tag;
> +	u32 blk_tag = blk_mq_unique_tag(scmd->request);
> +	int idx = blk_mq_unique_tag_to_tag(blk_tag);
>   
>   	if (idx < 0)
>   		return idx;
> @@ -7456,26 +7458,6 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
>   	h->msix_vectors = 0;
>   }
>   
> -static void hpsa_setup_reply_map(struct ctlr_info *h)
> -{
> -	const struct cpumask *mask;
> -	unsigned int queue, cpu;
> -
> -	for (queue = 0; queue < h->msix_vectors; queue++) {
> -		mask = pci_irq_get_affinity(h->pdev, queue);
> -		if (!mask)
> -			goto fallback;
> -
> -		for_each_cpu(cpu, mask)
> -			h->reply_map[cpu] = queue;
> -	}
> -	return;
> -
> -fallback:
> -	for_each_possible_cpu(cpu)
> -		h->reply_map[cpu] = 0;
> -}
> -
>   /* If MSI/MSI-X is supported by the kernel we will try to enable it on
>    * controllers that are capable. If not, we use legacy INTx mode.
>    */
> @@ -7872,9 +7854,6 @@ static int hpsa_pci_init(struct ctlr_info *h)
>   	if (err)
>   		goto clean1;
>   
> -	/* setup mapping between CPU and reply queue */
> -	hpsa_setup_reply_map(h);
> -
>   	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
>   	if (err)
>   		goto clean2;	/* intmode+region, pci */
> @@ -8613,7 +8592,6 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
>   
>   static void hpda_free_ctlr_info(struct ctlr_info *h)
>   {
> -	kfree(h->reply_map);
>   	kfree(h);
>   }
>   
> @@ -8622,14 +8600,6 @@ static struct ctlr_info *hpda_alloc_ctlr_info(void)
>   	struct ctlr_info *h;
>   
>   	h = kzalloc(sizeof(*h), GFP_KERNEL);
> -	if (!h)
> -		return NULL;
> -
> -	h->reply_map = kcalloc(nr_cpu_ids, sizeof(*h->reply_map), GFP_KERNEL);
> -	if (!h->reply_map) {
> -		kfree(h);
> -		return NULL;
> -	}
>   	return h;
>   }
>   
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index f8c88fc7b80a..ea4a609e3eb7 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -161,7 +161,6 @@ struct bmic_controller_parameters {
>   #pragma pack()
>   
>   struct ctlr_info {
> -	unsigned int *reply_map;
>   	int	ctlr;
>   	char	devname[8];
>   	char    *product_name;
> 

