Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C9EC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A5F20774
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 09:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJEJ34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 05:29:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:33110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgJEJ34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 05:29:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72107ACB0;
        Mon,  5 Oct 2020 09:29:55 +0000 (UTC)
Subject: Re: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute
 port_state
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
 <89648ad7-d4d2-c684-16d5-6bd39398f046@suse.de>
 <ff9771ee639a80275e1ef96f9da65042@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7f568b47-a14f-1ec1-222e-cf55983f2507@suse.de>
Date:   Mon, 5 Oct 2020 11:29:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ff9771ee639a80275e1ef96f9da65042@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 11:18 AM, Muneendra Kumar M wrote:
> Hi Hannes,
> 
> 
>>> -
>>> +	SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(port_state);
>>>    	BUG_ON(count > FC_STARGET_NUM_ATTRS);
>>>
>>>    	i->starget_attrs[count] = NULL;
> 
>> Why did you move it to be a 'starget' attribute?
>> I would have thought it should be an 'rport' attribute, seeing that it's
>> intrinsic to the fc transport class.
>>> [Muneendra] Correct me if my understanding is wrong.
>>> You want this to be part of /sys/class/fc_remote_ports/
>>> rport-X\:Y-Z/port_state instead of
>>> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> 
> Under rport we already have an attribute of port_state which is currently
> used to show the port_state.
> /sys/class/fc_remote_ports/ rport-X\:Y-Z/port_state
> 
> We can add the store functionality to the same to set the port_state.
> Is this  approach fine ?
> 
That was the idea, yes.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
