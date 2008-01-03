From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 3 Jan 2008 13:50:20 +0800
Message-ID: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757348AbYACFrJ@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net, jarkao2@gmail.com, krh@redhat.com, stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net, James.Bottomley@HansenPartnership.com, a.zummo@towertech.it, cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org, i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net, spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert semaphore to mutex in struct class.
All the patches in this series should be applyed simultaneously

toc:
---
1-driver-core-struct-class-convert-semaphore-to-mutex.patch
2-i2c-struct-class-convert-semaphore-to-mutex.patch
3-ieee1394-struct-class-convert-semaphore-to-mutex.patch
4-power-struct-class-convert-semaphore-to-mutex.patch
5-rtc-struct-class-convert-semaphore-to-mutex.patch
6-scsi-struct-class-convert-semaphore-to-mutex.patch
7-spi-struct-class-convert-semaphore-to-mutex.patch

Summary diffstat:
---
drivers/base/class.c              |   22 ++++++++++----------
drivers/base/core.c               |   13 +++++-------
drivers/i2c/i2c-core.c            |    9 +++-----
drivers/ieee1394/nodemgr.c        |   40 +++++++++++++++++++-------------------
drivers/power/apm_power.c         |    6 ++---
drivers/power/power_supply_core.c |    8 +++----
drivers/rtc/interface.c           |    4 +--
drivers/scsi/hosts.c              |    4 +--
drivers/spi/spi.c                 |    4 +--
include/linux/device.h            |    3 +-
10 files changed, 56 insertions(+), 57 deletions(-)

One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add

Jan  3 10:45:15 darkstar kernel: =============================================
Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
Jan  3 10:45:15 darkstar kernel: modprobe/2130 is trying to acquire lock:
Jan  3 10:45:15 darkstar kernel:  (&cls->mutex){--..}, at: [<c02d4ee0>] class_device_add+0x140/0x240
Jan  3 10:45:15 darkstar kernel:
Jan  3 10:45:15 darkstar kernel: but task is already holding lock:
Jan  3 10:45:15 darkstar kernel:  (&cls->mutex){--..}, at: [<c02d52c3>] class_interface_register+0x43/0xf0
Jan  3 10:45:15 darkstar kernel:
Jan  3 10:45:15 darkstar kernel: other info that might help us debug this:
Jan  3 10:45:15 darkstar kernel: 1 lock held by modprobe/2130:
Jan  3 10:45:15 darkstar kernel:  #0:  (&cls->mutex){--..}, at: [<c02d52c3>] class_interface_register+0x43/0xf0
Jan  3 10:45:15 darkstar kernel:
Jan  3 10:45:15 darkstar kernel: stack backtrace:
Jan  3 10:45:15 darkstar kernel: Pid: 2130, comm: modprobe Not tainted 2.6.24-rc6-mm1-mutex #1
Jan  3 10:45:15 darkstar kernel:  [<c0104d2a>] show_trace_log_lvl+0x1a/0x30
Jan  3 10:45:15 darkstar kernel:  [<c0104d52>] show_trace+0x12/0x20
Jan  3 10:45:15 darkstar kernel:  [<c0104ecd>] dump_stack+0x6d/0x80
Jan  3 10:45:15 darkstar kernel:  [<c0152867>] print_deadlock_bug+0xc7/0xe0
Jan  3 10:45:15 darkstar kernel:  [<c01528ec>] check_deadlock+0x6c/0x80
Jan  3 10:45:15 darkstar kernel:  [<c0152d5c>] validate_chain+0x14c/0x370
Jan  3 10:45:15 darkstar kernel:  [<c01548b0>] __lock_acquire+0x1c0/0x7e0
Jan  3 10:45:15 darkstar kernel:  [<c0155599>] lock_acquire+0x79/0xb0
Jan  3 10:45:15 darkstar kernel:  [<c04252cc>] mutex_lock_nested+0x8c/0x300
Jan  3 10:45:15 darkstar kernel:  [<c02d4ee0>] class_device_add+0x140/0x240
Jan  3 10:45:15 darkstar kernel:  [<c02d4ff2>] class_device_register+0x12/0x20
Jan  3 10:45:15 darkstar kernel:  [<c02d509a>] class_device_create+0x9a/0xb0
Jan  3 10:45:15 darkstar kernel:  [<f886225c>] sg_add+0x12c/0x200 [sg]
Jan  3 10:45:15 darkstar kernel:  [<c02d5359>] class_interface_register+0xd9/0xf0
Jan  3 10:45:15 darkstar kernel:  [<c031242f>] scsi_register_interface+0xf/0x20
Jan  3 10:45:15 darkstar kernel:  [<f882b082>] init_sg+0x82/0xbc [sg]
Jan  3 10:45:15 darkstar kernel:  [<c015e4fa>] sys_init_module+0xea/0x130
Jan  3 10:45:15 darkstar kernel:  [<c0103f42>] syscall_call+0x7/0xb
Jan  3 10:45:15 darkstar kernel:  =======================

If there's anything missed please help to point out, thanks.

Regards
dave
