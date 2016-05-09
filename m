From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v3
Date: Mon, 9 May 2016 09:50:15 -0400
Message-ID: <57309597.1040903@stratus.com>
References: <56F9A22F.7020002@sandisk.com> <572BA5EF.6000702@sandisk.com>
 <572BAFB0.2020305@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0120.outbound.protection.outlook.com ([65.55.169.120]:7040
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751312AbcEIOXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 10:23:36 -0400
In-Reply-To: <572BAFB0.2020305@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/05/2016 04:40 PM, Joe Lawrence wrote:
> On 05/05/2016 03:58 PM, Bart Van Assche wrote:
>> On 03/28/2016 02:29 PM, Bart Van Assche wrote:
>>> Avoid that the sd driver registers a BDI device with a name that
>>> is still in use. This patch avoids that the following warning gets
>>> triggered:
>>>
>>> [ ... ]
>>
>> (replying to my own e-mail)
>>
>> If anyone could review this patch that would be very welcome.
> 
> Hi Bart,
> 
> I *think* I may be hitting this same problem running some tests here at Stratus
> ... snip...


Hi Bart,

Good news = With your v3 patch, I didn't see the "sysfs: cannot create
duplicate filename '/devices/virtual/bdi/65:0'" warning during my
weekend testing (573 surprise disk HBA removals).

Bad news = I still crashed in add_disk > sysfs_create_link >
sysfs_do_create_link_sd on a NULL target_kobj->sd ... unfortunately I
don't have kdump working, so all I have is a serial console output to
work with for now.

Regards,

-- Joe
