From: "Gwendal Grignou" <gwendal@google.com>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Wed, 20 Aug 2008 11:55:59 -0700
Message-ID: <e7510f760808201155wd649f74jb50299d33b780cae@mail.gmail.com>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
	 <48ABD2FD.8010802@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:25352 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYHTS4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 14:56:09 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id m7KIu1se030446
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2008 19:56:02 +0100
Received: from rn-out-0910.google.com (rndk32.prod.google.com [10.38.137.32])
	by zps78.corp.google.com with ESMTP id m7KIu0k6004773
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2008 11:56:00 -0700
Received: by rn-out-0910.google.com with SMTP id k32so192952rnd.7
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2008 11:56:00 -0700 (PDT)
In-Reply-To: <48ABD2FD.8010802@kernel.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi Tejun,

1- the hierarchy

In the case CONFIG_SYSFS_DEPRECATED is not set, here is the view of
ATA topology in sysfs: [I can describe when CONFIG_SYSFS_DEPRECATED is
set upon request]

The parent of the hierarchy is the device object given when the ata
host object is created. In the following example of a ATA controller
on a PCI bus, the current directory is the pci directory of the
controller - "/sys/devices/pci0000:00/0000:00:1f.2".
If there is no port multiplier are connected connected to a port, we would find:

ata1            <== 1 is the port_id of the port
ata1/ata_port
ata1/ata_port/ata1 <== directory where sysfs attributes are
ata1/link1
ata1/link1/ata_link
ata1/link1/ata_link/link1  <== directory where sysfs attributes are
ata1/link1/dev1.0
ata1/link1/dev1.0/ata_device
ata1/link1/dev1.0/ata_device/dev1.0  <== directory where sysfs attributes are
ata1/link1/dev1.1           <== If controller can support 2 devices
per link, a second device created even if there is not slave disk
attached
ata1/link1/dev1.1/ata_device
ata1/link1/dev1.1/ata_device/dev1.1

If there is a port multiplier, 15 links are created in addition:
ata5
ata5/ata_port
ata5/ata_port/ata5
ata5/link5            <====== host link
ata5/link5/ata_link
ata5/link5/ata_link/link5
ata5/link5/dev5.0   <==== device behind the host link [port multiplier]
ata5/link5/dev5.0/ata_device
ata5/link5/dev5.0/ata_device/dev5.0
ata5/link5.0  <=== first link behind the PM, port 0
ata5/link5.0/ata_link
ata5/link5.0/ata_link/link5.0
ata5/link5.0/dev5.0.0   <=== device object for sata device connected
in port 0 of the PM [if any]
ata5/link5.0/dev5.0.0/ata_device
ata5/link5.0/dev5.0.0/ata_device/dev5.0.0
ata5/link5.1
ata5/link5.1/ata_link
ata5/link5.1/ata_link/link5.1
ata5/link5.1/dev5.1.0
ata5/link5.1/dev5.1.0/ata_device
ata5/link5.1/dev5.1.0/ata_device/dev5.1.0
ata5/link5.2
ata5/link5.2/ata_link
ata5/link5.2/ata_link/link5.2
ata5/link5.2/dev5.2.0
ata5/link5.2/dev5.2.0/ata_device
ata5/link5.2/dev5.2.0/ata_device/dev5.2.0
...
ata5/link5.14
ata5/link5.14/ata_link
ata5/link5.14/ata_link/link5.14
ata5/link5.14/dev5.14.0 <=== device object for sata device connected
in port 14 of the PM [if any]
ata5/link5.14/dev5.14.0/ata_device
ata5/link5.14/dev5.14.0/ata_device/dev5.14.0


I describe the current information you can find in these object in
Documentation/ABI/testing/sysfs-ata in the latest version of the
patch.

2- sysfs object lifecycle

I try to sync sysfs object lifetime with libata object lifetime rules.
Given libata creates objects statically, I decided to create related
sysfs objects at almost the same time, even if they are not populated:

For port object, I have to wait for for print_id to be set. In the
latest version of the patch [v4], I create the sysfs port object
before calling ata_scsi_add_host().
The sysfs link object for the host link is created when the port
object is created. Related ata_link has been initialized before.

When a SATA PMP is found, all sysfs link objects  are created in
sata_pmp_init_links(), if the data structure to hold the links behind
the PMP did not exist already.

Given sysfs link objects are always created after ata_link_init() and
ata_dev_init() are called, sysfs ata_device object are implicitly
created when the links are created.

Given during error handling link and device ata objects are wiped out
instead of being freed, I alter memset() for link and devices to not
include fields holding sysfs information.

For cleanup:
All sysfs related objects are deleted in ata_port_detach, called when
.remove entry point of a ATA driver is called.

I was tempted to add objects only when they are useful [for instance,
creating only the required number of links object behind the PMP], but
I balked away; as you point out, the lifecycle is quite different from
scsi_device for instance, and I did not want to change the logic of
libata.

Also, I tried to create a link between scsi_device and ata_device
object when appropriate, but I was not successful: scsi_device sysfs
objects are created after slave_configure is called, so I did not find
an easy hook in libata to create the link.

Thanks,

Gwendal.


On Wed, Aug 20, 2008 at 1:17 AM, Tejun Heo <tj@kernel.org> wrote:
> Gwendal Grignou wrote:
>>>From df84b33306569f8247f331fd67b0a7e7dfb47936 Mon Sep 17 00:00:00 2001
>> From: Gwendal Grignou <gwendal@google.com>
>> Date: Mon, 18 Aug 2008 14:02:09 -0700
>> Subject: Add transport class for libata.
>>
>> This patch adds objects for accessing libata objects from user space:
>> - ata_port class: one per ATA port
>> - ata_link class: one per ATA port or 15 for SATA Port Multiplier
>> - ata_device class: up to 2 for PATA link, usually one for SATA.
>>
>> Each object exports information from the corresponding data strucure.
>> For instance, ata_device exports id, the cached identify output if
>> the device is a disk, gscr register output if it is a PM.
>>
>> More fields can be added later, like error counters and ATA specific
>> statistics.
>
> Ah... I'm not so sure about the class transport approach although I do
> agree that sysfs hierarchy for libata is way overdue.  Hmmm... Can you
> please explain the planned hierarchy and how you're gonna match lifetime
> rules?  Because libata uses very different object lifetime rules from
> the generic driver layer, it can get ugly at times and from a quick
> glance I don't really think the problem has been addressed but I could
> have just missed it.
>
> Thanks.
>
> --
> tejun
>
