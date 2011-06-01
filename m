From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_transport_spi: Export host width and HBA id
Date: Wed, 01 Jun 2011 11:15:43 -0400
Message-ID: <4DE6579F.8080402@interlog.com>
References: <201106011318.p51DImMr003035@pentland.suse.de> <1306940171.11897.52.camel@mulgrave.site> <4DE65408.2020502@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37562 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab1FAPQF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 11:16:05 -0400
In-Reply-To: <4DE65408.2020502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On 11-06-01 11:00 AM, Hannes Reinecke wrote:
> On 06/01/2011 04:56 PM, James Bottomley wrote:
>> On Wed, 2011-06-01 at 15:18 +0200, Hannes Reinecke wrote:
>>> Currently it's impossible to find out if the host supports
>>> wide SCSI unless you're committed to trawl through syslog.
>>> And it's near impossible to find the actual HBA id, which
>>> is settable for some SCSI HBAs (like aic7xxx).
>>> So export them via sysfs.
>>
>> Um, that's what the the
>>
>> /sys/class/spi_transport/target<x:y:x>/max_width
>>
>> parameter gives you, isn't it?
>>
>> max_width tells you if the HBA/device combination supports wide; width
>> tells you if the device is using it.
>>
> Not quite. You'll only have that parameter if there is a target attached to the
> HBA.
> If there is none you still wouldn't know how far you should be scanning as there
> won't be any indicator in sysfs.
>
> In this case that's an ESX server emulating an sym53c8xx HBA.
> And disks attached to it on the fly.
> If you start up with no disks attached and attach a new disc
> to eg target ID 12 you're stuck.

It is about time that VMware emulated SAS rather than SPI for
virtual storage. Then if something changes, ESX can emulate
a SAS Broadcast(Change) and then smarter SAS HBA drivers will
run their discover process and find the changes.

Doug Gilbert
