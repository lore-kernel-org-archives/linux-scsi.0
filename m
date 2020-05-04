Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682E8C47247
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B9320757
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 10:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgEDKYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 06:24:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:52010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgEDKYq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 May 2020 06:24:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8175AAB3D;
        Mon,  4 May 2020 10:24:45 +0000 (UTC)
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590> <20200501174505.GC23795@lst.de>
 <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
 <20200502142907.GE1013372@T590>
 <8795fedc-8b07-fbfc-89f5-0cb76ee054b0@suse.de>
 <20200504084700.GB1139563@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <902fae06-8ad7-9abd-c76c-61f975471711@suse.de>
Date:   Mon, 4 May 2020 12:24:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504084700.GB1139563@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/20 10:47 AM, Ming Lei wrote:
> On Mon, May 04, 2020 at 08:55:05AM +0200, Hannes Reinecke wrote:
>> On 5/2/20 4:29 PM, Ming Lei wrote:
>>> On Sat, May 02, 2020 at 10:49:32AM +0200, Hannes Reinecke wrote:
>>>> On 5/1/20 7:45 PM, Christoph Hellwig wrote:
>>>>> On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
>>>>>>> We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
>>>>>>> which seems to relate to a hardware setting.
>>>>>>>
>>>>>>> But I can see to update the reserved command functionality for allowing to
>>>>>>> fetch commands from the normal I/O tag pool; in the case of LUN reset it
>>>>>>> shouldn't make much of a difference as the all I/O is quiesced anyway.
>>>>>>
>>>>>> It isn't related with reset.
>>>>>>
>>>>>> This patch reduces active IO queue depth by 1 anytime no matter there is reset
>>>>>> or not, and this way may cause performance regression.
>>>>>
>>>>> But isn't it the right thing to do?  How else do we guarantee that
>>>>> there always is a tag available for the LU reset?
>>>>>
>>>> Precisely. One could argue that this is an issue with the current driver,
>>>> too; if all tags have timed-out there is no way how we can send a LUN reset
>>>> even now. Hence we need to reserve a tag for us to reliably send a LUN
>>>> reset.
>>>> And this was precisely the problem what sparked off this entire patchset;
>>>> some drivers require a valid tag to send internal, non SCSI commands to the
>>>> hardware.
>>>
>>> Could you explain a bit how you conclude that csio_scsi reset hander has to
>>> use one unique tag? At least we don't allocate request from block layer for
>>> ioctl(SG_SCSI_RESET), see scsi_ioctl_reset(). Also this patch doesn't
>>> use the reserved rq->tag too.
>>>
>>>> And with the current design it requires some really ugly hacks to make this
>>>> to work.
>>>
>>> You also don't explain how csio_eh_lun_reset_handler() is broken and where
>>> the ugly hack is in csio scsi too, and how this patch fixes the issue, could
>>> you document the exact reason in the commit log?
>>>
>> The problem is the ioctl path.
>> When issuing TMF commands from the ioctl path we currently do not have a
>> valid SCSI command to pass to the various SCSI EH functions.
>> This requires the SCSI LLDDs to check for every EH function whether the
>> passed in SCSI command is valid (ie coming from SCSI EH), or a made up one
>> coming from the ioctl path.
> 
> Could you point out where the check is in csio driver?
> 
Okok, I see your point.

Indeed the csiostor driver doesn't use the 'tag' per se for submitting 
commands; it's just using the scsi command pointer as a tag to figure 
out if a completion has been send from the hw.

I'll be giving it a bit more thought, and will be dropping it for the 
next round (which will contain only the minimal changes to get the 
'reserved_cmds' interface in).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
