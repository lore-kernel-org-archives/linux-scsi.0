From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] another tranche of SCSI updates for 2.6.26
Date: Mon, 28 Apr 2008 03:34:00 +0200
Message-ID: <20080428013400.GA6245@elte.hu>
References: <1209320076.3801.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:38677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYD1Be2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2008 21:34:28 -0400
Content-Disposition: inline
In-Reply-To: <1209320076.3801.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This represents the tree I had waitin on other mergers.  I'm not sure 
> this is it, because there are other features (like aic94xx running 
> abort) we're racing to get in.
> 
> The patch is available at:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

hm, got this crash with latest -git shortly after i rebased from this 
morning's git to this night's git, it looks SCSI related:

[   44.513114] Calling initcall 0xc1cece47: init_this_scsi_driver+0x0/0xd0()
[   47.919053] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   47.927035] IP: [<c09cf947>] scsi_destroy_command_freelist+0x15/0x5a
[   47.931008] *pde = 00000000 
[   47.935253] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   47.939004] Modules linked in:
[   47.939004] 
[   47.939004] Pid: 1, comm: swapper Not tainted (2.6.25-sched-devel.git-x86-latest.git #5)
[   47.939004] EIP: 0060:[<c09cf947>] EFLAGS: 00010217 CPU: 0
[   47.939004] EIP is at scsi_destroy_command_freelist+0x15/0x5a
[   47.939004] EAX: c0042000 EBX: 00000000 ECX: c199ba14 EDX: fffffffc
[   47.939004] ESI: c0042000 EDI: c0042034 EBP: f7c36ebc ESP: f7c36eb0
[   47.939004]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   47.939004] Process swapper (pid: 1, ti=f7c36000 task=f7c4e000 task.ti=f7c36000)
[   47.939004] Stack: c0042000 00000000 00000000 f7c36ecc c09cfa4c c004225c c1a43378 f7c36ed4 
[   47.939004]        c0688535 f7c36ee8 c04e942b c0042260 c04e93e6 00000330 f7c36ef8 c04e9f20 
[   47.939004]        c004225c 00000002 f7c36f04 c04e9353 c0042000 f7c36f0c c0688aee f7c36f14 
[   47.939004] Call Trace:
[   47.939004]  [<c09cfa4c>] ? scsi_host_dev_release+0x79/0xa9
[   47.939004]  [<c0688535>] ? device_release+0x3e/0x54
[   47.939004]  [<c04e942b>] ? kobject_release+0x45/0x55
[   47.939004]  [<c04e93e6>] ? kobject_release+0x0/0x55
[   47.939004]  [<c04e9f20>] ? kref_put+0x3e/0x49
[   47.939004]  [<c04e9353>] ? kobject_put+0x41/0x46
[   47.939004]  [<c0688aee>] ? put_device+0x16/0x18
[   47.939004]  [<c09cf9d1>] ? scsi_host_put+0x12/0x14
[   47.939004]  [<c09cfbac>] ? scsi_unregister+0x1d/0x20
[   47.939004]  [<c1cece2d>] ? aha1542_detect+0x7d1/0x7eb
[   47.939004]  [<c016de2e>] ? trace_hardirqs_on+0xb/0xd
[   47.939004]  [<c1cece52>] ? init_this_scsi_driver+0xb/0xd0
[   47.939004]  [<c01922a7>] ? ftrace_record_ip+0x1d4/0x1ed
[   47.939004]  [<c1cecea5>] ? init_this_scsi_driver+0x5e/0xd0
[   47.939004]  [<c1c934e5>] ? kernel_init+0x152/0x2b0
[   47.939004]  [<c1c93393>] ? kernel_init+0x0/0x2b0
[   47.939004]  [<c1c93393>] ? kernel_init+0x0/0x2b0
[   47.939004]  [<c011c967>] ? kernel_thread_helper+0x7/0x10
[   47.939004]  =======================
[   47.939004] Code: ff eb 0c 89 fa 83 c0 04 e8 78 ba b2 ff 31 d2 5b 89 d0 5e 5f 5d c3 55 89 e5 57 56 53 e8 cf d0 74 ff 89 c6 8d 78 34 eb 1c 8d 53 fc <8b> 42 08 8b 4a 04 89 41 04 89 08 89 5a 08 89 5a 04 8b 46 10 e8 
[   47.939004] EIP: [<c09cf947>] scsi_destroy_command_freelist+0x15/0x5a SS:ESP 0068:f7c36eb0

see:

 http://redhat.com/~mingo/misc/config-Mon_Apr_28_03_01_00_CEST_2008.bad
 http://redhat.com/~mingo/misc/log-Mon_Apr_28_03_01_00_CEST_2008.bad

the commits i pulled are below. The tree before that survived 100+ 
randconfig bootups - this failed after 7 iterations.

	Ingo

---------------------->
commit 064922a805ec7aadfafdd27aa6b4908d737c3c1d
Merge: 42cadc8... ecc1241...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 11:25:00 2008 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (40 commits)
      [SCSI] jazz_esp, sgiwd93, sni_53c710, sun3x_esp: fix platform driver hotplug/coldplug
      [SCSI] aic7xxx: add const
      [SCSI] aic7xxx: add static
      [SCSI] aic7xxx: Update _shipped files
      [SCSI] aic7xxx: teach aicasm to not emit unused debug code/data
      [SCSI] qla2xxx: Update version number to 8.02.01-k2.
      [SCSI] qla2xxx: Correct regression in relogin code.
      [SCSI] qla2xxx: Correct misc. endian and byte-ordering issues.
      [SCSI] qla2xxx: make qla2x00_issue_iocb_timeout() static
      [SCSI] qla2xxx: qla_os.c, make 2 functions static
      [SCSI] qla2xxx: Re-register FDMI information after a LIP.
      [SCSI] qla2xxx: Correct SRB usage-after-completion/free issues.
      [SCSI] qla2xxx: Correct ISP84XX verify-chip response handling.
      [SCSI] qla2xxx: Wakeup DPC thread to process any deferred-work requests.
      [SCSI] qla2xxx: Collapse RISC-RAM retrieval code during a firmware-dump.
      [SCSI] m68k: new mac_esp scsi driver
      [SCSI] zfcp: Add some statistics provided by the FCP adapter to the sysfs
      [SCSI] zfcp: Print some messages only during ERP
      [SCSI] zfcp: Wait for free SBAL during exchange config
      [SCSI] scsi_transport_fc: fc_user_scan correction
      ...

commit ecc1241e80a0bdc854b1602a44be3ad106753d4f
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Fri Apr 18 13:57:19 2008 -0700

    [SCSI] jazz_esp, sgiwd93, sni_53c710, sun3x_esp: fix platform driver hotplug/coldplug
    
    Since
    
    commit 43cc71eed1250755986da4c0f9898f9a635cb3bf
    Author: Kay Sievers <kay.sievers@vrfy.org>
    Date:   Sat Aug 18 04:40:39 2007 +0200
    
        platform: prefix MODALIAS with "platform:"
    
    the platform modalias is prefixed with "platform:". Add MODULE_ALIAS()
    to the hotpluggable SCSI platform drivers, to re-enable auto loading.
    
    [dbrownell@users.sourceforge.net: more drivers, registration fixes]
    [akpm@linux-foundation.org: fix sgiwd93.c]
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 980b306a297725d4f25c779ca15086de757acadf
Author: Denys Vlasenko <vda.linux@googlemail.com>
Date:   Fri Apr 25 04:36:01 2008 +0200

    [SCSI] aic7xxx: add const
    
    This patch adds more const keywords where appropriate.
    
    Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
    Acked-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit d1d7b19d433188e94fc87cc7ca66363cd77a0bba
Author: Denys Vlasenko <vda.linux@googlemail.com>
Date:   Fri Apr 25 04:34:49 2008 +0200

    [SCSI] aic7xxx: add static
    
    This patch adds static (and sometimes const) keywords where appropriate.
    
    Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
    Acked-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit d10c2e4627b0dda286bcd1c77720eb5fe4a04f93
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Apr 25 15:03:05 2008 +0200

    [SCSI] aic7xxx: Update _shipped files
    
    Update the precompiled sequencer code to match the latest
    aicasm changes.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 3dbd10f3d8b00dad35d3fac95e91c066ae71d9a8
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Apr 25 15:01:41 2008 +0200

    [SCSI] aic7xxx: teach aicasm to not emit unused debug code/data
    
    Add a 'count' variable to each symbol which gets increased every time
    the symbol is referenced.  And then modify the register definition to
    include counts for symbols which are referenced from the source code
    only and not from the sequencer code.
    
    This will give us an automatic usage count for the symbols with only
    minimal hand-crafting.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit a198c3d0393faa1fa9f0e6e917ce980d3638f8df
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:31 2008 -0700

    [SCSI] qla2xxx: Update version number to 8.02.01-k2.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 666301e673e192c87a40e07a8357d6996b57b70f
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:30 2008 -0700

    [SCSI] qla2xxx: Correct regression in relogin code.
    
    Commit 63a8651f2548c6bb5132c0b4e7dad4f57a9274db ([SCSI] qla2xxx:
    Correct infinite-login-retry issue.) introduced a small
    regression where a successful relogin would result in an fcport's
    loop_id to be incorrectly reset to FC_NO_LOOP_ID.  Only clear-out
    loopid, if retries have been 'truly' exhausted.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Cc: Stable Tree <stable@kernel.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit c6852c4c5984fff130a859792d4b26d30c85c54b
Author: Seokmann Ju <seokmann.ju@qlogic.com>
Date:   Thu Apr 24 15:21:29 2008 -0700

    [SCSI] qla2xxx: Correct misc. endian and byte-ordering issues.
    
    There were several places in the driver which could cause byte
    ordering problem as provided by Al Viro
    <viro@ZenIV.linux.org.uk>.
    
    Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 3b8117b837f5768f46e9a876a58de11606f63483
Author: Adrian Bunk <bunk@kernel.org>
Date:   Thu Apr 24 15:21:28 2008 -0700

    [SCSI] qla2xxx: make qla2x00_issue_iocb_timeout() static
    
    This patch makes the needlessly global qla2x00_issue_iocb_timeout()
    static.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 01ef66bbb65aa4db100b267778202d7657e244e4
Author: Adrian Bunk <bunk@kernel.org>
Date:   Thu Apr 24 15:21:27 2008 -0700

    [SCSI] qla2xxx: qla_os.c, make 2 functions static
    
    This patch makes the following needlessly global functions static:
    - qla2x00_alloc_work()
    - qla2x00_post_work()
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 7e47e5ca184548341a82eeb2238ee3622c43cae1
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:26 2008 -0700

    [SCSI] qla2xxx: Re-register FDMI information after a LIP.
    
    Original code would (incorrectly) only re-register after a
    loop-down condition.  Also, FDMI registration should be enabled
    by default.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 0c23b856581673c90aa619b1ab04127a7f90cea2
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:25 2008 -0700

    [SCSI] qla2xxx: Correct SRB usage-after-completion/free issues.
    
    The driver is incorrectly assuming that the 'sp' reference held
    in qla2[x00|4xx]_abort_command() is valid after the mailbox
    command is issued to abort the exchange.  It is *not*, as the
    command may be completed during interrupt context before control
    is returned to the mailbox caller.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit c1ec1f1bf9cb1ba80e79a74d48bcfb5da246d6f6
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:24 2008 -0700

    [SCSI] qla2xxx: Correct ISP84XX verify-chip response handling.
    
    Earlier code could trigger an infinite-retry if 1st invocation
    returned a non-CS_COMPLETE status.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 550bf57dfb2200721baa43cfd9a8c75c2c166870
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:23 2008 -0700

    [SCSI] qla2xxx: Wakeup DPC thread to process any deferred-work requests.
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit c5722708c236b51286651b8c07855f764239453b
Author: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date:   Thu Apr 24 15:21:22 2008 -0700

    [SCSI] qla2xxx: Collapse RISC-RAM retrieval code during a firmware-dump.
    
    Use the more efficient read-DMA'ble-buffer mailbox commands
    rather than reading a single word/dword at a time.  We also
    remove a bulk of the duplicate mailbox command-handling codes in
    favor of more generic read-memory() routines (qla2xxx_dump_ram()
    and qla24xx_dump_ram()).
    
    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 6fe07aaffbf086a0ce9134ef27ce4a8921ff5947
Author: Finn Thain <fthain@telegraphics.com.au>
Date:   Fri Apr 25 10:06:05 2008 -0500

    [SCSI] m68k: new mac_esp scsi driver
    
    Replace the mac_esp driver with a new one based on the esp_scsi core.
    
    For esp_scsi: add support for sync transfers for the PIO mode, add a new
    esp_driver_ops method to get the maximum dma transfer size (like the old
    NCR53C9x driver), and some cleanups.
    
    Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 6d9d63b9480e1c7ea41845646de803c2d3f0eae2
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Thu Apr 24 19:35:54 2008 +0200

    [SCSI] zfcp: Add some statistics provided by the FCP adapter to the sysfs
    
    The new FCP adapter statistics provide a variety of information about
    the virtual adapter (subchannel). In order to collect this information
    the zfcp driver is extended to query this information.
    
    The information provided by the new FCP adapter statistics can be
    fetched by reading from the following files in the sysfs filesystem
    
    /sys/class/scsi_host/host<n>/seconds_active
    /sys/class/scsi_host/host<n>/requests
    /sys/class/scsi_host/host<n>/megabytes
    /sys/class/scsi_host/host<n>/utilization
    
    These are the statistics on a virtual adapter (subchannel) level.
    
    The information provided is raw and not modified or interpreted by any
    means.  No interpretation or modification of the values is done by the
    zfcp driver.
    
    Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
    Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit ec258fe4b76dba29e1a149cd8f23ee931b47afb2
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Thu Apr 24 19:35:53 2008 +0200

    [SCSI] zfcp: Print some messages only during ERP
    
    When statistics are polled from sysfs, the statistics use the same
    commands as the adapter initialization. Change the messages printed
    here, so they are only printed during initialization and not for each
    poll of adapter data.
    
    Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
    Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit aee6ef1859fd975b285b6de1857f7dcf39671818
Author: Swen Schillig <swen@vnet.ibm.com>
Date:   Thu Apr 24 19:35:52 2008 +0200

    [SCSI] zfcp: Wait for free SBAL during exchange config
    
    When sending a exchange config data command, wait for a free SBAL.
    This does not matter during adapter initialization, but this is
    required for pulling adapter statistics during high I/O load.
    
    Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
    Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit bda232531f0c117921690ee3c060953c8f12e5a1
Author: James Smart <James.Smart@Emulex.Com>
Date:   Thu Apr 24 12:12:46 2008 -0400

    [SCSI] scsi_transport_fc: fc_user_scan correction
    
    Way back when, when the fc_user_scan routine was created, it kept some
    of its original logic that walked the rport list and kicked off a scan.
    Unfortunately, it didn't keep any of the locking around the rport list,
    nor did it consider the synchronous nature of the scan invoked. The result,
    there are some scan requests where the rport list changes, thus a subsequent
    scan is called on a bogus rport structure and the system NMI's.
    
    Signed-off-by: James Smart <james.smart@emulex.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 87c4d7bc2aaa9b782aac6ab0a74cf16f87398bbc
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Apr 24 19:45:32 2008 -0400

    [SCSI] aha1542: minor irq handler cleanups
    
    - where the 'irq' function argument is known never to be used, rename
      it to 'dummy' to make this more obvious
    
    - replace per-irq lookup functions and tables with a direct reference
      to data object obtained via 'dev_id' function argument, passed from
      request_irq()
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 9f9a73b6fe0c8fd9b54b650e34956eb92df6abfa
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Wed Apr 23 09:56:14 2008 -0700

    [SCSI] scsi_transport_spi: include sysfs.h
    
    scsi_transport_spi.c needs to #include <linux/sysfs.h>:
    
    next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
    make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 1377d8dd7e1b5526637958aabb5427bbee5a68d7
Author: Adrian Bunk <bunk@kernel.org>
Date:   Wed Apr 23 12:51:10 2008 +0300

    [SCSI] FlashPoint: fix off-by-one errors
    
    This patch fixes off-by-one errors in error checks (the variables are
    used as array indexes for arrays with MAX_SCSI_TAR resp. MAX_LUN
    elements) spotted by the Coverity checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 2b48aed182c65b3387b076364ab286c445aa4a93
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Apr 23 11:39:49 2008 +0200

    [SCSI] aic7xxx: Update type check in aicasm grammar
    
    The function type_check() in aicasm grammar code was
    never used properly due to a bug.
    This patch fixes it up and ensures it's only called if appropriate.
    
    In addition the unused 16bit instruction are disabled, but left in
    the code for reference.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 542bd1377a963070bc4a03ff7d2690ddf3920596
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Mon Apr 21 10:57:20 2008 -0500

    [SCSI] fix SLUB WARN_ON
    
    We're getting a WARN_ON from SLUB indicating that we're trying to free
    caches with in-use objects.  The root cause is a new dependency in the
    command/sense free on unchecked_isa_dma.  The WARN_ON is caused by
    drivers which change this in their setup after the command/sense cache
    is allocated.
    
    The fix is to move the allocation of this cache into scsi_add_host()
    so things like gdth have an opportunity to modify it between alloc and
    add (but *not* after).
    
    The true fix would be to move unchecked_isa_dma into the template and
    out of the host, so it because a truly read only variable.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 42cadc86008aae0fd9ff31642dc01ed50723cf32
Merge: fba5c1a... 66c0b39...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 10:13:52 2008 -0700

    Merge branch 'kvm-updates-2.6.26' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm
    
    * 'kvm-updates-2.6.26' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm: (147 commits)
      KVM: kill file->f_count abuse in kvm
      KVM: MMU: kvm_pv_mmu_op should not take mmap_sem
      KVM: SVM: remove selective CR0 comment
      KVM: SVM: remove now obsolete FIXME comment
      KVM: SVM: disable CR8 intercept when tpr is not masking interrupts
      KVM: SVM: sync V_TPR with LAPIC.TPR if CR8 write intercept is disabled
      KVM: export kvm_lapic_set_tpr() to modules
      KVM: SVM: sync TPR value to V_TPR field in the VMCB
      KVM: ppc: PowerPC 440 KVM implementation
      KVM: Add MAINTAINERS entry for PowerPC KVM
      KVM: ppc: Add DCR access information to struct kvm_run
      ppc: Export tlb_44x_hwater for KVM
      KVM: Rename debugfs_dir to kvm_debugfs_dir
      KVM: x86 emulator: fix lea to really get the effective address
      KVM: x86 emulator: fix smsw and lmsw with a memory operand
      KVM: x86 emulator: initialize src.val and dst.val for register operands
      KVM: SVM: force a new asid when initializing the vmcb
      KVM: fix kvm_vcpu_kick vs __vcpu_run race
      KVM: add ioctls to save/store mpstate
      KVM: Rename VCPU_MP_STATE_* to KVM_MP_STATE_*
      ...

commit fba5c1af5c4fd6645fe62ea84ccde0981282cf66
Merge: f222eba... 077e3bd...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 10:13:06 2008 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
    
    * git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6: (49 commits)
      ide-tape: remove tape->merge_stage
      ide-tape: mv tape->merge_stage_size tape->merge_bh_size
      ide-tape: mv idetape_empty_write_pipeline ide_tape_flush_merge_buffer
      ide-tape: mv idetape_discard_read_pipeline ide_tape_discard_merge_buffer
      ide-tape: make __idetape_discard_read_pipeline() of type void
      ide: remove now unused ide_pci_create_host_proc()
      ide: remove /proc/ide/ali
      ide-tape: improve buffer pages freeing strategy
      ide-tape: mv tape->pages_per_stage tape->pages_per_buffer
      ide-tape: mv tape->stage_size tape->buffer_size
      ide-tape: improve buffer allocation strategy
      ide: add struct ide_io_ports (take 3)
      ide: make ide_unregister() take 'ide_hwif_t *' as an argument (take 2)
      ide: sanitize ide_unregister() usage
      mpc8xx-ide: use ide_find_port()
      ide: add "noacpi" / "acpigtf" / "acpionboot" parameters
      gayle: add "doubler" parameter
      ide: add "cdrom=" and "chs=" parameters
      ide: add "nodma|noflush|noprobe|nowerr=" parameters
      ide: remove obsoleted "hdx=autotune" kernel parameter
      ...

commit f222eba0f9d98376d363b51fcc2361fb56929844
Merge: cf867ac... 7f424a8...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 10:10:54 2008 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-idle-fix
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-idle-fix:
      fix idle (arch, acpi and apm) and lockdep

commit cf867ac375cea7c7a834eaddaf373e2662d9e260
Merge: 2d630d1... 2043021...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 10:10:37 2008 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input:
      Input: xpad - fix build failure

commit 2d630d1a6827bb7266dcd8bba5f99fac2505ee97
Merge: f375d55... ed4d3c1...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 27 10:10:14 2008 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband:
      mlx4_core: Add helper to move QP to ready-to-send
      mlx4_core: Add HW queues allocation helpers
      RDMA/nes: Remove volatile qualifier from struct nes_hw_cq.cq_vbase
      mlx4_core: CQ resizing should pass a 0 opcode modifier to MODIFY_CQ
      mlx4_core: Move kernel doorbell management into core
      IB/ehca: Bump version number to 0026
      IB/ehca: Make some module parameters bool, update descriptions
      IB/ehca: Remove mr_largepage parameter
      IB/ehca: Move high-volume debug output to higher debug levels
      IB/ehca: Prevent posting of SQ WQEs if QP not in RTS
      IPoIB: Handle 4K IB MTU for UD (datagram) mode
      RDMA/nes: Fix adapter reset after PXE boot
      RDMA/nes: Print IPv4 addresses in a readable format
      RDMA/nes: Use print_mac() to format ethernet addresses for printing

commit f375d5588ff62caf31b4a68ac9347c153ac56590
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sun Apr 27 06:19:18 2008 +0100

    asm/unaligned.h doesn't work well as the very first include
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 7ac86bf61ad570a2ef642a3f7e72274570ace9c4
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sun Apr 27 06:15:42 2008 +0100

    e1000e triggers sparc32 gcc bug
    
    	... and isn't possible on sparc32 boxen anyway, unless somebody
    had done JavaStation with PCIE lately.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 66c0b394f08fd89236515c1c84485ea712a157be
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sat Apr 19 20:33:56 2008 +0100

    KVM: kill file->f_count abuse in kvm
    
    Use kvm own refcounting instead of playing with ->filp->f_count.
    That will allow to get rid of a lot of crap in anon_inode_getfd() and
    kill a race in kvm_dev_ioctl_create_vm() (file might have been closed
    immediately by another thread, so ->filp might point to already freed
    struct file when we get around to setting it).
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 960b3991698872f68f09d51f4c2794ad484fe1fd
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Wed Apr 16 17:19:06 2008 -0300

    KVM: MMU: kvm_pv_mmu_op should not take mmap_sem
    
    kvm_pv_mmu_op should not take mmap_sem. All gfn_to_page() callers down
    in the MMU processing will take it if necessary, so as it is it can
    deadlock.
    
    Apparently a leftover from the days before slots_lock.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1336028b9a1fb33537eab8caec66e812eb8cad63
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 17:01:05 2008 +0200

    KVM: SVM: remove selective CR0 comment
    
    There is not selective cr0 intercept bug. The code in the comment sets the
    CR0.PG bit. But KVM sets the CR4.PG bit for SVM always to implement the paged
    real mode. So the 'mov %eax,%cr0' instruction does not change the CR0.PG bit.
    Selective CR0 intercepts only occur when a bit is actually changed. So its the
    right behavior that there is no intercept on this instruction.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit aaf697e4e02bf6f7dd6105877bc58ebdbf612d66
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 16:51:19 2008 +0200

    KVM: SVM: remove now obsolete FIXME comment
    
    With the usage of the V_TPR field this comment is now obsolete.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit aaacfc9ae225e88695e610a35627d2256dc08633
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 16:51:18 2008 +0200

    KVM: SVM: disable CR8 intercept when tpr is not masking interrupts
    
    This patch disables the intercept of CR8 writes if the TPR is not masking
    interrupts. This reduces the total number CR8 intercepts to below 1 percent of
    what we have without this patch using Windows 64 bit guests.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d7bf8221a3037d0d0760a1ccf1833bda03213abf
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 16:51:17 2008 +0200

    KVM: SVM: sync V_TPR with LAPIC.TPR if CR8 write intercept is disabled
    
    If the CR8 write intercept is disabled the V_TPR field of the VMCB needs to be
    synced with the TPR field in the local apic.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ec7cf6903ffced20098e2bcc27a184172836dfb9
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 16:51:16 2008 +0200

    KVM: export kvm_lapic_set_tpr() to modules
    
    This patch exports the kvm_lapic_set_tpr() function from the lapic code to
    modules. It is required in the kvm-amd module to optimize CR8 intercepts.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 649d68643ebf02f31859ffbb16676aa44c72e6e9
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 16 16:51:15 2008 +0200

    KVM: SVM: sync TPR value to V_TPR field in the VMCB
    
    This patch adds syncing of the lapic.tpr field to the V_TPR field of the VMCB.
    With this change we can safely remove the CR8 read intercept.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit bbf45ba57eaec56569918a8bab96ab653bd45ec1
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Wed Apr 16 23:28:09 2008 -0500

    KVM: ppc: PowerPC 440 KVM implementation
    
    This functionality is definitely experimental, but is capable of running
    unmodified PowerPC 440 Linux kernels as guests on a PowerPC 440 host. (Only
    tested with 440EP "Bamboo" guests so far, but with appropriate userspace
    support other SoC/board combinations should work.)
    
    See Documentation/powerpc/kvm_440.txt for technical details.
    
    [stephen: build fix]
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Acked-by: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 513014b717203d1d689652d0fda86eee959a6a8a
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Wed Apr 16 23:28:08 2008 -0500

    KVM: Add MAINTAINERS entry for PowerPC KVM
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Acked-by: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit b2312f059c893833de58876c74290511846cd208
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Wed Apr 16 23:28:07 2008 -0500

    KVM: ppc: Add DCR access information to struct kvm_run
    
    Device Control Registers are essentially another address space found on PowerPC
    4xx processors, analogous to PIO on x86. DCRs are always 32 bits, and can be
    identified by a 32-bit number. We forward most DCR accesses to userspace for
    emulation (with the exception of CPR0 registers, which can be read directly
    for simplicity in timebase frequency determination).
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 4baacfb0de53b05428c87d377fc8a3def4dc10e7
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Wed Apr 16 23:28:06 2008 -0500

    ppc: Export tlb_44x_hwater for KVM
    
    PowerPC 440 KVM needs to know how many TLB entries are used for the host kernel
    linear mapping (it does not modify these mappings when switching between guest
    and host execution).
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
    Acked-by: Paul Mackerras <paulus@samba.org>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 76f7c87902fd2c2de9eb57168adbf9bc5ec2047d
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Tue Apr 15 16:05:42 2008 -0500

    KVM: Rename debugfs_dir to kvm_debugfs_dir
    
    It's a globally exported symbol now.
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f9b7aab35cc6c3542203354d9fc4ec8572074abc
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Apr 14 23:46:37 2008 +0300

    KVM: x86 emulator: fix lea to really get the effective address
    
    We never hit this, since there is currently no reason to emulate lea.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 16286d082d99cb41e16938fa6ba84604229f4b77
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Apr 14 14:40:50 2008 +0300

    KVM: x86 emulator: fix smsw and lmsw with a memory operand
    
    lmsw and smsw were implemented only with a register operand.  Extend them
    to support a memory operand as well.  Fixes Windows running some display
    compatibility test on AMD hosts.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 66b85505736dbd3a3a0ed5ae38c12bb218b231c0
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Apr 14 23:27:07 2008 +0300

    KVM: x86 emulator: initialize src.val and dst.val for register operands
    
    This lets us treat the case where mod == 3 in the same manner as other cases.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a79d2f1805da02d7837ec2240f0093c53272fb3a
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Apr 14 13:10:21 2008 +0300

    KVM: SVM: force a new asid when initializing the vmcb
    
    Shutdown interception clears the vmcb, leaving the asid at zero (which is
    illegal.  so force a new asid on vmcb initialization.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e9571ed54b2a290d61b98ad6f369f963159fe6da
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 11 15:01:22 2008 -0300

    KVM: fix kvm_vcpu_kick vs __vcpu_run race
    
    There is a window open between testing of pending IRQ's
    and assignment of guest_mode in __vcpu_run.
    
    Injection of IRQ's can race with __vcpu_run as follows:
    
    CPU0                                CPU1
    kvm_x86_ops->run()
    vcpu->guest_mode = 0                SET_IRQ_LINE ioctl
    ..
    kvm_x86_ops->inject_pending_irq
    kvm_cpu_has_interrupt()
    
                                        apic_test_and_set_irr()
                                        kvm_vcpu_kick
                                        if (vcpu->guest_mode)
                                            send_ipi()
    
    vcpu->guest_mode = 1
    
    So move guest_mode=1 assignment before ->inject_pending_irq, and make
    sure that it won't reorder after it.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 62d9f0dbc92d7e398fde53fc6021338393522e68
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 11 13:24:45 2008 -0300

    KVM: add ioctls to save/store mpstate
    
    So userspace can save/restore the mpstate during migration.
    
    [avi: export the #define constants describing the value]
    [christian: add s390 stubs]
    [avi: ditto for ia64]
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 582fb6c03a0e89d05e4efa8a3e4bd09d0942dadc
Author: David S. Miller <davem@davemloft.net>
Date:   Sat Apr 19 09:16:38 2008 -0500

    [SCSI] esp_scsi: Make cur_residue and tot_residue signed.
    
    Many of the overflow checks test whether the value has
    gone negative, and we want to retain such checks.
    
    Reported by Julia Lawall.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 077e3bdb9ec34d7cb5751b5be81a4a0f6f0eb5dc
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide-tape: remove tape->merge_stage
    
    Get rid of the pipeline merge stage but retain the chrdev req caching
    functionality by using a merge buffer tape->merge_bh which is flushed in chunks
    of several blocks at a time. Also, remove last references to pipelining, e.g.
    typedef idetape_stage_s.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 01a63aebe4dcfcbe983c40a475e4650a4ae614de
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide-tape: mv tape->merge_stage_size tape->merge_bh_size
    
    This is the size of the merge buffer.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit d9df937af4f980883d94276000e5af399438e1a9
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide-tape: mv idetape_empty_write_pipeline ide_tape_flush_merge_buffer
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ec0fdb01f808e3f0b50378bfabaee4ced41a8fd9
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide-tape: mv idetape_discard_read_pipeline ide_tape_discard_merge_buffer
    
    Also, rename its __-low level helper too.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 9798630a75c2c13849aeefcc1ba0559a701b5d95
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide-tape: make __idetape_discard_read_pipeline() of type void
    
    It always returns 0 which has no effect on tape positioning calculation so
    simplify it by converting its type to void, bringing no functional change to the
    driver.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit fd0949e6e84e4e1649d8ea7367e78e72f59bb19f
Author: Alexey Dobriyan <adobriyan@sw.ru>
Date:   Sun Apr 27 15:38:34 2008 +0200

    ide: remove now unused ide_pci_create_host_proc()
    
    It creates files in proc with obsoleted ->get_info interface.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
    Cc: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 19ba7b8f35116dfafcb02bdb745d5015d97d9cb6
Author: Alexey Dobriyan <adobriyan@sw.ru>
Date:   Sun Apr 27 15:38:33 2008 +0200

    ide: remove /proc/ide/ali
    
    Bart says: "can be done from user-space and is not especially interesting
    even when debugging problems (raw PCI config space dump is far more useful)."
    
    Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
    Cc: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit d01dbc3b85d57f3ab89be4291d4739152bb1713a
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:33 2008 +0200

    ide-tape: improve buffer pages freeing strategy
    
    Instead of freeing pages one by one, free them 2^order-wise. Also, mv
    __idetape_kfree_stage() to ide_tape_kfree_buffer().
    
    [bart: add updating bh->b_data]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit a997a4356ba33dcb9c061677d5943794a29489e8
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:33 2008 +0200

    ide-tape: mv tape->pages_per_stage tape->pages_per_buffer
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit f73850a302de45c7cb6672d0e8b103c1f122b6ae
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:33 2008 +0200

    ide-tape: mv tape->stage_size tape->buffer_size
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 41aa17069ea8d2b5cd2ca1ef7ff6cdb7c6abec95
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:32 2008 +0200

    ide-tape: improve buffer allocation strategy
    
    Instead of allocating pages for the buffer one by one, take advantage of the
    buddy alloc system and request them 2^order at a time. This increases the chance
    for bigger buffer parts to be contigious and reduces loop iteration count. While
    at it, rename function __idetape_kmalloc_stage() to ide_tape_kmalloc_buffer().
    
    [bart: fold with "ide-tape: fix mem leak" patch to preserve bisectability]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 4c3032d8a4d6c97bd6e02bcab524ef2428d89561
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:32 2008 +0200

    ide: add struct ide_io_ports (take 3)
    
    * Add struct ide_io_ports and use it instead of `unsigned long io_ports[]`
      in ide_hwif_t.
    
    * Rename io_ports[] in hw_regs_t to io_ports_array[].
    
    * Use un-named union for 'unsigned long io_ports_array[]' and 'struct
      ide_io_ports io_ports' in hw_regs_t.
    
    * Remove IDE_*_OFFSET defines.
    
    v2:
    * scc_pata.c build fix from Stephen Rothwell.
    
    v3:
    * Fix ctl_adrr typo in Sparc-specific part of ns87415.c.
      (Noticed by Andrew Morton)
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 387750c3bf49c22f6189436032145e2131985076
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:31 2008 +0200

    ide: make ide_unregister() take 'ide_hwif_t *' as an argument (take 2)
    
    * Make ide_unregister() take 'ide_hwif_t *hwif' instead of 'unsigned int
      index' (hwif->index) as an argument and update all users accordingly.
    
    While at it:
    
    * Remove unnecessary checks for hwif != NULL from ide-pnp.c::idepnp_remove()
      and delkin_cb.c::delkin_cb_remove().
    
    * Remove needless hwif->chipset assignment from scc_pata.c::scc_remove().
    
    v2:
    * Fixup ide_unregister() documentation.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit bf64b7a9ddc604883a1f41535d3d7a62bca9ee81
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:31 2008 +0200

    ide: sanitize ide_unregister() usage
    
    * Remove ide_unregister() call from ide_exit()
      (host drivers take care of unregistering hwif-s themselves).
    
    * Remove ide_unregister() call from probe methods of
      bast-ide, palm_bk3710, ide-cs and delkin_cb host drivers
      (ide_find_port() returns only free ide_hwifs[] entries).
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 16019c35283e99b4b95b8a0757845bc2d0696b20
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:30 2008 +0200

    mpc8xx-ide: use ide_find_port()
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 1dbfeb4bc8fd0276750e5d1d454420f6c2da80e3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:30 2008 +0200

    ide: add "noacpi" / "acpigtf" / "acpionboot" parameters
    
    * Rename ide_noacpi{tfs,onboot} to ide_acpi{gtf,onboot} (+ reverse logic).
    
    * Move ide_*acpi* variables to ide-acpi.c and remove unnecessary initializers.
    
    * Add "noacpi" / "acpigtf" / "acpionboot" parameters.
    
    * Obsolete "ide=noacpi" / "ide=acpigtf" / "ide=acpionboot" kernel parameters.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 9dcba7f2b7697db787741cf6698bf5c95130ffce
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:30 2008 +0200

    gayle: add "doubler" parameter
    
    * Add "doubler" parameter to enable support for IDE doublers.
    
    * Obsolete "ide=doubler" kernel parameter.
    
    Cc: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 4706a7e03a03d6d206a93a49a0c723dd612cf8e9
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:30 2008 +0200

    ide: add "cdrom=" and "chs=" parameters
    
    * Add "cdrom=" and "chs=" parameters.
    
    * Obsolete "hdx=cdrom" and "hdx=cyls,heads,sects" kernel parameters.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 6e87543a94fb2a966c81a61fc91246592f9719da
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:30 2008 +0200

    ide: add "nodma|noflush|noprobe|nowerr=" parameters
    
    * Add "nodma|noflush|noprobe|nowerr=" parameters.
    
    * Obsolete "hdx=noprobe|none|nowerr|nodma|noflush" kernel parameters.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 207daeaabb5396995ebac63415fab71476b64ca3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    ide: remove obsoleted "hdx=autotune" kernel parameter
    
    * Remove obsoleted "hdx=autotune" kernel parameter
      (we always auto-tune PIO if possible nowadays).
    
    * Remove no longer needed ide_drive_t.autotune flag.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit e160124ff6868e53511b16412d2ea91f87936be0
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    ide: remove IDE_HFLAG_NO_AUTOTUNE host flag
    
    * Don't set IDE_HFLAG_NO_AUTOTUNE host flag in sgiioc4 and icside
      host drivers - there is no need for it as they don't implement
      ->set_pio_mode method.
    
    * Remove no longer needed IDE_HFLAG_NO_AUTOTUNE host flag.
    
    There should be no functional changes caused by this patch.
    
    Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit bdffe5d2717c41945d75b488cfaa401d166cb3dd
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    cmd640: always auto-tune PIO
    
    * Default to tuning PIO0 and disabling prefetch prior to probing
      devices for CONFIG_BLK_DEV_CMD640_ENHANCED=y case.
    
    * Always auto-tune PIO.
    
    * Remove no longer used retrieve_drive_counts().
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 0d28ec7f213eee37855741410a95ec559f9fa87a
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    ide: always auto-tune PIO in legacy VLB host drivers
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 73f1ad8670effa9849c3d42457fa2b58f139e013
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    ide: mark "idebus=" kernel parameter as obsoleted (take 2)
    
    We have "vlb|pci_clock=" parameters now.
    
    Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ebae41a5a0583fb732c41445df4ac2c41016df74
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:29 2008 +0200

    ide: add "vlb|pci_clock=" parameter
    
    * Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).
    
    * Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).
    
    While at it:
    
    * qd65xx.c: rename {active,recovery}_cycle variables to {act,rec}_cyc.
    
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 10569713c78f3c499745651aebc90b0d1c454c28
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:28 2008 +0200

    ide-tape: remove comments markup from Documentation/ide/ide-tape.txt
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 4735f22cc10127189a13ce9b1c16fa152a99aaba
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:28 2008 +0200

    ide-tape: remove pipelined mode description from Documentation/ide/ide-tape.txt
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 5bd50dc6aa842a2b37f68dec73d9e2cc433c2af9
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:28 2008 +0200

    ide-tape: remove misc references to pipelined operation in the comments
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit c0674bf3b602c71f18ff1772fdfb4e7ea8ffbacc
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:28 2008 +0200

    ide-tape: remove pipelined mode parameters
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 83042b241601170c95b448267861be10a6025b3c
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:27 2008 +0200

    ide-tape: remove pipeline-specific members from struct ide_tape_obj
    
    Bart:
    - merge "ide-tape: remove pipeline-specific code from idetape_setup" patch
    - cleanup __idetape_discard_read_pipeline()
    - cleanup idetape_empty_write_pipeline()
    - fix 't' assignment in idetape_setup()
    - fix idetape_blkdev_ioctl() w.r.t. 'nr_stages'
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 42d5468921e9e9c0a2d13048a2dab09f844e18bc
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:27 2008 +0200

    ide-tape: remove pipelined mode tape control flags
    
    [bart: sync patch with current code and fix idetape_init_read()]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 0aa4b01e0345bb43450dee4377fc53fb4fd44eb1
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:27 2008 +0200

    ide-tape: remove remaining pipeline functionality
    
    The driver is using now solely its own request queue.
    
    - tape->next_stage is always NULL so it is safe to remove
      all code depending on tape->next_stage != NULL
    
    - this patch removes the last place which sets
      IDETAPE_FLAG_PIPELINE_ACTIVE in tape->flags
    
    [bart: add above explanations]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ea1ab3d3319b399e2b707c270d2d6077b61183f6
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:27 2008 +0200

    ide-tape: unwrap idetape_queue_pc_tail()
    
    idetape_queue_pc_tail() is a wrapper for its __idetape_queue_pc_tail() counterpart
    and has no other functionality. Remove it and call the "wrapped" function
    directly.
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 189bb3b345f59b11484b43f2717a66824acdc548
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:27 2008 +0200

    ide-tape: remove pipeline-specific code from idetape_end_request()
    
    As a side effect, remove unused idetape_kfree_stage() and
    idetape_abort_pipeline()
    
    [bart: resurrect taking tape->lock + clearing IDETAPE_FLAG_PIPELINE_ACTIVE]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 473567f1a4996a49cb5456e55815051a6e6eb3f1
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:26 2008 +0200

    ide-tape: remove idetape_remove_stage_head()
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit b361acb1083f0b313a4b398de48450f5edb81fe1
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:26 2008 +0200

    ide-tape: remove idetape_pipeline_size()
    
    The computation of the block offset of the the tape position (MTIOCPOS,
    MTIOCGET) is not influenced by the stages queued in the pipeline anymore but by
    the size of the current buffer which is going to be sent to the drive.
    
    [bart: resurrect deleted idetape_wait_for_pipeline() call]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 7f5e72f471763fe2a6e72863a64a2ef459f37835
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:26 2008 +0200

    ide-tape: remove pipeline-specific code in idetape_space_over_filemarks()
    
    Since we don't do pipeline read-ahead anymore, we don't have to look for
    filemarks we have crossed. Therefore, remove the code chunk that does that and
    pass on the command to the tape. As a side effect, remove unused
    idetape_wait_first_stage().
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 8646c88f1572512761b33d01467e8643586972ce
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:26 2008 +0200

    ide-tape: remove unused parameter from idetape_copy_stage_from_user
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 99d74e61ef7e9b0e2123830bc42b4639ee30145a
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:25 2008 +0200

    ide-tape: remove unused parameter from idetape_copy_stage_to_user
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 5e69bd959d1086f87a603b4ddc6bdb0a130ec7db
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:25 2008 +0200

    ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request()
    
    In order to do away with queueing read requests on the pipeline, several things
    have to be done:
    
    1. Do not allocate additional pipeline stages in idetape_init_read() until
    (tape->nr_stages < max_stages) and do only read operation preparations. As a
    collateral result, idetape_add_stage_tail() becomes unused so remove it.
    
    2. Queue the read request's buffer directly thru idetape_queue_rw_tail().
    
    3. Remove now unused idetape_kmalloc_stage() and idetape_switch_buffers().
    
    [bart: simplify the original patch]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ddfe7a776360f7067e06eee9d8b1ae4d957e6ddf
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:25 2008 +0200

    ide-tape remove pipeline speed/control calculations
    
    Pipeline handling calculations in idetape_calculate_speeds() can
    go since they do not have any effect on other functionality besides:
    
    1. info is only being exported through /proc as a read-only item
    (controlled_pipeline_head_speed, uncontrolled_pipeline_head_speed)
    
    2. used in idetape_restart_speed_control() which, in turn, is unrelated to
    other code
    
    3. used only for pipeline frames number accounting (tape->pipeline_head),
    also unused elsewhere.
    
    4.some variables are:
            only written to: tape->buffer_head;
            unused: tape->tape_head, tape->last_tape_head
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 97c566cebe083b8e500c9b0b5033212c809d9844
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:25 2008 +0200

    ide-tape: remove pipeline-specific code from idetape_add_chrdev_write_request
    
    Refrain from adding more write requests to the pipeline and queue them
    directly on the device's request queue instead.
    
    [bart: re-do for minimal behavior changes]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit f64eee7bb2819da5506a2db5b6297612a17eb3f8
Author: Borislav Petkov <petkovbb@googlemail.com>
Date:   Sun Apr 27 15:38:25 2008 +0200

    ide-tape: remove tape->cache_stage
    
    Prior to allocating a new pipeline stage, the code checked for the existence of
    a cached pipeline stage to use. Do away with and stick to normal pipeline
    stages only.
    
    [bart: keep idetape_kmalloc_stage() for now]
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit cc12175ff2eadb0918d573169af88429440a21ae
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:24 2008 +0200

    ide: remove obsoleted "hdx=noautotune" kernel parameter
    
    Remove obsoleted "hdx=noautotune" kernel parameter
    (it has been obsoleted since 1 Nov 2004).
    
    Then make ide_hwif_t.autotune a single bit flag
    and remove no longer needed IDE_TUNE_* defines.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit ef87f8d09639cbe22201c7dfe07586c43b255108
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:24 2008 +0200

    ide: remove obsoleted "idex=" kernel parameters
    
    * Remove obsoleted "idex=" kernel parameters.
    
    * Make probe_* and cmd640_vlb variables static.
    
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit e460a59751a7e53b549c63d4d308ba73582c8def
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:24 2008 +0200

    ide: remove obsoleted "idex=reset" kernel parameter
    
    Remove obsoleted "idex=reset" kernel parameter
    (it has been obsoleted since 1 Nov 2004).
    
    Then remove corresponding code from ide_probe_port()
    and no longer used ->reset field from ide_hwif_t.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 9dd4cf1fb949f6ba56b67078c09ef1b78f3c9421
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:24 2008 +0200

    ide: remove obsoleted "idex=serialize" kernel parameter
    
    Remove obsoleted "idex=serialize" kernel parameter
    (it has been obsoleted since 1 Nov 2004).
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 9fd91d959f1a19d1bfa46d97cbbbb55641ce26a6
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Apr 27 15:38:23 2008 +0200

    ide: add "ignore_cable" parameter (take 2)
    
    Add "ignore_cable" parameter:
    
    * "ide_core.ignore_cable=[interface_number]" boot option if IDE is built-in
      (i.e. "ide_core.ignore_cable=1" to force ignoring cable for "ide1")
    
    * "ignore_cable=[interface_number]" module parameter (for ide_core module)
      if IDE is compiled as module
    
    v2:
    * Add ide_port_apply_params() helper
      - use it in ide_device_add_all() and ide_scan_port().
    
    * Make it possible to later disable ignoring cable detection by passing
      "[interface_number]:0" to /sys/module/ide_core/parameters/ignore_cable
      (however sysfs interface is not enabled yet since it needs some other
       IDE changes to make it work reliable).
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 9c391bae6a65bd39962877ad7dc000b600757bbe
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sun Apr 27 15:38:23 2008 +0200

    ide: fix icside breakage
    
    	Fallout from commit ac95beedf8bc97b24f9540d4da9952f07221c023
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Russell King <rmk@arm.linux.org.uk>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit a45352908b88d383bc40e1e4d1a6cc5bbcefc895
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Apr 13 17:54:35 2008 +0300

    KVM: Rename VCPU_MP_STATE_* to KVM_MP_STATE_*
    
    We wish to export it to userspace, so move it into the kvm namespace.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3d80840d96127401ba6aeadd813c3a15b84e70fe
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 11 14:53:26 2008 -0300

    KVM: hlt emulation should take in-kernel APIC/PIT timers into account
    
    Timers that fire between guest hlt and vcpu_block's add_wait_queue() are
    ignored, possibly resulting in hangs.
    
    Also make sure that atomic_inc and waitqueue_active tests happen in the
    specified order, otherwise the following race is open:
    
    CPU0                                        CPU1
                                                if (waitqueue_active(wq))
    add_wait_queue()
    if (!atomic_read(pit_timer->pending))
        schedule()
                                                atomic_inc(pit_timer->pending)
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3564990af1b9f77a63692c1079e9c41af229f066
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 9 16:04:32 2008 +0200

    KVM: SVM: do not intercept task switch with NPT
    
    When KVM uses NPT there is no reason to intercept task switches. This patch
    removes the intercept for it in that case.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d4c9ff2d1b78e385471b3f4d80c0596909926ef7
Author: Feng(Eric) Liu <eric.e.liu@intel.com>
Date:   Thu Apr 10 08:47:53 2008 -0400

    KVM: Add kvm trace userspace interface
    
    This interface allows user a space application to read the trace of kvm
    related events through relayfs.
    
    Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 048354c8e6bf95e7347f623d8a0da5b89e216405
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Apr 11 02:51:52 2008 +0300

    KVM: ia64: Stub out kvmtrace
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7732a8d19bdc6ae18f68f9adb47d11c82a3a86cd
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Apr 11 02:50:40 2008 +0300

    KVM: s390: Stub out kvmtrace
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2714d1d3d6be882b97cd0125140fccf9976a460a
Author: Feng (Eric) Liu <eric.e.liu@intel.com>
Date:   Thu Apr 10 15:31:10 2008 -0400

    KVM: Add trace markers
    
    Trace markers allow userspace to trace execution of a virtual machine
    in order to monitor its performance.
    
    Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 53371b5098543ab09dcb0c7ce31da887dbe58c62
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 9 14:15:30 2008 +0200

    KVM: SVM: add intercept for machine check exception
    
    To properly forward a MCE occured while the guest is running to the host, we
    have to intercept this exception and call the host handler by hand. This is
    implemented by this patch.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 6394b6494c0a352a2db3ea3e891ba7aeea7c1441
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 9 14:15:29 2008 +0200

    KVM: SVM: align shadow CR4.MCE with host
    
    This patch aligns the host version of the CR4.MCE bit with the CR4 active in
    the guest. This is necessary to get MCE exceptions when the guest is running.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ec077263b2bb841d973d82342b7fbc07bbad4246
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Apr 9 14:15:28 2008 +0200

    KVM: SVM: indent svm_set_cr4 with tabs instead of spaces
    
    The svm_set_cr4 function is indented with spaces. This patch replaces
    them with tabs.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 258ac8e066622df3fef94c8adf32596faae5ab71
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Apr 6 14:25:46 2008 +0300

    KVM: Register ioctl range
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 35149e2129fe34fc8cb5917e1ecf5156b0fa3415
Author: Anthony Liguori <aliguori@us.ibm.com>
Date:   Wed Apr 2 14:46:56 2008 -0500

    KVM: MMU: Don't assume struct page for x86
    
    This patch introduces a gfn_to_pfn() function and corresponding functions like
    kvm_release_pfn_dirty().  Using these new functions, we can modify the x86
    MMU to no longer assume that it can always get a struct page for any given gfn.
    
    We don't want to eliminate gfn_to_page() entirely because a number of places
    assume they can do gfn_to_page() and then kmap() the results.  When we support
    IO memory, gfn_to_page() will fail for IO pages although gfn_to_pfn() will
    succeed.
    
    This does not implement support for avoiding reference counting for reserved
    RAM or for IO memory.  However, it should make those things pretty straight
    forward.
    
    Since we're only introducing new common symbols, I don't think it will break
    the non-x86 architectures but I haven't tested those.  I've tested Intel,
    AMD, NPT, and hugetlbfs with Windows and Linux guests.
    
    [avi: fix overflow when shifting left pfns by adding casts]
    
    Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fdae862f91728aec6dd8fd62cd2398868c906b6b
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 15:08:29 2008 +0800

    KVM: ia64: Add a guide about how to create kvm guests on ia64
    
    Guide for creating virtual machine on kvm/ia64.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit b693919ca983e9eb989d89dac5493ef3c5e98e77
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Fri Mar 28 14:58:47 2008 +0800

    KVM: ia64: Enable kvm build for ia64
    
    Update the related Makefile and KConfig for kvm build
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ad86b6c36bbb9c1cac610f1b8a310d87eafea778
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:59:30 2008 +0800

    KVM: ia64: Add kvm sal/pal virtulization support
    
    Some sal/pal calls would be traped to kvm for virtulization
    from guest firmware.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 827fa691e41a538bbe941d9c988e07e6abea1648
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:58:42 2008 +0800

    KVM: ia64: Add guest interruption injection support
    
    process.c mainly handle interruption injection, and some faults handling.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d62998a681f4688605895bb7068d76d25132e3a2
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:57:53 2008 +0800

    KVM: ia64: Generate offset values for assembly code use
    
    asm-offsets.c will generate offset values used for assembly code
    for some fileds of special structures.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7fc86bd9c0830651826d88c65b6aad55086a6e01
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:57:09 2008 +0800

    KVM: ia64: Add optimization for some virtulization faults
    
    optvfault.S Add optimization for some performance-critical
    virtualization faults.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 60a07bb9baa83e17d4b540a2f371661ecc353c6c
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 16:14:28 2008 +0800

    KVM: ia64: Add processor virtulization support
    
    vcpu.c provides processor virtualization logic for kvm.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a793537a970584720347293935a4bb6323791a05
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:54:42 2008 +0800

    KVM: ia64: Add trampoline for guest/host mode switch
    
    trampoline code targets for guest/host world switch.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e30af4ce7fea3d3a470f8f9996c53564f34e4754
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:53:32 2008 +0800

    KVM: ia64: Add mmio decoder for kvm/ia64
    
    mmio.c includes mmio decoder, and related mmio logics.
    
    Signed-off-by: Anthony Xu <Anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fbd4b5621c8db767f78c89d1ac708ac4bb276caf
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:52:19 2008 +0800

    KVM: ia64: Add interruption vector table for vmm
    
    vmm_ivt.S includes an ivt for vmm use.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 964cd94a2ae3b20f9da9bd43b31aac32c4fe9aee
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:50:59 2008 +0800

    KVM: ia64: Add TLB virtulization support
    
    vtlb.c includes tlb/VHPT virtulization.
    
    Signed-off-by: Anthony Xu <anthony.xu@intel.com>
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit bb46fb4af160ec7ae6e5102a79a3b2518eaee7af
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:49:24 2008 +0800

    KVM: ia64: VMM module interfaces
    
    vmm.c adds the interfaces with kvm/module, and initialize global data area.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a4f500381ac91969fa4f8b0a4e39e76dbf00a913
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 16:00:24 2008 +0800

    KVM: ia64: Add header files for kvm/ia64
    
    kvm_minstate.h : Marcos about Min save routines.
    lapic.h: apic structure definition.
    vcpu.h : routions related to vcpu virtualization.
    vti.h  : Some macros or routines for VT support on Itanium.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit b024b79322aad213cd2d4f30c23a6c626a0d5b31
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 15:29:29 2008 +0800

    KVM: ia64: Add kvm arch-specific core code for kvm/ia64
    
    kvm_ia64.c is created to handle kvm ia64-specific core logic.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1a9c1ac46990194f6b6ddc591c24e385e611fa25
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:45:06 2008 +0800

    KVM: ia64: Add header files for kvm/ia64
    
    Three header files are added:
    asm-ia64/kvm.h
    asm-ia64/kvm_host.h
    asm-ia64/kvm_para.h
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e235f3450f5bf94b989746163b7791784a78ee05
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Tue Apr 1 14:42:00 2008 +0800

    KVM: ia64: Prepare some structure and routines for kvm use
    
    Register structures are defined per SDM.
    Add three small routines for kernel:
    ia64_ttag, ia64_loadrs, ia64_flushrs
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit c71799c1f404c6e4f34fa64e6be39cd6149e5019
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Fri Apr 4 16:03:34 2008 +0200

    KVM: s390: Improve pgste accesses
    
    There is no need to use interlocked updates when the rcp
    lock is held. Therefore the simple bitops variants can be
    used. This should improve performance.
    
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f603f0731f43421403160f5f8b12e90f2e51f064
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Fri Apr 4 15:12:40 2008 +0200

    KVM: s390: rename stfl to kvm_stfl
    
    Temporarily rename this function to avoid merge conflicts and/or
    dependencies. This function will be removed as soon as git-s390
    and kvm.git are finally upstream.
    
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7e8e6ab48d78147f69c1ba2d6a362f8d33254468
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Fri Apr 4 15:12:35 2008 +0200

    KVM: s390: Fix incorrect return value
    
    kvm_arch_vcpu_ioctl_run currently incorrectly always returns 0.
    
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit bed1d1dfc4a458d82bcd258082638cbba860190d
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Apr 4 14:56:44 2008 -0300

    KVM: MMU: prepopulate guest pages after write-protecting
    
    Zdenek reported a bug where a looping "dmsetup status" eventually hangs
    on SMP guests.
    
    The problem is that kvm_mmu_get_page() prepopulates the shadow MMU
    before write protecting the guest page tables. By doing so, it leaves a
    window open where the guest can mark a pte as present while the host has
    shadow cached such pte as "notrap". Accesses to such address will fault
    in the guest without the host having a chance to fix the situation.
    
    Fix by moving the write protection before the pte prefetch.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fcd6dbac9267c1c06a205ad8bb4bd027c0ace7f7
Author: Avi Kivity <avi@qumranet.com>
Date:   Thu Apr 3 12:02:21 2008 +0300

    KVM: MMU: Only mark_page_accessed() if the page was accessed by the guest
    
    If the accessed bit is not set, the guest has never accessed this page
    (at least through this spte), so there's no need to mark the page
    accessed.  This provides more accurate data for the eviction algortithm.
    
    Noted by Andrea Arcangeli.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d39f13b0da7fa7f705fbe6c80995205d0380bc7a
Author: Izik Eidus <izike@qumranet.com>
Date:   Sun Mar 30 16:01:25 2008 +0300

    KVM: add vm refcounting
    
    the main purpose of adding this functions is the abilaty to release the
    spinlock that protect the kvm list while still be able to do operations
    on a specific kvm in a safe way.
    
    Signed-off-by: Izik Eidus <izike@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 9c20456a32ce9e82ccda55e12c10016b181d85e5
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Tue Apr 1 16:44:56 2008 +0200

    KVM: function declaration parameter name cleanup
    
    The kvm_host.h file for x86 declares the functions kvm_set_cr[0348]. In the
    header file their second parameter is named cr0 in all cases. This patch
    renames the parameters so that they match the function name.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3d45830c2b11a9d756faae161742b7d1ec417f7e
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Mar 25 11:26:13 2008 +0200

    KVM: Free apic access page on vm destruction
    
    Noticed by Marcelo Tosatti.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3ee16c814511cd58f956b47b9c7654f57f674688
Author: Izik Eidus <izike@qumranet.com>
Date:   Sun Mar 30 15:17:21 2008 +0300

    KVM: MMU: allow the vm to shrink the kvm mmu shadow caches
    
    Allow the Linux memory manager to reclaim memory in the kvm shadow cache.
    
    Signed-off-by: Izik Eidus <izike@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3200f405a1e8e06c8634f11d33614455baa4e6be
Author: Marcelo Tosatti <marcelo@kvack.org>
Date:   Sat Mar 29 20:17:59 2008 -0300

    KVM: MMU: unify slots_lock usage
    
    Unify slots_lock acquision around vcpu_run(). This is simpler and less
    error-prone.
    
    Also fix some callsites that were not grabbing the lock properly.
    
    [avi: drop slots_lock while in guest mode to avoid holding the lock
          for indefinite periods]
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 25c5f225beda4fbea878ed8b6203ab4ecc7de2d1
Author: Sheng Yang <sheng.yang@intel.com>
Date:   Fri Mar 28 13:18:56 2008 +0800

    KVM: VMX: Enable MSR Bitmap feature
    
    MSR Bitmap controls whether the accessing of an MSR causes VM Exit.
    Eliminating exits on automatically saved and restored MSRs yields a
    small performance gain.
    
    Signed-off-by: Sheng Yang <sheng.yang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e976a2b997fc4ad70ccc53acfe62811c4aaec851
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:46 2008 +0100

    s390: KVM guest: virtio device support, and kvm hypercalls
    
    This patch implements kvm guest kernel support for paravirtualized devices
    and contains two parts:
    o a basic virtio stub using virtio_ring and external interrupts and hypercalls
    o full hypercall implementation in kvm_para.h
    
    Currently we dont have PCI on s390. Making virtio_pci usable for s390 seems
    more complicated that providing an own stub. This virtio stub is similar to
    the lguest one, the memory for the descriptors and the device detection is made
    via additional mapped memory on top of the guest storage. We use an external
    interrupt with extint code 0x2603 for host->guest notification.
    
    The hypercall definition uses the diag instruction for issuing a hypercall. The
    parameters are written in R2-R7, the hypercall number is written in R1. This is
    similar to the system call ABI (svc) which can use R1 for the number and R2-R6
    for the parameters.
    
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fa5877439d5a062d91c3abd5a690483bbdb4268e
Author: Carsten Otte <cotte@de.ibm.com>
Date:   Tue Mar 25 18:47:44 2008 +0100

    s390: KVM guest: detect when running on kvm
    
    This patch adds functionality to detect if the kernel runs under the KVM
    hypervisor. A macro MACHINE_IS_KVM is exported for device drivers. This
    allows drivers to skip device detection if the systems runs non-virtualized.
    We also define a preferred console to avoid having the ttyS0, which is a line
    mode only console.
    
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 85f8fffe3c2ab13f13526c46b5471fc22e98ccfe
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:41 2008 +0100

    KVM: s390: update maintainers
    
    This patch adds an entry for kvm on s390 to the MAINTAINERS file :-). We intend
    to push all patches regarding this via Avi's kvm.git.
    
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 5ecee4ba4eb2ada7ece7c41eb08cf7bc51b579e2
Author: Carsten Otte <cotte@de.ibm.com>
Date:   Tue Mar 25 18:47:38 2008 +0100

    KVM: s390: API documentation
    
    This patch adds Documentation/s390/kvm.txt, which describes specifics of kvm's
    user interface that are unique to s390 architecture.
    
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 77b455f1bcfa0fddb31b8e6f9f2adc246acb4216
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:36 2008 +0100

    KVM: s390: add kvm to kconfig on s390
    
    This patch adds the virtualization submenu and the kvm option to the kernel
    config. It also defines HAVE_KVM for 64bit kernels.
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e28acfea5dd9dbc67c2594cbefc140129dbd0e3f
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:34 2008 +0100

    KVM: s390: intercepts for diagnose instructions
    
    This patch introduces interpretation of some diagnose instruction intercepts.
    Diagnose is our classic architected way of doing a hypercall. This patch
    features the following diagnose codes:
    - vm storage size, that tells the guest about its memory layout
    - time slice end, which is used by the guest to indicate that it waits
      for a lock and thus cannot use up its time slice in a useful way
    - ipl functions, which a guest can use to reset and reboot itself
    
    In order to implement ipl functions, we also introduce an exit reason that
    causes userspace to perform various resets on the virtual machine. All resets
    are described in the principles of operation book, except KVM_S390_RESET_IPL
    which causes a reboot of the machine.
    
    Acked-by: Martin Schwidefsky <martin.schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 5288fbf0ef041ba0e8b4dcb2df4536b5e3a48b32
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:31 2008 +0100

    KVM: s390: interprocessor communication via sigp
    
    This patch introduces in-kernel handling of _some_ sigp interprocessor
    signals (similar to ipi).
    kvm_s390_handle_sigp() decodes the sigp instruction and calls individual
    handlers depending on the operation requested:
    - sigp sense tries to retrieve information such as existence or running state
      of the remote cpu
    - sigp emergency sends an external interrupt to the remove cpu
    - sigp stop stops a remove cpu
    - sigp stop store status stops a remote cpu, and stores its entire internal
      state to the cpus lowcore
    - sigp set arch sets the architecture mode of the remote cpu. setting to
      ESAME (s390x 64bit) is accepted, setting to ESA/S390 (s390, 31 or 24 bit) is
      denied, all others are passed to userland
    - sigp set prefix sets the prefix register of a remote cpu
    
    For implementation of this, the stop intercept indication starts to get reused
    on purpose: a set of action bits defines what to do once a cpu gets stopped:
    ACTION_STOP_ON_STOP  really stops the cpu when a stop intercept is recognized
    ACTION_STORE_ON_STOP stores the cpu status to lowcore when a stop intercept is
                         recognized
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 453423dce2785b8e22077e3b3eeecb4f60fe3470
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:29 2008 +0100

    KVM: s390: intercepts for privileged instructions
    
    This patch introduces in-kernel handling of some intercepts for privileged
    instructions:
    
    handle_set_prefix()        sets the prefix register of the local cpu
    handle_store_prefix()      stores the content of the prefix register to memory
    handle_store_cpu_address() stores the cpu number of the current cpu to memory
    handle_skey()              just decrements the instruction address and retries
    handle_stsch()             delivers condition code 3 "operation not supported"
    handle_chsc()              same here
    handle_stfl()              stores the facility list which contains the
                               capabilities of the cpu
    handle_stidp()             stores cpu type/model/revision and such
    handle_stsi()              stores information about the system topology
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ba5c1e9b6ceebdc39343cc03eb39f077abd3c571
Author: Carsten Otte <cotte@de.ibm.com>
Date:   Tue Mar 25 18:47:26 2008 +0100

    KVM: s390: interrupt subsystem, cpu timer, waitpsw
    
    This patch contains the s390 interrupt subsystem (similar to in kernel apic)
    including timer interrupts (similar to in-kernel-pit) and enabled wait
    (similar to in kernel hlt).
    
    In order to achieve that, this patch also introduces intercept handling
    for instruction intercepts, and it implements load control instructions.
    
    This patch introduces an ioctl KVM_S390_INTERRUPT which is valid for both
    the vm file descriptors and the vcpu file descriptors. In case this ioctl is
    issued against a vm file descriptor, the interrupt is considered floating.
    Floating interrupts may be delivered to any virtual cpu in the configuration.
    
    The following interrupts are supported:
    SIGP STOP       - interprocessor signal that stops a remote cpu
    SIGP SET PREFIX - interprocessor signal that sets the prefix register of a
                      (stopped) remote cpu
    INT EMERGENCY   - interprocessor interrupt, usually used to signal need_reshed
                      and for smp_call_function() in the guest.
    PROGRAM INT     - exception during program execution such as page fault, illegal
                      instruction and friends
    RESTART         - interprocessor signal that starts a stopped cpu
    INT VIRTIO      - floating interrupt for virtio signalisation
    INT SERVICE     - floating interrupt for signalisations from the system
                      service processor
    
    struct kvm_s390_interrupt, which is submitted as ioctl parameter when injecting
    an interrupt, also carrys parameter data for interrupts along with the interrupt
    type. Interrupts on s390 usually have a state that represents the current
    operation, or identifies which device has caused the interruption on s390.
    
    kvm_s390_handle_wait() does handle waitpsw in two flavors: in case of a
    disabled wait (that is, disabled for interrupts), we exit to userspace. In case
    of an enabled wait we set up a timer that equals the cpu clock comparator value
    and sleep on a wait queue.
    
    [christian: change virtio interrupt to 0x2603]
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 8f2abe6a1e525e878bdf58f68ccd146d543fde84
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:23 2008 +0100

    KVM: s390: sie intercept handling
    
    This path introduces handling of sie intercepts in three flavors: Intercepts
    are either handled completely in-kernel by kvm_handle_sie_intercept(),
    or passed to userspace with corresponding data in struct kvm_run in case
    kvm_handle_sie_intercept() returns -ENOTSUPP.
    In case of partial execution in kernel with the need of userspace support,
    kvm_handle_sie_intercept() may choose to set up struct kvm_run and return
    -EREMOTE.
    
    The trivial intercept reasons are handled in this patch:
    handle_noop() just does nothing for intercepts that don't require our support
      at all
    handle_stop() is called when a cpu enters stopped state, and it drops out to
      userland after updating our vcpu state
    handle_validity() faults in the cpu lowcore if needed, or passes the request
      to userland
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit b0c632db637d68ad39d9f97f452ce176253f5f4e
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Tue Mar 25 18:47:20 2008 +0100

    KVM: s390: arch backend for the kvm kernel module
    
    This patch contains the port of Qumranet's kvm kernel module to IBM zSeries
     (aka s390x, mainframe) architecture. It uses the mainframe's virtualization
    instruction SIE to run virtual machines with up to 64 virtual CPUs each.
    This port is only usable on 64bit host kernels, and can only run 64bit guest
    kernels. However, running 31bit applications in guest userspace is possible.
    
    The following source files are introduced by this patch
    arch/s390/kvm/kvm-s390.c    similar to arch/x86/kvm/x86.c, this implements all
                                arch callbacks for kvm. __vcpu_run calls back into
                                sie64a to enter the guest machine context
    arch/s390/kvm/sie64a.S      assembler function sie64a, which enters guest
                                context via SIE, and switches world before and after                            that
    include/asm-s390/kvm_host.h contains all vital data structures needed to run
                                virtual machines on the mainframe
    include/asm-s390/kvm.h      defines kvm_regs and friends for user access to
                                guest register content
    arch/s390/kvm/gaccess.h     functions similar to uaccess to access guest memory
    arch/s390/kvm/kvm-s390.h    header file for kvm-s390 internals, extended by
                                later patches
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 8a88ac6183975c73c65b45f365f6f3b875c1348b
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:15 2008 +0100

    s390: KVM preparation: address of the 64bit extint parm in lowcore
    
    The address 0x11b8 is used by z/VM for pfault and diag 250 I/O to
    provide a 64 bit extint parameter. virtio uses the same address, so
    its time to update the lowcore structure.
    
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 5b7baf05783b1ac97a510243d7e82293416a7cf6
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Tue Mar 25 18:47:12 2008 +0100

    s390: KVM preparation: host memory management changes for s390 kvm
    
    This patch changes the s390 memory management defintions to use the pgste field
    for dirty and reference bit tracking of host and guest code. Usually on s390,
    dirty and referenced are tracked in storage keys, which belong to the physical
    page. This changes with virtualization: The guest and host dirty/reference bits
    are defined to be the logical OR of the values for the mapping and the physical
    page. This patch implements the necessary changes in pgtable.h for s390.
    
    There is a common code change in mm/rmap.c, the call to
    page_test_and_clear_young must be moved. This is a no-op for all
    architecture but s390. page_referenced checks the referenced bits for
    the physiscal page and for all mappings:
    o The physical page is checked with page_test_and_clear_young.
    o The mappings are checked with ptep_test_and_clear_young and friends.
    
    Without pgstes (the current implementation on Linux s390) the physical page
    check is implemented but the mapping callbacks are no-ops because dirty
    and referenced are not tracked in the s390 page tables. The pgstes introduces
    guest and host dirty and reference bits for s390 in the host mapping. These
    mapping must be checked before page_test_and_clear_young resets the reference
    bit.
    
    Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Acked-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 402b08622d9ac6e32e25289573272e0f21bb58a7
Author: Carsten Otte <cotte@de.ibm.com>
Date:   Tue Mar 25 18:47:10 2008 +0100

    s390: KVM preparation: provide hook to enable pgstes in user pagetable
    
    The SIE instruction on s390 uses the 2nd half of the page table page to
    virtualize the storage keys of a guest. This patch offers the s390_enable_sie
    function, which reorganizes the page tables of a single-threaded process to
    reserve space in the page table:
    s390_enable_sie makes sure that the process is single threaded and then uses
    dup_mm to create a new mm with reorganized page tables. The old mm is freed
    and the process has now a page status extended field after every page table.
    
    Code that wants to exploit pgstes should SELECT CONFIG_PGSTE.
    
    This patch has a small common code hit, namely making dup_mm non-static.
    
    Edit (Carsten): I've modified Martin's patch, following Jeremy Fitzhardinge's
    review feedback. Now we do have the prototype for dup_mm in
    include/linux/sched.h. Following Martin's suggestion, s390_enable_sie() does now
    call task_lock() to prevent race against ptrace modification of mm_users.
    
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Signed-off-by: Carsten Otte <cotte@de.ibm.com>
    Acked-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 37817f2982d0f559f90cecc66e150dd9d2c2df05
Author: Izik Eidus <izike@qumranet.com>
Date:   Mon Mar 24 23:14:53 2008 +0200

    KVM: x86: hardware task switching support
    
    This emulates the x86 hardware task switch mechanism in software, as it is
    unsupported by either vmx or svm.  It allows operating systems which use it,
    like freedos, to run as kvm guests.
    
    Signed-off-by: Izik Eidus <izike@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2e4d2653497856b102c90153f970c9e344ba96c6
Author: Izik Eidus <izike@qumranet.com>
Date:   Mon Mar 24 19:38:34 2008 +0200

    KVM: x86: add functions to get the cpl of vcpu
    
    Signed-off-by: Izik Eidus <izike@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 4c9fc8ef501790732ed035585b491756b75ea4c6
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Mar 24 18:15:14 2008 +0200

    KVM: VMX: Add module option to disable flexpriority
    
    Useful for debugging.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 268fe02ae058c0c5e84ad678d67e5d7b013e664f
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Mar 23 18:36:30 2008 +0200

    KVM: no longer EXPERIMENTAL
    
    Long overdue.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 0b49ea8659fd3b5005823e02d2d0a775521770e5
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Mar 23 15:06:23 2008 +0200

    KVM: MMU: Introduce and use spte_to_page()
    
    Encapsulate the pte mask'n'shift in a function.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 855149aaa90016c576a0e684361a34f8047307d0
Author: Izik Eidus <izike@qumranet.com>
Date:   Thu Mar 20 18:17:24 2008 +0200

    KVM: MMU: fix dirty bit setting when removing write permissions
    
    When mmu_set_spte() checks if a page related to spte should be release as
    dirty or clean, it check if the shadow pte was writeble, but in case
    rmap_write_protect() is called called it is possible for shadow ptes that were
    writeble to become readonly and therefor mmu_set_spte will release the pages
    as clean.
    
    This patch fix this issue by marking the page as dirty inside
    rmap_write_protect().
    
    Signed-off-by: Izik Eidus <izike@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 69a9f69bb24d6d3dbf3d2ba542ddceeda40536d5
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Mar 21 12:38:23 2008 +0200

    KVM: Move some x86 specific constants and structures to include/asm-x86
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 947da53830690cbd77d7f2b625d0df1f161ffd54
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Mar 18 11:05:52 2008 +0200

    KVM: MMU: Set the accessed bit on non-speculative shadow ptes
    
    If we populate a shadow pte due to a fault (and not speculatively due to a
    pte write) then we can set the accessed bit on it, as we know it will be
    set immediately on the next guest instruction.  This saves a read-modify-write
    operation.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 97646202bc3f190dfcb48a3d506ea2445717d392
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Wed Mar 12 18:10:45 2008 +0100

    KVM: kvm.h: __user requires compiler.h
    
    include/linux/kvm.h defines struct kvm_dirty_log to
    	[...]
    	union {
    		void __user *dirty_bitmap; /* one bit per page */
    		__u64 padding;
    	};
    
    __user requires compiler.h to compile. Currently, this works on x86
    only coincidentally due to other include files. This patch makes
    kvm.h compile in all cases.
    
    Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1e977aa12dd4f80688b1f243762212e75c6d7fe8
Author: Glauber Costa <gcosta@redhat.com>
Date:   Mon Mar 17 16:08:40 2008 -0300

    x86: KVM guest: disable clock before rebooting.
    
    This patch writes 0 (actually, what really matters is that the
    LSB is cleared) to the system time msr before shutting down
    the machine for kexec.
    
    Without it, we can have a random memory location being written
    when the guest comes back
    
    It overrides the functions shutdown, used in the path of kernel_kexec() (sys.c)
    and crash_shutdown, used in the path of crash_kexec() (kexec.c)
    
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3c62c62502bea24448d4e82aa1f33c7dbca61a32
Author: Glauber Costa <gcosta@redhat.com>
Date:   Mon Mar 17 16:08:39 2008 -0300

    x86: make native_machine_shutdown non-static
    
    it will allow external users to call it. It is mainly
    useful for routines that will override its machine_ops
    field for its own special purposes, but want to call the
    normal shutdown routine after they're done
    
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ed23dc6f5bc950ebbe683dd0bed1d5878230c171
Author: Glauber Costa <gcosta@redhat.com>
Date:   Mon Mar 17 16:08:38 2008 -0300

    x86: allow machine_crash_shutdown to be replaced
    
    This patch a llows machine_crash_shutdown to
    be replaced, just like any of the other functions
    in machine_ops
    
    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 096d14a3b57e4a87d27be09cc64b4f84660acd08
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Feb 22 12:21:38 2008 -0500

    x86: KVM guest: hypercall batching
    
    Batch pte updates and tlb flushes in lazy MMU mode.
    
    [avi:
     - adjust to mmu_op
     - helper for getting para_state without debug warnings]
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1da8a77bdc294acdc37e8504926383b86f72d6be
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Feb 22 12:21:37 2008 -0500

    x86: KVM guest: hypercall based pte updates and TLB flushes
    
    Hypercall based pte updates are faster than faults, and also allow use
    of the lazy MMU mode to batch operations.
    
    Don't report the feature if two dimensional paging is enabled.
    
    [avi:
     - guest/host split
     - fix 32-bit truncation issues
     - adjust to mmu_op
     - adjust to ->release_*() renamed
     - add ->release_pud()]
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2f333bcb4edd8daef99dabe4e7df8277af73cff1
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Feb 22 12:21:37 2008 -0500

    KVM: MMU: hypercall based pte updates and TLB flushes
    
    Hypercall based pte updates are faster than faults, and also allow use
    of the lazy MMU mode to batch operations.
    
    Don't report the feature if two dimensional paging is enabled.
    
    [avi:
     - one mmu_op hypercall instead of one per op
     - allow 64-bit gpa on hypercall
     - don't pass host errors (-ENOMEM) to guest]
    
    [akpm: warning fix on i386]
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 9f81128591ca1e9907f2e7a7b195e33232167d60
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Mar 2 14:06:05 2008 +0200

    KVM: Provide unlocked version of emulator_write_phys()
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 0cf1bfd2737f41e59f974a61eab11af206d2042a
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Feb 22 12:21:36 2008 -0500

    x86: KVM guest: add basic paravirt support
    
    Add basic KVM paravirt support. Avoid vm-exits on IO delays.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a28e4f5a621289fe0d9c8a461b0c256f9e17f3bc
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Fri Feb 22 12:21:36 2008 -0500

    KVM: add basic paravirt support
    
    Add basic KVM paravirt support. Avoid vm-exits on IO delays.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 308b0f239e8d6754b8b903d279e5b5b987e257ac
Author: Sheng Yang <sheng.yang@intel.com>
Date:   Thu Mar 13 10:22:26 2008 +0800

    KVM: Add reset support for in kernel PIT
    
    Separate the reset part and prepare for reset support.
    
    Signed-off-by: Sheng Yang <sheng.yang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e0f63cb9277b64850854aee301762beeeb463473
Author: Sheng Yang <sheng.yang@intel.com>
Date:   Tue Mar 4 00:50:59 2008 +0800

    KVM: Add save/restore supporting of in kernel PIT
    
    Signed-off-by: Sheng Yang <sheng.yang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7837699fa6d7adf81f26ab73a5f6897ea1ab9d6a
Author: Sheng Yang <sheng.yang@intel.com>
Date:   Mon Jan 28 05:10:22 2008 +0800

    KVM: In kernel PIT model
    
    The patch moves the PIT model from userspace to kernel, and increases
    the timer accuracy greatly.
    
    [marcelo: make last_injected_time per-guest]
    
    Signed-off-by: Sheng Yang <sheng.yang@intel.com>
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Tested-and-Acked-by: Alex Davis <alex14641@yahoo.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 4fcaa98267efc4d39ded9b0bc33c6b4a2f62fecd
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Mar 5 09:33:44 2008 +0200

    KVM: Remove pointless desc_ptr #ifdef
    
    The desc_struct changes left an unnecessary #ifdef; remove it.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 019960ae9933161c2809fa4ee608ba30d9639fd2
Author: Avi Kivity <avi@qumranet.com>
Date:   Tue Mar 4 10:44:51 2008 +0200

    KVM: VMX: Don't adjust tsc offset forward
    
    Most Intel hosts have a stable tsc, and playing with the offset only
    reduces accuracy.  By limiting tsc offset adjustment only to forward updates,
    we effectively disable tsc offset adjustment on these hosts.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit b8688d51bbe4872fbcec751e04369606082ac610
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Mar 3 12:59:56 2008 -0800

    KVM: replace remaining __FUNCTION__ occurances
    
    __FUNCTION__ is gcc-specific, use __func__
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 71c4dfafc0932d92cc99c7e839d25174b0ce10a1
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Tue Feb 26 16:49:16 2008 +0100

    KVM: detect if VCPU triple faults
    
    In the current inject_page_fault path KVM only checks if there is another PF
    pending and injects a DF then. But it has to check for a pending DF too to
    detect a shutdown condition in the VCPU.  If this is not detected the VCPU goes
    to a PF -> DF -> PF loop when it should triple fault. This patch detects this
    condition and handles it with an KVM_SHUTDOWN exit to userspace.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 3e4bb3ac9e0ada5df5f6729648d403ea9f071d10
Author: Xiantao Zhang <xiantao.zhang@intel.com>
Date:   Mon Feb 25 18:52:20 2008 +0800

    KVM: Use kzalloc to avoid allocating kvm_regs from kernel stack
    
    Since the size of kvm_regs is too big to allocate from kernel stack on ia64,
    use kzalloc to allocate it.
    
    Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2d3ad1f40c841bd3e97d30d423eea53915d085dc
Author: Avi Kivity <avi@qumranet.com>
Date:   Sun Feb 24 11:20:43 2008 +0200

    KVM: Prefix control register accessors with kvm_ to avoid namespace pollution
    
    Names like 'set_cr3()' look dangerously close to affecting the host.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 05da45583de9b383dc81dd695fe248431d6c9f2b
Author: Marcelo Tosatti <marcelo@kvack.org>
Date:   Sat Feb 23 11:44:30 2008 -0300

    KVM: MMU: large page support
    
    Create large pages mappings if the guest PTE's are marked as such and
    the underlying memory is hugetlbfs backed.  If the largepage contains
    write-protected pages, a large pte is not used.
    
    Gives a consistent 2% improvement for data copies on ram mounted
    filesystem, without NPT/EPT.
    
    Anthony measures a 4% improvement on 4-way kernbench, with NPT.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2e53d63acba75795aa226febd140f67c58c6a353
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Wed Feb 20 14:47:24 2008 -0500

    KVM: MMU: ignore zapped root pagetables
    
    Mark zapped root pagetables as invalid and ignore such pages during lookup.
    
    This is a problem with the cr3-target feature, where a zapped root table fools
    the faulting code into creating a read-only mapping. The result is a lockup
    if the instruction can't be emulated.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Anthony Liguori <aliguori@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 847f0ad8cbfa70c1af6948025836dfbd9ed6da1e
Author: Alexander Graf <alex@csgraf.de>
Date:   Thu Feb 21 12:11:01 2008 +0100

    KVM: Implement dummy values for MSR_PERF_STATUS
    
    Darwin relies on this and ceases to work without.
    
    Signed-off-by: Alexander Graf <alex@csgraf.de>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 14af3f3c56103d8c3bb173c255ef5d89fb0c9350
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Feb 19 10:25:50 2008 -0800

    KVM: sparse fixes for kvm/x86.c
    
    In two case statements, use the ever popular 'i' instead of index:
    arch/x86/kvm/x86.c:1063:7: warning: symbol 'index' shadows an earlier one
    arch/x86/kvm/x86.c:1000:9: originally declared here
    arch/x86/kvm/x86.c:1079:7: warning: symbol 'index' shadows an earlier one
    arch/x86/kvm/x86.c:1000:9: originally declared here
    
    Make it static.
    arch/x86/kvm/x86.c:1945:24: warning: symbol 'emulate_ops' was not declared. Should it be static?
    
    Drop the return statements.
    arch/x86/kvm/x86.c:2878:2: warning: returning void-valued expression
    arch/x86/kvm/x86.c:2944:2: warning: returning void-valued expression
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 4866d5e3d59c7831c7fa117c246a39165817db0d
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Feb 19 10:32:02 2008 -0800

    KVM: SVM: make iopm_base static
    
    Fixes sparse warning as well.
    arch/x86/kvm/svm.c:69:15: warning: symbol 'iopm_base' was not declared. Should it be static?
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 77cd337f2246ae72915538383e8f5a6b7ffb363d
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Feb 19 10:43:11 2008 -0800

    KVM: x86 emulator: fix sparse warnings in x86_emulate.c
    
    Nesting __emulate_2op_nobyte inside__emulate_2op produces many shadowed
    variable warnings on the internal variable _tmp used by both macros.
    
    Change the outer macro to use __tmp.
    
    Avoids a sparse warning like the following at every call site of __emulate_2op
    arch/x86/kvm/x86_emulate.c:1091:3: warning: symbol '_tmp' shadows an earlier one
    arch/x86/kvm/x86_emulate.c:1091:3: originally declared here
    [18 more warnings suppressed]
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f11c3a8d84d7bf091bf963edd7104dd4ba6416c3
Author: Amit Shah <amit.shah@qumranet.com>
Date:   Thu Feb 21 01:00:30 2008 +0530

    KVM: Add stat counter for hypercalls
    
    Signed-off-by: Amit Shah <amit.shah@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a5f61300c489e334ddf99781a13a7f8d4b580781
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Feb 20 17:57:21 2008 +0200

    KVM: Use x86's segment descriptor struct instead of private definition
    
    The x86 desc_struct unification allows us to remove segment_descriptor.h.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ef2979bd98dac86ea6a4cd9bdd6820a466108017
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Feb 20 12:04:47 2008 +0200

    KVM: Increase the number of user memory slots per vm
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit a988b910ef816ed57e1cecbec14e98e906453f91
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Feb 20 11:59:20 2008 +0200

    KVM: Add API for determining the number of supported memory slots
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit edbe6c325da48e707a3b31310c5ff5783cf6c0be
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Feb 20 11:56:51 2008 +0200

    KVM: Increase vcpu count to 16
    
    With NPT support, scalability is much improved.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f725230af9ea03f6cc6f4a90e87aa428df46ec19
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Feb 20 11:53:16 2008 +0200

    KVM: Add API to retrieve the number of supported vcpus per vm
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7a95727567f0991751c2db774a110b4f8080de7f
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Feb 19 07:40:41 2008 -0800

    KVM: x86 emulator: make register_address_increment and JMP_REL static inlines
    
    Change jmp_rel() to a function as well.
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e4706772ea46e57cf69a7140c40063a21884c8e0
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Feb 19 07:40:38 2008 -0800

    KVM: x86 emulator: make register_address, address_mask static inlines
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit ddcb2885e2902ebfc422eccd763b02c5ee22d68b
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Feb 18 11:12:48 2008 -0800

    KVM: x86 emulator: add ad_mask static inline
    
    Replaces open-coded mask calculation in macros.
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 790c73f6289a204f858ffdcbe4a2b38e91657ec6
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Fri Feb 15 17:52:48 2008 -0200

    x86: KVM guest: paravirtualized clocksource
    
    This is the guest part of kvm clock implementation
    It does not do tsc-only timing, as tsc can have deltas
    between cpus, and it did not seem worthy to me to keep
    adjusting them.
    
    We do use it, however, for fine-grained adjustment.
    
    Other than that, time comes from the host.
    
    [randy dunlap: add missing include]
    [randy dunlap: disallow on Voyager or Visual WS]
    
    Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 18068523d3a0b41fcee5b53cdb437a0ab4d65e4b
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Fri Feb 15 17:52:47 2008 -0200

    KVM: paravirtualized clocksource: host part
    
    This is the host part of kvm clocksource implementation. As it does
    not include clockevents, it is a fairly simple implementation. We
    only have to register a per-vcpu area, and start writing to it periodically.
    
    The area is binary compatible with xen, as we use the same shadow_info
    structure.
    
    [marcelo: fix bad_page on MSR_KVM_SYSTEM_TIME]
    [avi: save full value of the msr, even if enable bit is clear]
    [avi: clear previous value of time_page]
    
    Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 24e09cbf480a72f9c952af4ca77b159503dca44b
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Feb 13 18:58:47 2008 +0100

    KVM: SVM: enable LBR virtualization
    
    This patch implements the Last Branch Record Virtualization (LBRV) feature of
    the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
    be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
    there is no increased world switch overhead when the guest doesn't use these
    MSRs.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f65c229c3e7743c6654c16b9ec6248466b5eef21
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Feb 13 18:58:46 2008 +0100

    KVM: SVM: allocate the MSR permission map per VCPU
    
    This patch changes the kvm-amd module to allocate the SVM MSR permission map
    per VCPU instead of a global map for all VCPUs. With this we have more
    flexibility allowing specific guests to access virtualized MSRs. This is
    required for LBR virtualization.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e6101a96c9efb74c98bba6322d4c5ea89e47e0fe
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Feb 13 18:58:45 2008 +0100

    KVM: SVM: let init_vmcb() take struct vcpu_svm as parameter
    
    Change the parameter of the init_vmcb() function in the kvm-amd module from
    struct vmcb to struct vcpu_svm.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2e11384c2c6f1ce662b1e5b05ba49b216a052f2a
Author: Ryan Harper <ryanh@us.ibm.com>
Date:   Mon Feb 11 10:26:38 2008 -0600

    KVM: VMX: fix typo in VMX header define
    
    Looking at Intel Volume 3b, page 148, table 20-11 and noticed
    that the field name is 'Deliver' not 'Deliever'.  Attached patch changes
    the define name and its user in vmx.c
    
    Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 709ddebf81cb40e3c36c6109a7892e8b93a09464
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:45 2008 +0100

    KVM: SVM: add support for Nested Paging
    
    This patch contains the SVM architecture dependent changes for KVM to enable
    support for the Nested Paging feature of AMD Barcelona and Phenom processors.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fb72d1674d860b0c9ef9b66b7f4f01fe5b3d2c00
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:44 2008 +0100

    KVM: MMU: add TDP support to the KVM MMU
    
    This patch contains the changes to the KVM MMU necessary for support of the
    Nested Paging feature in AMD Barcelona and Phenom Processors.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit cc4b6871e771e76dc1de06adb8aed261a1c66be8
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:43 2008 +0100

    KVM: export the load_pdptrs() function to modules
    
    The load_pdptrs() function is required in the SVM module for NPT support.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 4d9976bbdc09e08b69fc12fee2042c3528187b32
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:42 2008 +0100

    KVM: MMU: make the __nonpaging_map function generic
    
    The mapping function for the nonpaging case in the softmmu does basically the
    same as required for Nested Paging. Make this function generic so it can be
    used for both.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1855267210e1a8c9d41fe3a3c7a0d42eca5fb7cd
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:41 2008 +0100

    KVM: export information about NPT to generic x86 code
    
    The generic x86 code has to know if the specific implementation uses Nested
    Paging. In the generic code Nested Paging is called Two Dimensional Paging
    (TDP) to avoid confusion with (future) TDP implementations of other vendors.
    This patch exports the availability of TDP to the generic x86 code.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 6c7dac72d5c7dc0e09512dce865398167be9a8f7
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:40 2008 +0100

    KVM: SVM: add module parameter to disable Nested Paging
    
    To disable the use of the Nested Paging feature even if it is available in
    hardware this patch adds a module parameter. Nested Paging can be disabled by
    passing npt=0 to the kvm_amd module.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e3da3acdb32c1804a5c853feebcc037b7434076f
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:39 2008 +0100

    KVM: SVM: add detection of Nested Paging feature
    
    Let SVM detect if the Nested Paging feature is available on the hardware.
    Disable it to keep this patch series bisectable.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 33bd6a0b3e8baed6469c8e68ea1b16cb50c4f5af
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Feb 7 13:47:38 2008 +0100

    KVM: SVM: move feature detection to hardware setup code
    
    By moving the SVM feature detection from the each_cpu code to the hardware
    setup code it runs only once. As an additional advance the feature check is now
    available earlier in the module setup process.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 9457a712a2f464c4b21bb7f78998775c69673a0c
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jan 31 14:57:40 2008 +0100

    KVM: allow access to EFER in 32bit KVM
    
    This patch makes the EFER register accessible on a 32bit KVM host. This is
    necessary to boot 32 bit PAE guests under SVM.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 9f62e19a1107466b9e9501e23a9dd5acb81fdca1
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jan 31 14:57:39 2008 +0100

    KVM: VMX: unifdef the EFER specific code
    
    To allow access to the EFER register in 32bit KVM the EFER specific code has to
    be exported to the x86 generic code. This patch does this in a backwards
    compatible manner.
    
    [avi: add check for EFER-less hosts]
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 50a37eb4e05efaa7bac6a948fd4db1a48c728b99
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jan 31 14:57:38 2008 +0100

    KVM: align valid EFER bits with the features of the host system
    
    This patch aligns the bits the guest can set in the EFER register with the
    features in the host processor. Currently it lets EFER.NX disabled if the
    processor does not support it and enables EFER.LME and EFER.LMA only for KVM on
    64 bit hosts.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit f2b4b7ddf633ffa24ce7c89c9e0d8a06463484e3
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jan 31 14:57:37 2008 +0100

    KVM: make EFER_RESERVED_BITS configurable for architecture code
    
    This patch give the SVM and VMX implementations the ability to add some bits
    the guest can set in its EFER register.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 0aac03f07b37da96e00371e66973d5ffaae578a4
Author: Andrea Arcangeli <andrea@qumranet.com>
Date:   Wed Jan 30 19:57:35 2008 +0100

    KVM: Disable pagefaults during copy_from_user_inatomic()
    
    With CONFIG_PREEMPT=n, this is needed in order to disable the fault-in
    code from sleeping.
    
    Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 31bb117eb48f2629e030ca547ca89a1c34150183
Author: Hollis Blanchard <hollisb@us.ibm.com>
Date:   Mon Jan 28 17:42:34 2008 -0600

    KVM: Use CONFIG_PREEMPT_NOTIFIERS around struct preempt_notifier
    
    This allows kvm_host.h to be #included even when struct preempt_notifier is
    undefined. This is needed to build ppc asm-offsets.h.
    
    Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 2384d2b32640839a4d4d260ca7c5aa4edbf68d91
Author: Sheng Yang <sheng.yang@intel.com>
Date:   Thu Jan 17 15:14:33 2008 +0800

    KVM: VMX: Enable Virtual Processor Identification (VPID)
    
    To allow TLB entries to be retained across VM entry and VM exit, the VMM
    can now identify distinct address spaces through a new virtual-processor ID
    (VPID) field of the VMCS.
    
    [avi: drop vpid_sync_all()]
    [avi: add "cc" to asm constraints]
    
    Signed-off-by: Sheng Yang <sheng.yang@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit adb1ff46754a87f3f6c9e7ee0a92f9a8a183bb38
Author: Avi Kivity <avi@qumranet.com>
Date:   Thu Jan 24 15:13:08 2008 +0200

    KVM: Limit vcpu mmap size to one page on non-x86
    
    The second page is only needed on archs that support pio.
    
    Noted by Carsten Otte.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d196e343361c229496adeda42335856da9d057de
Author: Avi Kivity <avi@qumranet.com>
Date:   Thu Jan 24 11:44:11 2008 +0200

    KVM: MMU: Decouple mmio from shadow page tables
    
    Currently an mmio guest pte is encoded in the shadow pagetable as a
    not-present trapping pte, with the SHADOW_IO_MARK bit set.  However
    nothing is ever done with this information, so maintaining it is a
    useless complication.
    
    This patch moves the check for mmio to before shadow ptes are instantiated,
    so the shadow code is never invoked for ptes that reference mmio.  The code
    is simpler, and with future work, can be made to handle mmio concurrently.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1d6ad2073e5354912291277c606a57fd37330f04
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Jan 23 22:26:09 2008 +0200

    KVM: x86 emulator: group decoding for group 1 instructions
    
    Opcodes 0x80-0x83
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 09566765efd034feba45611f9d0ae9a702f8bb1d
Author: Avi Kivity <avi@qumranet.com>
Date:   Wed Jan 23 18:14:23 2008 +0200

    KVM: Only x86 has pio
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 5c5027425ec23ded452879ee5d0775a9a90fb9bf
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 22 20:46:14 2008 +0100

    KVM: constify function pointer tables
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit d95058a1a7170ae2af2939cbdab0ff5d5e005238
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jan 18 13:36:50 2008 +0200

    KVM: x86 emulator: add group 7 decoding
    
    This adds group decoding for opcode 0x0f 0x01 (group 7).
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit fd60754e4ffa992586346dd56451723b4c096626
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jan 18 13:12:26 2008 +0200

    KVM: x86 emulator: Group decoding for groups 4 and 5
    
    Add group decoding support for opcode 0xfe (group 4) and 0xff (group 5).
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 7d858a19efe5844a98e060931570359b70dea6d1
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jan 18 12:58:04 2008 +0200

    KVM: x86 emulator: Group decoding for group 3
    
    This adds group decoding support for opcodes 0xf6, 0xf7 (group 3).
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 43bb19cd3398d3f544d8e2d6ed6c5c5d7b4e5819
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jan 18 12:46:50 2008 +0200

    KVM: x86 emulator: group decoding for group 1A
    
    This adds group decode support for opcode 0x8f.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit e09d082c03e137015bc0a17ca77e4b9dca08a5d7
Author: Avi Kivity <avi@qumranet.com>
Date:   Fri Jan 18 12:38:59 2008 +0200

    KVM: x86 emulator: add support for group decoding
    
    Certain x86 instructions use bits 3:5 of the byte following the opcode as an
    opcode extension, with the decode sometimes depending on bits 6:7 as well.
    Add support for this in the main decoding table rather than an ad-hock
    adaptation per opcode.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 1ae0a13def678876b9acfb5ac1e2cf7d5d45a60d
Author: Dong, Eddie <eddie.dong@intel.com>
Date:   Mon Jan 7 13:20:25 2008 +0200

    KVM: MMU: Simplify hash table indexing
    
    Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 489f1d6526ab68ca1842398fa3ae95c597fe3d32
Author: Dong, Eddie <eddie.dong@intel.com>
Date:   Mon Jan 7 11:14:20 2008 +0200

    KVM: MMU: Update shadow ptes on partial guest pte writes
    
    A guest partial guest pte write will leave shadow_trap_nonpresent_pte
    in spte, which generates a vmexit at the next guest access through that pte.
    
    This patch improves this by reading the full guest pte in advance and thus
    being able to update the spte and eliminate the vmexit.
    
    This helps pae guests which use two 32-bit writes to set a single 64-bit pte.
    
    [truncation fix by Eric]
    
    Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
    Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

commit 20430214cc0073dc7e817b032e32ae2ae54b4911
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Sun Apr 27 00:10:11 2008 -0400

    Input: xpad - fix build failure
    
    If both CONFIG_JOYSTICK_XPAD_FF and CONFIG_JOYSTICK_XPAD_LEDS are unset
    xpad_bulk_out is not defined and build fails. Move it out of the #ifdef
    block so it is always defined.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

commit 7f424a8b08c26dc14ac5c17164014539ac9a5c65
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Apr 25 17:39:01 2008 +0200

    fix idle (arch, acpi and apm) and lockdep
    
    OK, so 25-mm1 gave a lockdep error which made me look into this.
    
    The first thing that I noticed was the horrible mess; the second thing I
    saw was hacks like: 71e93d15612c61c2e26a169567becf088e71b8ff
    
    The problem is that arch idle routines are somewhat inconsitent with
    their IRQ state handling and instead of fixing _that_, we go paper over
    the problem.
    
    So the thing I've tried to do is set a standard for idle routines and
    fix them all up to adhere to that. So the rules are:
    
      idle routines are entered with IRQs disabled
      idle routines will exit with IRQs enabled
    
    Nearly all already did this in one form or another.
    
    Merge the 32 and 64 bit bits so they no longer have different bugs.
    
    As for the actual lockdep warning; __sti_mwait() did a plainly un-annotated
    irq-enable.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Tested-by: Bob Copeland <me@bobcopeland.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

commit ed4d3c1061d6f367a4ef5e1656c25af3314fe2b7
Author: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Date:   Fri Apr 25 14:52:32 2008 -0700

    mlx4_core: Add helper to move QP to ready-to-send
    
    Avoid duplicating code in ethernet and FC modules.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 38ae6a535470b959df67ded6798fc542bb212e19
Author: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Date:   Fri Apr 25 14:27:08 2008 -0700

    mlx4_core: Add HW queues allocation helpers
    
    Wrap doorbell, buffer and MTT allocation in helper functions for
    ethernet and FC modules to use.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit e19166d5df10be0ea404c4e346cf6be93bfb1d63
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Apr 18 19:22:52 2008 -0400

    [SCSI] aha152x, eata, u14-34f: minor irq handler cleanups
    
    - remove pointless casts from void*
    
    - remove needless references to 'irq' function argument, when that
      information is already stored somewhere in a driver-private struct.
    
    - where the 'irq' function argument is known never to be used, rename
      it to 'dummy' to make this more obvious
    
    - remove always-false tests for dev_id==NULL
    
    - remove always-true tests for 'irq == host_struct->irq'
    
    - replace per-irq lookup functions and tables with a direct reference
      to data object obtained via 'dev_id' function argument, passed from
      request_irq()
    
    This change's main purpose is to prepare for the patchset in
    jgarzik/misc-2.6.git#irq-remove, that explores removal of the
    never-used 'irq' argument in each interrupt handler.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 8911c9e3343c647b59727b47b10feca7ee9ac9c3
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date:   Fri Apr 18 23:39:03 2008 +0400

    [SCSI] aic79xx: fix MMIO for PPC 44x platforms
    
    The driver stores the PCI resource address into 'u_long' variable before
    calling ioremap_nocache() on it. This warrants kernel oops when the registers
    are accessed on PPC 44x platforms which (being 32-bit) have PCI memory space
    mapped beyond 4 GB.
    
    The arch/ppc/ kernel has a fixup in ioremap() that helps create an illusion
    that the PCI memory resources are mapped below 4 GB, but arch/powerpc/ code
    got rid of this trick, having instead CONFIG_RESOURCES_64BIT enabled.
    
    Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 448504130f18bc9d8d10ba045775c906abd01438
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date:   Fri Apr 18 23:30:45 2008 +0400

    [SCSI] aic7xxx: fix MMIO for PPC 44x platforms
    
    The driver stores the PCI resource address into 'u_long' variable before
    calling ioremap_nocache() on it. This warrants kernel oops when the registers
    are accessed on PPC 44x platforms which (being 32-bit) have PCI memory space
    mapped beyond 4 GB.
    
    The arch/ppc/ kernel has a fixup in ioremap() that helps create an illusion
    that the PCI memory resources are mapped below 4 GB, but arch/powerpc/ code
    got rid of this trick, having instead CONFIG_RESOURCES_64BIT enabled.
    
    Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit be0d67680d524981dd65c661efe3c9cbd52a684f
Author: Denys Vlasenko <vda.linux@googlemail.com>
Date:   Sun Mar 23 04:41:22 2008 +0100

    [SCSI] aic7xxx, aic79xx: deinline functions
    
    Deinlines and moves big functions from .h to .c files.
    Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
    
    Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 31d1e340f0e8d53804d737571b2f2bb28a74ecc5
Author: Roland Dreier <rolandd@cisco.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    RDMA/nes: Remove volatile qualifier from struct nes_hw_cq.cq_vbase
    
    Remove the volatile qualifier from the cq_vbase member of struct
    nes_hw_cq, and add an rmb() in the one place where it looks like
    access order might make a difference.  As usual, removing a volatile
    qualifier in a declaration is actually a bug fix, since a volatile
    qualifier is not sufficient to make sure that aggressively
    out-of-order CPUs don't reorder things and cause incorrect results.
    
    For example, a CPU might speculatively execute reads of other cqe
    fields before the NIC hardware has written those fields and before it
    has set the NES_CQE_VALID bit (even though those reads come after the
    test of the NES_CQE_VALID bit in program order), but then when the CPU
    actually executes the conditional test of the NES_CQE_VALID, the bit
    has been set, and the CPU will proceed with the results of the earlier
    speculative execution and end up using bogus data.
    
    This also gets rid of the warning:
    
        drivers/infiniband/hw/nes/nes_verbs.c: In function 'nes_destroy_cq':
        drivers/infiniband/hw/nes/nes_verbs.c:1978: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit f5b3a096b138940f283907debe9bde6c6f40ebf3
Author: Vladimir Sokolovsky <vlad@mellanox.co.il>
Date:   Wed Apr 23 11:55:45 2008 -0700

    mlx4_core: CQ resizing should pass a 0 opcode modifier to MODIFY_CQ
    
    The call to mlx4_MODIFY_CQ() had a typo so that mlx4_cq_resize() was
    actually asking the FW to modify a CQ's interrupt moderation rather than
    asking it to resize a CQ.
    
    Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 6296883ca4cd52dafb45f191d24102e28ded38f2
Author: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Date:   Wed Apr 23 11:55:45 2008 -0700

    mlx4_core: Move kernel doorbell management into core
    
    In addition to mlx4_ib, there will be ethernet and FC consumers of
    mlx4_core, so move the code for managing kernel doorbells into the
    core module to avoid having to duplicate this multiple times.
    
    Signed-off-by: Yevgeny Petrilin <yevgenyp@mellanox.co.il>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 14fb05b3497351fbeb514381bcd227d84e115bd9
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IB/ehca: Bump version number to 0026
    
    Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 0455e36d81db76f5f4acb68a820da43adfa7ccec
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IB/ehca: Make some module parameters bool, update descriptions
    
    Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit a7607c9b1112b498c3044c9e5bc68fdb4985f93e
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IB/ehca: Remove mr_largepage parameter
    
    Always enable large page support; didn't seem to cause problems for anyone.
    
    Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 4da27d6d5b92c8fe4b3a3e5bcf42606d9e4a6fc8
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IB/ehca: Move high-volume debug output to higher debug levels
    
    Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 863fb09fbf1eb74f56ea02184a62165056aa29cb
Author: Joachim Fenkes <fenkes@de.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IB/ehca: Prevent posting of SQ WQEs if QP not in RTS
    
    ...as required by IB Spec, C10-29.
    
    Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit bc7b3a36ba02e4053ca38653e6a753082d9add03
Author: Shirley Ma <mashirle@us.ibm.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    IPoIB: Handle 4K IB MTU for UD (datagram) mode
    
    This patch enables IPoIB to use 4K UD messages (when the underlying
    device and fabrics support a 4K MTU) by using two scatter buffers when
    PAGE_SIZE is less than or equal to thhe HCA IB MTU size.  The first
    buffer is for IPoIB header + GRH header, and the second buffer is the
    IPoIB payload, which is 4K-4.
    
    Signed-off-by: Shirley Ma <xma@us.ibm.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit bc5698f3ecc9587e1edb343a2878f8d228c49e0e
Author: Chien Tung <ctung@neteffect.com>
Date:   Wed Apr 23 11:55:45 2008 -0700

    RDMA/nes: Fix adapter reset after PXE boot
    
    After PXE boot, the iw_nes driver does a full reset to ensure the card
    is in a clean state.  However, it doesn't wait for firmware to
    complete its work before issuing a port reset to enable the ports,
    which leads to problems bringing up the ports.
    
    The solution is to wait for firmware to complete its work before
    proceeding with port reset.
    
    This bug was flagged by Roland Dreier <rolandd@cisco.com>.
    
    Cc: <stable@kernel.org>
    Signed-off-by: Chien Tung <ctung@neteffect.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit e447703123d817b3f802c6eb69171d5342c8832e
Author: Roland Dreier <rolandd@cisco.com>
Date:   Wed Apr 23 11:55:43 2008 -0700

    RDMA/nes: Print IPv4 addresses in a readable format
    
    Use NIPQUAD_FMT instead of printing raw 32-bit hex quantities in
    debugging output.
    
    Acked-by: Glenn Streiff <gstreiff@neteffect.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 2bd01c5d2ed04838d50548cb7b955505a20ac0bd
Author: Roland Dreier <rolandd@cisco.com>
Date:   Wed Apr 23 11:52:18 2008 -0700

    RDMA/nes: Use print_mac() to format ethernet addresses for printing
    
    Removing open-coded MAC formats shrinks the source and the generated
    code too, eg on x86-64:
    
    add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-103 (-103)
    function                                     old     new   delta
    make_cm_node                                 932     912     -20
    nes_netdev_set_mac_address                   427     406     -21
    nes_netdev_set_multicast_list               1148    1124     -24
    nes_probe                                   2349    2311     -38
    
    Acked-by: Glenn Streiff <gstreiff@neteffect.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

commit 93c20a59af4624aedf53f8320606b355aa951bc1
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Sat Apr 19 00:43:15 2008 +0900

    [SCSI] scsi_transport_sas: fix the lifetime of sas bsg objects
    
    scsi_transport_sas calls blk_cleanup_queue too early for bsg
    queues. If a user holds a sas_host, end_device, or expander device
    open, remove the device, then send a request to it, we get a kernel
    crash. We need to call blk_cleanup_queue in the release callback as we
    do with scsi devices.
    
    This patch moves blk_cleanup_queue to sas_expander_release and
    sas_end_device_release from sas_bsg_remove. sas_host can't use the
    release callback in struct device so use bsg's release callback.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 97f46ae45c70857e459b7f8df1fc2807e7bd90a9
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Sat Apr 19 00:43:14 2008 +0900

    [SCSI] bsg: add release callback support
    
    This patch adds release callback support, which is called when a bsg
    device goes away. bsg_register_queue() takes a pointer to a callback
    function. This feature is useful for stuff like sas_host that can't
    use the release callback in struct device.
    
    If a caller doesn't need bsg's release callback, it can call
    bsg_register_queue() with NULL pointer (e.g. scsi devices can use
    release callback in struct device so they don't need bsg's callback).
    
    With this patch, bsg uses kref for refcounts on bsg devices instead of
    get/put_device in fops->open/release. bsg calls put_device and the
    caller's release callback (if it was registered) in kref_put's
    release.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 643eb2d932c97a0583381629d632d486934cf7ee
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 22 22:42:27 2008 -0500

    [SCSI] rework scsi_target allocation
    
    The current target allocation code registeres each possible target
    with sysfs; it will be deleted again if no useable LUN on this target
    was found. This results in a string of 'target add/target remove' uevents.
    
    Based on a patch by Hannes Reinecke <hare@suse.de> this patch reworks
    the target allocation code so that only uevents for existing targets
    are sent. The sysfs registration is split off from the existing
    scsi_target_alloc() into a in a new scsi_add_target() function, which
    should be called whenever an existing target is found. Only then a
    uevent is sent, so we'll be generating events for existing targets
    only.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit f7120a4f75168df3c02efacd10403a4ba0bcb29d
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Mar 18 14:32:28 2008 +0100

    [SCSI] use default attributes for scsi_host
    
    This patch removes the unused sysfs attibute overwriting logic for
    the scsi host attibutes, and plugs them into the driver core default
    attribute creation.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 352f6bb422bd31a80b4a0f1c3f19b6993df2508c
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Mar 20 20:57:02 2008 -0500

    [SCSI] scsi_transport_spi: fix the attribute settings
    
    We now take advantage of the mode_t return of is_valid, and also
    update the attributes when the target is configured.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 0f4238958d28044b335644b69df6071cdb04b5ce
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Mar 20 20:47:52 2008 -0500

    [SCSI] sysfs: make group is_valid return a mode_t
    
    We have a problem in scsi_transport_spi in that we need to customise
    not only the visibility of the attributes, but also their mode.  Fix
    this by making the is_visible() callback return a mode, with 0
    indicating is not visible.
    
    Also add a sysfs_update_group() API to allow us to change either the
    visibility or mode of the files at any time on the fly.
    
    Acked-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit bbd1ae412c9eb09ae7bb11cfaf7018a2367d493f
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Mar 18 14:32:28 2008 +0100

    [SCSI] qla2xxx, lfpc: Rename 'state' attribute to 'link_state'
    
    lpfc and qla2xxx overwrite the standard 'state' attribute with
    custom callbacks. So rename the custom attributes to 'link_state'
    and retain the original meaning of the 'state' attribute.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Acked-by: James Smart <James.Smart@Emulex.Com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit b0ed43360fdca227048d88a08290365cb681c1a8
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Mar 18 14:32:28 2008 +0100

    [SCSI] add scsi_host and scsi_target to scsi_bus
    
    This patch implements scsi_host and scsi_target device types
    and adds both to the scsi_bus.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit cb6b7f40630f94126233194847a86bf5501fb63c
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Mar 15 13:01:40 2008 -0500

    [SCSI] ses: fix up functionality after class_device->device conversion
    
    ses uses an unusual two level class hierarchy which broke in this
    conversion.  Fix it up still with a two level hierarchy, but this time
    let the ses device manage the links to and from the real device in the
    enclosure.
    
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 7d15d6a4dc08dfd456d834e33ef6c1d798fb2edc
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Mar 14 14:12:43 2008 -0700

    [SCSI] st: fix up after class_device removal
    
    There's a change in the SCSI tree that adds another class_device, so change
    it to an ordinary device
    
    [jejb: this one got rebased until it's basically cosmetic only]
    
    Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>



