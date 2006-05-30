From: Riccardo Magliocchetti <riccardo@datahost.it>
Subject: [PATCH] Move advansys.c documentation
Date: Tue, 30 May 2006 16:58:14 +0200
Message-ID: <20060530165814.8267e4a6.riccardo@datahost.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 85-18-122-240.ip.fastwebnet.it ([85.18.122.240]:34067 "EHLO
	mbox.puzzleworx.com") by vger.kernel.org with ESMTP id S932301AbWE3O4u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 10:56:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

this patch moves the documentation from advansys.c to
Documentation/scsi/ and updates 00-INDEX.

I've found a scsi card with this chip so I'm doing this in the hope that
someone code-wise is encouraged to fix the #warning :)

I'm not subscribed to the list, please cc me on reply.

Signed-off-by: Riccardo Magliocchetti <riccardo@datahost.it>

--

diff -ruN linux/Documentation/scsi/00-INDEX linux-advansys/Documentation/scsi/00-INDEX
--- linux/Documentation/scsi/00-INDEX	2006-05-30 12:59:15.000000000 +0200
+++ linux-advansys/Documentation/scsi/00-INDEX	2006-05-30 13:02:10.000000000 +0200
@@ -24,6 +24,8 @@
 	- info on driver for Mylex adapters
 NinjaSCSI.txt
 	- info on WorkBiT NinjaSCSI-32/32Bi driver
+advansys.txt
+	- info on driver for AdvanSys adapters
 aha152x.txt
 	- info on driver for Adaptec AHA152x based adapters
 aic7xxx.txt
diff -ruN linux/Documentation/scsi/advansys.txt linux-advansys/Documentation/scsi/advansys.txt
--- linux/Documentation/scsi/advansys.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-advansys/Documentation/scsi/advansys.txt	2006-05-30 13:06:49.000000000 +0200
@@ -0,0 +1,728 @@
+  Documentation for the AdvanSys Driver
+
+  A. Linux Kernels Supported by this Driver
+  B. Adapters Supported by this Driver
+  C. Linux source files modified by AdvanSys Driver
+  D. Source Comments
+  E. Driver Compile Time Options and Debugging
+  F. Driver LILO Option
+  G. Tests to run before releasing new driver
+  H. Release History
+  I. Known Problems/Fix List
+  J. Credits (Chronological Order)
+
+  A. Linux Kernels Supported by this Driver
+
+     This driver has been tested in the following Linux kernels: v2.2.18
+     v2.4.0. The driver is supported on v2.2 and v2.4 kernels and on x86,
+     alpha, and PowerPC platforms.
+
+  B. Adapters Supported by this Driver
+
+     AdvanSys (Advanced System Products, Inc.) manufactures the following
+     RISC-based, Bus-Mastering, Fast (10 Mhz) and Ultra (20 Mhz) Narrow
+     (8-bit transfer) SCSI Host Adapters for the ISA, EISA, VL, and PCI
+     buses and RISC-based, Bus-Mastering, Ultra (20 Mhz) Wide (16-bit
+     transfer) SCSI Host Adapters for the PCI bus.
+
+     The CDB counts below indicate the number of SCSI CDB (Command
+     Descriptor Block) requests that can be stored in the RISC chip
+     cache and board LRAM. A CDB is a single SCSI command. The driver
+     detect routine will display the number of CDBs available for each
+     adapter detected. The number of CDBs used by the driver can be
+     lowered in the BIOS by changing the 'Host Queue Size' adapter setting.
+
+     Laptop Products:
+        ABP-480 - Bus-Master CardBus (16 CDB) (2.4 kernel and greater)
+
+     Connectivity Products:
+        ABP510/5150 - Bus-Master ISA (240 CDB)
+        ABP5140 - Bus-Master ISA PnP (16 CDB)
+        ABP5142 - Bus-Master ISA PnP with floppy (16 CDB)
+        ABP902/3902 - Bus-Master PCI (16 CDB)
+        ABP3905 - Bus-Master PCI (16 CDB)
+        ABP915 - Bus-Master PCI (16 CDB)
+        ABP920 - Bus-Master PCI (16 CDB)
+        ABP3922 - Bus-Master PCI (16 CDB)
+        ABP3925 - Bus-Master PCI (16 CDB)
+        ABP930 - Bus-Master PCI (16 CDB)
+        ABP930U - Bus-Master PCI Ultra (16 CDB)
+        ABP930UA - Bus-Master PCI Ultra (16 CDB)
+        ABP960 - Bus-Master PCI MAC/PC (16 CDB)
+        ABP960U - Bus-Master PCI MAC/PC Ultra (16 CDB)
+
+     Single Channel Products:
+        ABP542 - Bus-Master ISA with floppy (240 CDB)
+        ABP742 - Bus-Master EISA (240 CDB)
+        ABP842 - Bus-Master VL (240 CDB)
+        ABP940 - Bus-Master PCI (240 CDB)
+        ABP940U - Bus-Master PCI Ultra (240 CDB)
+        ABP940UA/3940UA - Bus-Master PCI Ultra (240 CDB)
+        ABP970 - Bus-Master PCI MAC/PC (240 CDB)
+        ABP970U - Bus-Master PCI MAC/PC Ultra (240 CDB)
+        ABP3960UA - Bus-Master PCI MAC/PC Ultra (240 CDB)
+        ABP940UW/3940UW - Bus-Master PCI Ultra-Wide (253 CDB)
+        ABP970UW - Bus-Master PCI MAC/PC Ultra-Wide (253 CDB)
+        ABP3940U2W - Bus-Master PCI LVD/Ultra2-Wide (253 CDB)
+
+     Multi-Channel Products:
+        ABP752 - Dual Channel Bus-Master EISA (240 CDB Per Channel)
+        ABP852 - Dual Channel Bus-Master VL (240 CDB Per Channel)
+        ABP950 - Dual Channel Bus-Master PCI (240 CDB Per Channel)
+        ABP950UW - Dual Channel Bus-Master PCI Ultra-Wide (253 CDB Per Channel)
+        ABP980 - Four Channel Bus-Master PCI (240 CDB Per Channel)
+        ABP980U - Four Channel Bus-Master PCI Ultra (240 CDB Per Channel)
+        ABP980UA/3980UA - Four Channel Bus-Master PCI Ultra (16 CDB Per Chan.)
+        ABP3950U2W - Bus-Master PCI LVD/Ultra2-Wide and Ultra-Wide (253 CDB)
+        ABP3950U3W - Bus-Master PCI Dual LVD2/Ultra3-Wide (253 CDB)
+
+  C. Linux source files modified by AdvanSys Driver
+
+     This section for historical purposes documents the changes
+     originally made to the Linux kernel source to add the advansys
+     driver. As Linux has changed some of these files have also
+     been modified.
+
+     1. linux/arch/i386/config.in:
+
+          bool 'AdvanSys SCSI support' CONFIG_SCSI_ADVANSYS y
+
+     2. linux/drivers/scsi/hosts.c:
+
+          #ifdef CONFIG_SCSI_ADVANSYS
+          #include "advansys.h"
+          #endif
+
+        and after "static struct scsi_host_template builtin_scsi_hosts[] =":
+
+          #ifdef CONFIG_SCSI_ADVANSYS
+          ADVANSYS,
+          #endif
+
+     3. linux/drivers/scsi/Makefile:
+
+          ifdef CONFIG_SCSI_ADVANSYS
+          SCSI_SRCS := $(SCSI_SRCS) advansys.c
+          SCSI_OBJS := $(SCSI_OBJS) advansys.o
+          else
+          SCSI_MODULE_OBJS := $(SCSI_MODULE_OBJS) advansys.o
+          endif
+
+     4. linux/init/main.c:
+
+          extern void advansys_setup(char *str, int *ints);
+
+        and add the following lines to the bootsetups[] array.
+
+          #ifdef CONFIG_SCSI_ADVANSYS
+             { "advansys=", advansys_setup },
+          #endif
+
+  D. Source Comments
+
+     1. Use tab stops set to 4 for the source files. For vi use 'se tabstops=4'.
+
+     2. This driver should be maintained in multiple files. But to make
+        it easier to include with Linux and to follow Linux conventions,
+        the whole driver is maintained in the source files advansys.h and
+        advansys.c. In this file logical sections of the driver begin with
+        a comment that contains '---'. The following are the logical sections
+        of the driver below.
+
+           --- Linux Version
+           --- Linux Include File
+           --- Driver Options
+           --- Debugging Header
+           --- Asc Library Constants and Macros
+           --- Adv Library Constants and Macros
+           --- Driver Constants and Macros
+           --- Driver Structures
+           --- Driver Data
+           --- Driver Function Prototypes
+           --- Linux 'struct scsi_host_template' and advansys_setup() Functions
+           --- Loadable Driver Support
+           --- Miscellaneous Driver Functions
+           --- Functions Required by the Asc Library
+           --- Functions Required by the Adv Library
+           --- Tracing and Debugging Functions
+           --- Asc Library Functions
+           --- Adv Library Functions
+
+     3. The string 'XXX' is used to flag code that needs to be re-written
+        or that contains a problem that needs to be addressed.
+
+     4. I have stripped comments from and reformatted the source for the
+        Asc Library and Adv Library to reduce the size of this file. This
+        source can be found under the following headings. The Asc Library
+        is used to support Narrow Boards. The Adv Library is used to
+        support Wide Boards.
+
+           --- Asc Library Constants and Macros
+           --- Adv Library Constants and Macros
+           --- Asc Library Functions
+           --- Adv Library Functions
+
+  E. Driver Compile Time Options and Debugging
+
+     In this source file the following constants can be defined. They are
+     defined in the source below. Both of these options are enabled by
+     default.
+
+     1. ADVANSYS_ASSERT - Enable driver assertions (Def: Enabled)
+
+        Enabling this option adds assertion logic statements to the
+        driver. If an assertion fails a message will be displayed to
+        the console, but the system will continue to operate. Any
+        assertions encountered should be reported to the person
+        responsible for the driver. Assertion statements may proactively
+        detect problems with the driver and facilitate fixing these
+        problems. Enabling assertions will add a small overhead to the
+        execution of the driver.
+
+     2. ADVANSYS_DEBUG - Enable driver debugging (Def: Disabled)
+
+        Enabling this option adds tracing functions to the driver and
+        the ability to set a driver tracing level at boot time. This
+        option will also export symbols not required outside the driver to
+        the kernel name space. This option is very useful for debugging
+        the driver, but it will add to the size of the driver execution
+        image and add overhead to the execution of the driver.
+
+        The amount of debugging output can be controlled with the global
+        variable 'asc_dbglvl'. The higher the number the more output. By
+        default the debug level is 0.
+
+        If the driver is loaded at boot time and the LILO Driver Option
+        is included in the system, the debug level can be changed by
+        specifying a 5th (ASC_NUM_IOPORT_PROBE + 1) I/O Port. The
+        first three hex digits of the pseudo I/O Port must be set to
+        'deb' and the fourth hex digit specifies the debug level: 0 - F.
+        The following command line will look for an adapter at 0x330
+        and set the debug level to 2.
+
+           linux advansys=0x330,0,0,0,0xdeb2
+
+        If the driver is built as a loadable module this variable can be
+        defined when the driver is loaded. The following insmod command
+        will set the debug level to one.
+
+           insmod advansys.o asc_dbglvl=1
+
+        Debugging Message Levels:
+           0: Errors Only
+           1: High-Level Tracing
+           2-N: Verbose Tracing
+
+        To enable debug output to console, please make sure that:
+
+        a. System and kernel logging is enabled (syslogd, klogd running).
+        b. Kernel messages are routed to console output. Check
+           /etc/syslog.conf for an entry similar to this:
+
+                kern.*                  /dev/console
+
+        c. klogd is started with the appropriate -c parameter
+           (e.g. klogd -c 8)
+
+        This will cause printk() messages to be be displayed on the
+        current console. Refer to the klogd(8) and syslogd(8) man pages
+        for details.
+
+        Alternatively you can enable printk() to console with this
+        program. However, this is not the 'official' way to do this.
+        Debug output is logged in /var/log/messages.
+
+          main()
+          {
+                  syscall(103, 7, 0, 0);
+          }
+
+        Increasing LOG_BUF_LEN in kernel/printk.c to something like
+        40960 allows more debug messages to be buffered in the kernel
+        and written to the console or log file.
+
+     3. ADVANSYS_STATS - Enable statistics (Def: Enabled >= v1.3.0)
+
+        Enabling this option adds statistics collection and display
+        through /proc to the driver. The information is useful for
+        monitoring driver and device performance. It will add to the
+        size of the driver execution image and add minor overhead to
+        the execution of the driver.
+
+        Statistics are maintained on a per adapter basis. Driver entry
+        point call counts and transfer size counts are maintained.
+        Statistics are only available for kernels greater than or equal
+        to v1.3.0 with the CONFIG_PROC_FS (/proc) file system configured.
+
+        AdvanSys SCSI adapter files have the following path name format:
+
+           /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
+
+        This information can be displayed with cat. For example:
+
+           cat /proc/scsi/advansys/0
+
+        When ADVANSYS_STATS is not defined the AdvanSys /proc files only
+        contain adapter and device configuration information.
+
+  F. Driver LILO Option
+
+     If init/main.c is modified as described in the 'Directions for Adding
+     the AdvanSys Driver to Linux' section (B.4.) above, the driver will
+     recognize the 'advansys' LILO command line and /etc/lilo.conf option.
+     This option can be used to either disable I/O port scanning or to limit
+     scanning to 1 - 4 I/O ports. Regardless of the option setting EISA and
+     PCI boards will still be searched for and detected. This option only
+     affects searching for ISA and VL boards.
+
+     Examples:
+       1. Eliminate I/O port scanning:
+            boot: linux advansys=
+              or
+            boot: linux advansys=0x0
+       2. Limit I/O port scanning to one I/O port:
+            boot: linux advansys=0x110
+       3. Limit I/O port scanning to four I/O ports:
+            boot: linux advansys=0x110,0x210,0x230,0x330
+
+     For a loadable module the same effect can be achieved by setting
+     the 'asc_iopflag' variable and 'asc_ioport' array when loading
+     the driver, e.g.
+
+           insmod advansys.o asc_iopflag=1 asc_ioport=0x110,0x330
+
+     If ADVANSYS_DEBUG is defined a 5th (ASC_NUM_IOPORT_PROBE + 1)
+     I/O Port may be added to specify the driver debug level. Refer to
+     the 'Driver Compile Time Options and Debugging' section above for
+     more information.
+
+  G. Tests to run before releasing new driver
+
+     1. In the supported kernels verify there are no warning or compile
+        errors when the kernel is built as both a driver and as a module
+        and with the following options:
+
+        ADVANSYS_DEBUG - enabled and disabled
+        CONFIG_SMP - enabled and disabled
+        CONFIG_PROC_FS - enabled and disabled
+
+     2. Run tests on an x86, alpha, and PowerPC with at least one narrow
+        card and one wide card attached to a hard disk and CD-ROM drive:
+        fdisk, mkfs, fsck, bonnie, copy/compare test from the
+        CD-ROM to the hard drive.
+
+  H. Release History
+
+     BETA-1.0 (12/23/95):
+         First Release
+
+     BETA-1.1 (12/28/95):
+         1. Prevent advansys_detect() from being called twice.
+         2. Add LILO 0xdeb[0-f] option to set 'asc_dbglvl'.
+
+     1.2 (1/12/96):
+         1. Prevent re-entrancy in the interrupt handler which
+            resulted in the driver hanging Linux.
+         2. Fix problem that prevented ABP-940 cards from being
+            recognized on some PCI motherboards.
+         3. Add support for the ABP-5140 PnP ISA card.
+         4. Fix check condition return status.
+         5. Add conditionally compiled code for Linux v1.3.X.
+
+     1.3 (2/23/96):
+         1. Fix problem in advansys_biosparam() that resulted in the
+            wrong drive geometry being returned for drives > 1GB with
+            extended translation enabled.
+         2. Add additional tracing during device initialization.
+         3. Change code that only applies to ISA PnP adapter.
+         4. Eliminate 'make dep' warning.
+         5. Try to fix problem with handling resets by increasing their
+            timeout value.
+
+     1.4 (5/8/96):
+         1. Change definitions to eliminate conflicts with other subsystems.
+         2. Add versioning code for the shared interrupt changes.
+         3. Eliminate problem in asc_rmqueue() with iterating after removing
+            a request.
+         4. Remove reset request loop problem from the "Known Problems or
+            Issues" section. This problem was isolated and fixed in the
+            mid-level SCSI driver.
+
+     1.5 (8/8/96):
+         1. Add support for ABP-940U (PCI Ultra) adapter.
+         2. Add support for IRQ sharing by setting the SA_SHIRQ flag for
+            request_irq and supplying a dev_id pointer to both request_irq()
+            and free_irq().
+         3. In AscSearchIOPortAddr11() restore a call to check_region() which
+            should be used before I/O port probing.
+         4. Fix bug in asc_prt_hex() which resulted in the displaying
+            the wrong data.
+         5. Incorporate miscellaneous Asc Library bug fixes and new microcode.
+         6. Change driver versioning to be specific to each Linux sub-level.
+         7. Change statistics gathering to be per adapter instead of global
+            to the driver.
+         8. Add more information and statistics to the adapter /proc file:
+            /proc/scsi/advansys[0...].
+         9. Remove 'cmd_per_lun' from the "Known Problems or Issues" list.
+            This problem has been addressed with the SCSI mid-level changes
+            made in v1.3.89. The advansys_select_queue_depths() function
+            was added for the v1.3.89 changes.
+
+     1.6 (9/10/96):
+         1. Incorporate miscellaneous Asc Library bug fixes and new microcode.
+
+     1.7 (9/25/96):
+         1. Enable clustering and optimize the setting of the maximum number
+            of scatter gather elements for any particular board. Clustering
+            increases CPU utilization, but results in a relatively larger
+            increase in I/O throughput.
+         2. Improve the performance of the request queuing functions by
+            adding a last pointer to the queue structure.
+         3. Correct problems with reset and abort request handling that
+            could have hung or crashed Linux.
+         4. Add more information to the adapter /proc file:
+            /proc/scsi/advansys[0...].
+         5. Remove the request timeout issue form the driver issues list.
+         6. Miscellaneous documentation additions and changes.
+
+     1.8 (10/4/96):
+         1. Make changes to handle the new v2.1.0 kernel memory mapping
+            in which a kernel virtual address may not be equivalent to its
+            bus or DMA memory address.
+         2. Change abort and reset request handling to make it yet even
+            more robust.
+         3. Try to mitigate request starvation by sending ordered requests
+            to heavily loaded, tag queuing enabled devices.
+         4. Maintain statistics on request response time.
+         5. Add request response time statistics and other information to
+            the adapter /proc file: /proc/scsi/advansys[0...].
+
+     1.9 (10/21/96):
+         1. Add conditionally compiled code (ASC_QUEUE_FLOW_CONTROL) to
+            make use of mid-level SCSI driver device queue depth flow
+            control mechanism. This will eliminate aborts caused by a
+            device being unable to keep up with requests and eliminate
+            repeat busy or QUEUE FULL status returned by a device.
+         2. Incorporate miscellaneous Asc Library bug fixes.
+         3. To allow the driver to work in kernels with broken module
+            support set 'cmd_per_lun' if the driver is compiled as a
+            module. This change affects kernels v1.3.89 to present.
+         4. Remove PCI BIOS address from the driver banner. The PCI BIOS
+            is relocated by the motherboard BIOS and its new address can
+            not be determined by the driver.
+         5. Add mid-level SCSI queue depth information to the adapter
+            /proc file: /proc/scsi/advansys[0...].
+
+     2.0 (11/14/96):
+         1. Change allocation of global structures used for device
+            initialization to guarantee they are in DMA-able memory.
+            Previously when the driver was loaded as a module these
+            structures might not have been in DMA-able memory, causing
+            device initialization to fail.
+
+     2.1 (12/30/96):
+         1. In advansys_reset(), if the request is a synchronous reset
+            request, even if the request serial number has changed, then
+            complete the request.
+         2. Add Asc Library bug fixes including new microcode.
+         3. Clear inquiry buffer before using it.
+         4. Correct ifdef typo.
+
+     2.2 (1/15/97):
+         1. Add Asc Library bug fixes including new microcode.
+         2. Add synchronous data transfer rate information to the
+            adapter /proc file: /proc/scsi/advansys[0...].
+         3. Change ADVANSYS_DEBUG to be disabled by default. This
+            will reduce the size of the driver image, eliminate execution
+            overhead, and remove unneeded symbols from the kernel symbol
+            space that were previously added by the driver.
+         4. Add new compile-time option ADVANSYS_ASSERT for assertion
+            code that used to be defined within ADVANSYS_DEBUG. This
+            option is enabled by default.
+
+     2.8 (5/26/97):
+         1. Change version number to 2.8 to synchronize the Linux driver
+            version numbering with other AdvanSys drivers.
+         2. Reformat source files without tabs to present the same view
+            of the file to everyone regardless of the editor tab setting
+            being used.
+         3. Add Asc Library bug fixes.
+
+     3.1A (1/8/98):
+         1. Change version number to 3.1 to indicate that support for
+            Ultra-Wide adapters (ABP-940UW) is included in this release.
+         2. Add Asc Library (Narrow Board) bug fixes.
+         3. Report an underrun condition with the host status byte set
+            to DID_UNDERRUN. Currently DID_UNDERRUN is defined to 0 which
+            causes the underrun condition to be ignored. When Linux defines
+            its own DID_UNDERRUN the constant defined in this file can be
+            removed.
+         4. Add patch to AscWaitTixISRDone().
+         5. Add support for up to 16 different AdvanSys host adapter SCSI
+            channels in one system. This allows four cards with four channels
+            to be used in one system.
+
+     3.1B (1/9/98):
+         1. Handle that PCI register base addresses are not always page
+            aligned even though ioremap() requires that the address argument
+            be page aligned.
+
+     3.1C (1/10/98):
+         1. Update latest BIOS version checked for from the /proc file.
+         2. Don't set microcode SDTR variable at initialization. Instead
+            wait until device capabilities have been detected from an Inquiry
+            command.
+
+     3.1D (1/21/98):
+         1. Improve performance when the driver is compiled as module by
+            allowing up to 64 scatter-gather elements instead of 8.
+
+     3.1E (5/1/98):
+         1. Set time delay in AscWaitTixISRDone() to 1000 ms.
+         2. Include SMP locking changes.
+         3. For v2.1.93 and newer kernels use CONFIG_PCI and new PCI BIOS
+            access functions.
+         4. Update board serial number printing.
+         5. Try allocating an IRQ both with and without the SA_INTERRUPT
+            flag set to allow IRQ sharing with drivers that do not set
+            the SA_INTERRUPT flag. Also display a more descriptive error
+            message if request_irq() fails.
+         6. Update to latest Asc and Adv Libraries.
+
+     3.2A (7/22/99):
+         1. Update Adv Library to 4.16 which includes support for
+            the ASC38C0800 (Ultra2/LVD) IC.
+
+     3.2B (8/23/99):
+         1. Correct PCI compile time option for v2.1.93 and greater
+            kernels, advansys_info() string, and debug compile time
+            option.
+         2. Correct DvcSleepMilliSecond() for v2.1.0 and greater
+            kernels. This caused an LVD detection/BIST problem problem
+            among other things.
+         3. Sort PCI cards by PCI Bus, Slot, Function ascending order
+            to be consistent with the BIOS.
+         4. Update to Asc Library S121 and Adv Library 5.2.
+
+     3.2C (8/24/99):
+         1. Correct PCI card detection bug introduced in 3.2B that
+            prevented PCI cards from being detected in kernels older
+            than v2.1.93.
+
+     3.2D (8/26/99):
+         1. Correct /proc device synchronous speed information display.
+            Also when re-negotiation is pending for a target device
+            note this condition with an * and footnote.
+         2. Correct initialization problem with Ultra-Wide cards that
+            have a pre-3.2 BIOS. A microcode variable changed locations
+            in 3.2 and greater BIOSes which caused WDTR to be attempted
+            erroneously with drives that don't support WDTR.
+
+     3.2E (8/30/99):
+         1. Fix compile error caused by v2.3.13 PCI structure change.
+         2. Remove field from ASCEEP_CONFIG that resulted in an EEPROM
+            checksum error for ISA cards.
+         3. Remove ASC_QUEUE_FLOW_CONTROL conditional code. The mid-level
+            SCSI changes that it depended on were never included in Linux.
+
+     3.2F (9/3/99):
+         1. Handle new initial function code added in v2.3.16 for all
+            driver versions.
+
+     3.2G (9/8/99):
+         1. Fix PCI board detection in v2.3.13 and greater kernels.
+         2. Fix comiple errors in v2.3.X with debugging enabled.
+
+     3.2H (9/13/99):
+         1. Add 64-bit address, long support for Alpha and UltraSPARC.
+            The driver has been verified to work on an Alpha system.
+         2. Add partial byte order handling support for Power PC and
+            other big-endian platforms. This support has not yet been
+            completed or verified.
+         3. For wide boards replace block zeroing of request and
+            scatter-gather structures with individual field initialization
+            to improve performance.
+         4. Correct and clarify ROM BIOS version detection.
+
+     3.2I (10/8/99):
+         1. Update to Adv Library 5.4.
+         2. Add v2.3.19 underrun reporting to asc_isr_callback() and
+            adv_isr_callback().  Remove DID_UNDERRUN constant and other
+            no longer needed code that previously documented the lack
+            of underrun handling.
+
+     3.2J (10/14/99):
+         1. Eliminate compile errors for v2.0 and earlier kernels.
+
+     3.2K (11/15/99):
+         1. Correct debug compile error in asc_prt_adv_scsi_req_q().
+         2. Update Adv Library to 5.5.
+         3. Add ifdef handling for /proc changes added in v2.3.28.
+         4. Increase Wide board scatter-gather list maximum length to
+            255 when the driver is compiled into the kernel.
+
+     3.2L (11/18/99):
+         1. Fix bug in adv_get_sglist() that caused an assertion failure
+            at line 7475. The reqp->sgblkp pointer must be initialized
+            to NULL in adv_get_sglist().
+
+     3.2M (11/29/99):
+         1. Really fix bug in adv_get_sglist().
+         2. Incorporate v2.3.29 changes into driver.
+
+     3.2N (4/1/00):
+         1. Add CONFIG_ISA ifdef code.
+         2. Include advansys_interrupts_enabled name change patch.
+         3. For >= v2.3.28 use new SCSI error handling with new function
+            advansys_eh_bus_reset(). Don't include an abort function
+            because of base library limitations.
+         4. For >= v2.3.28 use per board lock instead of io_request_lock.
+         5. For >= v2.3.28 eliminate advansys_command() and
+            advansys_command_done().
+         6. Add some changes for PowerPC (Big Endian) support, but it isn't
+            working yet.
+         7. Fix "nonexistent resource free" problem that occurred on a module
+            unload for boards with an I/O space >= 255. The 'n_io_port' field
+            is only one byte and can not be used to hold an ioport length more
+            than 255.
+
+     3.3A (4/4/00):
+         1. Update to Adv Library 5.8.
+         2. For wide cards add support for CDBs up to 16 bytes.
+         3. Eliminate warnings when CONFIG_PROC_FS is not defined.
+
+     3.3B (5/1/00):
+         1. Support for PowerPC (Big Endian) wide cards. Narrow cards
+            still need work.
+         2. Change bitfields to shift and mask access for endian
+            portability.
+
+     3.3C (10/13/00):
+         1. Update for latest 2.4 kernel.
+         2. Test ABP-480 CardBus support in 2.4 kernel - works!
+         3. Update to Asc Library S123.
+         4. Update to Adv Library 5.12.
+
+     3.3D (11/22/00):
+         1. Update for latest 2.4 kernel.
+         2. Create patches for 2.2 and 2.4 kernels.
+
+     3.3E (1/9/01):
+         1. Now that 2.4 is released remove ifdef code for kernel versions
+            less than 2.2. The driver is now only supported in kernels 2.2,
+            2.4, and greater.
+         2. Add code to release and acquire the io_request_lock in
+            the driver entrypoint functions: advansys_detect and
+            advansys_queuecommand. In kernel 2.4 the SCSI mid-level driver
+            still holds the io_request_lock on entry to SCSI low-level drivers.
+            This was supposed to be removed before 2.4 was released but never
+            happened. When the mid-level SCSI driver is changed all references
+            to the io_request_lock should be removed from the driver.
+         3. Simplify error handling by removing advansys_abort(),
+            AscAbortSRB(), AscResetDevice(). SCSI bus reset requests are
+            now handled by resetting the SCSI bus and fully re-initializing
+            the chip. This simple method of error recovery has proven to work
+            most reliably after attempts at different methods. Also now only
+            support the "new" error handling method and remove the obsolete
+            error handling interface.
+         4. Fix debug build errors.
+
+     3.3F (1/24/01):
+         1. Merge with ConnectCom version from Andy Kellner which
+            updates Adv Library to 5.14.
+         2. Make PowerPC (Big Endian) work for narrow cards and
+            fix problems writing EEPROM for wide cards.
+         3. Remove interrupts_enabled assertion function.
+
+     3.3G (2/16/01):
+         1. Return an error from narrow boards if passed a 16 byte
+            CDB. The wide board can already handle 16 byte CDBs.
+
+     3.3GJ (4/15/02):
+	 1. hacks for lk 2.5 series (D. Gilbert)
+
+     3.3GJD (10/14/02):
+         1. change select_queue_depths to slave_configure
+	 2. make cmd_per_lun be sane again
+
+     3.3K [2004/06/24]:
+         1. continuing cleanup for lk 2.6 series
+         2. Fix problem in lk 2.6.7-bk2 that broke PCI wide cards
+         3. Fix problem that oopsed ISA cards
+
+  I. Known Problems/Fix List (XXX)
+
+     1. Need to add memory mapping workaround. Test the memory mapping.
+        If it doesn't work revert to I/O port access. Can a test be done
+        safely?
+     2. Handle an interrupt not working. Keep an interrupt counter in
+        the interrupt handler. In the timeout function if the interrupt
+        has not occurred then print a message and run in polled mode.
+     3. Allow bus type scanning order to be changed.
+     4. Need to add support for target mode commands, cf. CAM XPT.
+
+  J. Credits (Chronological Order)
+
+     Bob Frey <bfrey@turbolinux.com.cn> wrote the AdvanSys SCSI driver
+     and maintained it up to 3.3F. He continues to answer questions
+     and help maintain the driver.
+
+     Nathan Hartwell <mage@cdc3.cdc.net> provided the directions and
+     basis for the Linux v1.3.X changes which were included in the
+     1.2 release.
+
+     Thomas E Zerucha <zerucha@shell.portal.com> pointed out a bug
+     in advansys_biosparam() which was fixed in the 1.3 release.
+
+     Erik Ratcliffe <erik@caldera.com> has done testing of the
+     AdvanSys driver in the Caldera releases.
+
+     Rik van Riel <H.H.vanRiel@fys.ruu.nl> provided a patch to
+     AscWaitTixISRDone() which he found necessary to make the
+     driver work with a SCSI-1 disk.
+
+     Mark Moran <mmoran@mmoran.com> has helped test Ultra-Wide
+     support in the 3.1A driver.
+
+     Doug Gilbert <dgilbert@interlog.com> has made changes and
+     suggestions to improve the driver and done a lot of testing.
+
+     Ken Mort <ken@mort.net> reported a DEBUG compile bug fixed
+     in 3.2K.
+
+     Tom Rini <trini@kernel.crashing.org> provided the CONFIG_ISA
+     patch and helped with PowerPC wide and narrow board support.
+
+     Philip Blundell <philb@gnu.org> provided an
+     advansys_interrupts_enabled patch.
+
+     Dave Jones <dave@denial.force9.co.uk> reported the compiler
+     warnings generated when CONFIG_PROC_FS was not defined in
+     the 3.2M driver.
+
+     Jerry Quinn <jlquinn@us.ibm.com> fixed PowerPC support (endian
+     problems) for wide cards.
+
+     Bryan Henderson <bryanh@giraffe-data.com> helped debug narrow
+     card error handling.
+
+     Manuel Veloso <veloso@pobox.com> worked hard on PowerPC narrow
+     board support and fixed a bug in AscGetEEPConfig().
+
+     Arnaldo Carvalho de Melo <acme@conectiva.com.br> made
+     save_flags/restore_flags changes.
+
+     Andy Kellner <AKellner@connectcom.net> continues the Advansys SCSI
+     driver development for ConnectCom (Version > 3.3F).
+
+  K. ConnectCom (AdvanSys) Contact Information
+
+     Mail:                   ConnectCom Solutions, Inc.
+                             1150 Ringwood Court
+                             San Jose, CA 95131
+     Operator/Sales:         1-408-383-9400
+     FAX:                    1-408-383-9612
+     Tech Support:           1-408-467-2930
+     Tech Support E-Mail:    linux@connectcom.net
+     FTP Site:               ftp.connectcom.net (login: anonymous)
+     Web Site:               http://www.connectcom.net
diff -ruN linux/drivers/scsi/advansys.c linux-advansys/drivers/scsi/advansys.c
--- linux/drivers/scsi/advansys.c	2006-05-30 12:57:18.000000000 +0200
+++ linux-advansys/drivers/scsi/advansys.c	2006-05-30 13:08:26.000000000 +0200
@@ -18,739 +18,6 @@
  */
 
 /*
-
-  Documentation for the AdvanSys Driver
-
-  A. Linux Kernels Supported by this Driver
-  B. Adapters Supported by this Driver
-  C. Linux source files modified by AdvanSys Driver
-  D. Source Comments
-  E. Driver Compile Time Options and Debugging
-  F. Driver LILO Option
-  G. Tests to run before releasing new driver
-  H. Release History
-  I. Known Problems/Fix List
-  J. Credits (Chronological Order)
-
-  A. Linux Kernels Supported by this Driver
-
-     This driver has been tested in the following Linux kernels: v2.2.18
-     v2.4.0. The driver is supported on v2.2 and v2.4 kernels and on x86,
-     alpha, and PowerPC platforms.
-
-  B. Adapters Supported by this Driver
-
-     AdvanSys (Advanced System Products, Inc.) manufactures the following
-     RISC-based, Bus-Mastering, Fast (10 Mhz) and Ultra (20 Mhz) Narrow
-     (8-bit transfer) SCSI Host Adapters for the ISA, EISA, VL, and PCI
-     buses and RISC-based, Bus-Mastering, Ultra (20 Mhz) Wide (16-bit
-     transfer) SCSI Host Adapters for the PCI bus.
-
-     The CDB counts below indicate the number of SCSI CDB (Command
-     Descriptor Block) requests that can be stored in the RISC chip
-     cache and board LRAM. A CDB is a single SCSI command. The driver
-     detect routine will display the number of CDBs available for each
-     adapter detected. The number of CDBs used by the driver can be
-     lowered in the BIOS by changing the 'Host Queue Size' adapter setting.
-
-     Laptop Products:
-        ABP-480 - Bus-Master CardBus (16 CDB) (2.4 kernel and greater)
-
-     Connectivity Products:
-        ABP510/5150 - Bus-Master ISA (240 CDB)
-        ABP5140 - Bus-Master ISA PnP (16 CDB)
-        ABP5142 - Bus-Master ISA PnP with floppy (16 CDB)
-        ABP902/3902 - Bus-Master PCI (16 CDB)
-        ABP3905 - Bus-Master PCI (16 CDB)
-        ABP915 - Bus-Master PCI (16 CDB)
-        ABP920 - Bus-Master PCI (16 CDB)
-        ABP3922 - Bus-Master PCI (16 CDB)
-        ABP3925 - Bus-Master PCI (16 CDB)
-        ABP930 - Bus-Master PCI (16 CDB)
-        ABP930U - Bus-Master PCI Ultra (16 CDB)
-        ABP930UA - Bus-Master PCI Ultra (16 CDB)
-        ABP960 - Bus-Master PCI MAC/PC (16 CDB)
-        ABP960U - Bus-Master PCI MAC/PC Ultra (16 CDB)
-
-     Single Channel Products:
-        ABP542 - Bus-Master ISA with floppy (240 CDB)
-        ABP742 - Bus-Master EISA (240 CDB)
-        ABP842 - Bus-Master VL (240 CDB)
-        ABP940 - Bus-Master PCI (240 CDB)
-        ABP940U - Bus-Master PCI Ultra (240 CDB)
-        ABP940UA/3940UA - Bus-Master PCI Ultra (240 CDB)
-        ABP970 - Bus-Master PCI MAC/PC (240 CDB)
-        ABP970U - Bus-Master PCI MAC/PC Ultra (240 CDB)
-        ABP3960UA - Bus-Master PCI MAC/PC Ultra (240 CDB)
-        ABP940UW/3940UW - Bus-Master PCI Ultra-Wide (253 CDB)
-        ABP970UW - Bus-Master PCI MAC/PC Ultra-Wide (253 CDB)
-        ABP3940U2W - Bus-Master PCI LVD/Ultra2-Wide (253 CDB)
-
-     Multi-Channel Products:
-        ABP752 - Dual Channel Bus-Master EISA (240 CDB Per Channel)
-        ABP852 - Dual Channel Bus-Master VL (240 CDB Per Channel)
-        ABP950 - Dual Channel Bus-Master PCI (240 CDB Per Channel)
-        ABP950UW - Dual Channel Bus-Master PCI Ultra-Wide (253 CDB Per Channel)
-        ABP980 - Four Channel Bus-Master PCI (240 CDB Per Channel)
-        ABP980U - Four Channel Bus-Master PCI Ultra (240 CDB Per Channel)
-        ABP980UA/3980UA - Four Channel Bus-Master PCI Ultra (16 CDB Per Chan.)
-        ABP3950U2W - Bus-Master PCI LVD/Ultra2-Wide and Ultra-Wide (253 CDB)
-        ABP3950U3W - Bus-Master PCI Dual LVD2/Ultra3-Wide (253 CDB)
-
-  C. Linux source files modified by AdvanSys Driver
-
-     This section for historical purposes documents the changes
-     originally made to the Linux kernel source to add the advansys
-     driver. As Linux has changed some of these files have also
-     been modified.
-
-     1. linux/arch/i386/config.in:
-
-          bool 'AdvanSys SCSI support' CONFIG_SCSI_ADVANSYS y
-
-     2. linux/drivers/scsi/hosts.c:
-
-          #ifdef CONFIG_SCSI_ADVANSYS
-          #include "advansys.h"
-          #endif
-
-        and after "static struct scsi_host_template builtin_scsi_hosts[] =":
-
-          #ifdef CONFIG_SCSI_ADVANSYS
-          ADVANSYS,
-          #endif
-
-     3. linux/drivers/scsi/Makefile:
-
-          ifdef CONFIG_SCSI_ADVANSYS
-          SCSI_SRCS := $(SCSI_SRCS) advansys.c
-          SCSI_OBJS := $(SCSI_OBJS) advansys.o
-          else
-          SCSI_MODULE_OBJS := $(SCSI_MODULE_OBJS) advansys.o
-          endif
-
-     4. linux/init/main.c:
-
-          extern void advansys_setup(char *str, int *ints);
-
-        and add the following lines to the bootsetups[] array.
-
-          #ifdef CONFIG_SCSI_ADVANSYS
-             { "advansys=", advansys_setup },
-          #endif
-
-  D. Source Comments
-
-     1. Use tab stops set to 4 for the source files. For vi use 'se tabstops=4'.
-
-     2. This driver should be maintained in multiple files. But to make
-        it easier to include with Linux and to follow Linux conventions,
-        the whole driver is maintained in the source files advansys.h and
-        advansys.c. In this file logical sections of the driver begin with
-        a comment that contains '---'. The following are the logical sections
-        of the driver below.
-
-           --- Linux Version
-           --- Linux Include File
-           --- Driver Options
-           --- Debugging Header
-           --- Asc Library Constants and Macros
-           --- Adv Library Constants and Macros
-           --- Driver Constants and Macros
-           --- Driver Structures
-           --- Driver Data
-           --- Driver Function Prototypes
-           --- Linux 'struct scsi_host_template' and advansys_setup() Functions
-           --- Loadable Driver Support
-           --- Miscellaneous Driver Functions
-           --- Functions Required by the Asc Library
-           --- Functions Required by the Adv Library
-           --- Tracing and Debugging Functions
-           --- Asc Library Functions
-           --- Adv Library Functions
-
-     3. The string 'XXX' is used to flag code that needs to be re-written
-        or that contains a problem that needs to be addressed.
-
-     4. I have stripped comments from and reformatted the source for the
-        Asc Library and Adv Library to reduce the size of this file. This
-        source can be found under the following headings. The Asc Library
-        is used to support Narrow Boards. The Adv Library is used to
-        support Wide Boards.
-
-           --- Asc Library Constants and Macros
-           --- Adv Library Constants and Macros
-           --- Asc Library Functions
-           --- Adv Library Functions
-
-  E. Driver Compile Time Options and Debugging
-
-     In this source file the following constants can be defined. They are
-     defined in the source below. Both of these options are enabled by
-     default.
-
-     1. ADVANSYS_ASSERT - Enable driver assertions (Def: Enabled)
-
-        Enabling this option adds assertion logic statements to the
-        driver. If an assertion fails a message will be displayed to
-        the console, but the system will continue to operate. Any
-        assertions encountered should be reported to the person
-        responsible for the driver. Assertion statements may proactively
-        detect problems with the driver and facilitate fixing these
-        problems. Enabling assertions will add a small overhead to the
-        execution of the driver.
-
-     2. ADVANSYS_DEBUG - Enable driver debugging (Def: Disabled)
-
-        Enabling this option adds tracing functions to the driver and
-        the ability to set a driver tracing level at boot time. This
-        option will also export symbols not required outside the driver to
-        the kernel name space. This option is very useful for debugging
-        the driver, but it will add to the size of the driver execution
-        image and add overhead to the execution of the driver.
-
-        The amount of debugging output can be controlled with the global
-        variable 'asc_dbglvl'. The higher the number the more output. By
-        default the debug level is 0.
-
-        If the driver is loaded at boot time and the LILO Driver Option
-        is included in the system, the debug level can be changed by
-        specifying a 5th (ASC_NUM_IOPORT_PROBE + 1) I/O Port. The
-        first three hex digits of the pseudo I/O Port must be set to
-        'deb' and the fourth hex digit specifies the debug level: 0 - F.
-        The following command line will look for an adapter at 0x330
-        and set the debug level to 2.
-
-           linux advansys=0x330,0,0,0,0xdeb2
-
-        If the driver is built as a loadable module this variable can be
-        defined when the driver is loaded. The following insmod command
-        will set the debug level to one.
-
-           insmod advansys.o asc_dbglvl=1
-
-        Debugging Message Levels:
-           0: Errors Only
-           1: High-Level Tracing
-           2-N: Verbose Tracing
-
-        To enable debug output to console, please make sure that:
-
-        a. System and kernel logging is enabled (syslogd, klogd running).
-        b. Kernel messages are routed to console output. Check
-           /etc/syslog.conf for an entry similar to this:
-
-                kern.*                  /dev/console
-
-        c. klogd is started with the appropriate -c parameter
-           (e.g. klogd -c 8)
-
-        This will cause printk() messages to be be displayed on the
-        current console. Refer to the klogd(8) and syslogd(8) man pages
-        for details.
-
-        Alternatively you can enable printk() to console with this
-        program. However, this is not the 'official' way to do this.
-        Debug output is logged in /var/log/messages.
-
-          main()
-          {
-                  syscall(103, 7, 0, 0);
-          }
-
-        Increasing LOG_BUF_LEN in kernel/printk.c to something like
-        40960 allows more debug messages to be buffered in the kernel
-        and written to the console or log file.
-
-     3. ADVANSYS_STATS - Enable statistics (Def: Enabled >= v1.3.0)
-
-        Enabling this option adds statistics collection and display
-        through /proc to the driver. The information is useful for
-        monitoring driver and device performance. It will add to the
-        size of the driver execution image and add minor overhead to
-        the execution of the driver.
-
-        Statistics are maintained on a per adapter basis. Driver entry
-        point call counts and transfer size counts are maintained.
-        Statistics are only available for kernels greater than or equal
-        to v1.3.0 with the CONFIG_PROC_FS (/proc) file system configured.
-
-        AdvanSys SCSI adapter files have the following path name format:
-
-           /proc/scsi/advansys/[0-(ASC_NUM_BOARD_SUPPORTED-1)]
-
-        This information can be displayed with cat. For example:
-
-           cat /proc/scsi/advansys/0
-
-        When ADVANSYS_STATS is not defined the AdvanSys /proc files only
-        contain adapter and device configuration information.
-
-  F. Driver LILO Option
-
-     If init/main.c is modified as described in the 'Directions for Adding
-     the AdvanSys Driver to Linux' section (B.4.) above, the driver will
-     recognize the 'advansys' LILO command line and /etc/lilo.conf option.
-     This option can be used to either disable I/O port scanning or to limit
-     scanning to 1 - 4 I/O ports. Regardless of the option setting EISA and
-     PCI boards will still be searched for and detected. This option only
-     affects searching for ISA and VL boards.
-
-     Examples:
-       1. Eliminate I/O port scanning:
-            boot: linux advansys=
-              or
-            boot: linux advansys=0x0
-       2. Limit I/O port scanning to one I/O port:
-            boot: linux advansys=0x110
-       3. Limit I/O port scanning to four I/O ports:
-            boot: linux advansys=0x110,0x210,0x230,0x330
-
-     For a loadable module the same effect can be achieved by setting
-     the 'asc_iopflag' variable and 'asc_ioport' array when loading
-     the driver, e.g.
-
-           insmod advansys.o asc_iopflag=1 asc_ioport=0x110,0x330
-
-     If ADVANSYS_DEBUG is defined a 5th (ASC_NUM_IOPORT_PROBE + 1)
-     I/O Port may be added to specify the driver debug level. Refer to
-     the 'Driver Compile Time Options and Debugging' section above for
-     more information.
-
-  G. Tests to run before releasing new driver
-
-     1. In the supported kernels verify there are no warning or compile
-        errors when the kernel is built as both a driver and as a module
-        and with the following options:
-
-        ADVANSYS_DEBUG - enabled and disabled
-        CONFIG_SMP - enabled and disabled
-        CONFIG_PROC_FS - enabled and disabled
-
-     2. Run tests on an x86, alpha, and PowerPC with at least one narrow
-        card and one wide card attached to a hard disk and CD-ROM drive:
-        fdisk, mkfs, fsck, bonnie, copy/compare test from the
-        CD-ROM to the hard drive.
-
-  H. Release History
-
-     BETA-1.0 (12/23/95):
-         First Release
-
-     BETA-1.1 (12/28/95):
-         1. Prevent advansys_detect() from being called twice.
-         2. Add LILO 0xdeb[0-f] option to set 'asc_dbglvl'.
-
-     1.2 (1/12/96):
-         1. Prevent re-entrancy in the interrupt handler which
-            resulted in the driver hanging Linux.
-         2. Fix problem that prevented ABP-940 cards from being
-            recognized on some PCI motherboards.
-         3. Add support for the ABP-5140 PnP ISA card.
-         4. Fix check condition return status.
-         5. Add conditionally compiled code for Linux v1.3.X.
-
-     1.3 (2/23/96):
-         1. Fix problem in advansys_biosparam() that resulted in the
-            wrong drive geometry being returned for drives > 1GB with
-            extended translation enabled.
-         2. Add additional tracing during device initialization.
-         3. Change code that only applies to ISA PnP adapter.
-         4. Eliminate 'make dep' warning.
-         5. Try to fix problem with handling resets by increasing their
-            timeout value.
-
-     1.4 (5/8/96):
-         1. Change definitions to eliminate conflicts with other subsystems.
-         2. Add versioning code for the shared interrupt changes.
-         3. Eliminate problem in asc_rmqueue() with iterating after removing
-            a request.
-         4. Remove reset request loop problem from the "Known Problems or
-            Issues" section. This problem was isolated and fixed in the
-            mid-level SCSI driver.
-
-     1.5 (8/8/96):
-         1. Add support for ABP-940U (PCI Ultra) adapter.
-         2. Add support for IRQ sharing by setting the SA_SHIRQ flag for
-            request_irq and supplying a dev_id pointer to both request_irq()
-            and free_irq().
-         3. In AscSearchIOPortAddr11() restore a call to check_region() which
-            should be used before I/O port probing.
-         4. Fix bug in asc_prt_hex() which resulted in the displaying
-            the wrong data.
-         5. Incorporate miscellaneous Asc Library bug fixes and new microcode.
-         6. Change driver versioning to be specific to each Linux sub-level.
-         7. Change statistics gathering to be per adapter instead of global
-            to the driver.
-         8. Add more information and statistics to the adapter /proc file:
-            /proc/scsi/advansys[0...].
-         9. Remove 'cmd_per_lun' from the "Known Problems or Issues" list.
-            This problem has been addressed with the SCSI mid-level changes
-            made in v1.3.89. The advansys_select_queue_depths() function
-            was added for the v1.3.89 changes.
-
-     1.6 (9/10/96):
-         1. Incorporate miscellaneous Asc Library bug fixes and new microcode.
-
-     1.7 (9/25/96):
-         1. Enable clustering and optimize the setting of the maximum number
-            of scatter gather elements for any particular board. Clustering
-            increases CPU utilization, but results in a relatively larger
-            increase in I/O throughput.
-         2. Improve the performance of the request queuing functions by
-            adding a last pointer to the queue structure.
-         3. Correct problems with reset and abort request handling that
-            could have hung or crashed Linux.
-         4. Add more information to the adapter /proc file:
-            /proc/scsi/advansys[0...].
-         5. Remove the request timeout issue form the driver issues list.
-         6. Miscellaneous documentation additions and changes.
-
-     1.8 (10/4/96):
-         1. Make changes to handle the new v2.1.0 kernel memory mapping
-            in which a kernel virtual address may not be equivalent to its
-            bus or DMA memory address.
-         2. Change abort and reset request handling to make it yet even
-            more robust.
-         3. Try to mitigate request starvation by sending ordered requests
-            to heavily loaded, tag queuing enabled devices.
-         4. Maintain statistics on request response time.
-         5. Add request response time statistics and other information to
-            the adapter /proc file: /proc/scsi/advansys[0...].
-
-     1.9 (10/21/96):
-         1. Add conditionally compiled code (ASC_QUEUE_FLOW_CONTROL) to
-            make use of mid-level SCSI driver device queue depth flow
-            control mechanism. This will eliminate aborts caused by a
-            device being unable to keep up with requests and eliminate
-            repeat busy or QUEUE FULL status returned by a device.
-         2. Incorporate miscellaneous Asc Library bug fixes.
-         3. To allow the driver to work in kernels with broken module
-            support set 'cmd_per_lun' if the driver is compiled as a
-            module. This change affects kernels v1.3.89 to present.
-         4. Remove PCI BIOS address from the driver banner. The PCI BIOS
-            is relocated by the motherboard BIOS and its new address can
-            not be determined by the driver.
-         5. Add mid-level SCSI queue depth information to the adapter
-            /proc file: /proc/scsi/advansys[0...].
-
-     2.0 (11/14/96):
-         1. Change allocation of global structures used for device
-            initialization to guarantee they are in DMA-able memory.
-            Previously when the driver was loaded as a module these
-            structures might not have been in DMA-able memory, causing
-            device initialization to fail.
-
-     2.1 (12/30/96):
-         1. In advansys_reset(), if the request is a synchronous reset
-            request, even if the request serial number has changed, then
-            complete the request.
-         2. Add Asc Library bug fixes including new microcode.
-         3. Clear inquiry buffer before using it.
-         4. Correct ifdef typo.
-
-     2.2 (1/15/97):
-         1. Add Asc Library bug fixes including new microcode.
-         2. Add synchronous data transfer rate information to the
-            adapter /proc file: /proc/scsi/advansys[0...].
-         3. Change ADVANSYS_DEBUG to be disabled by default. This
-            will reduce the size of the driver image, eliminate execution
-            overhead, and remove unneeded symbols from the kernel symbol
-            space that were previously added by the driver.
-         4. Add new compile-time option ADVANSYS_ASSERT for assertion
-            code that used to be defined within ADVANSYS_DEBUG. This
-            option is enabled by default.
-
-     2.8 (5/26/97):
-         1. Change version number to 2.8 to synchronize the Linux driver
-            version numbering with other AdvanSys drivers.
-         2. Reformat source files without tabs to present the same view
-            of the file to everyone regardless of the editor tab setting
-            being used.
-         3. Add Asc Library bug fixes.
-
-     3.1A (1/8/98):
-         1. Change version number to 3.1 to indicate that support for
-            Ultra-Wide adapters (ABP-940UW) is included in this release.
-         2. Add Asc Library (Narrow Board) bug fixes.
-         3. Report an underrun condition with the host status byte set
-            to DID_UNDERRUN. Currently DID_UNDERRUN is defined to 0 which
-            causes the underrun condition to be ignored. When Linux defines
-            its own DID_UNDERRUN the constant defined in this file can be
-            removed.
-         4. Add patch to AscWaitTixISRDone().
-         5. Add support for up to 16 different AdvanSys host adapter SCSI
-            channels in one system. This allows four cards with four channels
-            to be used in one system.
-
-     3.1B (1/9/98):
-         1. Handle that PCI register base addresses are not always page
-            aligned even though ioremap() requires that the address argument
-            be page aligned.
-
-     3.1C (1/10/98):
-         1. Update latest BIOS version checked for from the /proc file.
-         2. Don't set microcode SDTR variable at initialization. Instead
-            wait until device capabilities have been detected from an Inquiry
-            command.
-
-     3.1D (1/21/98):
-         1. Improve performance when the driver is compiled as module by
-            allowing up to 64 scatter-gather elements instead of 8.
-
-     3.1E (5/1/98):
-         1. Set time delay in AscWaitTixISRDone() to 1000 ms.
-         2. Include SMP locking changes.
-         3. For v2.1.93 and newer kernels use CONFIG_PCI and new PCI BIOS
-            access functions.
-         4. Update board serial number printing.
-         5. Try allocating an IRQ both with and without the SA_INTERRUPT
-            flag set to allow IRQ sharing with drivers that do not set
-            the SA_INTERRUPT flag. Also display a more descriptive error
-            message if request_irq() fails.
-         6. Update to latest Asc and Adv Libraries.
-
-     3.2A (7/22/99):
-         1. Update Adv Library to 4.16 which includes support for
-            the ASC38C0800 (Ultra2/LVD) IC.
-
-     3.2B (8/23/99):
-         1. Correct PCI compile time option for v2.1.93 and greater
-            kernels, advansys_info() string, and debug compile time
-            option.
-         2. Correct DvcSleepMilliSecond() for v2.1.0 and greater
-            kernels. This caused an LVD detection/BIST problem problem
-            among other things.
-         3. Sort PCI cards by PCI Bus, Slot, Function ascending order
-            to be consistent with the BIOS.
-         4. Update to Asc Library S121 and Adv Library 5.2.
-
-     3.2C (8/24/99):
-         1. Correct PCI card detection bug introduced in 3.2B that
-            prevented PCI cards from being detected in kernels older
-            than v2.1.93.
-
-     3.2D (8/26/99):
-         1. Correct /proc device synchronous speed information display.
-            Also when re-negotiation is pending for a target device
-            note this condition with an * and footnote.
-         2. Correct initialization problem with Ultra-Wide cards that
-            have a pre-3.2 BIOS. A microcode variable changed locations
-            in 3.2 and greater BIOSes which caused WDTR to be attempted
-            erroneously with drives that don't support WDTR.
-
-     3.2E (8/30/99):
-         1. Fix compile error caused by v2.3.13 PCI structure change.
-         2. Remove field from ASCEEP_CONFIG that resulted in an EEPROM
-            checksum error for ISA cards.
-         3. Remove ASC_QUEUE_FLOW_CONTROL conditional code. The mid-level
-            SCSI changes that it depended on were never included in Linux.
-
-     3.2F (9/3/99):
-         1. Handle new initial function code added in v2.3.16 for all
-            driver versions.
-
-     3.2G (9/8/99):
-         1. Fix PCI board detection in v2.3.13 and greater kernels.
-         2. Fix comiple errors in v2.3.X with debugging enabled.
-
-     3.2H (9/13/99):
-         1. Add 64-bit address, long support for Alpha and UltraSPARC.
-            The driver has been verified to work on an Alpha system.
-         2. Add partial byte order handling support for Power PC and
-            other big-endian platforms. This support has not yet been
-            completed or verified.
-         3. For wide boards replace block zeroing of request and
-            scatter-gather structures with individual field initialization
-            to improve performance.
-         4. Correct and clarify ROM BIOS version detection.
-
-     3.2I (10/8/99):
-         1. Update to Adv Library 5.4.
-         2. Add v2.3.19 underrun reporting to asc_isr_callback() and
-            adv_isr_callback().  Remove DID_UNDERRUN constant and other
-            no longer needed code that previously documented the lack
-            of underrun handling.
-
-     3.2J (10/14/99):
-         1. Eliminate compile errors for v2.0 and earlier kernels.
-
-     3.2K (11/15/99):
-         1. Correct debug compile error in asc_prt_adv_scsi_req_q().
-         2. Update Adv Library to 5.5.
-         3. Add ifdef handling for /proc changes added in v2.3.28.
-         4. Increase Wide board scatter-gather list maximum length to
-            255 when the driver is compiled into the kernel.
-
-     3.2L (11/18/99):
-         1. Fix bug in adv_get_sglist() that caused an assertion failure
-            at line 7475. The reqp->sgblkp pointer must be initialized
-            to NULL in adv_get_sglist().
-
-     3.2M (11/29/99):
-         1. Really fix bug in adv_get_sglist().
-         2. Incorporate v2.3.29 changes into driver.
-
-     3.2N (4/1/00):
-         1. Add CONFIG_ISA ifdef code.
-         2. Include advansys_interrupts_enabled name change patch.
-         3. For >= v2.3.28 use new SCSI error handling with new function
-            advansys_eh_bus_reset(). Don't include an abort function
-            because of base library limitations.
-         4. For >= v2.3.28 use per board lock instead of io_request_lock.
-         5. For >= v2.3.28 eliminate advansys_command() and
-            advansys_command_done().
-         6. Add some changes for PowerPC (Big Endian) support, but it isn't
-            working yet.
-         7. Fix "nonexistent resource free" problem that occurred on a module
-            unload for boards with an I/O space >= 255. The 'n_io_port' field
-            is only one byte and can not be used to hold an ioport length more
-            than 255.
-
-     3.3A (4/4/00):
-         1. Update to Adv Library 5.8.
-         2. For wide cards add support for CDBs up to 16 bytes.
-         3. Eliminate warnings when CONFIG_PROC_FS is not defined.
-
-     3.3B (5/1/00):
-         1. Support for PowerPC (Big Endian) wide cards. Narrow cards
-            still need work.
-         2. Change bitfields to shift and mask access for endian
-            portability.
-
-     3.3C (10/13/00):
-         1. Update for latest 2.4 kernel.
-         2. Test ABP-480 CardBus support in 2.4 kernel - works!
-         3. Update to Asc Library S123.
-         4. Update to Adv Library 5.12.
-
-     3.3D (11/22/00):
-         1. Update for latest 2.4 kernel.
-         2. Create patches for 2.2 and 2.4 kernels.
-
-     3.3E (1/9/01):
-         1. Now that 2.4 is released remove ifdef code for kernel versions
-            less than 2.2. The driver is now only supported in kernels 2.2,
-            2.4, and greater.
-         2. Add code to release and acquire the io_request_lock in
-            the driver entrypoint functions: advansys_detect and
-            advansys_queuecommand. In kernel 2.4 the SCSI mid-level driver
-            still holds the io_request_lock on entry to SCSI low-level drivers.
-            This was supposed to be removed before 2.4 was released but never
-            happened. When the mid-level SCSI driver is changed all references
-            to the io_request_lock should be removed from the driver.
-         3. Simplify error handling by removing advansys_abort(),
-            AscAbortSRB(), AscResetDevice(). SCSI bus reset requests are
-            now handled by resetting the SCSI bus and fully re-initializing
-            the chip. This simple method of error recovery has proven to work
-            most reliably after attempts at different methods. Also now only
-            support the "new" error handling method and remove the obsolete
-            error handling interface.
-         4. Fix debug build errors.
-
-     3.3F (1/24/01):
-         1. Merge with ConnectCom version from Andy Kellner which
-            updates Adv Library to 5.14.
-         2. Make PowerPC (Big Endian) work for narrow cards and
-            fix problems writing EEPROM for wide cards.
-         3. Remove interrupts_enabled assertion function.
-
-     3.3G (2/16/01):
-         1. Return an error from narrow boards if passed a 16 byte
-            CDB. The wide board can already handle 16 byte CDBs.
-
-     3.3GJ (4/15/02):
-	 1. hacks for lk 2.5 series (D. Gilbert)
-
-     3.3GJD (10/14/02):
-         1. change select_queue_depths to slave_configure
-	 2. make cmd_per_lun be sane again
-
-     3.3K [2004/06/24]:
-         1. continuing cleanup for lk 2.6 series
-         2. Fix problem in lk 2.6.7-bk2 that broke PCI wide cards
-         3. Fix problem that oopsed ISA cards
-
-  I. Known Problems/Fix List (XXX)
-
-     1. Need to add memory mapping workaround. Test the memory mapping.
-        If it doesn't work revert to I/O port access. Can a test be done
-        safely?
-     2. Handle an interrupt not working. Keep an interrupt counter in
-        the interrupt handler. In the timeout function if the interrupt
-        has not occurred then print a message and run in polled mode.
-     3. Allow bus type scanning order to be changed.
-     4. Need to add support for target mode commands, cf. CAM XPT.
-
-  J. Credits (Chronological Order)
-
-     Bob Frey <bfrey@turbolinux.com.cn> wrote the AdvanSys SCSI driver
-     and maintained it up to 3.3F. He continues to answer questions
-     and help maintain the driver.
-
-     Nathan Hartwell <mage@cdc3.cdc.net> provided the directions and
-     basis for the Linux v1.3.X changes which were included in the
-     1.2 release.
-
-     Thomas E Zerucha <zerucha@shell.portal.com> pointed out a bug
-     in advansys_biosparam() which was fixed in the 1.3 release.
-
-     Erik Ratcliffe <erik@caldera.com> has done testing of the
-     AdvanSys driver in the Caldera releases.
-
-     Rik van Riel <H.H.vanRiel@fys.ruu.nl> provided a patch to
-     AscWaitTixISRDone() which he found necessary to make the
-     driver work with a SCSI-1 disk.
-
-     Mark Moran <mmoran@mmoran.com> has helped test Ultra-Wide
-     support in the 3.1A driver.
-
-     Doug Gilbert <dgilbert@interlog.com> has made changes and
-     suggestions to improve the driver and done a lot of testing.
-
-     Ken Mort <ken@mort.net> reported a DEBUG compile bug fixed
-     in 3.2K.
-
-     Tom Rini <trini@kernel.crashing.org> provided the CONFIG_ISA
-     patch and helped with PowerPC wide and narrow board support.
-
-     Philip Blundell <philb@gnu.org> provided an
-     advansys_interrupts_enabled patch.
-
-     Dave Jones <dave@denial.force9.co.uk> reported the compiler
-     warnings generated when CONFIG_PROC_FS was not defined in
-     the 3.2M driver.
-
-     Jerry Quinn <jlquinn@us.ibm.com> fixed PowerPC support (endian
-     problems) for wide cards.
-
-     Bryan Henderson <bryanh@giraffe-data.com> helped debug narrow
-     card error handling.
-
-     Manuel Veloso <veloso@pobox.com> worked hard on PowerPC narrow
-     board support and fixed a bug in AscGetEEPConfig().
-
-     Arnaldo Carvalho de Melo <acme@conectiva.com.br> made
-     save_flags/restore_flags changes.
-
-     Andy Kellner <AKellner@connectcom.net> continues the Advansys SCSI
-     driver development for ConnectCom (Version > 3.3F).
-
-  K. ConnectCom (AdvanSys) Contact Information
-
-     Mail:                   ConnectCom Solutions, Inc.
-                             1150 Ringwood Court
-                             San Jose, CA 95131
-     Operator/Sales:         1-408-383-9400
-     FAX:                    1-408-383-9612
-     Tech Support:           1-408-467-2930
-     Tech Support E-Mail:    linux@connectcom.net
-     FTP Site:               ftp.connectcom.net (login: anonymous)
-     Web Site:               http://www.connectcom.net
-
-*/
-
-/*
  * --- Linux Include Files
  */
 

