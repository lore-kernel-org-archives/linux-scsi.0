Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E325C71C
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219107; cv=none; b=fm0ora0kdE1JlS3swPbrT5+TL/ffB39HmaiaHpTw5wEjnUlvlxKoO+XLML+NqH2Q1EwaMJ9NkTGB7tMg2D6nYOMkF+eaiEhk+zz1Wgb2OD+PqaC324BI1Mcw/PKa79GSgy/a9Dl6ujZwhFFlTvTyEQVsqLLnN/zgcuEwk6tVnAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219107; c=relaxed/simple;
	bh=6imizPB8DTAmx5T0ZnrVTxcjT6yTsbGhyI641hmSrls=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=EGPseHcDXiFCzirPLDJZkFRf76rpmXx72Vt66hWIcMaoK9csnkGT6I+uyDSbEIi3l5fgnENiJkdcT5Wg7tMLQnWjPIci8EW8VYMpD0txKAS9JPhh5yTzj1m/jlmPNZqPuI1iNryZJbKadowTu4KkwZns3GBjL2R2iCGg8bnp1mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AClVlOhT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AClVlOhT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739219103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iPOBe+Uwlx3L1+ARNdkzXMkHsDFVFStQPqRJpWJWW1I=;
	b=AClVlOhTZ/M2GUSoA+4qA9qeyyDjkYc4VdsxJ2q9r8P7bpbm5yS9apELXrualDxfL9aMPl
	SHwGapvpCPJFZNX987rQvHNqET8iIzYf9mcTbAmABGFYvqDHHWmfmAgZIOSS6WqOpqPfUK
	c0n6WFbIY4TFKIKplbHtRWWtyovM5NE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-88-1dCl5-A0NPesm6zhdhwrcA-1; Mon,
 10 Feb 2025 15:25:00 -0500
X-MC-Unique: 1dCl5-A0NPesm6zhdhwrcA-1
X-Mimecast-MFC-AGG-ID: 1dCl5-A0NPesm6zhdhwrcA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6FF01800873;
	Mon, 10 Feb 2025 20:24:58 +0000 (UTC)
Received: from [10.22.80.239] (unknown [10.22.80.239])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 757821800352;
	Mon, 10 Feb 2025 20:24:56 +0000 (UTC)
Message-ID: <45ccb6f1-e352-4499-aa16-f22c70d0e186@redhat.com>
Date: Mon, 10 Feb 2025 15:24:55 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
From: John Meneghini <jmeneghi@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Marco Patalano <mpatalan@redhat.com>,
 Scott Benesh <Scott.Benesh@microchip.com>,
 Don Brace <Don.Brace@microchip.com>, Tom White <Tom.White@microchip.com>,
 Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>,
 linux-scsi@vger.kernel.org, Sagar Biradar <sagar.biradar@microchip.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <7f055e1d-fdff-4fe9-a522-dbb22662e810@redhat.com>
Content-Language: en-US
Organization: RHEL Core Storge Team
In-Reply-To: <7f055e1d-fdff-4fe9-a522-dbb22662e810@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Someone told me this email was confusing.

To be clear: Red Hat has reviewed and tested multiple versions of this patch internally and
we are shipping an out of tree version of this patch in RHEL-8.  These changes provide
a critical fix for one of our customers who is using aacraid in a production environment
with offline cpu support. We've asked Sagar to submit this private version of his patch
upstream but he found that it needed some rework because of the recent changes made by patch
(bd326a5ad6397c scsi: replace blk_mq_pci_map_queues with blk_mq_map_hw_queues)

So after refactoring his patch I asked our Red Hat QA department to retest this latest
version the patch with an upstream kernel.

What's included below is a description of the origin problem that was seen with
a RHEL-10 kernel, based on v6.9, with a description of the test that was run.

All tests are passing with this patch based on scsi/6.14/staging.

Martin, can we please merge this into 6.14, or perhaps 6.15?

/John

On 2/10/25 12:20 PM, John Meneghini wrote:
> This patch has already been Reviewed-by and Tested-by Red Hat.
> 
> However, after applying this patch to scsi/6.14/staging I've asked our QA engineer, Marco Patalono,
> to please re-test this patch and confirm this it fixes the problem.
> 
> What were you trying to do that didn't work?
> 
> While running the offline CPU automation on my system with an ASR405 storage controller
> (AACRAID), I hit the following hung_task_timeouts:
> 
> [   85.132499] aacraid: Host adapter abort request.
> [   85.132499] aacraid: Outstanding commands on (0,1,3,0):
> [  103.569532] aacraid: Host adapter abort request.
> [  103.569532] aacraid: Outstanding commands on (0,1,3,0):
> [  106.897528] aacraid: Host adapter abort request.
> [  106.897528] aacraid: Outstanding commands on (0,1,3,0):
> [  106.912542] aacraid: Host bus reset request. SCSI hang ?
> [  106.919612] aacraid 0000:84:00.0: Controller reset type is 3
> [-- MARK -- Fri Jun 14 16:10:00 2024]
> [  188.472054] aacraid: Comm Interface type2 enabled
> [  270.986453] aacraid: Host adapter abort request.
> [  270.986453] aacraid: Outstanding commands on (0,1,3,0):
> [  271.006495] aacraid: Host bus reset request. SCSI hang ?
> [  271.020473] aacraid 0000:84:00.0: Controller reset type is 3
> [  352.307955] aacraid: Comm Interface type2 enabled
> [  369.271587] INFO: task kworker/u65:1:130 blocked for more than 122 seconds.
> [  369.271599]       Not tainted 6.9.0-7.el10.x86_64 #1
> [  369.271604] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.271977] INFO: task kworker/u65:2:132 blocked for more than 122 seconds.
> [  369.271980]       Not tainted 6.9.0-7.el10.x86_64 #1
> [  369.271981] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.272344] INFO: task xfsaild/dm-0:778 blocked for more than 122 seconds.
> [  369.272346]       Not tainted 6.9.0-7.el10.x86_64 #1
> [  369.272348] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.273538] INFO: task restraintd:1399 blocked for more than 122 seconds.
> [  369.273541]       Not tainted 6.9.0-7.el10.x86_64 #1
> [  369.273542] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  369.273895] INFO: task main.sh:1900 blocked for more than 122 seconds.
> [  369.273897]       Not tainted 6.9.0-7.el10.x86_64 #1
> [  369.273898] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  373.404946] sd 0:1:3:0: [sdb] tag#454 timing out command, waited 180s
> [  424.076623] aacraid: Host adapter abort request.
> [  424.076623] aacraid: Outstanding commands on (0,1,3,0):
> 
> Please provide the package NVR for which bug is seen:
> RHEL-10.0-20240603.86
> 
> kernel-6.9.0-7.el10
> 
> How reproducible: Often
> 
> Steps to reproduce:
> Generate I/O to disks controller by the ASR8405
> Offline all CPUs except 2
> Online all CPUs
> 
> With the patched/upstream kernel provided, I am not seeing any issues when running
> the offline CPU automation after loading the module parameter as shown below:
> 
> # echo 'options aacraid aac_cpu_offline_feature=1' | sudo tee /etc/modprobe.d/aacraid.conf
> # dracut -f
> # reboot
> 
> Tested-by: Marco Patalano <mpatalan@redhat.com>
> 
> On 1/30/25 12:33 PM, Sagar Biradar wrote:
>> patch "(9dc704dcc09e scsi: aacraid: Reply queue mapping to
>> CPUs based on IRQ affinity)" caused issues starting V6.4.0,
>> which was later reverted by
>> patch "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs
>> based on IRQ affinity)"
>>
>> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining.
>> By default, it's disabled (0), but can be enabled during driver load
>> with:
>>     insmod ./aacraid.ko aac_cpu_offline_feature=1
>> Enabling this feature allows CPU offlining but may cause some IO
>> performance drop. It is recommended to enable it during driver load as
>> the relevant changes are part of the initialization routine.
>>
>> Fixes an I/O hang that arises because of an MSIx vector not having a
>> mapped online CPU upon receiving completion.
>>
>> SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()
>> and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.
>>
>> For reserved cmds, or the ones before the blk_mq init, use the vector_no
>> 0, which is the norm since don't yet have a proper mapping to the queues.
>>
>> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
>> Reviewed-by:John Meneghini <jmeneghi@redhat.com>
>> Reviewed-by:Tomas Henzl <thenzl@redhat.com>
>> Tested-by: Marco Patalano <mpatalan@redhat.com>
>> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
>> ---
>>   drivers/scsi/aacraid/aachba.c  |  6 ++++++
>>   drivers/scsi/aacraid/aacraid.h |  2 ++
>>   drivers/scsi/aacraid/commsup.c |  9 ++++++++-
>>   drivers/scsi/aacraid/linit.c   | 24 ++++++++++++++++++++++++
>>   drivers/scsi/aacraid/src.c     | 28 ++++++++++++++++++++++++++--
>>   5 files changed, 66 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
>> index abf6a82b74af..f325e79a1a01 100644
>> --- a/drivers/scsi/aacraid/aachba.c
>> +++ b/drivers/scsi/aacraid/aachba.c
>> @@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
>>       "\t1 - Array Meta Data Signature (default)\n"
>>       "\t2 - Adapter Serial Number");
>> +int aac_cpu_offline_feature;
>> +module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int, 0644);
>> +MODULE_PARM_DESC(aac_cpu_offline_feature,
>> +    "This enables CPU offline feature and may result in IO performance drop in some cases:\n"
>> +    "\t0 - Disable (default)\n"
>> +    "\t1 - Enable");
>>   static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
>>           struct fib *fibptr) {
>> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
>> index 8c384c25dca1..dba7ffc6d543 100644
>> --- a/drivers/scsi/aacraid/aacraid.h
>> +++ b/drivers/scsi/aacraid/aacraid.h
>> @@ -1673,6 +1673,7 @@ struct aac_dev
>>       u32            handle_pci_error;
>>       bool            init_reset;
>>       u8            soft_reset_support;
>> +    u8            use_map_queue;
>>   };
>>   #define aac_adapter_interrupt(dev) \
>> @@ -2777,4 +2778,5 @@ extern int update_interval;
>>   extern int check_interval;
>>   extern int aac_check_reset;
>>   extern int aac_fib_dump;
>> +extern int aac_cpu_offline_feature;
>>   #endif
>> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
>> index ffef61c4aa01..1d62730e5c1b 100644
>> --- a/drivers/scsi/aacraid/commsup.c
>> +++ b/drivers/scsi/aacraid/commsup.c
>> @@ -223,8 +223,15 @@ int aac_fib_setup(struct aac_dev * dev)
>>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>>   {
>>       struct fib *fibptr;
>> +    u32 blk_tag;
>> +    int i;
>> -    fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>> +    if (aac_cpu_offline_feature == 1) {
>> +        blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
>> +        i = blk_mq_unique_tag_to_tag(blk_tag);
>> +        fibptr = &dev->fibs[i];
>> +    } else
>> +        fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>>       /*
>>        *    Null out fields that depend on being zero at the start of
>>        *    each I/O
>> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
>> index 91170a67cc91..fc4d35950ccb 100644
>> --- a/drivers/scsi/aacraid/linit.c
>> +++ b/drivers/scsi/aacraid/linit.c
>> @@ -506,6 +506,23 @@ static int aac_sdev_configure(struct scsi_device *sdev,
>>       return 0;
>>   }
>> +/**
>> + *    aac_map_queues - Map hardware queues for the SCSI host
>> + *    @shost: SCSI host structure
>> + *
>> + *    Maps the default hardware queue for the given SCSI host to the
>> + *    corresponding PCI device and enables mapped queue usage.
>> + */
>> +
>> +static void aac_map_queues(struct Scsi_Host *shost)
>> +{
>> +    struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>> +
>> +    blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
>> +                &aac->pdev->dev, 0);
>> +    aac->use_map_queue = true;
>> +}
>> +
>>   /**
>>    *    aac_change_queue_depth        -    alter queue depths
>>    *    @sdev:    SCSI device we are considering
>> @@ -1490,6 +1507,7 @@ static const struct scsi_host_template aac_driver_template = {
>>       .bios_param            = aac_biosparm,
>>       .shost_groups            = aac_host_groups,
>>       .sdev_configure            = aac_sdev_configure,
>> +    .map_queues            = aac_map_queues,
>>       .change_queue_depth        = aac_change_queue_depth,
>>       .sdev_groups            = aac_dev_groups,
>>       .eh_abort_handler        = aac_eh_abort,
>> @@ -1777,6 +1795,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>>       shost->max_lun = AAC_MAX_LUN;
>>       pci_set_drvdata(pdev, shost);
>> +    if (aac_cpu_offline_feature == 1) {
>> +        shost->nr_hw_queues = aac->max_msix;
>> +        shost->can_queue    = aac->vector_cap;
>> +        shost->host_tagset = 1;
>> +    }
>>       error = scsi_add_host(shost, &pdev->dev);
>>       if (error)
>> @@ -1908,6 +1931,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>>       struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>>       aac_cancel_rescan_worker(aac);
>> +    aac->use_map_queue = false;
>>       scsi_remove_host(shost);
>>       __aac_shutdown(aac);
>> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
>> index 28115ed637e8..b9bed3e255c4 100644
>> --- a/drivers/scsi/aacraid/src.c
>> +++ b/drivers/scsi/aacraid/src.c
>> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)
>>   #endif
>>       u16 vector_no;
>> +    struct scsi_cmnd *scmd;
>> +    u32 blk_tag;
>> +    struct Scsi_Host *shost = dev->scsi_host_ptr;
>> +    struct blk_mq_queue_map *qmap;
>>       atomic_inc(&q->numpending);
>> @@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)
>>           if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>>               && dev->sa_firmware)
>>               vector_no = aac_get_vector(dev);
>> -        else
>> -            vector_no = fib->vector_no;
>> +        else {
>> +            if (aac_cpu_offline_feature == 1) {
>> +                if (!fib->vector_no || !fib->callback_data) {
>> +                    if (shost && dev->use_map_queue) {
>> +                        qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
>> +                    vector_no = qmap->mq_map[raw_smp_processor_id()];
>> +                    }
>> +                    /*
>> +                     *    We hardcode the vector_no for
>> +                     *    reserved commands as a valid shost is
>> +                     *    absent during the init
>> +                     */
>> +                    else
>> +                        vector_no = 0;
>> +                } else {
>> +                    scmd = (struct scsi_cmnd *)fib->callback_data;
>> +                    blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
>> +                    vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
>> +                }
>> +            } else
>> +                vector_no = fib->vector_no;
>> +        }
>>           if (native_hba) {
>>               if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
> 

