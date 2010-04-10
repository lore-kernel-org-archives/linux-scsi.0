From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Sat, 10 Apr 2010 19:31:17 +0400
Message-ID: <4BC099C5.9090704@vlnb.net>
References: <4BB45632.5020700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0DJPbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2010 11:31:06 -0400
In-Reply-To: <4BB45632.5020700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello Hannes,

Hannes Reinecke, on 04/01/2010 12:15 PM wrote:
> Hi all,
> 
> [Topic]
> Handling of invalid requests in virtual HBAs
> 
> [Abstract]
> This discussion will focus on the problem of correct request handling with virtual HBAs.
> For KVM I have implemented a 'megasas' HBA emulation which serves as a backend for the
> megaraid_sas linux driver.
> It is now possible to connect several disks from different (physical) HBAs to that
> HBA emulation, each having different logical capabilities wrt transfersize,
> sgl size, sgl length etc.
> 
> The goal of this discussion is how to determine the 'best' capability setting for the
> virtual HBA and how to handle hotplug scenarios, where a disk might be plugged in
> which has incompatible settings from the one the virtual HBA is using currently.

If I understand correctly, you need to allow several KVM guests to share 
the same physical disks?

If so, then it's a bit more complicated, than just to match capabilities 
between physical and virtual disks, because to safely share disks some 
advanced SCSI functionality should be emulated by the mid-level, like 
reservations and Unit Attentions. Otherwise, the sharing is very much 
against SCSI specs, so unsafe and can lead to data corruptions. More 
info you can find here: http://thread.gmane.org/gmane.linux.scsi/31288.

In my opinion, the simplest way would be:

1. Use in the host OS a SCSI target mid-layer, capable to support 
multi-initiators SCSI pass-through, like SCST (http://scst.sourceforge.net)

2. Write a simple 2 parts guest/host driver, one part of which would be 
a simple virtual HBA driver for guests, which would pass all requests 
from the guest OS to the host OS, and the second part would be a simple 
target driver for SCST, which would get requests from the virtual HBA in 
the guest and pass them to SCST on the host OS. Most likely, you already 
implemented most of the guest part of the driver in your 'megasas' HBA 
emulator. On the host side, for SCST most of the functionality already 
implemented by scst_local driver. All is necessary is to couple them 
together using some KVM transport for data between guests and host.

Thus, in this approach you need to connect the guest OS'es to already 
existing SCST (we hope someday SCST will be accepted in the mainline 
kernel, I'm currently preparing patches for the second review 
iteration), which you need to do anyway to implement correct devices 
sharing. Then SCST would do the rest.

This approach won't make any tight connection between physical and 
virtual HBAs, so can work with any SCSI-speaking HBAs (and not only-SCSI 
speaking, if a small layer to convert their requests in SCSI commands is 
implemented). The exact SCSI transport (SAS, SCSI, FC, etc.) the guest 
driver would report to the OS wouldn't matter much, because changing it 
is a matter of changing few constants. The hot plug would be handled 
automatically.

As a bonus, KVM guests would be able to use SCST emulated virtual 
devices (files as devices, virtual CDROMs, VTLs, etc.), including 
implemented in user space.

Obviously, this approach can be implemented with a minimal overhead 
(SCST internally is zero-copy).

Vlad
