Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B65DC433B4
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 09:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D0B61249
	for <linux-scsi@archiver.kernel.org>; Mon,  3 May 2021 09:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhECJhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 05:37:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:38854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233003AbhECJhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 May 2021 05:37:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8EE6AB234;
        Mon,  3 May 2021 09:36:43 +0000 (UTC)
Subject: Re: [PATCH 14/31] hpsa: use reserved commands
To:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Don Brace <don.brace@microchip.com>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-15-hare@suse.de>
 <f9a6f546-db53-c21d-912e-93b29849a6ef@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <946c2661-6f27-5c9f-9b9c-4d45a86bedba@suse.de>
Date:   Mon, 3 May 2021 11:36:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f9a6f546-db53-c21d-912e-93b29849a6ef@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/21 11:03 PM, michael.christie@oracle.com wrote:
> On 2/22/21 7:23 AM, Hannes Reinecke wrote:
>> -
>> -static struct CommandList *cmd_alloc(struct ctlr_info *h)
>> +static struct CommandList *cmd_alloc(struct ctlr_info *h, u8 direction)
>>  {
>> +	struct scsi_cmnd *scmd;
>>  	struct CommandList *c;
>> -	int refcount, i;
>> -	int offset = 0;
>> -
>> -	/*
>> -	 * There is some *extremely* small but non-zero chance that that
>> -	 * multiple threads could get in here, and one thread could
>> -	 * be scanning through the list of bits looking for a free
>> -	 * one, but the free ones are always behind him, and other
>> -	 * threads sneak in behind him and eat them before he can
>> -	 * get to them, so that while there is always a free one, a
>> -	 * very unlucky thread might be starved anyway, never able to
>> -	 * beat the other threads.  In reality, this happens so
>> -	 * infrequently as to be indistinguishable from never.
>> -	 *
>> -	 * Note that we start allocating commands before the SCSI host structure
>> -	 * is initialized.  Since the search starts at bit zero, this
>> -	 * all works, since we have at least one command structure available;
>> -	 * however, it means that the structures with the low indexes have to be
>> -	 * reserved for driver-initiated requests, while requests from the block
>> -	 * layer will use the higher indexes.
>> -	 */
>> -
>> -	for (;;) {
>> -		i = find_next_zero_bit(h->cmd_pool_bits,
>> -					HPSA_NRESERVED_CMDS,
>> -					offset);
>> -		if (unlikely(i >= HPSA_NRESERVED_CMDS)) {
>> -			offset = 0;
>> -			continue;
>> -		}
>> -		c = h->cmd_pool + i;
>> -		refcount = atomic_inc_return(&c->refcount);
>> -		if (unlikely(refcount > 1)) {
>> -			cmd_free(h, c); /* already in use */
>> -			offset = (i + 1) % HPSA_NRESERVED_CMDS;
>> -			continue;
>> -		}
>> -		set_bit(i & (BITS_PER_LONG - 1),
>> -			h->cmd_pool_bits + (i / BITS_PER_LONG));
>> -		break; /* it's ours now. */
>> +	int idx;
>> +
>> +	scmd = scsi_get_internal_cmd(h->raid_ctrl_sdev,
>> +				     (direction & XFER_WRITE) ?
>> +				     DMA_TO_DEVICE : DMA_FROM_DEVICE,
>> +				     REQ_NOWAIT);
>> +	if (!scmd) {
>> +		dev_warn(&h->pdev->dev, "failed to allocate reserved cmd\n");
>> +		return NULL;
> 
> I think in the orig code cmd_alloc would always return a non null pointer.
> It looks like we would always just keep looping.
> 
> Now, it looks like we could fail from the above code where we return NULL.
> I was not sure if it's maybe impossible to hit the "return NULL" becuase we
> only call this function when we know there will be a cmd availale. If we
> can fail then the cmd_alloc callers should check for NULL now I think.
> 
Yes, that's indeed the case with this patch.
But seeing that the original code would spin until a tag becomes
available we can drop the REQ_NOWAIT flags and should get roughly the
same behaviour as we have now.

Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
