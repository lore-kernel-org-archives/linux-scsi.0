From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Wed, 10 Jan 2018 15:14:40 -0700
Message-ID: <e407e98c266c060412bfa8b64ded18df@mail.gmail.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org> <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <1515601333.2745.8.camel@wdc.com> <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:38981 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752464AbeAJWOn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 17:14:43 -0500
Received: by mail-qk0-f171.google.com with SMTP id r8so1418544qke.6
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2018 14:14:42 -0800 (PST)
In-Reply-To: <d6da790a-8248-c71d-6643-6ae3107989d0@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Bart Van Assche <Bart.VanAssche@wdc.com>, hch@infradead.org, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

Bart et al,
Broadcom's Tri-mode HBAs and MegaRAID controllers are capable of
connecting with SAS, SATA, NVMe drives,  SAS expanders and PCIe switches
(with NVMe drives connected behind that) and are capable of creating RAID
volumes on top of similar family of drives.  In the case of RAID
controllers, all of those drives and RAID volumes are exposed to the OS as
generic SCSI devices and in the case of HBA only for SAS and SATA the
topology is exposed to OS through SAS transport layer and NVMe drives are
exposed as generic SCSI devices.  The SCSI CDB to specific packet (SATA
frames, SSP frames or NVMe) translation occurs in the hardware/firmware.
For the OS driver, the interface to interact is common across all the type
of devices and it is MPI SCSI IO Request.

The NVMe passthru support added in this patch is only for management
purpose and will let Broadcom specific management applications to send
some direct NVMe commands to the hardware/firmware solely for management
purpose.  For normal READ/WRITE I/O the preferred path is to issue SCSI
command to our hardware/firmware and let it translate to the NVMe.

We have many architectural constraints to directly expose NVMe drives to
NVMe subsystem for normal I/O usage and management usage and hence we
prefer not to go down the path.

This patch is just addition of new feature for our management applications
(which are common across many OSes) to access a specific type of MPI
command to manage NVMe drives connected behind our HBAs (which are
non-standard) in a vendor specific way, hence we think this patch is valid
to be accepted to megaraid driver.  Please let us know if more details are
required on the tri-mode controllers.

Thanks
Sathya


-----Original Message-----
From: Linux-nvme [mailto:linux-nvme-bounces@lists.infradead.org] On Behalf
Of Douglas Gilbert
Sent: Wednesday, January 10, 2018 1:06 PM
To: Bart Van Assche; hch@infradead.org; kashyap.desai@broadcom.com;
shivasharan.srikanteshwara@broadcom.com
Cc: sumit.saxena@broadcom.com; peter.rivera@broadcom.com;
linux-nvme@lists.infradead.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support

On 2018-01-10 11:22 AM, Bart Van Assche wrote:
> On Tue, 2018-01-09 at 22:07 +0530, Kashyap Desai wrote:
>> Overall NVME support behind MR controller is really a SCSI device. On
>> top of that, for MegaRaid, NVME device can be part of Virtual Disk
>> and those drive will not be exposed to the driver. User application
>> may like to talk to hidden NVME devices (part of VDs). This patch
>> will extend the existing interface for megaraid product in the same
>> way it is currently supported for other protocols like SMP, SATA
pass-through.
>
> It seems to me like there is a contradiction in the above paragraph:
> if some NVMe devices are not exposed to the driver, how can a user
> space application ever send NVMe commands to it?

I think that he meant that the NVMe physical devices (e.g. SSDs) are not
exposed to the upper layers (e.g. the SCSI mid-layer and above). The SCSI
subsystem has a no_uld_attach device flag that lets a LLD attach physical
devices but the sd driver and hence the block layer do not "see" them. The
idea is that maintenance programs like smartmontools can use them via the
bsg or sg drivers. The Megaraid driver code does not seem to use
no_uld_attach. Does the NVMe subsystem have similar "generic" (i.e.
non-block) devices accessible to the user space?

> Anyway, has it been considered to implement the NVMe support as an
> NVMe transport driver? The upstream kernel already supports NVMe
> communication with NVMe PCI devices, NVMe over RDMA and NVMe over FC.
> If communication to the NVMe devices behind the MegaRaid controller
> would be implemented as an NVMe transport driver then all
> functionality of the Linux NVMe driver could be reused, including its
sysfs entries.

Broadcom already sell "SAS" HBAs that have "tri-mode" phys. That is a phy
that can connect to a SAS device (e.g. a SAS expander), a SATA device or a
NVMe device. Now if I was Broadcom designing a 24 Gbps SAS-4 next
generation expander I would be thinking of using those tri-mode phys on
it. But then there is a problem, SAS currently supports 3 protocols: SSP
(for SCSI storage and enclosure management (SES)), STP (for SATA storage )
and SMP (for expander management). The problem is how those NVMe commands,
status and data cross the wire between the OS HBA (or MegaRaid type
controller) and an expander. Solving that might need some lateral
thinking.

On one hand the NVM Express folks seem to have shelved the idea of a SCSI
to NVMe Translation Layer (SNTL) and have not updated an old white paper
on the subject. Currently there is no SNTL on Linux (there was but it was
removed) or FreeBSD but there is one on Windows.

On the other hand I'm informed that recently the same body accepted the
SES-3 standard pretty much as-is. That is done with the addition of SES
Send and SES Receive commands to NVME-MI. The library under sg_ses has
already been modified to use them (by implementing a specialized SNTL).

Doug Gilbert


_______________________________________________
Linux-nvme mailing list
Linux-nvme@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-nvme
