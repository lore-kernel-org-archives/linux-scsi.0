Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFBFC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 20:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FA2222F2
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 20:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRUVe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 15:21:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:42048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726435AbfKRUVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 15:21:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6721DABF4;
        Mon, 18 Nov 2019 20:21:32 +0000 (UTC)
Subject: Re: [PATCH] lpfc: fixup out-of-bounds access during CPU hotplug
To:     James Smart <james.smart@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20191118123012.99664-1-hare@suse.de>
 <5c61c1ce-d4fc-23b8-621a-897febb89b67@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1713444f-2788-ca07-3452-efc9457215d9@suse.de>
Date:   Mon, 18 Nov 2019 21:21:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5c61c1ce-d4fc-23b8-621a-897febb89b67@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 8:28 PM, James Smart wrote:
> On 11/18/2019 4:30 AM, Hannes Reinecke wrote:
>> The lpfc driver allocates a cpu_map based on the number of possible
>> cpus during startup. If a CPU hotplug occurs the number of CPUs
>> might change, causing an out-of-bounds access when trying to lookup
>> the hardware index for a given CPU.
>>
>> Suggested-by: Daniel Wagner <daniel.wagner@suse.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c 
>> b/drivers/scsi/lpfc/lpfc_scsi.c
>> index ba26df90a36a..2380452a8efd 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -642,7 +642,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct 
>> lpfc_nodelist *ndlp,
>>       int tag;
>>       struct fcp_cmd_rsp_buf *tmp = NULL;
>> -    cpu = raw_smp_processor_id();
>> +    cpu = min_t(u32, raw_smp_processor_id(),
>> +            phba->sli4_hba.num_possible_cpu);
>>       if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
>>           tag = blk_mq_unique_tag(cmnd->request);
>>           idx = blk_mq_unique_tag_to_hwq(tag);
> 
> This should be unnecessary with the lpfc 12.6.0.1 and 12.6.0.2 patches 
> that tie into cpu onling/offlining and cpu hot add.
> 
> I am curious, how if a cpu is hot removed - how num_possible dynamically 
> changes (to a lower value ?) such that a thread can be running on a cpu 
> that returns a higher cpu number than num_possible ?
> 
Actually, the behaviour of num_possible_cpus() under cpu hotplug seems 
to be implementation-specific.
One might want to set it to the max value at all times, which has the 
drawback that you'd need to scale per-cpu values with that number, 
leading to a massive memory overhead as only very few installation will 
ever reach that number.
Others might want to set to the max value at the current configuration, 
implying that it might change under CPU hotplug.
Which seems to be the case for PowerPC, which was the case which 
triggered the issue at hand.
But maybe it was a plain bug in the CPU hotplug implementation; one 
should be asking BenH for details here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
