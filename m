From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
Date: Fri, 12 Mar 2010 22:13:05 -0700
Message-ID: <20100313051305.GA19498@parisc-linux.org>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com> <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com> <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org> <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org> <4B9B0868.7080807@kernel.org> <1268455576.2802.750.camel@mulgrave.site> <m1sk843jib.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m1sk843jib.fsf@fess.ebiederm.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Yinghai Lu <yinghai@kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>, linux-acpi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 12, 2010 at 08:58:36PM -0800, Eric W. Biederman wrote:
> The root problem is that we occasionally have unrecognized deadlocks
> on the sysfs attributes.
> 
> For 2.6.33 I managed to get lockdep mostly working but there the way
> I did it generated a lot of false positives.
> 
> For 2.6.34 I reworked the sysfs lockdep handling to remove the false
> positives by treating each sysfs attribute as it's own class.  Most
> sysfs attributes are declared statically and don't need any
> initialization.  Unfortunately there are a handful of dynamically
> allocated sysfs attributes that do need initialization.
> 
> This patch is a fix to get one of those last handful of dynamically
> allocated sysfs attributes that I missed and apparently do not
> exist in my test system.

There's a few more than this showing up on my laptop.  Looking in dmesg,
the first gets a backtrace:

[    1.034471] BUG: key f6a26638 not in .data!
[    1.034600] ------------[ cut here ]------------
[    1.034736] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xd1/0x40c()
[    1.034867] Hardware name: LifeBook P8010
[    1.034993] Modules linked in:
[    1.035170] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-00005-g522dba7 #80
[    1.035300] Call Trace:
[    1.035428]  [<c102caba>] warn_slowpath_common+0x60/0x90
[    1.035561]  [<c102caf7>] warn_slowpath_null+0xd/0x10
[    1.035694]  [<c104fa6a>] lockdep_init_map+0xd1/0x40c
[    1.035827]  [<c10de32a>] ? sysfs_new_dirent+0x73/0xdb
[    1.035959]  [<c10ddc56>] sysfs_add_file_mode+0x4c/0x88
[    1.036132]  [<c10ddca0>] sysfs_add_file+0xe/0x13
[    1.036264]  [<c10ddd32>] sysfs_create_file+0x20/0x22
[    1.036394]  [<c11ee279>] device_create_file+0x13/0x15
[    1.036528]  [<c129246e>] thermal_zone_device_register+0x3d0/0x5db
[    1.036662]  [<c11b160f>] acpi_thermal_add+0x1f6/0x42d

Subsequent ones don't:

[    1.039072] BUG: key f6a26668 not in .data!
[    1.039220] BUG: key f6a2f488 not in .data!
[    1.039358] BUG: key f6a2f408 not in .data!
[    1.039571] thermal LNXTHERM:01: registered as thermal_zone0
[    1.039719] ACPI: Thermal Zone [TZ00] (27 C)
[    1.040515] BUG: key f6a18e38 not in .data!
[    1.040648] BUG: key f6a18e68 not in .data!
[    1.040800] BUG: key f6a9ef88 not in .data!
[    1.040941] BUG: key f6a9ef08 not in .data!
[    1.041185] thermal LNXTHERM:02: registered as thermal_zone1

[   25.196957] iwlagn 0000:14:00.0: firmware: requesting iwlwifi-4965-2.ucode
[   25.197163] BUG: key f663393c not in .data!
[   25.217340] iwlagn 0000:14:00.0: loaded firmware version 228.57.2.21

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
