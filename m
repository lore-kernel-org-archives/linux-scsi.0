From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [PATCH] scsi: fix lockdep warning
Date: Tue, 30 Mar 2010 08:05:28 -0700 (PDT)
Message-ID: <4bb21338.0d0db80a.1685.ffffb9e1@mx.google.com>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>
	<m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>
	<4BA47692.7040401@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:36874 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0C3PFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 11:05:31 -0400
In-Reply-To: <4BA47692.7040401@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <gregkh@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, 20 Mar 2010 00:17:38 -0700, Yinghai Lu <yinghai@kernel.org> wrote:
> 
> with qlogic and emulex card etc.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

As several others have pointed out, you appear to be call sysfs_bin_attr_init()
against statically allocated attributes. Is there an updated patchset that you've been meaning to send out?

Moreover, there are still failures in the ACPI thermal driver (at very least)
on master (9623e5a23724d09283c238960946ec6f65733afe).

- Ben


[    3.240692] BUG: key ffff88011b1a9528 not in .data!
[    3.245578] ------------[ cut here ]------------
[    3.250195] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x125/0x140()
[    3.257229] Hardware name: Latitude D830                   
[    3.262793] Modules linked in:
[    3.265864] Pid: 1, comm: swapper Not tainted 2.6.34-rc2-ben #137
[    3.271946] Call Trace:
[    3.274397]  [<ffffffff8105a86b>] warn_slowpath_common+0x7b/0xc0
[    3.280395]  [<ffffffff8105a8c4>] warn_slowpath_null+0x14/0x20
[    3.286220]  [<ffffffff8108ea75>] lockdep_init_map+0x125/0x140
[    3.292046]  [<ffffffff811ae51f>] sysfs_add_file_mode+0x6f/0xd0
[    3.297960]  [<ffffffff8130b464>] ? snprintf+0x34/0x40
[    3.303093]  [<ffffffff811ae591>] sysfs_add_file+0x11/0x20
[    3.308570]  [<ffffffff811ae676>] sysfs_create_file+0x26/0x30
[    3.314311]  [<ffffffff813bbe99>] device_create_file+0x19/0x20
[    3.320136]  [<ffffffff8146176b>] thermal_zone_device_register+0x45b/0x860
[    3.327001]  [<ffffffff81370e45>] acpi_thermal_add+0x245/0x4e4
[    3.332827]  [<ffffffff811b0250>] ? sysfs_do_create_link+0xd0/0x170
[    3.339085]  [<ffffffff81347100>] acpi_device_probe+0x50/0x122
[    3.344909]  [<ffffffff813bee86>] driver_probe_device+0x96/0x1a0
[    3.350906]  [<ffffffff813bef90>] ? __driver_attach+0x0/0xa0
[    3.356557]  [<ffffffff813bf02b>] __driver_attach+0x9b/0xa0
[    3.362121]  [<ffffffff813bef90>] ? __driver_attach+0x0/0xa0
[    3.367773]  [<ffffffff813be2ac>] bus_for_each_dev+0x6c/0xa0
[    3.373423]  [<ffffffff813becce>] driver_attach+0x1e/0x20
[    3.378814]  [<ffffffff813be591>] bus_add_driver+0xe1/0x280
[    3.384380]  [<ffffffff813bf378>] driver_register+0x78/0x140
[    3.390031]  [<ffffffff81b2f591>] ? acpi_thermal_init+0x0/0x7b
[    3.395855]  [<ffffffff81347a70>] acpi_bus_register_driver+0x43/0x45
[    3.402199]  [<ffffffff81b2f5ea>] acpi_thermal_init+0x59/0x7b
[    3.407938]  [<ffffffff8100204c>] do_one_initcall+0x3c/0x1a0
[    3.413591]  [<ffffffff81b05757>] kernel_init+0x15a/0x1e4
[    3.418984]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
[    3.424895]  [<ffffffff815bbf90>] ? restore_args+0x0/0x30
[    3.430286]  [<ffffffff81b055fd>] ? kernel_init+0x0/0x1e4
[    3.435678]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
[    3.441765] ---[ end trace a22d306b065d4a66 ]---
[    3.446380] BUG: key ffff88011b1a9570 not in .data!

