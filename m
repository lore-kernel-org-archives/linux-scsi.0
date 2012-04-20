From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] libsas fixes for 3.4-rc4
Date: Fri, 20 Apr 2012 15:29:02 -0700
Message-ID: <1334960945.21447.19.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, jack_wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

Linus,

The following changes since commit cd8df932d894f3128c884e3ae1b2b484540513db:

  [SCSI] qla4xxx: Update driver version to 5.02.00-k15 (2012-02-29 17:03:03 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git tags/libsas-fixes

for you to fetch changes up to 3385b6baa9f3bbf69d4c1fc58342936e75d095b1:

  Revert "[SCSI] libsas: fix sas port naming" (2012-04-19 23:48:12 -0700)

----------------------------------------------------------------
libsas-fixes for 3.4-rc4

Regression fixes to stabilize the new workqueue and ata asynchronous
error handling implementation that was merged for v3.4-rc1.

1/ fix regression in sas_drain_work() which was stomping on 'work'
   entries while the workqueue was manipulating them.  User sees
   random crashes when trying to use scsi_transport_sas attributes for
   resets, or during discovery.

2/ (2) longstanding bugs related to the fact that libata (inventor and
   primary host_eh_scheduled user) had built-in assumptions of 1:1
   Scsi_Host-to-ata_port relationship.  The libsas 1:N arrangement
   magnified these problems when it gained async eh and began scheduling
   eh in more scenarios (sas-transports resets) in 3.4-rc1.

3/ lifetime fixes for the rphy since code that has a domain_device
   reference expects to be able to de-reference rphy parameters.

4/ (3) fixes for expander discovery bugs, one a recent regression with
   ata-eh clobbering expander-phy data as it polled leading to system
   crashes, a long standing bug that caused libsas to be
   incompatible with expanders that advertised "PHY_VACANT" in low order
   phy indexes, and a quirk for expanders that sometimes fail to zero
   the sas address when no device is attached.

5/ fix for a long-standing bug whereby hotunplug events during initial
   host scan can cause a system crash

6/ fix for a mvsas regression caused by the new end-device naming in
   libsas making the incorrect assumption that at all phy ids
   exported by an lldd are unique.

----------------------------------------------------------------

These patches, save for the new "scsi: fix eh wakeup (scsi_schedule_eh
vs scsi_restart_operations)" and "Revert "[SCSI] libsas: fix sas port
naming", were all originally posted before the merge
window opened, and have also appeared in -next for the same timeframe.

The commit dates are not that aged (9 days old) because they were
rebased out of larger set of updates that were pending for 3.4.

There is a mix of pure regression fixes and fixes for long-standing bugs
in libsas.  Some of the long-standing bug fixes are made worse / easier
to trigger by the new async error handling scheme.

The largest patch in the series is "libata, libsas: introduce sched_eh
and end_eh port ops" it has been on the list since March 10th.

Jack Wang has independently tested this set with pm8001 and reports
success. [1]

Apologies if scsi-rc-fixes was in the process of picking these up.  With
-rc4 looming I lost my nerve and pulled the trigger.

--
Dan


[1]: http://www.spinics.net/lists/linux-scsi/msg58761.html

Dan Williams (11):
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      libata, libsas: introduce sched_eh and end_eh port ops
      libsas: fix sas_get_port_device regression
      libsas: unify domain_device sas_rphy lifetimes
      libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
      libata: make ata_print_id atomic
      libsas, libata: fix start of life for a sas ata_port
      scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
      libsas: fix false positive 'device attached' conditions
      scsi_transport_sas: fix delete vs scan race
      Revert "[SCSI] libsas: fix sas port naming"

Maciej Trela (1):
      libsas: cleanup spurious calls to scsi_schedule_eh

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

 drivers/ata/libata-core.c           |    8 +++-
 drivers/ata/libata-eh.c             |   57 +++++++++++++++++++++------
 drivers/ata/libata-scsi.c           |   35 +++++++++--------
 drivers/ata/libata.h                |    2 +-
 drivers/scsi/ipr.c                  |    6 ++-
 drivers/scsi/libsas/sas_ata.c       |   72 +++++++++++++++++++++--------------
 drivers/scsi/libsas/sas_discover.c  |   67 ++++++++++++++++++--------------
 drivers/scsi/libsas/sas_event.c     |   36 +++++++++---------
 drivers/scsi/libsas/sas_expander.c  |   56 +++++++++++++++++++++------
 drivers/scsi/libsas/sas_init.c      |   25 ++++++------
 drivers/scsi/libsas/sas_internal.h  |    6 +--
 drivers/scsi/libsas/sas_phy.c       |   21 ++++------
 drivers/scsi/libsas/sas_port.c      |   17 +++------
 drivers/scsi/libsas/sas_scsi_host.c |   28 ++++++++++----
 drivers/scsi/scsi_error.c           |   14 +++++++
 drivers/scsi/scsi_transport_sas.c   |    6 ++-
 include/linux/libata.h              |    7 +++-
 include/scsi/libsas.h               |   44 ++++++++++++++++++---
 include/scsi/sas_ata.h              |    9 ++++-
 19 files changed, 344 insertions(+), 172 deletions(-)


commit 3385b6baa9f3bbf69d4c1fc58342936e75d095b1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 19 23:48:12 2012 -0700

    Revert "[SCSI] libsas: fix sas port naming"
    
    This reverts commit a692b0eec5efae382dfa800e8b4b083f172921a7.
    
    Tom reports:
    
    [    8.741033] ------------[ cut here ]------------
    [    8.741038] WARNING: at fs/sysfs/dir.c:508 sysfs_add_one+0xc1/0xf0()
    [    8.741040] Hardware name: To Be Filled By O.E.M.
    [    8.741041] sysfs: cannot create duplicate filename
    
    ...and missing 2 out of 4 drives connected to mvsas.  Commit a692b0ee
    made the assumption that all the phy ids an lldd registers to libsas are
    unique.  However, in the "multi-chip" case mvsas does a rather annoying
    duplication of phy ids in the array passed to libsas.  So, for example,
    chip0 has phy0-3 at ha phy index 0-3 and chip1 has its phy0-3 at ha phy
    index 4-7.  The more natural model would be to create a scsi_host (and
    sas_ha) per chip (controller), but for now revert the naming fix which
    unfortunately means dealing with unpredictable end-device names for a
    bit longer.
    
    Cc: Xiangliang Yu <yuxiangl@marvell.com>
    Cc: Patrick Thomson <patrick.s.thomson@intel.com>
    Reported-by: Tom Rini <trini@ti.com>
    Tested-by: Tom Rini <trini@ti.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e81dcce46fdbb2c968d7314c2f19da3c2bba24d1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 20 10:58:38 2012 -0700

    scsi_transport_sas: fix delete vs scan race
    
    The following crash results from cases where the end_device has been
    removed before scsi_sysfs_add_sdev has had a chance to run.
    
     BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
     IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
     ...
     Call Trace:
      [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
      [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
      [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
      [<ffffffff8125e70b>] kobject_add+0x64/0x66
      [<ffffffff8131122b>] device_add+0x12d/0x63a
      [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
      [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
      [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
      [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145
    
    ...teach sas_rphy_remove to wait for async scanning to quiesce before
    removing the end_device.  It seems this is a more general problem [1],
    but this patch only addresses sas transport.
    
    [1]: 23edb6e [SCSI] mpt2sas: Do not set sas_device->starget to NULL from
    the slave_destroy callback when all the LUNS have been deleted
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 55c53f6aed389e9e789df8d8e65d728ac125dba1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 20 10:50:27 2012 -0700

    libsas: fix false positive 'device attached' conditions
    
    Normalize phy->attached_sas_addr to return a zero-address in the case
    when device-type == NO_DEVICE or the linkrate is invalid to handle
    expanders that put non-zero sas addresses in the discovery response:
    
     sas: ex 5001b4da000f903f phy02:U:0 attached: 0100000000000000 (no device)
     sas: ex 5001b4da000f903f phy01:U:0 attached: 0100000000000000 (no device)
     sas: ex 5001b4da000f903f phy03:U:0 attached: 0100000000000000 (no device)
     sas: ex 5001b4da000f903f phy00:U:0 attached: 0100000000000000 (no device)
    
    Reported-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fcc1ce20ffbc553b25b6c635f4bb838940f58d2d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 6 16:35:36 2012 -0700

    scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)
    
    Rapid ata hotplug on a libsas controller results in cases where libsas
    is waiting indefinitely on eh to perform an ata probe.
    
    A race exists between scsi_schedule_eh() and scsi_restart_operations()
    in the case when scsi_restart_operations() issues i/o to other devices
    in the sas domain.  When this happens the host state transitions from
    SHOST_RECOVERY (set by scsi_schedule_eh) back to SHOST_RUNNING and
    ->host_busy is non-zero so we put the eh thread to sleep even though
    ->host_eh_scheduled is active.
    
    Before putting the error handler to sleep we need to check if the
    host_state needs to return to SHOST_RECOVERY for another trip through
    eh.
    
    Cc: Tejun Heo <tj@kernel.org>
    Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
    Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fcf62bdd26101fe6ae8760c5e9eb4d5e49e0a5ec
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 21 21:09:07 2012 -0700

    libsas, libata: fix start of life for a sas ata_port
    
    This changes the ordering of initialization and probing events from:
      1/ allocate rphy in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
      2/ allocate ata_port and schedule port probe in DISCE_PROBE
    ...to:
      1/ allocate ata_port in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
      2/ allocate rphy in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
      3/ schedule port probe in DISCE_PROBE
    
    This ordering prevents PHYE_SIGNAL_LOSS_EVENTS from sneaking in to
    destrory ata devices before they have been fully initialized:
    
      BUG: unable to handle kernel paging request at 0000000000003b10
      IP: [<ffffffffa0053d7e>] sas_ata_end_eh+0x12/0x5e [libsas]
      ...
      [<ffffffffa004d1af>] sas_unregister_common_dev+0x78/0xc9 [libsas]
      [<ffffffffa004d4d4>] sas_unregister_dev+0x4f/0xad [libsas]
      [<ffffffffa004d5b1>] sas_unregister_domain_devices+0x7f/0xbf [libsas]
      [<ffffffffa004c487>] sas_deform_port+0x61/0x1b8 [libsas]
      [<ffffffffa004bed0>] sas_phye_loss_of_signal+0x29/0x2b [libsas]
    
    ...and kills the awkward "sata domain_device briefly existing in the
    domain without an ata_port" state.
    
    Reported-by: Michal Kosciowski <michal.kosciowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cb7e940b56fc8a67a6a17bc7935268f7b128f90d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 21 21:09:05 2012 -0700

    libata: make ata_print_id atomic
    
    This variable is incremented from multiple contexts (module_init via
    libata-lldds and the libsas discovery thread).  Make it atomic to head
    off any chance of libsas and libata creating duplicate ids.
    
    Acked-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6ec4dacc7c11b5999abe78f9a7e0125062b1d660
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 20 13:24:29 2012 -0700

    libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
    
    The check_ready implementation in the expander-attached ata device case
    polls on sas_ex_phy_discover().  The effect is that the ex_phy fields
    (critically ->attached_sas_addr) can change.  When ata_eh ends and
    libsas comes along to revalidate the domain
    sas_unregister_devs_sas_addr() can fail to lookup devices to remove, or
    fail to re-add an ata device that ata_eh marked as disabled.  So change
    the code to skip the sas_address and change count updates when ata_eh is
    active.
    
    Cc: Jack Wang <jack_wang@usish.com>
    Tested-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Tested-by: Bartek Nowakowski <bartek.nowakowski@intel.com>
    Tested-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit db25a56d901cfc259240d6b6cf999170d7f35fff
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 20 10:53:24 2012 -0700

    libsas: unify domain_device sas_rphy lifetimes
    
    Since the domain_device can out live the scsi_target we need the rphy to
    follow suit otherwise we run into issues like:
    
      BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
      IP: [<ffffffffa011561b>] sas_ata_printk+0x43/0x6f [libsas]
      PGD 0
      Oops: 0000 [#1] SMP
      CPU 1
      Modules linked in: ses enclosure isci libsas scsi_transport_sas fuse sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf microcode pcspkr igb joydev iTCO_wdt ioatdma iTCO_vendor_support i2c_i801 i2c_core dca wmi hed ipv6 pata_acpi ata_generic [last unloaded: scsi_wait_scan]
    
      Pid: 129, comm: kworker/u:3 Not tainted 3.3.0-rc5-isci+ #1 Intel Corporation SandyBridge Platform/To be filled by O.E.M.
      RIP: 0010:[<ffffffffa011561b>] [<ffffffffa011561b>] sas_ata_printk+0x43/0x6f [libsas]
      RSP: 0018:ffff88042232dd70 EFLAGS: 00010282
      RAX: 0000000000000000 RBX: ffff8804283165b8 RCX: ffff88042232dda0
      RDX: ffff88042232dd78 RSI: ffff8804283165b8 RDI: ffffffffa01188d7
      RBP: ffff88042232ddd0 R08: ffff880388454000 R09: ffff8803edfde1f8
      R10: ffff8803edfde1f8 R11: ffff8803edfde1f8 R12: ffff880428316750
      R13: ffff880388454000 R14: ffff8803f88b31d0 R15: ffff8803f8b21d50
      FS: 0000000000000000(0000) GS:ffff88042ee20000(0000) knlGS:0000000000000000
      CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
      CR2: 0000000000000050 CR3: 0000000001a05000 CR4: 00000000000406e0
      DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
      DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
      Process kworker/u:3 (pid: 129, threadinfo ffff88042232c000, task ffff88042230c920)
      Stack:
      0000000000000000 ffff880400000018 ffff88042232dde0 ffff88042232dda0
      ffffffffa01188c4 ffff88042ee93af0 ffff88042232ddb0 ffffffff8100e047
      ffff88042232de10 ffff880420e5a2c8 ffff8803f8b21d50 ffff8803edfde1f8
      Call Trace:
      [<ffffffff8100e047>] ? load_TLS+0xb/0xf
      [<ffffffffa01156ad>] async_sas_ata_eh+0x66/0x95 [libsas]
      [<ffffffff810655e1>] async_run_entry_fn+0x9e/0x131
    
    Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
    Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6be254f019fd8dadc63cc63ded75d2422e2057b7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 12 11:38:26 2012 -0700

    libsas: fix sas_get_port_device regression
    
    Commit 899fcf4 "[SCSI] libsas: set attached device type and target
    protocols for local phys" setup 'phy' to be dereferenced after
    list_for_each_entry(phy, &port->phy_list, port_phy_el) (i.e. phy ==
    &port->phy_list) resulting in reports like:
    
      BUG: unable to handle kernel NULL pointer dereference at 00000000000002b0
      IP: [<ffffffffa00ce948>] sas_discover_domain+0x29e/0x4fb [libsas]
    
    ...fix by deferring sas_phy_set_target() to the end of
    sas_get_port_device().
    
    Reported-by: Tom Jackson <thomas.p.jackson@intel.com>
    Tested-by: Tom Jackson <thomas.p.jackson@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 71cb71d183256fbe77f35558606989c8f47c4ff0
Author: Thomas Jackson <thomas.p.jackson@intel.com>
Date:   Fri Feb 17 18:33:10 2012 -0800

    libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys
    
    If an expander reports 'PHY VACANT' for a phy index prior to the one
    that generated a BCN libsas fails rediscovery.  Since a vacant phy is
    defined as a valid phy index that will never have an attached device
    just continue the search.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Thomas Jackson <thomas.p.jackson@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 705885cb7b906ebddafbaedd693c355f8350ac4e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 1 18:44:25 2012 -0800

    libata, libsas: introduce sched_eh and end_eh port ops
    
    When managing shost->host_eh_scheduled libata assumes that there is a
    1:1 shost-to-ata_port relationship.  libsas creates a 1:N relationship
    so it needs to manage host_eh_scheduled cumulatively at the host level.
    The sched_eh and end_eh port port ops allow libsas to track when domain
    devices enter/leave the "eh-pending" state under ha->lock (previously
    named ha->state_lock, but it is no longer just a lock for ha->state
    changes).
    
    Since host_eh_scheduled indicates eh without backing commands pinning
    the device it can be deallocated at any time.  Move the taking of the
    domain_device reference under the port_lock to guarantee that the
    ata_port stays around for the duration of eh.
    
    Cc: Tejun Heo <tj@kernel.org>
    Acked-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3c1dbbd2529c659745c047c449037e4f94d326cb
Author: Maciej Trela <maciej.trela@intel.com>
Date:   Sun Mar 4 17:58:55 2012 -0800

    libsas: cleanup spurious calls to scsi_schedule_eh
    
    eh is woken up automatically by the presence of failed commands,
    scsi_schedule_eh is reserved for cases where there are no failed
    commands.  This guarantees that host_eh_sceduled is only incremented
    when an explicit eh request is made.
    
    Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Maciej Trela <maciej.trela@intel.com>
    [fixed spurious delete of sas_ata_task_abort]
    Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 63494f1cc2022fd9271c0af3399df3bc7dbec55c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 9 11:00:06 2012 -0800

    libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
    
    When requeuing work to a draining workqueue the last work instance may
    not be idle, so sas_queue_work() must not touch work->entry.  Introduce
    sas_work with a drain_node list_head to have a private list for
    collecting work deferred due to drain collision.
    
    Fixes reports like:
      BUG: unable to handle kernel NULL pointer dereference at           (null)
      IP: [<ffffffff810410d4>] process_one_work+0x2e/0x338
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


