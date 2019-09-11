Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6ADC5ACAE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 19:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1E42085B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 19:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="G3nQ1rSy";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fM1Ha/RN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfIKTVi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 15:21:38 -0400
Received: from a4-15.smtp-out.eu-west-1.amazonses.com ([54.240.4.15]:55192
        "EHLO a4-15.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728554AbfIKTVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Sep 2019 15:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ob2ngmaigrjtzxgmrxn2h6b3gszyqty3; d=urbackup.org; t=1568229695;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=59uwGM4pJHMCdblcEPt/Fvw4TL4wwHzA/X28KUFue3I=;
        b=G3nQ1rSyB48pRZdQDv+uufB2Vcs0TLLb5gGL19jiCtLnKCT5K9fUl1vYX7spDjNi
        k4AbTcBlnfNSWJ1Ak0nue0x7s9NUG3oIuB1F0LztmZYLUo85zQQA5AhOLNPeInvSMEp
        oGkvnR8RiquJJLrFtyzU/zc6VN7Th+MfoaOmg36E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=ihchhvubuqgjsxyuhssfvqohv7z3u4hn; d=amazonses.com; t=1568229695;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=59uwGM4pJHMCdblcEPt/Fvw4TL4wwHzA/X28KUFue3I=;
        b=fM1Ha/RNmcr1i4oE3mqYGN+X6q7QP1JquVojnQPrmF3YY6BHEP0ham9ft+lnv8YU
        NaskoVhw3YiBSsfW1H8rHEE4jqPisjhjZsvMc06f4mQfoUdTmVa3WClMVtk/SgAcM56
        ZZMWDPu+9zbO3GrB51ISKopFRuNq5FfR0bdPAWHc=
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     Mike Christie <mchristi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
References: <20190909162804.5694-1-mchristi@redhat.com>
 <5D76995B.1010507@redhat.com>
 <BYAPR04MB5816DABF3C5071D13D823990E7B60@BYAPR04MB5816.namprd04.prod.outlook.com>
 <0102016d1f7af966-334f093b-2a62-4baa-9678-8d90d5fba6d9-000000@eu-west-1.amazonses.com>
 <5D792758.2060706@redhat.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102016d21c61ec3-4e148e0f-24f5-4e00-a74e-6249653167c7-000000@eu-west-1.amazonses.com>
Date:   Wed, 11 Sep 2019 19:21:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5D792758.2060706@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2019.09.11-54.240.4.15
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11.09.2019 18:56 Mike Christie wrote:
> On 09/11/2019 03:40 AM, Martin Raiber wrote:
>> On 10.09.2019 10:35 Damien Le Moal wrote:
>>> Mike,
>>>
>>> On 2019/09/09 19:26, Mike Christie wrote:
>>>> Forgot to cc linux-mm.
>>>>
>>>> On 09/09/2019 11:28 AM, Mike Christie wrote:
>>>>> There are several storage drivers like dm-multipath, iscsi, and nbd that
>>>>> have userspace components that can run in the IO path. For example,
>>>>> iscsi and nbd's userspace deamons may need to recreate a socket and/or
>>>>> send IO on it, and dm-multipath's daemon multipathd may need to send IO
>>>>> to figure out the state of paths and re-set them up.
>>>>>
>>>>> In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the
>>>>> memalloc_*_save/restore functions to control the allocation behavior,
>>>>> but for userspace we would end up hitting a allocation that ended up
>>>>> writing data back to the same device we are trying to allocate for.
>>>>>
>>>>> This patch allows the userspace deamon to set the PF_MEMALLOC* flags
>>>>> through procfs. It currently only supports PF_MEMALLOC_NOIO, but
>>>>> depending on what other drivers and userspace file systems need, for
>>>>> the final version I can add the other flags for that file or do a file
>>>>> per flag or just do a memalloc_noio file.
>>> Awesome. That probably will be the perfect solution for the problem we hit with
>>> tcmu-runner a while back (please see this thread:
>>> https://www.spinics.net/lists/linux-fsdevel/msg148912.html).
>>>
>>> I think we definitely need nofs as well for dealing with cases where the backend
>>> storage for the user daemon is a file.
>>>
>>> I will give this patch a try as soon as possible (I am traveling currently).
>>>
>>> Best regards.
>> I had issues with this as well, and work on this is appreciated! In my
>> case it is a loop block device on a fuse file system.
>> Setting PF_LESS_THROTTLE was the one that helped the most, though, so
>> add an option for that as well? I set this via prctl() for the thread
>> calling it (was easiest to add to).
>>
>> Sorry, I have no idea about the current rationale, but wouldn't it be
>> better to have a way to mask a set of block devices/file systems not to
>> write-back to in a thread. So in my case I'd specify that the fuse
>> daemon threads cannot write-back to the file system and loop device
>> running on top of the fuse file system, while all other block
>> devices/file systems can be write-back to (causing less swapping/OOM
>> issues).
> I'm not sure I understood you.
>
> The storage daemons I mentioned normally kick off N threads per M
> devices. The threads handle duties like IO and error handling for those
> devices. Those threads would set the flag, so those IO/error-handler
> related operations do not end up writing back to them. So it works
> similar to how storage drivers work in the kernel where iscsi_tcp has an
> xmit thread and that does memalloc_noreclaim_save. Only the threads for
> those specific devices being would set the flag.
>
> In your case, it sounds like you have a thread/threads that would
> operate on multiple devices and some need the behavior and some do not.
> Is that right?

No, sounds the same as your case. As an example think of vdfuse (or
qemu-nbd locally). You'd have something like

ext4(a) <- loop <- fuse file system <- vdfuse <- disk.vdi container file
<- ext4(b) <- block device

If vdfuse threads cause writeback to ext4(a), you'd get the issue we
have. Setting PF_LESS_THROTTLE and/or PF_MEMALLOC_NOIO mostly avoids
this problem, but with only PF_LESS_THROTTLE there are still corner
cases (I think if ext4(b) slows down suddenly) where it wedges itself
and the side effect of setting PF_MEMALLOC_NOIO are being discussed...
The best solution would be, I guess, to have a way for vdfuse to set
something, such that write-back to ext4(a) isn't allowed from those
threads, but write-back to ext4(b) (and all other block devices) is. But
I only have a rough idea of how write-back works, so this is really only
a guess.

