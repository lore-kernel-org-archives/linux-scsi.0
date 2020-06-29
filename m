Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E276AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB6C206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgF2TL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:11:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbgF2TLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A3AFAACB8;
        Mon, 29 Jun 2020 14:59:56 +0000 (UTC)
Subject: Re: [PATCH 07/22] csiostor: use internal command for LUN reset
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>, linux-scsi@vger.kernel.org
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-8-hare@suse.de>
 <4567ba10-c024-8e37-7aef-7ea13025952e@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <efa3cdb0-260a-9490-db24-ca544aacfb99@suse.de>
Date:   Mon, 29 Jun 2020 16:59:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4567ba10-c024-8e37-7aef-7ea13025952e@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/20 3:51 PM, John Garry wrote:
> On 29/06/2020 08:20, Hannes Reinecke wrote:
>> When issuing a LUN reset we should be allocating an
>> internal command to avoid overwriting the original command.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/csiostor/csio_scsi.c | 48 
>> +++++++++++++++++++++++----------------
>>   1 file changed, 29 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/scsi/csiostor/csio_scsi.c 
>> b/drivers/scsi/csiostor/csio_scsi.c
>> index 00cf33573136..27001fdcdcac 100644
>> --- a/drivers/scsi/csiostor/csio_scsi.c
>> +++ b/drivers/scsi/csiostor/csio_scsi.c
>> @@ -2057,10 +2057,12 @@ csio_tm_cbfn(struct csio_hw *hw, struct 
>> csio_ioreq *req)
>>   static int
>>   csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>>   {
>> -    struct csio_lnode *ln = shost_priv(cmnd->device->host);
>> +    struct scsi_cmnd *reset_cmnd;
>> +    struct scsi_device *sdev = cmnd->device;
>> +    struct csio_lnode *ln = shost_priv(sdev->host);
>>       struct csio_hw *hw = csio_lnode_to_hw(ln);
>>       struct csio_scsim *scsim = csio_hw_to_scsim(hw);
>> -    struct csio_rnode *rn = (struct csio_rnode 
>> *)(cmnd->device->hostdata);
>> +    struct csio_rnode *rn = (struct csio_rnode *)(sdev->hostdata);
>>       struct csio_ioreq *ioreq = NULL;
>>       struct csio_scsi_qset *sqset;
>>       unsigned long flags;
>> @@ -2073,13 +2075,13 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>>           goto fail;
>>       csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
>> -              cmnd->device->lun, rn->flowid, rn->scsi_id);
>> +              sdev->lun, rn->flowid, rn->scsi_id);
>>       if (!csio_is_lnode_ready(ln)) {
>>           csio_err(hw,
>>                "LUN reset cannot be issued on non-ready"
>>                " local node vnpi:0x%x (LUN:%llu)\n",
>> -             ln->vnp_flowid, cmnd->device->lun);
>> +             ln->vnp_flowid, sdev->lun);
>>           goto fail;
>>       }
>> @@ -2099,17 +2101,22 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
>>           csio_err(hw,
>>                "LUN reset cannot be issued on non-ready"
>>                " remote node ssni:0x%x (LUN:%llu)\n",
>> -             rn->flowid, cmnd->device->lun);
>> +             rn->flowid, sdev->lun);
>>           goto fail;
>>       }
>> +    reset_cmnd = scsi_get_internal_cmd(sdev, DMA_NONE, REQ_NOWAIT);
> 
> out of curiosity, do we use the tag at all or need to allocate a request 
> here?
> 
> it seems that the current code just scribbles on the scmd host scribble 
> parts, and now we use the internal scmd host scribble parts instead - so 
> I'm not sure what we're really improving here.
> 

Primary goal is to register the TMF with the block layer to make it 
aware that some command is outstanding.
Probably not that crucial, so I'll be dropping it for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
