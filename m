Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4650C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9250F6500B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhCLQJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:09:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:34836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhCLQI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 11:08:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2767EB124;
        Fri, 12 Mar 2021 16:08:58 +0000 (UTC)
Subject: Re: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
To:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210222132405.91369-1-hare@suse.de>
 <ef8fe68b-dcf0-6092-b51f-1ef79af61cc2@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <02a97468-4dc2-f840-06a9-1a3a7c5a6852@suse.de>
Date:   Fri, 12 Mar 2021 17:08:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ef8fe68b-dcf0-6092-b51f-1ef79af61cc2@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/12/21 12:53 AM, michael.christie@oracle.com wrote:
> On 2/22/21 7:23 AM, Hannes Reinecke wrote:
>> Hi all,
>>
>> quite some drivers use internal commands for various purposes, most
>> commonly sending TMFs or querying the HBA status.
>> While these commands use the same submission mechanism than normal
>> I/O commands, they will not be counted as outstanding commands,
>> requiring those drivers to implement their own mechanism to figure
>> out outstanding commands.
>> The block layer already has the concept of 'reserved' tags for
>> precisely this purpose, namely non-I/O tags which live off a separate
>> tag pool. That guarantees that these commands can always be sent,
>> and won't be influenced by tag starvation from the I/O tag pool.
>> This patchset enables the use of reserved tags for the SCSI midlayer
>> by allocating a virtual LUN for the HBA itself which just serves
>> as a resource to allocate valid tags from.
>> This removes quite some hacks which were required for some
>> drivers (eg. fnic or snic), and allows the use of tagset
>> iterators within the drivers.
>>
> 
> Hey Hannes,
> 
> I was trying to port some iscsi patches to this set. One question I had
> is how to handle if my driver implements init_cmd_priv, and wants to use
> the reserved cmds for a non scsi IO. My case I want to use them for cmds
> like a iscsi nop/ping, device/target reset or login request.
> 
> There is no bit to way to tell if at init_cmd_priv time the cmd will be
> for a reserved or non reserved cmd right? If not, I was wondering should
> I do:
> 
> 1. in libiscsi, allocate an array of size $reserved_cmds with non_scsi_cmds
> structs. When I need to do a non scsi cmd do blk_mq_get_tag on the host's
> tags to get a reserved tag then use that to lookup a struct in my array?
> 
> 2. in libiscsi when I need to do a non scsi cmd do a scsi_get_internal_cmd.
> At this time allocate the non_scsi_cmd struct parts.
> 
You sure you will need to allocate additional stuff?
The request already comes with the request, scsi, and driver private
bits (ie the additional space from .cmd_size) allocated.

And yes, you can tell in init_cmd_priv() if the command is coming from
the private pool; I had a helper 'req_is_reserved' once, I thought it's
still there ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
