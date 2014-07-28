From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 0/6] qla2xxx device removal fixups
Date: Mon, 28 Jul 2014 14:26:34 -0400
Message-ID: <alpine.OSX.2.00.1407281425400.2028@administrators-macbook-pro.local>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:59057 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbaG1S0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 14:26:54 -0400
In-Reply-To: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>

Ack the series.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Wed, 18 Jun 2014, Joe Lawrence wrote:

> Hi Chad, Giri, et al.
>
> Stratus has been testing the upstream qla2xxx driver against surprise
> device removal and has found a few minor issues along the way.  With
> this patchset, results have been good.  Although the following changes
> may be most interesting on a Stratus platform, they should be applicable
> to general hotplug scenarios on other hardware.
>
> The first two patches are independent from the others and can be
> reviewed as such.  One fixes up a use-after-free and the other
> consolidates some code.
>
> The final four patches are more invasive and modify the scsi_qla_host
> structure to avoid device removal race conditions.  These changes were
> written to demonstrate the problem at hand and minimally fix them in
> order to continue testing.  (For example, adding completely a new
> pci_flags member to scsi_qla_host is probably overkill.)
>
> We would welcome any feedback or questions about our testing.
>
> Regards,
>
> -- Joe
>
>
> Joe Lawrence (6):
>
>  qla2xxx: Fix shost use-after-free on device removal
>
>    scsi_qla_host *base_vha is allocated as part of the Scsi_Host
>    private hostdata[] by qla2x00_create_host.  When the last reference
>    on the host is put by qla2x00_remove_one, it's released along with
>    any hostdata[], rendering base_vha unsafe to dereference.
>
>    To safely complete the adapter cleanup in qla2x00_remove_one,
>    use the scsi_qla_host_t *qla_hw_data pointer that is already in
>    hand.
>
>    To reproduce, set kernel boot option slub_debug=FZPU and remove
>    an adapter instance.
>
>
>  qla2xxx: Use qla2x00_clear_drv_active on probe failure
>
>    Clean up some duplicate code along the way.
>
>
>  qla2xxx: Collect PCI register checks and board_disable scheduling
>
>    PCI register read checks are performed throughout the driver to
>    detect disconnected hardware.  There is currently a function that
>    verifies 32-bit values and schedules board_removal if needed. Other
>    16-bit registers are checked and board_removal scheduling scattered
>    around the driver.
>
>    This change pulls all of these together such that a new 16-bit
>    register check function wrappers the existing 32-bit version and
>    centralizes the scheduling of board_disable work to a single
>    invocation.
>
>    The following patches depend upon this change.
>
>
>  qla2xxx: Schedule board_disable only once
>
>    In automated hot-plug device removal testing, occasionally
>    qla2x00_disable_board_on_pci_error would run twice.  I believe this
>    occurred by a second qla2x00_check_reg_for_disconnect scheduling
>    board_disable while the first instance was still running.
>
>    The easiest solution seemed to be adding a per-adapter flag that
>    could be test_and_set before scheduling board_disable.
>
>
>  qla2xxx: Prevent removal and board_disable race
>
>    This race was discovered through many iterations of automated PCI
>    hotplug.  The automated test inserts faults on the Stratus platform
>    to simulate device removal.  After removal, it re-adds the devices,
>    simulating PCI hotplug insertion.  Rinse, repeat.
>
>    The race occurs when a Stratus proprietary hotplug driver detects
>    that PCI devices have gone missing and calls into the kernel PCI
>    subsystem to remove them.  At nearly the same time, the qla2xxx
>    driver figures out the same issue and schedules a board_disable.  It
>    takes a few hundred device removals to hit, but it seemed that the
>    problem was that qla2x00_disable_board_on_pci_error started, then
>    qla2xxx_remove_one was invoked, so one of the two started touching
>    already freed resources.
>
>    Although the bug manifested on a Stratus platform running modified
>    drivers, the window for qla2xxx_remove_one to race
>    qla2x00_disable_board_on_pci_error is still present if running stock
>    kernel/drivers on commodity hardware.  It may be difficult to hit,
>    but one could theoretically invoke PCI device removal via sysfs (or
>    simply unload the qla2xxx driver) and for board_disable to run at
>    the same time.
>
>    The fix leaves the Scsi_Host intact during board_disable so that
>    qla2x00_remove_one can safely stop the main timer and
>    cancel_work_sync on any outstanding board_disable work.  A
>    PFLG_DRIVER_REMOVING bit is also set to prevent any other
>    board_disable instances from scheduling.  Once the asynchronous
>    players are out of the way, qla2x00_remove_one can move forward
>    cleaning up whatever remaining resources are still attached.
>
>    The PCI device enable count check in qla2x00_remove_one was
>    re-purposed to determine if board_disable had run.  Its original
>    intention to detect qla2x00_probe_one failure was invalid.  As long
>    as the driver .probe routine returns an -ERRNO, then its counterpart
>    .remove routine is *not* called.
>
>
>  qla2xxx: Prevent probe and board_disable race
>
>    An automated Stratus device removal test hotplug removes devices
>    shortly during/after their initialization.  The test inserts
>    devices, then proceeds to remove them at various 1, 2, 3, 4...
>    second intervals.  This test revealed two bugs:
>
>    1 - The struct isp_operations initialize_adapter callback is invoked
>    by qla2x00_probe_one before ha->board_disable is initialized. The
>    callback will eventually read PCI registers and potentially trigger
>    the disconnection check.  If the board_disable work structure hasn't
>    been initialized, an ugly WARN trace will be emitted. The call stack
>    looked something like:
>
>      qla2x00_probe_one
>        qla2x00_initialize_adapter
>          qla2xxx_get_flash_info
>            qla2xxx_get_flt_info
>              qla25xx_read_optrom_data
>                 qla2x00_dump_ram
>                   qla2x00_mailbox_command
>                     qla24xx_intr_handler
>                       qla2x00_check_reg_for_disconnect
>
>    2 - Races between the qla2x00_disable_board_on_pci_error and
>    qla2x00_probe_one. The latter was written before any asynchronous
>    device removals were introduced by commit f3ddac1 "qla2xxx: Disable
>    adapter when we encounter a PCI disconnect," and proceeds as if it
>    were the only game in town with respect to the underlying device.
>    Restore that assumption by preventing any board_disable scheduling
>    while qla2x00_probe_one is in flight.  Holding off this scheduling
>    prevents the race, as well as avoids bug #1.
>
> drivers/scsi/qla2xxx/qla_def.h |    5 ++++
> drivers/scsi/qla2xxx/qla_gbl.h |    3 +-
> drivers/scsi/qla2xxx/qla_isr.c |   44 +++++++++++++++--------------
> drivers/scsi/qla2xxx/qla_mr.c  |    2 +-
> drivers/scsi/qla2xxx/qla_nx.c  |    6 ++--
> drivers/scsi/qla2xxx/qla_os.c  |   60 ++++++++++++++++++----------------------
> 6 files changed, 61 insertions(+), 59 deletions(-)
>
>
