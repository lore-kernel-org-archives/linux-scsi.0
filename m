From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 20:13:50 -0400
Message-ID: <430BBBBE.4070408@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050823154232.GA3464@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42712 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932505AbVHXANy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 20:13:54 -0400
In-Reply-To: <20050823154232.GA3464@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/23/05 11:42, Patrick Mansfield wrote:
> On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:
> 
> 
>>- the target id is logical for everything but SPI
> 
> 
>>For FC, target ids are typically assigned to devices on a
>>1st-seen-1st-assigned basis. For several reasons, there can be
>>changes in port discovery order after link events (cable pulls,
>>etc). For 2.4 kernels, the driver typically maintained a mapping
>>within the driver to ensure the same device showed up at the same
>>target id, even if it disappeared for some amount of time. If FC
>>was the boot device, wacky methods were used to ensure the mapping
>>persisted boot-to-boot.
> 
> 
> As others stated, id is already a tag/label. You should be able to pass
> whatever id you want to scsi_scan_target, like the FC ID (port_id), and

No!

The whole point is to move _away_ from HCIL.  So that addressing
of devices in SCSI Core is _completely_ independent of addressing
at the protocol layer.

In fact SCSI Core neither needs to address/enumerate the devices,
nor it needs to know any kind of addressing.

All SCSI Core needs is a pointer to a structure that it can pass
to the LLDD's Execute Task, so that the task can be sent to that
device and executed.

This allows great versatility between type of device, protocol
it speaks, command set it uses, transport used to talk to the device.

> then we also want an abstract iterator in fc transport for the id for
> usage in scsi_scan.c:scsi_scan_channel. Then you can lose all the
> fc_host->next_target_id code.

This gets too complicated and unnecessary.  First there is no such
thing as scsi_scan_channel() for FC or for SAS or for iSCSI or for ...

If you use propely the kobject model, no such "container" is needed.
Hotplug works very nice too.

	Luben











