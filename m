From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Wed, 10 Jan 2018 15:06:17 -0500
Message-ID: <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org>
 <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <1515601333.2745.8.camel@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44407 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752348AbeAJUG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 15:06:29 -0500
In-Reply-To: <1515601333.2745.8.camel@wdc.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "shivasharan.srikanteshwara@broadcom.com" <shivasharan.srikanteshwara@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>, "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>

On 2018-01-10 11:22 AM, Bart Van Assche wrote:
> On Tue, 2018-01-09 at 22:07 +0530, Kashyap Desai wrote:
>> Overall NVME support behind MR controller is really a SCSI device. On top
>> of that, for MegaRaid, NVME device can be part of Virtual Disk and those
>> drive will not be exposed to the driver. User application may like to talk
>> to hidden NVME devices (part of VDs). This patch will extend the existing
>> interface for megaraid product in the same way it is currently supported
>> for other protocols like SMP, SATA pass-through.
> 
> It seems to me like there is a contradiction in the above paragraph: if some
> NVMe devices are not exposed to the driver, how can a user space application
> ever send NVMe commands to it?

I think that he meant that the NVMe physical devices (e.g. SSDs) are not
exposed to the upper layers (e.g. the SCSI mid-layer and above). The
SCSI subsystem has a no_uld_attach device flag that lets a LLD attach
physical devices but the sd driver and hence the block layer do not
"see" them. The idea is that maintenance programs like smartmontools
can use them via the bsg or sg drivers. The Megaraid driver code does
not seem to use no_uld_attach. Does the NVMe subsystem have similar
"generic" (i.e. non-block) devices accessible to the user space?

> Anyway, has it been considered to implement the NVMe support as an NVMe
> transport driver? The upstream kernel already supports NVMe communication
> with NVMe PCI devices, NVMe over RDMA and NVMe over FC. If communication to
> the NVMe devices behind the MegaRaid controller would be implemented as an
> NVMe transport driver then all functionality of the Linux NVMe driver could
> be reused, including its sysfs entries.

Broadcom already sell "SAS" HBAs that have "tri-mode" phys. That is a phy
that can connect to a SAS device (e.g. a SAS expander), a SATA device or a
NVMe device. Now if I was Broadcom designing a 24 Gbps SAS-4 next generation
expander I would be thinking of using those tri-mode phys on it. But then
there is a problem, SAS currently supports 3 protocols: SSP (for SCSI
storage and enclosure management (SES)), STP (for SATA storage ) and SMP
(for expander management). The problem is how those NVMe commands, status
and data cross the wire between the OS HBA (or MegaRaid type controller) and
an expander. Solving that might need some lateral thinking.

On one hand the NVM Express folks seem to have shelved the idea of a SCSI
to NVMe Translation Layer (SNTL) and have not updated an old white paper
on the subject. Currently there is no SNTL on Linux (there was but it was
removed) or FreeBSD but there is one on Windows.

On the other hand I'm informed that recently the same body accepted the
SES-3 standard pretty much as-is. That is done with the addition of SES
Send and SES Receive commands to NVME-MI. The library under sg_ses has
already been modified to use them (by implementing a specialized SNTL).

Doug Gilbert
