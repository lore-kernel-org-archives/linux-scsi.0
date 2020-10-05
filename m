Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543F0C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 06:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C8CE206C3
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 06:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgJEGta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:49:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:33258 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgJEGta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 02:49:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9E11CABD1;
        Mon,  5 Oct 2020 06:49:28 +0000 (UTC)
Subject: Re: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute
 port_state
To:     Benjamin Block <bblock@linux.ibm.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
 <20201002162633.GA8365@t480-pf1aa2c2>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ca995d96-608b-39b9-8ded-4a6dd7598660@suse.de>
Date:   Mon, 5 Oct 2020 08:49:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002162633.GA8365@t480-pf1aa2c2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/20 6:26 PM, Benjamin Block wrote:
> On Mon, Sep 28, 2020 at 10:20:56AM +0530, Muneendra wrote:
>> Added a new sysfs attribute port_state under fc_transport/target*/
>>
>> With this new interface the user can move the port_state from
>> Marginal -> Online and Online->Marginal.
>>
>> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
>> scmd->state for all the pending io's on the scsi device associated
>> with target port.
>>
>> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
>> scmd->state for all the pending io's on the scsi device associated
>> with target port.
>>
>> Below is the interface provided to set the port state to Marginal
>> and Online.
>>
>> echo "Marginal" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
>> echo "Online" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
>>
>> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
>> fc_timeout_deleted_rport functions  to handle the new rport state
>> FC_PORTSTATE_MARGINAL.
> 
> Hey Muneendra, out of curiosity, what drives these changes to the
> port_state in userspace, and based on what?
> 
> I imagine something uses the other bunch of sysfs attributes that were
> introduced recently that get feed by FPIN notifications about congestion
> and such, or?
> 
> If so, is there any plans to integrated something along the lines in
> multipathd/multipath-tools? Or maybe I missed that.
> 
My idea here was that that 'marginal' port state is initiated by FPIN 
notifications; ideally set from the driver itself, but initially most 
likely from userspace (eg multipathd).

Problem here is that the FPIN comes in various flavours (eg congestion 
or link degradation), each of which will result in either one or several 
FPIN notifications.
EG for link congestion it is expected to get messages at a certain 
frequency for as long as the situation occurs.
Meaning we would have to have some sort of mechanism for checking that 
frequency, and reset the state if the condition persists.

How exactly we're going to do this, whether by external daemon or 
integrated into multipathd, is currently subject for debate and testing.
I would prefer to have it integrated into multipathd, but it might well 
become too complex such that an external daemon might be the better option.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
