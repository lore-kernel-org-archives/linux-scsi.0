Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299A2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 06:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0921922CA0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 06:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgHEGdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 02:33:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:39426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHEGdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Aug 2020 02:33:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 76C79AC19;
        Wed,  5 Aug 2020 06:33:37 +0000 (UTC)
Subject: Re: [RFC 01/16] blkcg:Introduce blkio.app_identifier knob to blkio
 controller
To:     Ming Lei <tom.leiming@gmail.com>,
        James Smart <james.smart@broadcom.com>
Cc:     Tejun Heo <tj@kernel.org>, Daniel Wagner <dwagner@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ewan Milne <emilne@redhat.com>, mkumar@redhat.com
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-2-git-send-email-muneendra.kumar@broadcom.com>
 <20200804113130.qfi5agzilso3mlbp@beryllium.lan>
 <20200804142123.GA4819@mtj.thefacebook.com>
 <b35e0e83-eb6c-4282-5142-22d9a996d260@broadcom.com>
 <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <227c7f27-c6c7-5db1-59ac-2dd428f5a42a@suse.de>
Date:   Wed, 5 Aug 2020 08:33:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACVXFVPVM-xU0d2nETztPrS_EpacMy8A4x8FbShhLYt2iV_ouw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 5:59 AM, Ming Lei wrote:
> On Wed, Aug 5, 2020 at 8:42 AM James Smart <james.smart@broadcom.com> wrote:
>>
>> On 8/4/2020 7:21 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Tue, Aug 04, 2020 at 01:31:30PM +0200, Daniel Wagner wrote:
>>>> Hi,
>>>>
>>>> [cc Tejun]
>>>>
>>>> On Tue, Aug 04, 2020 at 07:43:01AM +0530, Muneendra wrote:
>>>>> This Patch added a unique application identifier i.e
>>>>> blkio.app_identifier knob to  blkio controller which
>>>>> allows identification of traffic sources at an
>>>>> individual cgroup based Applications
>>>>> (ex:virtual machine (VM))level in both host and
>>>>> fabric infrastructure.
>>> I'm not sure it makes sense to introduce custom IDs for these given that
>>> there already are unique per-host cgroup IDs which aren't recycled.
>>>
>>> Thanks.
>>>
>>
>> If the VM moves to a different host, does the per-host cgroup IDs
>> migrate with the VM ?   If not, we need to have an identifier that moves
>> with the VM and which is independent of what host the VM is residing on.
> 
> Hello James,
> 
> Is it possible to reuse VM's mac address or other unique ID for such purpose?
> 
None of these are guaranteed to be either present or unique.
It's not uncommon to have VMs with more than one MAC address, and any 
other unique identifier like system UUID is not required to be present.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
