From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 0/6] qla2xxx device removal fixups
Date: Wed, 18 Jun 2014 15:35:03 +0000
Message-ID: <D63B9804CB63AD4FAAD9660376956646471BE2D7@avmb2.qlogic.org>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D63B9804CB63AD4FAAD9660376956646471BE2D7avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:33209 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbaFRPfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2014 11:35:09 -0400
In-Reply-To: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, "Bill Kuzeja (Partner - Stratus)" <William.Kuzeja@Stratus.com>, Dave Bulkow <david.bulkow@stratus.com>

--_000_D63B9804CB63AD4FAAD9660376956646471BE2D7avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B049EBCD82123449300C90F8F6302C8@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Joe,

Thanks for the patches. We will review and update.

-- Giri

On 6/18/14 7:02 AM, "Joe Lawrence" <joe.lawrence@stratus.com> wrote:

>Hi Chad, Giri, et al.
>
>Stratus has been testing the upstream qla2xxx driver against surprise
>device removal and has found a few minor issues along the way.  With
>this patchset, results have been good.  Although the following changes
>may be most interesting on a Stratus platform, they should be applicable
>to general hotplug scenarios on other hardware.
>
>The first two patches are independent from the others and can be
>reviewed as such.  One fixes up a use-after-free and the other
>consolidates some code.
>
>The final four patches are more invasive and modify the scsi_qla_host
>structure to avoid device removal race conditions.  These changes were
>written to demonstrate the problem at hand and minimally fix them in
>order to continue testing.  (For example, adding completely a new
>pci_flags member to scsi_qla_host is probably overkill.)
>
>We would welcome any feedback or questions about our testing.
>
>Regards,
>
>-- Joe
>
>
>Joe Lawrence (6):
>
>  qla2xxx: Fix shost use-after-free on device removal
>
>    scsi_qla_host *base_vha is allocated as part of the Scsi_Host
>    private hostdata[] by qla2x00_create_host.  When the last reference
>    on the host is put by qla2x00_remove_one, it's released along with
>    any hostdata[], rendering base_vha unsafe to dereference.
>     =20
>    To safely complete the adapter cleanup in qla2x00_remove_one,
>    use the scsi_qla_host_t *qla_hw_data pointer that is already in
>    hand.
>     =20
>    To reproduce, set kernel boot option slub_debug=3DFZPU and remove
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
> drivers/scsi/qla2xxx/qla_os.c  |   60
>++++++++++++++++++----------------------
> 6 files changed, 61 insertions(+), 59 deletions(-)
>
>--=20
>1.7.10.4
>


--_000_D63B9804CB63AD4FAAD9660376956646471BE2D7avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
p5MWMy8CQHzTUC2SLeH/HtDjgW1R9QBBUJ2PhNI8OP9857l8PDigv2LLufksQcUh/+bg5eCRgLzR
5vC+D77/85D7wE/BOzUsQ/EAn/EEEP9w+3hwjcBhww+77tgwS0DmoLcewMXvxt9fWUGiEG8sUO9C
cln9zE+IsjQsQRah5xD91WFk0BC9/8x/5f/nC7j/9YTRMp7hUg9RYODwAOJg/7KiTAc8rz27Wf26
X7XUBjH78UL8oncSQLWRNWD0Nf4i/2bPlZsj6NSgpWHN4kKwL7Dn5ORCciVBZjPwQA9QntD6Ioi3
RFU0f1vxFRAD1KCfctGDpTVxcjOt5ywiq1T/lvYtMv8gQtCEWt4jTAI1UO1HwWcew3uid+LBQtA0
AP8d8Q1wVCEWxSMRQWBHwAsi+44UmdtS7pH0YhPT/LAYkP9LQK5j3yFhxRXERBFU3PS3/+Y7uFBz
IdhfomQxQPUA/eD/DaCE0FOQRuALIv8QLnI+gv/vXybk+IMJFA9Cs5HeAm/yn2DhSBB+kNRREgEj
MYcP7ThmLx+gSyAviLX6EnhwFaUwLjQAfITSNSArt/ux+M/532eLAPsWM/ugzi37//0PqvByLlvQ
+0LsNDT7owH5LQLr/w8AH35tAUL7NNPQ/u8Ev/rAbvp4Bgc2+6EDrwfP+sBToPkGBjYwhFYB/QK/
A08JoL8dsCACc7BiQKygs4E2ntAjlNSgYigrKSTgNTlnjgHWABIELSn4Tg8AIAOEVvggNy4xMC40
M/hNhFV9fYSgF2AAAAAfAEIAAQAAACQAAABHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBs
AGkAAAAfAGUAAQAAADoAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwA
bwBnAGkAYwAuAGMAbwBtAAAAAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAIAAAAAA
AAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBsAGkA
AABTAE0AVABQAAAAZwBpAHIAaQBkAGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8AAl0BAAAAOgAAAGcAaQByAGkAZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwA
aQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A5V8BAAAAQgAAAHMAaQBwADoAZwBpAHIAaQBk
AGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAaDAEA
AAAkAAAARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAHwAfDAEAAAA6AAAAZwBp
AHIAaQBkAGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAA
HwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAACAAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIA
AACARwBpAHIAaQBkAGgAYQByACAATQBhAGwAYQB2AGEAbABpAAAAUwBNAFQAUAAAAGcAaQByAGkA
ZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwAaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAA
ADoAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAAAfAPg/AQAAACQAAABHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBsAGkAAAAf
ACNAAQAAADoAAABnAGkAcgBpAGQAaABhAHIALgBtAGEAbABhAHYAYQBsAGkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAACAfk/AQAAAIAAAAAAAAAAgSsf
pL6jEBmdbgDdAQ9UAgAAAIBHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBsAGkAAABTAE0A
VABQAAAAZwBpAHIAaQBkAGgAYQByAC4AbQBhAGwAYQB2AGEAbABpAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8ACV0BAAAAOgAAAGcAaQByAGkAZABoAGEAcgAuAG0AYQBsAGEAdgBhAGwAaQBAAHEA
bABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAA
AAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/
5AQAAAIBCzABAAAAEAAAAMPSJwhUFbZOpsD3Htah+QgDABcAAQAAAEAAOQCALVffCovPAUAACDBh
ItjfCovPAQsAAIAIIAYAAAAAAMAAAAAAAABGAAAAABSFAAABAAAAHwAAgIYDAgAAAAAAwAAAAAAA
AEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBV
AFMAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAXAAAAFIAZQA6ACAA
WwBQAEEAVABDAEgAIAAwAC8ANgBdACAAcQBsAGEAMgB4AHgAeAAgAGQAZQB2AGkAYwBlACAAcgBl
AG0AbwB2AGEAbAAgAGYAaQB4AHUAcABzAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAA
AAAfAEIQAQAAAHgAAAA8ADEANAAwADMAMQAwADAAMQAzADkALQAxADcAOQA4AC0AMQAtAGcAaQB0
AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAGoAbwBlAC4AbABhAHcAcgBlAG4AYwBlAEAAcwB0AHIA
YQB0AHUAcwAuAGMAbwBtAD4AAAACAXEAAQAAABsAAAABAc+K/glztsJSjRelQrhzQO9vo8lqm3b/
wQAAHwBwAAEAAABUAAAAWwBQAEEAVABDAEgAIAAwAC8ANgBdACAAcQBsAGEAMgB4AHgAeAAgAGQA
ZQB2AGkAYwBlACAAcgBlAG0AbwB2AGEAbAAgAGYAaQB4AHUAcABzAAAAHwA1EAEAAAB4AAAAPABE
ADYAMwBCADkAOAAwADQAQwBCADYAMwBBAEQANABGAEEAQQBEADkANgA2ADAAMwA3ADYAOQA1ADYA
NgA0ADYANAA3ADEAQgBFADIARAA3AEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+
AAAAHwA5EAEAAAB4AAAAPAAxADQAMAAzADEAMAAwADEAMwA5AC0AMQA3ADkAOAAtADEALQBnAGkA
dAAtAHMAZQBuAGQALQBlAG0AYQBpAGwALQBqAG8AZQAuAGwAYQB3AHIAZQBuAGMAZQBAAHMAdABy
AGEAdAB1AHMALgBjAG8AbQA+AAAAAwDeP59OAABAAAcwQf7Q3wqLzwEDACYAAAAAAAIBRwABAAAA
LgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjItMTQwNjE4MTUzNTAzWi0xMjQyNAAAAB8AFRAB
AAAAWAAAADkAQgAwADQAOQBFAEIAQwBEADgAMgAxADIAMwA0ADQAOQAzADAAMABDADkAMABGADgA
RgA2ADMAMAAyAEMAOABAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQwAQAAAAwAAABJAwAA5ftk
9kgAAAAfAPo/AQAAACQAAABHAGkAcgBpAGQAaABhAHIAIABNAGEAbABhAHYAYQBsAGkAAAAfAACA
hgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEYAAABN
AGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgA0AC4AMgAuADEA
NAAwADUAMAA5AAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBh
AHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAASAEAAEkASQA9ADAA
MQAwADEAQwBGADgAQgAwAEEARABGAEQAMQBCAEEANwBEADkAMQAxAEMARgBFAEIAMwA0ADIAOQA2
ADgAMQBDAEMAOAAyADAAOQAxADkAQgA2ADMARQA7AFMAQgBNAEkARAA9ADMAOwBTADEAPQA8ADEA
NAAwADMAMQAwADAAMQAzADkALQAxADcAOQA4AC0AMQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBh
AGkAbAAtAGoAbwBlAC4AbABhAHcAcgBlAG4AYwBlAEAAcwB0AHIAYQB0AHUAcwAuAGMAbwBtAD4A
OwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADIAIAAoAEIAdQBpAGwAZAAg
ADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAADAA00/T8AAB8AAICGAwIAAAAAAMAA
AAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0A
aQBwAAAAAAABAAAAHAAAAFsAMQAwAC4AMgA5AC4AMgAuADEAMgA0AF0AAADGbg==

--_000_D63B9804CB63AD4FAAD9660376956646471BE2D7avmb2qlogicorg_--
