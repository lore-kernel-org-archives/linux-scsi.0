From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sun, 24 Jul 2016 06:51:52 -0700
Message-ID: <65e6de30-4811-969b-6c9e-312104e1ae6a@sandisk.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
 <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
 <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:35872
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751891AbcGXNwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2016 09:52:04 -0400
In-Reply-To: <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@hgst.com>

On 07/24/16 06:37, Bart Van Assche wrote:
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
>>>> However, as SMR drives seem to stabilise around having a fixed zone size
>>>> (with a possible exemption of the last zone to cover left-overs)
>>>> I'd be fine a replace this with a single 'zone_size' attribute which
>>>> could be set to eg '-1' for drives which indeed would implement variable
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

(replying to my own e-mail)

Something I should have asked before: is the zone information intended 
for end users or rather for software developers? In the latter case, 
have you considered to use debugfs instead of sysfs to export this 
information? From Documentation/filesystems/debugfs.txt: "Unlike /proc, 
which is only meant for information about a process, or sysfs, which has 
strict one-value-per-file rules, debugfs has no rules at all."

Bart.
