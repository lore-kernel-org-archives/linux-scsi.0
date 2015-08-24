From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Mon, 24 Aug 2015 00:21:36 -0700
Message-ID: <CAOMFOmXsCaL=dwffcwuDQebXf4ZET7pZOSPjNnbi_f_4z8MMMA@mail.gmail.com>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
	<CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>
	<55DAB673.10903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33755 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbbHXHVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2015 03:21:37 -0400
Received: by vkd66 with SMTP id 66so53745972vkd.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 00:21:36 -0700 (PDT)
In-Reply-To: <55DAB673.10903@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de, Tejun Heo <tj@kernel.org>

Hi

On Sun, Aug 23, 2015 at 11:15 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 08/22/2015 07:23 PM, Anatol Pomozov wrote:
>> Hi
>>
>> On Fri, Aug 21, 2015 at 10:37 PM, Anatol Pomozov
>> <anatol.pomozov@gmail.com> wrote:
>>> Discs are from different batches and I was a bit surprised to see
>>> identical failures at the same time. I was ready send the drives to
>>> RMA but then I discovered this thread
>>> https://bbs.archlinux.org/viewtopic.php?id=199351 A lot of people
>>> report the same problem as mine. It was found that the problem appears
>>> only starting from 3.19, with kernel 3.18 or Windows these drives work
>>> fine. It is recommended to revert this change
>>> 9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb "libata: Implement
>>> ATA_DEV_ZAC" that seems fixes the issue.
>>
>> I looked at this commit and it actually adds SMR support to SCSI
>> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
>> algorithms. It is suboptimal but still much better than IO failures
>> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors I see
>> at my computer.
>>
>> If this SMR support is considered as non-stable, can we at least get a
>> kernel boot (or config) option that disables ZAC?
>>
> Again: Has anybody actually _tested_ that reverting this patch fixes
> this issue?
> Or even a proper bisect?
>
> Needless to say, my drives work without issues, so I can't really
> reproduce this issue.
>
> Which disks are these?

I have ST8000AS0002
http://www.newegg.com/Product/Product.aspx?Item=N82E16822178748

Here is smartctl info https://gist.github.com/anatol/66f5368208c903133f24
