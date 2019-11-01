Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE0ECA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D5A3208E3
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 16:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKAQax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:30:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:42262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbfKAQax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Nov 2019 12:30:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 932D5B326;
        Fri,  1 Nov 2019 16:30:50 +0000 (UTC)
Subject: Re: [PATCH 3/4] aacraid: use blk_mq_rq_busy_iter() for traversing
 outstanding commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191101111838.140027-1-hare@suse.de>
 <20191101111838.140027-4-hare@suse.de>
 <6c70be12-cc58-1c69-beed-f9cd8ef65269@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <49cab747-c1d6-a97a-6adb-8e547e8a2e0a@suse.de>
Date:   Fri, 1 Nov 2019 17:30:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6c70be12-cc58-1c69-beed-f9cd8ef65269@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/19 4:34 PM, Bart Van Assche wrote:
> On 11/1/19 4:18 AM, Hannes Reinecke wrote:
>> +static bool synchronize_busy_iter(struct request *req, void *data, 
>> bool reserved)
>> +{
>> +    struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> +    struct synchronize_busy_data *busy_data = data;
>> +
>> +    if (busy_data->sdev == cmd->device &&
>> +        cmd->SCp.phase == AAC_OWNER_FIRMWARE) {
>> +        u64 cmnd_lba;
>> +        u32 cmnd_count;
>> +
>> +        if (cmd->cmnd[0] == WRITE_6) {
>> +            cmnd_lba = ((cmd->cmnd[1] & 0x1F) << 16) |
>> +                (cmd->cmnd[2] << 8) |
>> +                cmd->cmnd[3];
>> +            cmnd_count = cmd->cmnd[4];
>> +            if (cmnd_count == 0)
>> +                cmnd_count = 256;
>> +        } else if (cmd->cmnd[0] == WRITE_16) {
>> +            cmnd_lba = ((u64)cmd->cmnd[2] << 56) |
>> +                ((u64)cmd->cmnd[3] << 48) |
>> +                ((u64)cmd->cmnd[4] << 40) |
>> +                ((u64)cmd->cmnd[5] << 32) |
>> +                ((u64)cmd->cmnd[6] << 24) |
>> +                (cmd->cmnd[7] << 16) |
>> +                (cmd->cmnd[8] << 8) |
>> +                cmd->cmnd[9];
>> +            cmnd_count = (cmd->cmnd[10] << 24) |
>> +                (cmd->cmnd[11] << 16) |
>> +                (cmd->cmnd[12] << 8) |
>> +                cmd->cmnd[13];
>> +        } else if (cmd->cmnd[0] == WRITE_12) {
>> +            cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
>> +                (cmd->cmnd[3] << 16) |
>> +                (cmd->cmnd[4] << 8) |
>> +                cmd->cmnd[5];
>> +            cmnd_count = (cmd->cmnd[6] << 24) |
>> +                (cmd->cmnd[7] << 16) |
>> +                (cmd->cmnd[8] << 8) |
>> +                cmd->cmnd[9];
>> +        } else if (cmd->cmnd[0] == WRITE_10) {
>> +            cmnd_lba = ((u64)cmd->cmnd[2] << 24) |
>> +                (cmd->cmnd[3] << 16) |
>> +                (cmd->cmnd[4] << 8) |
>> +                cmd->cmnd[5];
>> +            cmnd_count = (cmd->cmnd[7] << 8) |
>> +                cmd->cmnd[8];
>> +        } else
>> +            return true;
> 
> The above code looks very similar to the code in scsi_trace.c. Although 
> SCSI LLDs shouldn't parse CDBs, there are a few SCSI LLDs that do this. 
> Would it be worth it to introduce a function in the SCSI core that 
> extracts the most important fields from a CDB (LBA, data buffer size, ...)?
> 
Possibly.
I'll see what I can come up with.

But in either case I'd rather do this as a separate patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
