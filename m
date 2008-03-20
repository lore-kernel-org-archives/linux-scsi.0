From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] rework scsi_target allocation
Date: Thu, 20 Mar 2008 13:35:02 -0500
Message-ID: <1206038103.3038.37.camel@localhost.localdomain>
References: <20080318133228.764CA15915C@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56331 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYCTSfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 14:35:07 -0400
In-Reply-To: <20080318133228.764CA15915C@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> The current target allocation code registeres each possible target
> with sysfs; it will be deleted again if no useable LUN on this target
> was found. This results in a string of 'target add/target remove' uevents.
> 
> This patch reworks the target allocation code so that only
> uevents for existing targets are sent. The sysfs registration
> is split off from the existing scsi_target_alloc() into a
> in a new scsi_add_target() function, which should be called
> whenever an existing target is found. Only then a uevent is
> sent, so we'll be generating events for existing targets only.
> 
> And while we're at it the cleanup code has been moved to the
> ->release function, so that the target will always be useable
> as long as the reference to it is held.

This just doesn't work.  The problem is that calling
transport_destroy_device() from the release method means the target is
never released.  I know you tried to work around it in patch 6 (Fix
refcounting for attribute_container) but that doesn't fix it (and it's
not really correct: the attributes are using the device, they should
have a ref to it).  The underlying problem is that in the new view of
classes, the directory for the class devices already has a ref on the
target.

You can see this simply by removing and inserting the aic79xx module
with these patches applied:

list_add corruption. prev->next should be next (c045e3c0), but was 6b6b6b6b. (prev=f5374b84).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000:04:00.0/irq
Modules linked in: aic79xx(+) sr_mod cdrom serio_raw iTCO_wdt iTCO_vendor_support i3000_edac ext3 jbd mbcache sd_mod uhci_hcd scsi_transport_spi aic94xx libsas libata firmware_class scsi_transport_sas tg3 usbcore scsi_mod [last unloaded: aic79xx]

Pid: 4139, comm: modprobe Not tainted (2.6.25-rc6-mc7 #12)
EIP: 0060:[<c01ed92a>] EFLAGS: 00010282 CPU: 1
EIP is at __list_add+0x5a/0x60
EAX: 00000061 EBX: f7a06d9c ECX: c0119540 EDX: f7d7af30
ESI: f8963d20 EDI: 00000011 EBP: f7a6be40 ESP: f7a6be2c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 4139, ti=f7a6a000 task=f7d7af30 task.ti=f7a6a000)
Stack: c0416d00 c045e3c0 6b6b6b6b f5374b84 f7a06d9c f7a6be4c c025722b f7a06d50 
       f7a6be5c f8870b24 ffffffed f89652c0 f7a6be88 f884e0fa f89652c0 00000001 
       f89652c0 f89652c0 00000011 f7a6be88 f89652c0 f89652c0 00000011 f7a6bfb0 
Call Trace:
 [<c025722b>] ? attribute_container_register+0x3b/0x50
 [<f8870b24>] ? spi_attach_transport+0x44/0x80 [scsi_transport_spi]
 [<f884e0fa>] ? ahd_linux_init+0xfa/0x2bc [aic79xx]
 [<c01487aa>] ? sys_init_module+0xea/0x1c90
 [<c0128140>] ? __request_region+0x0/0x80
 [<c01041d7>] ? restore_nocheck+0x12/0x15
 [<c01405ed>] ? trace_hardirqs_on+0xbd/0x140
 [<c0104176>] ? syscall_call+0x7/0xb
 =======================
Code: 44 24 08 c7 04 24 b0 6c 41 c0 e8 92 54 f3 ff 0f 0b eb fe 89 54 24 08 89 4c 24 04 89 44 24 0c c7 04 24 00 6d 41 c0 e8 76 54 f3 ff <0f> 0b eb fe 66 90 8b 0a 55 89 e5 e8 96 ff ff ff 5d c3 90 90 90 
EIP: [<c01ed92a>] __list_add+0x5a/0x60 SS:ESP 0068:f7a6be2c
---[ end trace 5eac9928f4e352f7 ]---

James


