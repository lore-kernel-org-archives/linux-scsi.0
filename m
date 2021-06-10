Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0391EC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 15:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E2E613E3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 15:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhFJPHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 11:07:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38348 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhFJPHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 11:07:05 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4B1BD1FD3F;
        Thu, 10 Jun 2021 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623337508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1u6AVXRqlu9Q/BYkByDk+dwsGv2BpsoWcFSiM1eZAU=;
        b=gD3MnDSL952svG7i4msvjAWWr72iYzVvTciBz5lHhAJPAj/IkV253S8NBTUeDnX0bSgZcZ
        /6pSkekO40Un1XOq6M5vBWRUHMIJmn3VZoR9E2OvEGjRzFUZ2gzdz/FhmzzZZy1NGtt7gu
        fwC9agBXevDdxq2fCgf9Ufi+k+211SY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623337508;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1u6AVXRqlu9Q/BYkByDk+dwsGv2BpsoWcFSiM1eZAU=;
        b=yHuuP+5+YnKwICFKNivdTbWdBcxp+klbxFAt22JPjW7UQuTlnqi0HRMeYiAdOpKqJ7LG74
        V3HPidN50qtYVZCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 26674118DD;
        Thu, 10 Jun 2021 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623337508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1u6AVXRqlu9Q/BYkByDk+dwsGv2BpsoWcFSiM1eZAU=;
        b=gD3MnDSL952svG7i4msvjAWWr72iYzVvTciBz5lHhAJPAj/IkV253S8NBTUeDnX0bSgZcZ
        /6pSkekO40Un1XOq6M5vBWRUHMIJmn3VZoR9E2OvEGjRzFUZ2gzdz/FhmzzZZy1NGtt7gu
        fwC9agBXevDdxq2fCgf9Ufi+k+211SY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623337508;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y1u6AVXRqlu9Q/BYkByDk+dwsGv2BpsoWcFSiM1eZAU=;
        b=yHuuP+5+YnKwICFKNivdTbWdBcxp+klbxFAt22JPjW7UQuTlnqi0HRMeYiAdOpKqJ7LG74
        V3HPidN50qtYVZCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id EZ2bCCQqwmCjfQAALh3uQQ
        (envelope-from <hare@suse.de>); Thu, 10 Jun 2021 15:05:08 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>
References: <a189ec50-4c11-9ee9-0b9e-b492507adc1e@suse.de>
 <485837f392401bf35fb7fc8231d7a051f47b53d7.camel@HansenPartnership.com>
 <539b35c6-34f7-62e0-4d93-6d27145bb78f@suse.de>
 <f31fbb6d2f374a39d22e3fca122d757e905d2711.camel@HansenPartnership.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [LSF/MM/BPF TOPIC] block namespaces
Message-ID: <33f720ce-484b-0c42-b14a-0a7df3e09e81@suse.de>
Date:   Thu, 10 Jun 2021 17:05:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <f31fbb6d2f374a39d22e3fca122d757e905d2711.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/21 4:29 PM, James Bottomley wrote:
> On Thu, 2021-06-10 at 07:49 +0200, Hannes Reinecke wrote:
>> On 6/9/21 8:36 PM, James Bottomley wrote:
>>> On Thu, 2021-05-27 at 10:01 +0200, Hannes Reinecke wrote:
>>>> Hi all,
>>>>
>>>> I guess it's time to tick off yet another item on my long-term
>>>> to-do list:
>>>>
>>>> Block namespaces
>>>> ----------------
>>>>
>>>> Idea is similar to what network already does: allowing each user
>>>> namespace to have a different 'view' on the existing block
>>>> devices.  EG if the admin creates a ramdisk in one namespace this
>>>> device should not be visible to other namespaces.  But for me the
>>>> most important use-case would be qemu; currently the devices need
>>>> to be set up in the host, even though the host has no business
>>>> touching it as they really belong to the qemu instance.  This
>>>> is causing quite some irritation eg when this device has LVM or
>>>> MD metadata and udev is trying to activate it on the host.
>>>
>>> I suppose the first question is "why block only?"  There are
>>> several existing device namespace proposals which would be more
>>> generic.
>>>
>>
>> Well; I'm more of a storage person, and do know the needs and 
>> shortcomings in that area. Less well so in other areas...
> 
> OK, but this should work for all devices, just like the device cgroup
> if it's going to be an adjunct to it.
> 
>>>> Overall plan is to restrict views of '/dev', '/sys/dev/block' and
>>>> '/sys/block' to only present the devices 'visible' for this
>>>> namespace.
>>>
>>> We actually already have a devices cgroup that does some of this:
>>>
>>> https://www.kernel.org/doc/Documentation/cgroup-v1/devices.txt
>>>
>> I know. But this essentially is a filter on '/dev' only, and needs to
>> be configured. Which makes it very unwieldy to use.
>> And the contents of sysfs are not modified, so there's a mismatch 
>> between contents in /dev and /sys.
>> Which might cause issues with monitoring tools.
> 
> Firstly, since it does part of what you want, we at least need to
> understand why you think it can't be enhanced to do everything.
> 
> The /sys problem has been discussed many times.  GregKH really doesn't
> like the idea of filtering /sys (and most container people agree), so
> the options available seem to be don't mount /sys in a container or
> emulate it via fuse.  If you pick either does the device cgroup now
> work for you?
> 

... begging the question why he relented for network namespaces.
They _do_ modify sysfs, and that via generic hooks (ie making struct
class namespace-aware).
And as this is a public interface I don't see why I can't be using it...

>>> However, visibility isn't the only problem, for direct passthrough
>>> there's also uevent handling and people have even asked about
>>> module loading.
>>>
>> I am aware, and that's another reason why device cgroup doesn't cut
>> it.
> 
> Christian Brauner is looking at this ... apparently Ubuntu has some
> thumb drive inside lxc container use case that needs it.
> 

Guess with whom I'm discussing on how to implement this.

>>>>   Initially the drivers would keep their global enumeration, but
>>>> plan is to make the drivers namespace-aware, too, such that each
>>>> namespace could have its own driver-specific device enumeration.
>>>
>>> I really wouldn't do this.  Namespace/Cgroup separation should be
>>> kept as high as possible.  If it leaks into the drivers it will
>>> become unmaintainable.  Why do you think you need the drivers to be
>>> aware?  If it's just enumeration, that should all be doable with
>>> the visibility driver unless you want to do things like compact
>>> numbering?
>>>
>> Which is precisely why I mentioned device modifications.
>> On a generic level we can influence the visibility of devices in 
>> relation to namespaces, we cannot influence the devices themselves.
>> This will lead to namespaces seeing disjunct device numbers (ie 8:0
>> and 8:8 on ns 1, 8:4 on ns 2). Not that I think that will be an
>> issue, but  certainly a change in behaviour.
> 
> Well, not necessarily, the pid namespace is an example of a remapping
> namespace.  The same thing could be done for device numbering, but
> there really needs to be a compelling case.  Given our use of hotplug,
> why would any tool assume compact numbering?  And if you don't need
> compact numbering there's no need to bother with remapping.
> 

Which is my assumption, too. I have just mentioned it here for
completeness sake. It's not that I'll be implementing it for now.

>>>> Goal of this topic is to get a consensus on whether block
>>>> namespaces are a feature which would find interest, and also to
>>>> discuss some design details here:
>>>> - Only in certain cases can a namespace be assigned (eg by
>>>> calling
>>>> 'modprobe', starting iscsiadm, or calling nvme-cli); how do we
>>>> handle
>>>> devices for which no namespace can be identified?
>>>> - Shall we allow for different device enumeration per namespace?
>>>> - Into which level should we go with hiding sysfs structures?
>>>>    Is blanking out the higher-level interfaces in /dev and
>>>> /sys/block    enough?
>>>
>>> First question is does the device cgroup do enough for you and if
>>> not what's missing?
>>>
>> See above. sysfs modifications and uevent filtering are missing.
>> This infrastructure for that is already in place thanks to network 
>> namespaces, we 'just' need to make use of it.
>> Additional drawback is the manual configuration of device-cgroup.
> 
> OK, so still, why not fix or enhance the device cgroup?  The current
> proposal seems to want to duplicate it as a namespace.
> 
Primarily because device-group is really limited in its functionality,
and the interface into the device core is, quite frankly, horrible.
(Implementing it under security/device_cgroup.c, and having direct
function calls from fs/block_dev.c and fs/namei.c?
hch will yet at me if I attempted that.)

Re-implementing that as a namespace is the cleaner solution.
Actually, it should be possible to re-implementing device-cgroup on to
of the block namespaces; for that we'll have to expand it to cover all
devices, but you're arguing for that anyway.
So, let's see.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
