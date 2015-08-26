From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: IO failures with SMR drives at latest kernel versions
Date: Wed, 26 Aug 2015 14:13:11 -0700
Message-ID: <CAOMFOmWTZNi0E1RNFWTszRQDZ8NijN4hnLbPDkHL-gpUWQ+XKg@mail.gmail.com>
References: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
	<CAOMFOmXSrG82TFmHFTiCQoG3hkwJ69+U5Z=fXfbbgdf=xjTaJQ@mail.gmail.com>
	<55DAB673.10903@suse.de>
	<CAOMFOmUHzLad4wLMJdAxj+CPKM_GCY3dTZUqpD2icoEJKdJ8uw@mail.gmail.com>
	<55DD5F45.7010905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:35969 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbbHZVNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2015 17:13:12 -0400
Received: by vkif69 with SMTP id f69so89367132vki.3
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2015 14:13:11 -0700 (PDT)
In-Reply-To: <55DD5F45.7010905@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, adrian.palmer@seagate.com
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, hch@lst.de, Tejun Heo <tj@kernel.org>

Hi

The same issue was reported here
http://www.spinics.net/lists/linux-ide/msg50641.html

Adding Adrian from Seagate to help track down this issue.

On Tue, Aug 25, 2015 at 11:40 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 08/26/2015 06:53 AM, Anatol Pomozov wrote:
>> Hi
>>
>> On Sun, Aug 23, 2015 at 11:15 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>> I looked at this commit and it actually adds SMR support to SCSI
>>>> layer. Reverting ATA_DEV_ZAC means going back to zones-unaware
>>>> algorithms. It is suboptimal but still much better than IO failures
>>>> and "BTRFS: lost page write due to I/O error on /dev/sdc" errors I see
>>>> at my computer.
>>>>
>>>> If this SMR support is considered as non-stable, can we at least get a
>>>> kernel boot (or config) option that disables ZAC?
>>>>
>>> Again: Has anybody actually _tested_ that reverting this patch fixes
>>> this issue?
>>
>> Yes I tested it.
>>
>> This error happens only under heavy load with a lot of read/writes
>> (like btrfs rebalance).
>>
>> With current Linux-4.1.6 'btrfs balance' fails after ~10 minutes after
>> start. I reverted ZAC related changes and then ran rebalancing. The
>> operation finished successfully after 3 hours of running.
>>
> Can you be a bit more specific about the 'ZAC related changes'?
> There have been several patches, and we really would need to know
> which one was the offending one.

I reverted these changes:

9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb
f9ca5ab832e7ac5bc2b6fe0e82ad46d536f436f9
