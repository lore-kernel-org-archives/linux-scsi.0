Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED7BC3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BE92137B
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEBItf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 04:49:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:56420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgEBItf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 04:49:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4A1A9AC51;
        Sat,  2 May 2020 08:49:34 +0000 (UTC)
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590> <20200501174505.GC23795@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
Date:   Sat, 2 May 2020 10:49:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501174505.GC23795@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 7:45 PM, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
>>> We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
>>> which seems to relate to a hardware setting.
>>>
>>> But I can see to update the reserved command functionality for allowing to
>>> fetch commands from the normal I/O tag pool; in the case of LUN reset it
>>> shouldn't make much of a difference as the all I/O is quiesced anyway.
>>
>> It isn't related with reset.
>>
>> This patch reduces active IO queue depth by 1 anytime no matter there is reset
>> or not, and this way may cause performance regression.
> 
> But isn't it the right thing to do?  How else do we guarantee that
> there always is a tag available for the LU reset?
> 
Precisely. One could argue that this is an issue with the current 
driver, too; if all tags have timed-out there is no way how we can send 
a LUN reset even now. Hence we need to reserve a tag for us to reliably 
send a LUN reset.
And this was precisely the problem what sparked off this entire 
patchset; some drivers require a valid tag to send internal, non SCSI 
commands to the hardware.
And with the current design it requires some really ugly hacks to make 
this to work.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
