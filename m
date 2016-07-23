From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sat, 23 Jul 2016 15:13:15 -0700
Message-ID: <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:36046
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751364AbcGWWNX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2016 18:13:23 -0400
In-Reply-To: <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>

On 07/23/16 05:43, Hannes Reinecke wrote:
> On 07/22/2016 10:45 PM, Martin K. Petersen wrote:
>>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
>>
>> Hannes> Add a sysfs queue attribute 'zoned' to display the zone layout
>> Hannes> for zoned devices.
>>
>> Not quite one value per file :(
>>
> Yes.
> But I wanted to display the zone layout in a concise way allowing
> user-space programs to determine the zone layout without having to
> issue a 'REPORT ZONES' command themselves.
> I found it slightly pointless to add one sysfs entry per zone,
> and at the same time a simple 'zone_size' attribute wouldn't cover all
> possibilities.
>
> However, as SMR drives seem to stabilise around having a fixed zone size
> (with a possible exemption of the last zone to cover left-overs)
> I'd be fine a replace this with a single 'zone_size' attribute which
> could be set to eg '-1' for drives which indeed would implement variable
> zone sizes.

It's not that hard to convert the information exported by 
queue_zoned_show() from a single sysfs attribute into one directory per 
zone. Doing so would make it much easier for scripts to parse that 
information and would also avoid that the zone information has to be 
truncated because not all of it fits into a single page.

Bart.
