From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_spi: Export host width and HBA id
Date: Fri, 03 Jun 2011 07:59:22 +0200
Message-ID: <4DE8783A.9010801@suse.de>
References: <201106011318.p51DImMr003035@pentland.suse.de> <1306940171.11897.52.camel@mulgrave.site> <4DE65408.2020502@suse.de> <4DE6579F.8080402@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1FCF7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2011 01:59:24 -0400
In-Reply-To: <4DE6579F.8080402@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/01/2011 05:15 PM, Douglas Gilbert wrote:
> On 11-06-01 11:00 AM, Hannes Reinecke wrote:
>> On 06/01/2011 04:56 PM, James Bottomley wrote:
>>> On Wed, 2011-06-01 at 15:18 +0200, Hannes Reinecke wrote:
>>>> Currently it's impossible to find out if the host supports
>>>> wide SCSI unless you're committed to trawl through syslog.
>>>> And it's near impossible to find the actual HBA id, which
>>>> is settable for some SCSI HBAs (like aic7xxx).
>>>> So export them via sysfs.
>>>
>>> Um, that's what the the
>>>
>>> /sys/class/spi_transport/target<x:y:x>/max_width
>>>
>>> parameter gives you, isn't it?
>>>
>>> max_width tells you if the HBA/device combination supports wide;
>>> width
>>> tells you if the device is using it.
>>>
>> Not quite. You'll only have that parameter if there is a target
>> attached to the
>> HBA.
>> If there is none you still wouldn't know how far you should be
>> scanning as there
>> won't be any indicator in sysfs.
>>
>> In this case that's an ESX server emulating an sym53c8xx HBA.
>> And disks attached to it on the fly.
>> If you start up with no disks attached and attach a new disc
>> to eg target ID 12 you're stuck.
>
> It is about time that VMware emulated SAS rather than SPI for
> virtual storage. Then if something changes, ESX can emulate
> a SAS Broadcast(Change) and then smarter SAS HBA drivers will
> run their discover process and find the changes.
>
Hey, don't tell me.
I'm fighting for years to get my megaraid SAS emulation into Qemu.
And it took me about the same time to get VMWare to buy into the=20
idea of supporting VPD page 0x83.

So I won't hold my breath there.
And, btw, we'd need the hba_id anyway if we ever want to calculate=20
transport IDs on SCSI parallel devices :-).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
