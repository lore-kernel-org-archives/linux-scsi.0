From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Mon, 25 Jul 2016 08:44:20 -0600
Message-ID: <2d999840-7f9f-481b-de86-534fd2d807c4@kernel.dk>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
 <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
 <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37041 "EHLO
	mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbcGYOoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2016 10:44:24 -0400
Received: by mail-it0-f46.google.com with SMTP id f6so106671573ith.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 07:44:23 -0700 (PDT)
In-Reply-To: <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>

On 07/24/2016 07:37 AM, Bart Van Assche wrote:
> On 07/24/16 00:10, Hannes Reinecke wrote:
>> On 07/24/2016 12:13 AM, Bart Van Assche wrote:
>>> On 07/23/16 05:43, Hannes Reinecke wrote:
>>>> On 07/22/2016 10:45 PM, Martin K. Petersen wrote:
>>>>>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>>>>>
>>>>> Hannes> Add a sysfs queue attribute 'zoned' to display the zone layout
>>>>> Hannes> for zoned devices.
>>>>>
>>>>> Not quite one value per file :(
>>>>>
>>>> Yes.
>>>> But I wanted to display the zone layout in a concise way allowing
>>>> user-space programs to determine the zone layout without having to
>>>> issue a 'REPORT ZONES' command themselves.
>>>> I found it slightly pointless to add one sysfs entry per zone,
>>>> and at the same time a simple 'zone_size' attribute wouldn't cover all
>>>> possibilities.
>>>>
>>>> However, as SMR drives seem to stabilise around having a fixed zone
>>>> size
>>>> (with a possible exemption of the last zone to cover left-overs)
>>>> I'd be fine a replace this with a single 'zone_size' attribute which
>>>> could be set to eg '-1' for drives which indeed would implement
>>>> variable
>>>> zone sizes.
>>>
>>> It's not that hard to convert the information exported by
>>> queue_zoned_show() from a single sysfs attribute into one directory per
>>> zone. Doing so would make it much easier for scripts to parse that
>>> information and would also avoid that the zone information has to be
>>> truncated because not all of it fits into a single page.
>>>
>> But this is precisely what I've tried to avoid.
>> Creating one file or directory per zone would mean we'll end up with
>> rough 20k files/directories.
>> Which I found rather excessive.
>>
>> Of course, it that is not a concern that I can easily convert it.
>
> If there are 10K zones and since queue_zoned_show() is limited to one
> page then only a very small fraction of the zone information will be
> available through sysfs. I remember from your presentations that reading
> the zone information is slow. Is 10K zones a typical value or a worst
> case value?

Just kill the sysfs file, it's useless for many zones. Either have the 
application use some library to provide the information, or use bsg and 
similar to get it.

-- 
Jens Axboe

