From: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Date: Fri, 22 Mar 2019 15:21:06 +0200
Message-ID: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

The printk family of functions supports %ps and %pS conversion specifiers
to print function names. Yet the deprecated %pf and %pF conversion
specifiers with equivalent functionality remain supported. A number of
users of %pf and %pF remain.

This patchsets converts the existing users of %pf and %pF to %ps and %pS,
respectively, and removes support for the deprecated %pf and %pF.

The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
%pf or %pF users have been added in the meantime so the patch is
sufficient as itself on linux-next, too.

Sakari Ailus (2):
  treewide: Switch printk users from %pf and %pF to %ps and %pS,
    respectively
  vsprintf: Remove support for %pF and %pf in favour of %pS and %ps

 Documentation/core-api/printk-formats.rst | 10 ----------
 arch/alpha/kernel/pci_iommu.c             | 20 ++++++++++----------
 arch/arm/mach-imx/pm-imx6.c               |  2 +-
 arch/arm/mm/alignment.c                   |  2 +-
 arch/arm/nwfpe/fpmodule.c                 |  2 +-
 arch/microblaze/mm/pgtable.c              |  2 +-
 arch/sparc/kernel/ds.c                    |  2 +-
 arch/um/kernel/sysrq.c                    |  2 +-
 arch/x86/include/asm/trace/exceptions.h   |  2 +-
 arch/x86/kernel/irq_64.c                  |  2 +-
 arch/x86/mm/extable.c                     |  4 ++--
 arch/x86/xen/multicalls.c                 |  2 +-
 drivers/acpi/device_pm.c                  |  2 +-
 drivers/base/power/main.c                 |  6 +++---
 drivers/base/syscore.c                    | 12 ++++++------
 drivers/block/drbd/drbd_receiver.c        |  2 +-
 drivers/block/floppy.c                    | 10 +++++-----
 drivers/cpufreq/cpufreq.c                 |  2 +-
 drivers/mmc/core/quirks.h                 |  2 +-
 drivers/nvdimm/bus.c                      |  2 +-
 drivers/nvdimm/dimm_devs.c                |  2 +-
 drivers/pci/pci-driver.c                  | 14 +++++++-------
 drivers/pci/quirks.c                      |  4 ++--
 drivers/pnp/quirks.c                      |  2 +-
 drivers/scsi/esp_scsi.c                   |  2 +-
 fs/btrfs/tests/free-space-tree-tests.c    |  4 ++--
 fs/f2fs/f2fs.h                            |  2 +-
 fs/pstore/inode.c                         |  2 +-
 include/trace/events/btrfs.h              |  2 +-
 include/trace/events/cpuhp.h              |  4 ++--
 include/trace/events/preemptirq.h         |  2 +-
 include/trace/events/rcu.h                |  4 ++--
 include/trace/events/sunrpc.h             |  2 +-
 include/trace/events/timer.h              |  8 ++++----
 include/trace/events/vmscan.h             |  4 ++--
 include/trace/events/workqueue.h          |  4 ++--
 include/trace/events/xen.h                |  2 +-
 init/main.c                               |  6 +++---
 kernel/async.c                            |  4 ++--
 kernel/events/uprobes.c                   |  2 +-
 kernel/fail_function.c                    |  2 +-
 kernel/irq/debugfs.c                      |  2 +-
 kernel/irq/handle.c                       |  2 +-
 kernel/irq/manage.c                       |  2 +-
 kernel/irq/spurious.c                     |  4 ++--
 kernel/rcu/tree.c                         |  2 +-
 kernel/stop_machine.c                     |  2 +-
 kernel/time/sched_clock.c                 |  2 +-
 kernel/time/timer.c                       |  2 +-
 kernel/workqueue.c                        | 12 ++++++------
 lib/error-inject.c                        |  2 +-
 lib/percpu-refcount.c                     |  4 ++--
 lib/vsprintf.c                            |  8 ++------
 mm/memblock.c                             | 12 ++++++------
 mm/memory.c                               |  2 +-
 mm/vmscan.c                               |  2 +-
 net/ceph/osd_client.c                     |  2 +-
 net/core/net-procfs.c                     |  2 +-
 net/core/netpoll.c                        |  4 ++--
 scripts/checkpatch.pl                     |  5 -----
 60 files changed, 111 insertions(+), 130 deletions(-)

-- 
2.11.0
