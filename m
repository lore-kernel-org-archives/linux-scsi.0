Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Nov 2023 22:42:25 PST
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960CEAD;
	Thu, 23 Nov 2023 22:42:25 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDB6E1F750;
	Fri, 24 Nov 2023 06:32:55 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F03C1340B;
	Fri, 24 Nov 2023 06:32:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dNduD5ZDYGWtMgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 Nov 2023 06:32:54 +0000
Message-ID: <89913549-cced-42c0-bcf3-33cea19353ee@suse.de>
Date: Fri, 24 Nov 2023 07:32:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 Sagar Biradar <sagar.biradar@microchip.com>,
 Don Brace <don.brace@microchip.com>, Gilbert Wu <gilbert.wu@microchip.com>,
 linux-scsi@vger.kernel.org, Martin Petersen <martin.petersen@oracle.com>,
 James Bottomley <jejb@linux.ibm.com>, Brian King
 <brking@linux.vnet.ibm.com>, stable@vger.kernel.org,
 Tom White <tom.white@microchip.com>, regressions@leemhuis.info, hare@suse.com
References: <20230519230834.27436-1-sagar.biradar@microchip.com>
 <c830058d-8d03-4da4-bdd4-0e56c567308f@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <c830058d-8d03-4da4-bdd4-0e56c567308f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++++
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [10.30 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 ARC_NA(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 RCPT_COUNT_TWELVE(0.00)[12];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]
X-Spam-Score: 10.30
X-Rspamd-Queue-Id: CDB6E1F750

On 11/23/23 13:01, John Garry wrote:
> On 20/05/2023 00:08, Sagar Biradar wrote:
>> Fix the IO hang that arises because of MSIx vector not
>> having a mapped online CPU upon receiving completion.
>>
>> The SCSI cmds take the blk_mq route, which is setup during the init.
>> The reserved cmds fetch the vector_no from mq_map after the init
>> is complete and before the init, they use 0 - as per the norm.
>>
>> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>
>> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>
> 
> This the patch which seems to be causing the issue in 
> https://bugzilla.kernel.org/show_bug.cgi?id=217599
> 
> I will comment here since I got no response there...
> 
>> ---
>>   drivers/scsi/aacraid/aacraid.h  |  1 +
>>   drivers/scsi/aacraid/comminit.c |  1 -
>>   drivers/scsi/aacraid/commsup.c  |  6 +++++-
>>   drivers/scsi/aacraid/linit.c    | 14 ++++++++++++++
>>   drivers/scsi/aacraid/src.c      | 25 +++++++++++++++++++++++--
>>   5 files changed, 43 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/aacraid.h 
>> b/drivers/scsi/aacraid/aacraid.h
>> index 5e115e8b2ba4..7c6efde75da6 100644
>> --- a/drivers/scsi/aacraid/aacraid.h
>> +++ b/drivers/scsi/aacraid/aacraid.h
>> @@ -1678,6 +1678,7 @@ struct aac_dev
>>       u32            handle_pci_error;
>>       bool            init_reset;
>>       u8            soft_reset_support;
>> +    u8            use_map_queue;
>>   };
>>   #define aac_adapter_interrupt(dev) \
>> diff --git a/drivers/scsi/aacraid/comminit.c 
>> b/drivers/scsi/aacraid/comminit.c
>> index bd99c5492b7d..a5483e7e283a 100644
>> --- a/drivers/scsi/aacraid/comminit.c
>> +++ b/drivers/scsi/aacraid/comminit.c
>> @@ -657,4 +657,3 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>>       return dev;
>>   }
>> -
>> diff --git a/drivers/scsi/aacraid/commsup.c 
>> b/drivers/scsi/aacraid/commsup.c
>> index deb32c9f4b3e..3f062e4013ab 100644
>> --- a/drivers/scsi/aacraid/commsup.c
>> +++ b/drivers/scsi/aacraid/commsup.c
>> @@ -223,8 +223,12 @@ int aac_fib_setup(struct aac_dev * dev)
>>   struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd 
>> *scmd)
>>   {
>>       struct fib *fibptr;
>> +    u32 blk_tag;
>> +    int i;
>> -    fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>> +    blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
>> +    i = blk_mq_unique_tag_to_tag(blk_tag);
>> +    fibptr = &dev->fibs[i];
>>       /*
>>        *    Null out fields that depend on being zero at the start of
>>        *    each I/O
>> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
>> index 5ba5c18b77b4..9caf8c314ce1 100644
>> --- a/drivers/scsi/aacraid/linit.c
>> +++ b/drivers/scsi/aacraid/linit.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/compat.h>
>>   #include <linux/blkdev.h>
>> +#include <linux/blk-mq-pci.h>
>>   #include <linux/completion.h>
>>   #include <linux/init.h>
>>   #include <linux/interrupt.h>
>> @@ -505,6 +506,15 @@ static int aac_slave_configure(struct scsi_device 
>> *sdev)
>>       return 0;
>>   }
>> +static void aac_map_queues(struct Scsi_Host *shost)
>> +{
>> +    struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>> +
>> +    blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
>> +                aac->pdev, 0);
>> +    aac->use_map_queue = true;
>> +}
>> +
>>   /**
>>    *    aac_change_queue_depth        -    alter queue depths
>>    *    @sdev:    SCSI device we are considering
>> @@ -1489,6 +1499,7 @@ static struct scsi_host_template 
>> aac_driver_template = {
>>       .bios_param            = aac_biosparm,
>>       .shost_groups            = aac_host_groups,
>>       .slave_configure        = aac_slave_configure,
>> +    .map_queues            = aac_map_queues,
>>       .change_queue_depth        = aac_change_queue_depth,
>>       .sdev_groups            = aac_dev_groups,
>>       .eh_abort_handler        = aac_eh_abort,
>> @@ -1776,6 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, 
>> const struct pci_device_id *id)
>>       shost->max_lun = AAC_MAX_LUN;
>>       pci_set_drvdata(pdev, shost);
>> +    shost->nr_hw_queues = aac->max_msix;
>> +    shost->host_tagset = 1;
>>       error = scsi_add_host(shost, &pdev->dev);
>>       if (error)
>> @@ -1908,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)
>>       struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
>>       aac_cancel_rescan_worker(aac);
>> +    aac->use_map_queue = false;
>>       scsi_remove_host(shost);
>>       __aac_shutdown(aac);
>> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
>> index 11ef58204e96..61949f374188 100644
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
>> @@ -505,8 +509,25 @@ static int aac_src_deliver_message(struct fib *fib)
>>           if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE3)
>>               && dev->sa_firmware)
>>               vector_no = aac_get_vector(dev);
>> -        else
>> -            vector_no = fib->vector_no;
>> +        else {
>> +            if (!fib->vector_no || !fib->callback_data) {
>> +                if (shost && dev->use_map_queue) {
>> +                    qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
>> +                    vector_no = qmap->mq_map[raw_smp_processor_id()];
>> +                }
>> +                /*
>> +                 *    We hardcode the vector_no for
>> +                 *    reserved commands as a valid shost is
>> +                 *    absent during the init
>> +                 */
>> +                else
>> +                    vector_no = 0;
>> +            } else {
>> +                scmd = (struct scsi_cmnd *)fib->callback_data;
>> +                blk_tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmd));
>> +                vector_no = blk_mq_unique_tag_to_hwq(blk_tag);
> 
> 
> 
> Hannes' patch in the bugzilla was to revert to using hw queue #0 always 
> for internal commands, and it didn't help.
> 
> Could there be any issue in using hw queue #0 for regular SCSI commands?
> 
> AFAICS, that's a significant change. Previously we would use 
> fib->vector_no to decide the queue, which was in range (1, dev->max_msix).
> 
> BTW, is there any code which relies on a command being sent/received on 
> the HW queue same as fib->vector_no?
> 
Yeah, and that's the clincher.
The vector/MSIx interrupt to use for the completion is encoded in the 
command (cf drivers/scsi/aacraid/src.c:aac_src_deliver_message()):

fib->hw_fib_va)->reply_qid = vector_no;

_and_ the command index:

fib->hw_fib_va)->request_id += (vector_no << 16);

so if we miscalculate the vector number here the command completion
will lookup the wrong command, and we get this issue.

But maybe the fix is relatively simple; can you try this:

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 61949f374188..698a206a2b43 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -510,7 +510,7 @@ static int aac_src_deliver_message(struct fib *fib)
                         && dev->sa_firmware)
                         vector_no = aac_get_vector(dev);
                 else {
-                       if (!fib->vector_no || !fib->callback_data) {
+                       if (!fib->callback_data) {
                                 if (shost && dev->use_map_queue) {
                                         qmap = 
&shost->tag_set.map[HCTX_TYPE_DEFAULT];
                                         vector_no = 
qmap->mq_map[raw_smp_processor_id()];

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

