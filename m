Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A7BC3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 079CE216FD
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgEBMY0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 08:24:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:41388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgEBMY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 08:24:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8C102ABCC;
        Sat,  2 May 2020 12:24:25 +0000 (UTC)
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de>
 <318ece17-394e-d518-ac24-19680e93e6ff@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8951aa47-d7b6-09e8-48b7-a0d996274bd6@suse.de>
Date:   Sat, 2 May 2020 14:24:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <318ece17-394e-d518-ac24-19680e93e6ff@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 2:01 PM, John Garry wrote:
> On 30/04/2020 14:18, Hannes Reinecke wrote:
>> +    rq = blk_mq_alloc_request(sdev->request_queue,
>> +                  data_direction == DMA_TO_DEVICE ?
>> +                  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
>> +                  BLK_MQ_REQ_RESERVED);
>> +    if (IS_ERR(rq))
>> +        return NULL;
>> +    scmd = blk_mq_rq_to_pdu(rq);
>> +    scmd->request = rq;
> 
> Should we just set scmd->device = sdev also for completeness?
> 
Inded, we should.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
