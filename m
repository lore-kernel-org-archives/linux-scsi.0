From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT RFC] isci: direction check (2.6.39)
Date: Tue, 26 Apr 2011 18:25:04 -0700
Message-ID: <1303867504.24953.181.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1D0BKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 21:10:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

James,

Here is a rundown of where the driver is at relative to a 2.6.39 merge
candidate and the outstanding review comments.

=== Status ===
1/ From Christoph: "unify core/lldd objects and remove glue code".  This
has been done for the remote_device representation with the following
commits.
      isci: make a remote_node_context a proper member of a remote_device
      isci: remove rnc->device back pointer
      isci: unify remote_device data structures
      isci: move remote_device handling out of the core
      isci: cleanup remote device construction and comments
      isci: kill smp_discover_response_protocols in favor of domain_device.dev_type
      isci: kill smp_discover_response
      isci: remove usage of sci_sas_address in scic_sds_remote_device
The full diffs from these last three commits are included below to
illustrate the resulting glue code that has been deleted.  Repeating
this level of unification across the other objects is in progress.

For 2.6.39 we have stopped short of a full rename of all the objects
while the other cleanups are pending.  I am assuming that as long as the
bulk cleanup is in place (diffstat clean i.e. no more
drivers/scsi/isci/core/ and the object lifetimes are unified) that
further fine grained cleanups can take place post merge?  See the
diffstat below to check the direction of this effort.

2/ From Christoph: "cleanup state machines".  The scic_sds_controller
state machine has been through the full gamut of cleanups and it is a
matter of repeating the same template (from the commits below) across
the other state machines.

8e131f53 isci: controller state machine cleanup step1
ba647271 isci: controller state machine cleanup step2
03355704 isci: controller state machine cleanup step3
13ca34a2 isci: remove base_controller abstraction
74b59773 isci: remove scic_controller state handlers

3/ From you: "no changes outside of drivers/scsi/isci/".  I have
reverted the tree's local copy of the pci_map_biosrom implementation
that is pending in the x86 maintainer tree [1].  So a git diff --stat
linus... shows only modifications in drivers/scsi/isci/
drivers/scsi/Makefile and drivers/scsi/Kconfig.

The x86-pending branch has the merge with tip.git and the patch to
re-introduce its usage in the driver post 2.6.39.

4/ From the beginning: "Remove the intel_{sas|sata|scsi.h} headers".
This is still in progress and is partially addressed by the unification
work.  We have found that there are some definitions that the driver
needs that do not exist in include/scsi/.  For those we will include a
local definition with a note to move them to their proper location post
merge.

5/ Miscellaneous, "remove timer list abstraction", "sci_base_object
removal" and other minor cleanups are still in the works.

=== Issues that the review has not covered to date ===
1/ The driver's abort/error handling and task lifetime.  This has likely
been blocked behind review of the overall driver structure.  At this
point it is looking like a post 2.6.39 effort.

2/ A libsas gap around reset handling.  We are currently seeing sas
drives in a software raid array drop off because domain discovery after
a device reset finds the device missing before it recovers from the
reset.  We have a fix that can be localized to the driver but that is
likely a layering violation.  From our determination libsas should be
filtering broadcast change notifications while resets are pending (I'll
send more details in a separate thread).  For now this workaround is not
included in the git tree.

3/ The status of the commits on the libsas-pending branch
      libsas: flush initial device discovery before completing ->scan_finished()
      libsas: fix/amend device gone notification in sas_deform_port()
      libsas: check dev->gone before submitting sata i/o
I'll plan to resend for 2.6.40.

The isci git tree has been updated with the following (since the last
announcement [2])

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Bartosz Barcinski (2):
      isci: sparse warnings cleanup
      isci: audit usage of BUG_ON macro in isci driver

Christoph Hellwig (2):
      isci: simplify dma coherent allocation
      isci: remove scic_controller state handlers

Dan Williams (16):
      isci: replace sci_sas_link_rate with sas_linkrate
      isci: fix oem parameter header definition
      isci: validate oem parameters early, and fallback
      isci: rely on irq core for intx multiplexing, and silence screaming intx
      isci: make a remote_node_context a proper member of a remote_device
      isci: remove rnc->device back pointer
      isci: unify remote_device data structures
      isci: move remote_device handling out of the core
      isci: cleanup remote device construction and comments
      isci: kill smp_discover_response_protocols in favor of domain_device.dev_type
      isci: kill smp_discover_response
      isci: remove usage of sci_sas_address in scic_sds_remote_device
      isci: remove scic_sds_remote_device_get_port_index
      isci: allow fallback to option-rom if efi variable retrieval fails
      isci: defer pci_map_biosrom
      isci: fix CONFIG_EFI=n compile error

Dave Jiang (3):
      isci: replace this_* and the_* variables with more meaningful names
      isci: removing non-working ATAPI code
      isci: Remove excessive log noise with expander hot-unplug

Maciej Trela (3):
      isci: remove base_remote_device abstraction
      isci: remove base_port abstraction
      isci: remove base_phy abstraction

 drivers/scsi/isci/Makefile                         |   14 +-
 drivers/scsi/isci/core/intel_sas.h                 |  211 ---
 drivers/scsi/isci/core/sati_device.h               |  156 --
 drivers/scsi/isci/core/sati_translator_sequence.h  |  304 ----
 drivers/scsi/isci/core/sati_types.h                |  145 --
 .../isci/core/sci_base_memory_descriptor_list.c    |  159 --
 .../isci/core/sci_base_memory_descriptor_list.h    |  153 --
 drivers/scsi/isci/core/sci_base_phy.h              |  200 ---
 drivers/scsi/isci/core/sci_base_port.h             |  187 ---
 drivers/scsi/isci/core/sci_base_remote_device.h    |  274 ----
 .../scsi/isci/core/sci_memory_descriptor_list.h    |  168 --
 drivers/scsi/isci/core/sci_pool.h                  |   60 +-
 drivers/scsi/isci/core/scic_config_parameters.h    |    2 +
 drivers/scsi/isci/core/scic_controller.h           |    8 +-
 drivers/scsi/isci/core/scic_phy.h                  |    3 +-
 drivers/scsi/isci/core/scic_remote_device.h        |  294 ----
 drivers/scsi/isci/core/scic_sds_controller.c       | 1629 ++++++-------------
 drivers/scsi/isci/core/scic_sds_controller.h       |  175 +--
 drivers/scsi/isci/core/scic_sds_phy.c              |  720 ++++----
 drivers/scsi/isci/core/scic_sds_phy.h              |   94 +-
 drivers/scsi/isci/core/scic_sds_port.c             |  764 ++++-----
 drivers/scsi/isci/core/scic_sds_port.h             |  231 ++--
 .../isci/core/scic_sds_port_configuration_agent.c  |    2 +-
 drivers/scsi/isci/core/scic_sds_remote_device.c    | 1714 --------------------
 drivers/scsi/isci/core/scic_sds_remote_device.h    |  548 -------
 drivers/scsi/isci/core/scic_sds_request.c          |  251 ++--
 drivers/scsi/isci/core/scic_sds_request.h          |   40 +-
 drivers/scsi/isci/core/scic_sds_smp_request.c      |  132 +-
 drivers/scsi/isci/core/scic_sds_smp_request.h      |    3 +-
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |   30 +-
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |  806 ---------
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |   39 -
 drivers/scsi/isci/core/scic_sds_stp_request.c      |  387 +++---
 drivers/scsi/isci/core/scic_sds_stp_request.h      |    8 +-
 .../isci/core/scic_sds_unsolicited_frame_control.c |   66 +-
 .../isci/core/scic_sds_unsolicited_frame_control.h |   22 +-
 drivers/scsi/isci/host.c                           |  127 +--
 drivers/scsi/isci/host.h                           |   21 +-
 drivers/scsi/isci/init.c                           |   42 +-
 drivers/scsi/isci/port.c                           |    2 +-
 drivers/scsi/isci/port.h                           |    1 +
 drivers/scsi/isci/probe_roms.c                     |   31 +-
 drivers/scsi/isci/probe_roms.h                     |    2 +-
 drivers/scsi/isci/remote_device.c                  | 1655 +++++++++++++++++--
 drivers/scsi/isci/remote_device.h                  |  688 ++++++++-
 ...remote_node_context.c => remote_node_context.c} |  479 +++---
 ...remote_node_context.h => remote_node_context.h} |   31 +-
 ...sds_remote_node_table.c => remote_node_table.c} |    4 +-
 ...sds_remote_node_table.h => remote_node_table.h} |    0
 drivers/scsi/isci/request.c                        |   33 +-
 drivers/scsi/isci/request.h                        |    5 +-
 drivers/scsi/isci/sata.c                           |    3 +-
 .../scsi/isci/{core => }/scu_remote_node_context.h |    0
 ...sds_smp_remote_device.c => smp_remote_device.c} |  120 +-
 ...sds_stp_remote_device.c => stp_remote_device.c} |  377 ++---
 drivers/scsi/isci/task.c                           |   77 +-
 56 files changed, 4601 insertions(+), 9096 deletions(-)
 delete mode 100644 drivers/scsi/isci/core/sati_device.h
 delete mode 100644 drivers/scsi/isci/core/sati_translator_sequence.h
 delete mode 100644 drivers/scsi/isci/core/sati_types.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
 delete mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_phy.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_port.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_remote_device.h
 delete mode 100644 drivers/scsi/isci/core/sci_memory_descriptor_list.h
 delete mode 100644 drivers/scsi/isci/core/scic_remote_device.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.c
 rename drivers/scsi/isci/{core/scic_sds_remote_node_context.c => remote_node_context.c} (71%)
 rename drivers/scsi/isci/{core/scic_sds_remote_node_context.h => remote_node_context.h} (92%)
 rename drivers/scsi/isci/{core/scic_sds_remote_node_table.c => remote_node_table.c} (99%)
 rename drivers/scsi/isci/{core/scic_sds_remote_node_table.h => remote_node_table.h} (100%)
 rename drivers/scsi/isci/{core => }/scu_remote_node_context.h (100%)
 rename drivers/scsi/isci/{core/scic_sds_smp_remote_device.c => smp_remote_device.c} (69%)
 rename drivers/scsi/isci/{core/scic_sds_stp_remote_device.c => stp_remote_device.c} (62%)

commit 2db162f22e4176baa0a9ae20932178ddb5550050
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Apr 2 08:15:04 2011 -0400

    isci: simplify dma coherent allocation
    
    Remove the insane infrastructure for preallocating coheren DMA regions,
    and just allocate the memory where needed.  This also gets rid of the
    aligment adjustments given that Documentation/DMA-API-HOWTO.txt sais:
    
      "The cpu return address and the DMA bus master address are both
       guaranteed to be aligned to the smallest PAGE_SIZE order which
       is greater than or equal to the requested size.  This invariant
       exists (for example) to guarantee that if you allocate a chunk
       which is smaller than or equal to 64 kilobytes, the extent of the
       buffer you receive will not cross a 64K boundary."
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    [djbw: moved allocation from start to init, re-add memset]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 74b597736d5792690b6953c51d72e3c7d29c2313
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Apr 2 08:15:20 2011 -0400

    isci: remove scic_controller state handlers
    
    Remove the state handler indirections for the scic_controller, and replace
    them with procedural calls that check for the correct state first.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2c4302dce071ff3b1e5e1f4e168cd66a97d4c7ff
Author: Maciej Trela <maciej.trela@intel.com>
Date:   Tue Apr 12 17:28:35 2011 -0700

    isci: remove base_remote_device abstraction
    
    Merge struct sci_base_remote_device into scic_sds_remote_device.  As for
    now sci_base_remote_device was accessed indirectly using
    scic_sds_remote_device->parent field.  Both machine state handlers are
    also merged together.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Maciej Trela <Maciej.Trela@intel.com>
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2ac7e0116df9aa5e8cf2b834c096c2f11c82c10d
Author: Maciej Trela <maciej.trela@intel.com>
Date:   Tue Apr 12 17:28:37 2011 -0700

    isci: remove base_port abstraction
    
    Merge struct sci_base_port into scic_sds_port.  Until now sci_base_port
    was referenced indirectly with scic_sds_port->parent field.
    
    'sci_base_port' state machine handlers were also incorporated into
    scic_sds_port handlers.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Maciej Trela <Maciej.Trela@intel.com>
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f32e3000c55b826e5268afe978a31f5eac50f2e3
Author: Maciej Trela <maciej.trela@intel.com>
Date:   Tue Apr 12 17:28:39 2011 -0700

    isci: remove base_phy abstraction
    
    Merge struct sci_base_phy into scic_sds_phy.  Until now sci_base_phy was
    referenced using scic_sds_phy->parent field.
    
    'sci_base_phy' state machine handlers were also merged into scic_sds_phy
    state handlers.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Maciej Trela <Maciej.Trela@intel.com>
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d71288553c9da16524bd3cbe8bb388678e2c8302
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 14 18:27:49 2011 -0700

    isci: replace sci_sas_link_rate with sas_linkrate
    
    Drop duplicated enum definition.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6a0340c1bca8f396531653b43bc55b38bd58b491
Author: Bartosz Barcinski <Bartosz.Barcinski@intel.com>
Date:   Tue Apr 12 17:28:41 2011 -0700

    isci: sparse warnings cleanup
    
    Clean warnings and errors reported by sparse tool.
    
    request.c:430:50: warning: mixing different enum types
    remote_device.c:534:39: warning: symbol 'flags' shadows an earlier one
    task.c:495:44: warning: mixing different enum types
    scic_sds_controller.c:2155:24: warning: mixing different enum types
    scic_sds_controller.c:2272:36: warning: mixing different enum types
    scic_sds_controller.c:2911:38: warning: incorrect type in initializer (different address spaces)
    scic_sds_controller.c:2913:25: warning: incorrect type in argument 2 (different address spaces)
    scic_sds_request.c:875:34: warning: cast removes address space of expression
    scic_sds_request.c:876:123: warning: incorrect type in argument 2 (different address spaces)
    scic_sds_port.c:585:51: warning: incorrect type in assignment (different address spaces)
    scic_sds_port.c:712:9: warning: incorrect type in argument 2 (different address spaces)
    scic_sds_port.c:1770:25: warning: incorrect type in argument 2 (different address spaces)
    
    Signed-off-by: Bartosz Barcinski <Bartosz.Barcinski@intel.com>
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    [fixed up some false positives and misconversions]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d16ee15014ecf411282cb0e777f0e132135ab67d
Author: Bartosz Barcinski <Bartosz.Barcinski@intel.com>
Date:   Tue Apr 12 17:28:43 2011 -0700

    isci: audit usage of BUG_ON macro in isci driver
    
    Removes unnecessary usage of BUG_ON macro, excluding core directory.
    In some cases macro is unnecesary, check is done in caller function.
    In other cases macro is replaced by if construction with
    appropriate warning.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    [changed some survivable bug conditions to WARN_ONCE]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 91203928719e898f967441a39c7816a80e0fd661
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 19 15:29:25 2011 -0700

    isci: fix oem parameter header definition
    
    The element_length is 2 bytes.
    
    Reported-by: Yinghai Lu <yinghai.lu@oracle.com>
    Acked-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a49dab1e977b6918918e8817123cac7ee64e6fa0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Apr 20 12:57:08 2011 -0700

    isci: validate oem parameters early, and fallback
    
    If the platform specifies invalid parameters warn the user and fallback to
    internal defaults rather than fail the driver load altogether.
    
    Reported-by: Yinghai Lu <yinghai.lu@oracle.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5aa5c74b003d9755b8c9ed95f5a624dba67b49e7
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Thu Apr 21 05:34:49 2011 +0000

    isci: replace this_* and the_* variables with more meaningful names
    
    Removed any instances of the_* and this_* to variable names that are more
    meaningful and tell us what they actually are.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 88f5fad12e291afd891b6e3e446478a0cd3fd435
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 19 12:32:51 2011 -0700

    isci: rely on irq core for intx multiplexing, and silence screaming intx
    
    Remove the extra logic to poll each controller for interrupts, that's
    the core's job for shared interrupts.
    
    While testing noticed that a number of interrupts fire while waiting for
    the completion tasklet to run, so added an irq-ack.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 21eabe033a27f1a1ef871a21e3d5ca2a47b3fb63
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 19 13:48:49 2011 -0700

    isci: make a remote_node_context a proper member of a remote_device
    
    A rnc object has the same lifetime as its associated remote_device.  It might
    get re-initialized, but a remote device always has an rnc member.  Preparation
    for unifying scic_sds_remote_device and isci_remote_device
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 03f85d1289ffe62c46286418d79abfa7813fc72f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 19 18:35:58 2011 -0700

    isci: remove rnc->device back pointer
    
    Now that they are one in the same object remove the back pointer reference
    in favor of container_of.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c5a3ba2881f3d8dd8d5bb8e25ba98923b8a9b92b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 21 18:14:45 2011 -0700

    isci: unify remote_device data structures
    
    Make it explicit that isci_remote_device and scic_sds_remote_device are
    one in the same object.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3276e8fbe5eab91ef46448c6bf8d7919841f1e03
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 22 19:18:03 2011 -0700

    isci: move remote_device handling out of the core
    
    Now that the core/lldd remote_device data structures are nominally unified
    merge the corresponding sources into the top-level directory.  Also move the
    remote_node_context infrastructure which has no analog at the lldd level.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 76da8017a5cfa696caa659e7bd28cab05c4b3747
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Apr 25 11:48:29 2011 -0700

    isci: cleanup remote device construction and comments
    
    The construction routines scic_remote_device_[de]a_construct both reference
    the need to call scic_remote_device_construct first.  Delete that comment and
    just have them call it explicitly, also:
    * move the comments from header to source
    * delete dead references to scic_[de]a_remote_device_add_phy
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit eb66c0a4ba77c362669ea9f48b88759121eb7201
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 21 18:44:45 2011 -0700

    isci: kill smp_discover_response_protocols in favor of domain_device.dev_type
    
    This is step 1 of removing the contortions to:
    1/ unparse expander phy data into a smp discover frame
    2/ open-code-parse the smp discover fram into a domain_device.dev_type equivalent
    
    libsas has already spent cycles determining the dev_type, so now that
    scic_sds_remote_device is unified with isci_remote_device we can
    directly reference dev_type.
    
    This might also change multi-level expander detection as we previously only
    looked at dev_type == EDGE_DEV and we did not consider the FANOUT_DEV case.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/core/scic_sds_controller.h b/drivers/scsi/isci/core/scic_sds_controller.h
index e15c4e2..ce81286 100644
--- a/drivers/scsi/isci/core/scic_sds_controller.h
+++ b/drivers/scsi/isci/core/scic_sds_controller.h
@@ -74,9 +74,9 @@
 #include "scic_sds_port.h"
 #include "scic_sds_phy.h"
 #include "remote_node_table.h"
+#include "remote_device.h"
 #include "scu_registers.h"
 #include "scu_constants.h"
-#include "scu_remote_node_context.h"
 #include "scu_task_context.h"
 #include "scu_unsolicited_frame.h"
 #include "scic_sds_unsolicited_frame_control.h"
@@ -498,14 +498,16 @@ enum scic_sds_controller_states {
 #define scic_sds_io_sequence_increment(value) \
 	((value) = (((value) + 1) & 0x000F))
 
-#define scic_sds_remote_device_node_count(device) \
-	(\
-		(\
-			(device)->target_protocols.u.bits.attached_stp_target \
-			&& ((device)->is_direct_attached != true) \
-		) \
-		? SCU_STP_REMOTE_NODE_COUNT : SCU_SSP_REMOTE_NODE_COUNT	\
-	)
+/* expander attached sata devices require 3 rnc slots */
+static inline int scic_sds_remote_device_node_count(struct scic_sds_remote_device *sci_dev)
+{
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
+
+	if ((dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) &&
+	    !sci_dev->is_direct_attached)
+		return SCU_STP_REMOTE_NODE_COUNT;
+	return SCU_SSP_REMOTE_NODE_COUNT;
+}
 
 /**
  * scic_sds_controller_set_invalid_phy() -
diff --git a/drivers/scsi/isci/core/scic_sds_port.c b/drivers/scsi/isci/core/scic_sds_port.c
index b07e48e..057f95a 100644
--- a/drivers/scsi/isci/core/scic_sds_port.c
+++ b/drivers/scsi/isci/core/scic_sds_port.c
@@ -434,7 +434,7 @@ void scic_sds_port_get_attached_sas_address(
  *    multi-protocol support.
  *
  */
-void scic_sds_port_get_attached_protocols(
+static void scic_sds_port_get_attached_protocols(
 	struct scic_sds_port *sci_port,
 	struct sci_sas_identify_address_frame_protocols *protocols)
 {
diff --git a/drivers/scsi/isci/core/scic_sds_port.h b/drivers/scsi/isci/core/scic_sds_port.h
index 964e388..59c76cd 100644
--- a/drivers/scsi/isci/core/scic_sds_port.h
+++ b/drivers/scsi/isci/core/scic_sds_port.h
@@ -447,8 +447,4 @@ void scic_sds_port_get_attached_sas_address(
 	struct scic_sds_port *sci_port,
 	struct sci_sas_address *sas_address);
 
-void scic_sds_port_get_attached_protocols(
-	struct scic_sds_port *sci_port,
-	struct sci_sas_identify_address_frame_protocols *protocols);
-
 #endif /* _SCIC_SDS_PORT_H_ */
diff --git a/drivers/scsi/isci/core/scic_sds_request.c b/drivers/scsi/isci/core/scic_sds_request.c
index dfb9412..a66e7b2 100644
--- a/drivers/scsi/isci/core/scic_sds_request.c
+++ b/drivers/scsi/isci/core/scic_sds_request.c
@@ -1758,8 +1758,8 @@ enum sci_status scic_io_request_construct(struct scic_sds_controller *scic,
 					  struct scic_sds_request *sci_req,
 					  struct scic_sds_request **new_scic_io_request_handle)
 {
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	enum sci_status status = SCI_SUCCESS;
-	struct smp_discover_response_protocols device_protocol;
 
 	/* Build the common part of the request */
 	scic_sds_general_request_construct(scic, sci_dev, io_tag,
@@ -1768,19 +1768,16 @@ enum sci_status scic_io_request_construct(struct scic_sds_controller *scic,
 	if (sci_dev->rnc.remote_node_index == SCIC_SDS_REMOTE_NODE_CONTEXT_INVALID_INDEX)
 		return SCI_FAILURE_INVALID_REMOTE_DEVICE;
 
-	scic_remote_device_get_protocols(sci_dev, &device_protocol);
-
-	if (device_protocol.u.bits.attached_ssp_target) {
+	if (dev->dev_type == SAS_END_DEV) {
 		scic_sds_ssp_io_request_assign_buffers(sci_req);
-	} else if (device_protocol.u.bits.attached_stp_target) {
+	} else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
 		scic_sds_stp_request_assign_buffers(sci_req);
 		memset(sci_req->command_buffer, 0, sizeof(struct sata_fis_reg_h2d));
-	} else if (device_protocol.u.bits.attached_smp_target) {
+	} else if (dev_is_expander(dev)) {
 		scic_sds_smp_request_assign_buffers(sci_req);
 		memset(sci_req->command_buffer, 0, sizeof(struct smp_request));
-	} else {
+	} else
 		status = SCI_FAILURE_UNSUPPORTED_PROTOCOL;
-	}
 
 	if (status == SCI_SUCCESS) {
 		memset(sci_req->task_context_buffer, 0,
@@ -1798,17 +1795,15 @@ enum sci_status scic_task_request_construct(struct scic_sds_controller *scic,
 					    struct scic_sds_request *sci_req,
 					    struct scic_sds_request **new_sci_req)
 {
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	enum sci_status status = SCI_SUCCESS;
-	struct smp_discover_response_protocols device_protocol;
 
 	/* Build the common part of the request */
 	scic_sds_general_request_construct(scic, sci_dev, io_tag,
 					   user_io_request_object,
 					   sci_req);
 
-	scic_remote_device_get_protocols(sci_dev, &device_protocol);
-
-	if (device_protocol.u.bits.attached_ssp_target) {
+	if (dev->dev_type == SAS_END_DEV) {
 		scic_sds_ssp_task_request_assign_buffers(sci_req);
 
 		sci_req->has_started_substate_machine = true;
@@ -1820,11 +1815,10 @@ enum sci_status scic_task_request_construct(struct scic_sds_controller *scic,
 			scic_sds_io_request_started_task_mgmt_substate_table,
 			SCIC_SDS_IO_REQUEST_STARTED_TASK_MGMT_SUBSTATE_AWAIT_TC_COMPLETION
 			);
-	} else if (device_protocol.u.bits.attached_stp_target) {
+	} else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP))
 		scic_sds_stp_request_assign_buffers(sci_req);
-	} else {
+	else
 		status = SCI_FAILURE_UNSUPPORTED_PROTOCOL;
-	}
 
 	if (status == SCI_SUCCESS) {
 		sci_req->is_task_management_request = true;
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 7064181..fc79a5b 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -100,13 +100,6 @@ enum sas_linkrate scic_remote_device_get_connection_rate(
 }
 
 
-void scic_remote_device_get_protocols(
-	struct scic_sds_remote_device *sci_dev,
-	struct smp_discover_response_protocols *pr)
-{
-	pr->u.all = sci_dev->target_protocols.u.all;
-}
-
 #if !defined(DISABLE_ATAPI)
 bool scic_remote_device_is_atapi(struct scic_sds_remote_device *sci_dev)
 {
@@ -1490,7 +1483,7 @@ static enum sci_status scic_remote_device_da_construct(struct scic_sds_port *sci
 {
 	enum sci_status status;
 	u16 remote_node_index;
-	struct sci_sas_identify_address_frame_protocols protocols;
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 
 	scic_remote_device_construct(sci_port, sci_dev);
 
@@ -1498,53 +1491,46 @@ static enum sci_status scic_remote_device_da_construct(struct scic_sds_port *sci
 	 * This information is request to determine how many remote node context
 	 * entries will be needed to store the remote node.
 	 */
-	scic_sds_port_get_attached_protocols(sci_dev->owning_port, &protocols);
-	sci_dev->target_protocols.u.all = protocols.u.all;
 	sci_dev->is_direct_attached = true;
-#if !defined(DISABLE_ATAPI)
-	sci_dev->is_atapi = scic_sds_remote_device_is_atapi(sci_dev);
-#endif
+	status = scic_sds_controller_allocate_remote_node_context(sci_port->owning_controller,
+								  sci_dev,
+								  &remote_node_index);
 
-	status = scic_sds_controller_allocate_remote_node_context(
-		sci_dev->owning_port->owning_controller,
-		sci_dev,
-		&remote_node_index);
+	if (status != SCI_SUCCESS)
+		return status;
 
-	if (status == SCI_SUCCESS) {
-		sci_dev->rnc.remote_node_index = remote_node_index;
+	sci_dev->rnc.remote_node_index = remote_node_index;
 
-		scic_sds_port_get_attached_sas_address(
-			sci_dev->owning_port, &sci_dev->device_address);
+	scic_sds_port_get_attached_sas_address(sci_port, &sci_dev->device_address);
 
-		if (sci_dev->target_protocols.u.bits.attached_ssp_target) {
-			sci_dev->has_ready_substate_machine = false;
-		} else if (sci_dev->target_protocols.u.bits.attached_stp_target) {
-			sci_dev->has_ready_substate_machine = true;
+	if (dev->dev_type == SAS_END_DEV)
+		sci_dev->has_ready_substate_machine = false;
+	else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
+		sci_dev->has_ready_substate_machine = true;
 
-			sci_base_state_machine_construct(
+		sci_base_state_machine_construct(
 				&sci_dev->ready_substate_machine,
 				&sci_dev->parent,
 				scic_sds_stp_remote_device_ready_substate_table,
 				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
-		} else if (sci_dev->target_protocols.u.bits.attached_smp_target) {
-			sci_dev->has_ready_substate_machine = true;
+	} else if (dev_is_expander(dev)) {
+		sci_dev->has_ready_substate_machine = true;
 
-			/* add the SMP ready substate machine construction here */
-			sci_base_state_machine_construct(
+		/* add the SMP ready substate machine construction here */
+		sci_base_state_machine_construct(
 				&sci_dev->ready_substate_machine,
 				&sci_dev->parent,
 				scic_sds_smp_remote_device_ready_substate_table,
 				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
-		}
+	} else
+		return SCI_FAILURE_UNSUPPORTED_PROTOCOL;
 
-		sci_dev->connection_rate = scic_sds_port_get_max_allowed_speed(
-			sci_dev->owning_port);
+	sci_dev->connection_rate = scic_sds_port_get_max_allowed_speed(sci_port);
 
-		/* / @todo Should I assign the port width by reading all of the phys on the port? */
-		sci_dev->device_port_width = 1;
-	}
+	/* / @todo Should I assign the port width by reading all of the phys on the port? */
+	sci_dev->device_port_width = 1;
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static void scic_sds_remote_device_get_info_from_smp_discover_response(
@@ -1557,8 +1543,6 @@ static void scic_sds_remote_device_get_info_from_smp_discover_response(
 
 	sci_dev->device_address.low =
 		discover_response->attached_sas_address.low;
-
-	sci_dev->target_protocols.u.all = discover_response->protocols.u.all;
 }
 
 /**
@@ -1579,6 +1563,7 @@ static enum sci_status scic_remote_device_ea_construct(struct scic_sds_port *sci
 						       struct smp_response_discover *discover_response)
 {
 	struct scic_sds_controller *scic = sci_port->owning_controller;
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	enum sci_status status;
 
 	scic_remote_device_construct(sci_port, sci_dev);
@@ -1588,43 +1573,42 @@ static enum sci_status scic_remote_device_ea_construct(struct scic_sds_port *sci
 
 	status = scic_sds_controller_allocate_remote_node_context(
 		scic, sci_dev, &sci_dev->rnc.remote_node_index);
+	if (status != SCI_SUCCESS)
+		return status;
 
-	if (status == SCI_SUCCESS) {
-		if (sci_dev->target_protocols.u.bits.attached_ssp_target) {
-			sci_dev->has_ready_substate_machine = false;
-		} else if (sci_dev->target_protocols.u.bits.attached_smp_target) {
-			sci_dev->has_ready_substate_machine = true;
+	if (dev->dev_type == SAS_END_DEV)
+		sci_dev->has_ready_substate_machine = false;
+	else if (dev_is_expander(dev)) {
+		sci_dev->has_ready_substate_machine = true;
 
-			/* add the SMP ready substate machine construction here */
-			sci_base_state_machine_construct(
+		/* add the SMP ready substate machine construction here */
+		sci_base_state_machine_construct(
 				&sci_dev->ready_substate_machine,
 				&sci_dev->parent,
 				scic_sds_smp_remote_device_ready_substate_table,
 				SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
-		} else if (sci_dev->target_protocols.u.bits.attached_stp_target) {
-			sci_dev->has_ready_substate_machine = true;
+	} else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
+		sci_dev->has_ready_substate_machine = true;
 
-			sci_base_state_machine_construct(
+		sci_base_state_machine_construct(
 				&sci_dev->ready_substate_machine,
 				&sci_dev->parent,
 				scic_sds_stp_remote_device_ready_substate_table,
 				SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_IDLE);
-		}
+	}
 
-		/*
-		 * For SAS-2 the physical link rate is actually a logical link
-		 * rate that incorporates multiplexing.  The SCU doesn't
-		 * incorporate multiplexing and for the purposes of the
-		 * connection the logical link rate is that same as the
-		 * physical.  Furthermore, the SAS-2 and SAS-1.1 fields overlay
-		 * one another, so this code works for both situations. */
-		sci_dev->connection_rate = min_t(u16,
-			scic_sds_port_get_max_allowed_speed(sci_port),
+	/*
+	 * For SAS-2 the physical link rate is actually a logical link
+	 * rate that incorporates multiplexing.  The SCU doesn't
+	 * incorporate multiplexing and for the purposes of the
+	 * connection the logical link rate is that same as the
+	 * physical.  Furthermore, the SAS-2 and SAS-1.1 fields overlay
+	 * one another, so this code works for both situations. */
+	sci_dev->connection_rate = min_t(u16, scic_sds_port_get_max_allowed_speed(sci_port),
 			discover_response->u2.sas1_1.negotiated_physical_link_rate);
 
-		/* / @todo Should I assign the port width by reading all of the phys on the port? */
-		sci_dev->device_port_width = 1;
-	}
+	/* / @todo Should I assign the port width by reading all of the phys on the port? */
+	sci_dev->device_port_width = 1;
 
 	return status;
 }
@@ -1665,7 +1649,7 @@ static enum sci_status isci_remote_device_construct(
 	enum sci_status status = SCI_SUCCESS;
 
 	if (isci_device->domain_dev->parent &&
-	    (isci_device->domain_dev->parent->dev_type == EDGE_DEV)) {
+	    dev_is_expander(isci_device->domain_dev->parent)) {
 		int i;
 
 		/* struct smp_response_discover discover_response; */
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 9d8fcbf..3982160 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -100,11 +100,6 @@ struct scic_sds_remote_device {
 	enum sas_linkrate connection_rate;
 
 	/**
-	 * This field contains the allowed target protocols for this remote device.
-	 */
-	struct smp_discover_response_protocols target_protocols;
-
-	/**
 	 * This field contains the device SAS address.
 	 */
 	struct sci_sas_address device_address;
@@ -264,23 +259,6 @@ enum sci_status scic_remote_device_reset_complete(
 enum sas_linkrate scic_remote_device_get_connection_rate(
 	struct scic_sds_remote_device *remote_device);
 
-/**
- * scic_remote_device_get_protocols() - This method will indicate which
- *    protocols are supported by this remote device.
- * @remote_device: This parameter specifies the device for which to return the
- *    protocol.
- * @protocols: This parameter specifies the output values, from the remote
- *    device object, which indicate the protocols supported by the supplied
- *    remote_device.
- *
- * The type of protocols supported by this device.  The values are returned as
- * part of a bit mask in order to allow for multi-protocol support.
- */
-void scic_remote_device_get_protocols(
-	struct scic_sds_remote_device *remote_device,
-	struct smp_discover_response_protocols *protocols);
-
-
 #if !defined(DISABLE_ATAPI)
 /**
  * scic_remote_device_is_atapi() -
@@ -477,6 +455,18 @@ static inline struct scic_sds_remote_device *rnc_to_dev(struct scic_sds_remote_n
 	return sci_dev;
 }
 
+static inline struct domain_device *sci_dev_to_domain(struct scic_sds_remote_device *sci_dev)
+{
+	struct isci_remote_device *idev = container_of(sci_dev, typeof(*idev), sci);
+
+	return idev->domain_dev;
+}
+
+static inline bool dev_is_expander(struct domain_device *dev)
+{
+	return dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV;
+}
+
 typedef enum sci_status (*scic_sds_remote_device_request_handler_t)(
 	struct scic_sds_remote_device *device,
 	struct scic_sds_request *request);
diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index bdf0b51..285232f 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -106,8 +106,9 @@ bool scic_sds_remote_node_context_is_ready(
 static void scic_sds_remote_node_context_construct_buffer(
 	struct scic_sds_remote_node_context *sci_rnc)
 {
-	union scu_remote_node_context *rnc;
 	struct scic_sds_remote_device *sci_dev = rnc_to_dev(sci_rnc);
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
+	union scu_remote_node_context *rnc;
 	struct scic_sds_controller *scic;
 
 	scic = scic_sds_remote_device_get_controller(sci_dev);
@@ -134,11 +135,7 @@ static void scic_sds_remote_node_context_construct_buffer(
 
 	rnc->ssp.arbitration_wait_time = 0;
 
-
-	if (
-		sci_dev->target_protocols.u.bits.attached_sata_device
-		|| sci_dev->target_protocols.u.bits.attached_stp_target
-		) {
+	if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
 		rnc->ssp.connection_occupancy_timeout =
 			scic->user_parameters.sds1.stp_max_occupancy_timeout;
 		rnc->ssp.connection_inactivity_timeout =
@@ -639,45 +636,30 @@ static enum sci_status scic_sds_remote_node_context_tx_suspended_state_resume_ha
 	scics_sds_remote_node_context_callback callback,
 	void *callback_parameter)
 {
-	enum sci_status status;
-	struct smp_discover_response_protocols protocols;
+	struct scic_sds_remote_device *sci_dev = rnc_to_dev(sci_rnc);
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
+	enum sci_status status = SCI_SUCCESS;
 
-	scic_sds_remote_node_context_setup_to_resume(
-		sci_rnc, callback, callback_parameter
-		);
+	scic_sds_remote_node_context_setup_to_resume(sci_rnc, callback,
+						     callback_parameter);
 
 	/* TODO: consider adding a resume action of NONE, INVALIDATE, WRITE_TLCR */
-
-	scic_remote_device_get_protocols(rnc_to_dev(sci_rnc), &protocols);
-
-	if (
-		(protocols.u.bits.attached_ssp_target == 1)
-		|| (protocols.u.bits.attached_smp_target == 1)
-		) {
-		sci_base_state_machine_change_state(
-			&sci_rnc->state_machine,
-			SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
-			);
-
-		status = SCI_SUCCESS;
-	} else if (protocols.u.bits.attached_stp_target == 1) {
-		if (rnc_to_dev(sci_rnc)->is_direct_attached) {
+	if (dev->dev_type == SAS_END_DEV || dev_is_expander(dev))
+		sci_base_state_machine_change_state(&sci_rnc->state_machine,
+						    SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE);
+	else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
+		if (sci_dev->is_direct_attached) {
 			/* @todo Fix this since I am being silly in writing to the STPTLDARNI register. */
 			sci_base_state_machine_change_state(
 				&sci_rnc->state_machine,
-				SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE
-				);
+				SCIC_SDS_REMOTE_NODE_CONTEXT_RESUMING_STATE);
 		} else {
 			sci_base_state_machine_change_state(
 				&sci_rnc->state_machine,
-				SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE
-				);
+				SCIC_SDS_REMOTE_NODE_CONTEXT_INVALIDATING_STATE);
 		}
-
-		status = SCI_SUCCESS;
-	} else {
+	} else
 		status = SCI_FAILURE;
-	}
 
 	return status;
 }
@@ -932,6 +914,7 @@ static void scic_sds_remote_node_context_validate_context_buffer(
 	struct scic_sds_remote_node_context *sci_rnc)
 {
 	struct scic_sds_remote_device *sci_dev = rnc_to_dev(sci_rnc);
+	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	union scu_remote_node_context *rnc_buffer;
 
 	rnc_buffer = scic_sds_controller_get_remote_node_context_buffer(
@@ -942,7 +925,7 @@ static void scic_sds_remote_node_context_validate_context_buffer(
 	rnc_buffer->ssp.is_valid = true;
 
 	if (!sci_dev->is_direct_attached &&
-	    sci_dev->target_protocols.u.bits.attached_stp_target) {
+	    (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP))) {
 		scic_sds_remote_device_post_request(sci_dev,
 						    SCU_CONTEXT_COMMAND_POST_RNC_96);
 	} else {
@@ -1063,11 +1046,12 @@ static void scic_sds_remote_node_context_resuming_state_enter(
 	struct sci_base_object *object)
 {
 	struct scic_sds_remote_node_context *rnc;
-	struct smp_discover_response_protocols protocols;
 	struct scic_sds_remote_device *sci_dev;
+	struct domain_device *dev;
 
 	rnc = (struct scic_sds_remote_node_context *)object;
 	sci_dev = rnc_to_dev(rnc);
+	dev = sci_dev_to_domain(sci_dev);
 
 	SET_STATE_HANDLER(
 		rnc,
@@ -1081,13 +1065,10 @@ static void scic_sds_remote_node_context_resuming_state_enter(
 	 * resume because of a target reset we also need to update
 	 * the STPTLDARNI register with the RNi of the device
 	 */
-	scic_remote_device_get_protocols(sci_dev, &protocols);
-
-	if (protocols.u.bits.attached_stp_target == 1 &&
-	    sci_dev->is_direct_attached) {
+	if ((dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) &&
+	    sci_dev->is_direct_attached)
 		scic_sds_port_setup_transports(sci_dev->owning_port,
 					       rnc->remote_node_index);
-	}
 
 	scic_sds_remote_device_post_request(sci_dev, SCU_CONTEXT_COMMAND_POST_RNC_RESUME);
 }
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index ff5c05a..281a556 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -175,7 +175,6 @@ static enum sci_status isci_io_request_build(
 	struct isci_request *request,
 	struct isci_remote_device *isci_device)
 {
-	struct smp_discover_response_protocols dev_protocols;
 	enum sci_status status = SCI_SUCCESS;
 	struct sas_task *task = isci_request_access_task(request);
 	struct scic_sds_remote_device *sci_device = &isci_device->sci;
@@ -228,15 +227,19 @@ static enum sci_status isci_io_request_build(
 
 	sci_object_set_association(request->sci_request_handle, request);
 
-	/* Determine protocol and call the appropriate basic constructor */
-	scic_remote_device_get_protocols(sci_device, &dev_protocols);
-	if (dev_protocols.u.bits.attached_ssp_target)
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		status = isci_smp_request_build(request);
+		break;
+	case SAS_PROTOCOL_SSP:
 		status = isci_request_ssp_request_construct(request);
-	else if (dev_protocols.u.bits.attached_stp_target)
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
 		status = isci_request_stp_request_construct(request);
-	else if (dev_protocols.u.bits.attached_smp_target)
-		status = isci_smp_request_build(request);
-	else {
+		break;
+	default:
 		dev_warn(&isci_host->pdev->dev,
 			 "%s: unknown protocol\n", __func__);
 		return SCI_FAILURE;
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index e011d66..c6f1ffd 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -273,15 +273,14 @@ static enum sci_status isci_task_request_build(
 	enum sci_status status = SCI_FAILURE;
 	struct isci_request *request = NULL;
 	struct isci_remote_device *isci_device;
-/*	struct sci_sas_identify_address_frame_protocols dev_protocols; */
-	struct smp_discover_response_protocols dev_protocols;
-
+	struct domain_device *dev;
 
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_tmf = %p\n", __func__, isci_tmf);
 
 	isci_device = isci_tmf->device;
 	sci_device = &isci_device->sci;
+	dev = isci_device->domain_dev;
 
 	/* do common allocation and init of request object. */
 	status = isci_request_alloc_tmf(
@@ -319,16 +318,8 @@ static enum sci_status isci_task_request_build(
 		request
 		);
 
-	scic_remote_device_get_protocols(
-		sci_device,
-		&dev_protocols
-		);
-
-	/* let the core do it's protocol
-	 * specific construction.
-	 */
-	if (dev_protocols.u.bits.attached_ssp_target) {
-
+	/* XXX convert to get this from task->tproto like other drivers */
+	if (dev->dev_type == SAS_END_DEV) {
 		isci_tmf->proto = SAS_PROTOCOL_SSP;
 		status = scic_task_request_construct_ssp(
 			request->sci_request_handle
@@ -337,8 +328,7 @@ static enum sci_status isci_task_request_build(
 			goto errout;
 	}
 
-	if (dev_protocols.u.bits.attached_stp_target) {
-
+	if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
 		isci_tmf->proto = SAS_PROTOCOL_SATA;
 		status = isci_sata_management_task_request_build(request);
 

commit 247e6242acaf1a82631d6fbc6b1f21730b506a2b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Apr 25 14:29:29 2011 -0700

    isci: kill smp_discover_response
    
    An lldd need never look at the contents of an smp_discover_response frame.
    Kill the remaining locations where isci is looking at it:
    
    1/ covering for expanders that do not set the stp_attached bit (already
       handled by sas_ex_discover_end_dev)
    2/ an overkill method to notifiy the rest of the driver about remote_device
       sas addresses
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/core/intel_sas.h b/drivers/scsi/isci/core/intel_sas.h
index d9c9f33..b57f39c 100644
--- a/drivers/scsi/isci/core/intel_sas.h
+++ b/drivers/scsi/isci/core/intel_sas.h
@@ -628,202 +628,6 @@ struct smp_response_report_manufacturer_information {
 
 };
 
-#define SMP_RESPONSE_DISCOVER_FORMAT_1_1_SIZE 52
-#define SMP_RESPONSE_DISCOVER_FORMAT_2_SIZE   116
-
-/**
- * struct smp_discover_response_protocols - This structure depicts the discover
- *    response where the supported protocols by the remote phy are specified.
- *
- * For specific information on each of these individual fields please reference
- * the SAS specification Link layer section on address frames.
- */
-struct smp_discover_response_protocols {
-	union {
-		struct {
-			u16 attached_sata_host:1;
-			u16 attached_smp_initiator:1;
-			u16 attached_stp_initiator:1;
-			u16 attached_ssp_initiator:1;
-			u16 reserved3:4;
-			u16 attached_sata_device:1;
-			u16 attached_smp_target:1;
-			u16 attached_stp_target:1;
-			u16 attached_ssp_target:1;
-			u16 reserved4:3;
-			u16 attached_sata_port_selector:1;
-		} bits;
-
-		u16 all;
-	} u;
-
-};
-
-/**
- * struct SMP_RESPONSE_DISCOVER_FORMAT - This structure defines the SMP phy
- *    discover response format. It handles both SAS1.1 and SAS 2 definitions.
- *    The unions indicate locations where the SAS specification versions differ
- *    from one another.
- *
- *
- */
-struct smp_response_discover {
-
-	union {
-		struct {
-			u8 reserved[2];
-		} sas1_1;
-
-		struct {
-			u16 expander_change_count;
-		} sas2;
-
-	} u1;
-
-	u8 reserved1[3];
-	u8 phy_identifier;
-	u8 reserved2[2];
-
-	union {
-		struct {
-			u16 reserved1:4;
-			u16 attached_device_type:3;
-			u16 reserved2:1;
-			u16 negotiated_physical_link_rate:4;
-			u16 reserved3:4;
-		} sas1_1;
-
-		struct {
-			u16 attached_reason:4;
-			u16 attached_device_type:3;
-			u16 reserved2:1;
-			u16 negotiated_logical_link_rate:4;
-			u16 reserved3:4;
-		} sas2;
-
-	} u2;
-
-	struct smp_discover_response_protocols protocols;
-	struct sci_sas_address sas_address;
-	struct sci_sas_address attached_sas_address;
-
-	u8 attached_phy_identifier;
-
-	union {
-		struct {
-			u8 reserved;
-		} sas1_1;
-
-		struct {
-			u8 attached_break_reply_capable:1;
-			u8 attached_requested_inside_zpsds:1;
-			u8 attached_inside_zpsds_persistent:1;
-			u8 reserved1:5;
-		} sas2;
-
-	} u3;
-
-	u8 reserved_for_identify[6];
-
-	u32 hardware_min_physical_link_rate:4;
-	u32 programmed_min_physical_link_rate:4;
-	u32 hardware_max_physical_link_rate:4;
-	u32 programmed_max_physical_link_rate:4;
-	u32 phy_change_count:8;
-	u32 partial_pathway_timeout_value:4;
-	u32 reserved5:3;
-	u32 virtual_phy:1;
-
-	u32 routing_attribute:4;
-	u32 reserved6:4;
-	u32 connector_type:7;
-	u32 reserved7:1;
-	u32 connector_element_index:8;
-	u32 connector_physical_link:8;
-
-	u16 reserved8;
-	u16 vendor_specific;
-
-	union {
-		struct {
-			/**
-			 * In the SAS 1.1 specification this structure ends after 52 bytes.
-			 * As a result, the contents of this field should never have a
-			 * real value.  It is undefined.
-			 */
-			u8 undefined[SMP_RESPONSE_DISCOVER_FORMAT_2_SIZE
-				     - SMP_RESPONSE_DISCOVER_FORMAT_1_1_SIZE];
-		} sas1_1;
-
-		struct {
-			struct sci_sas_address attached_device_name;
-
-			u32 zoning_enabled:1;
-			u32 inside_zpsds:1;
-			u32 zone_group_persistent:1;
-			u32 reserved1:1;
-			u32 requested_inside_zpsds:1;
-			u32 inside_zpsds_persistent:1;
-			u32 requested_inside_zpsds_changed_by_expander:1;
-			u32 reserved2:1;
-			u32 reserved_for_zoning_fields:16;
-			u32 zone_group:8;
-
-			u8 self_configuration_status;
-			u8 self_configuration_levels_completed;
-			u16 reserved_for_self_config_fields;
-
-			struct sci_sas_address self_configuration_sas_address;
-
-			u32 programmed_phy_capabilities;
-			u32 current_phy_capabilities;
-			u32 attached_phy_capabilities;
-
-			u32 reserved3;
-
-			u32 reserved4:16;
-			u32 negotiated_physical_link_rate:4;
-			u32 reason:4;
-			u32 hardware_muxing_supported:1;
-			u32 negotiated_ssc:1;
-			u32 reserved5:6;
-
-			u32 default_zoning_enabled:1;
-			u32 reserved6:1;
-			u32 default_zone_group_persistent:1;
-			u32 reserved7:1;
-			u32 default_requested_inside_zpsds:1;
-			u32 default_inside_zpsds_persistent:1;
-			u32 reserved8:2;
-			u32 reserved9:16;
-			u32 default_zone_group:8;
-
-			u32 saved_zoning_enabled:1;
-			u32 reserved10:1;
-			u32 saved_zone_group_persistent:1;
-			u32 reserved11:1;
-			u32 saved_requested_inside_zpsds:1;
-			u32 saved_inside_zpsds_persistent:1;
-			u32 reserved12:18;
-			u32 saved_zone_group:8;
-
-			u32 reserved14:2;
-			u32 shadow_zone_group_persistent:1;
-			u32 reserved15:1;
-			u32 shadow_requested_inside_zpsds:1;
-			u32 shadow_inside_zpsds_persistent:1;
-			u32 reserved16:18;
-			u32 shadow_zone_group:8;
-
-			u8 device_slot_number;
-			u8 device_slot_group_number;
-			u8 device_slot_group_output_connector[6];
-		} sas2;
-
-	} u4;
-
-};
-
 /**
  * struct smp_response_report_phy_sata - This structure depicts the contents of
  *    the SAS SMP REPORT PHY SATA frame.  For specific information on each of
@@ -857,7 +661,6 @@ struct smp_response_vendor_specific {
 union smp_response_body {
 	struct smp_response_report_general report_general;
 	struct smp_response_report_manufacturer_information report_manufacturer_information;
-	struct smp_response_discover discover;
 	struct smp_response_report_phy_sata report_phy_sata;
 	struct smp_response_vendor_specific vendor_specific_response;
 };
diff --git a/drivers/scsi/isci/core/scic_sds_smp_request.c b/drivers/scsi/isci/core/scic_sds_smp_request.c
index 1790f25..d4009e5 100644
--- a/drivers/scsi/isci/core/scic_sds_smp_request.c
+++ b/drivers/scsi/isci/core/scic_sds_smp_request.c
@@ -339,26 +339,6 @@ static enum sci_status scic_sds_smp_request_await_response_frame_handler(
 			smp_response_buffer,
 			sizeof(union smp_response_body) / sizeof(u32)
 			);
-		if (rsp_hdr->function == SMP_FUNCTION_DISCOVER) {
-			struct smp_response *smp_resp;
-
-			smp_resp = (struct smp_response *)user_smp_buffer;
-
-			/*
-			 * Some expanders only report an attached SATA device, and
-			 * not an STP target.  Since the core depends on the STP
-			 * target attribute to correctly build I/O, set the bit now
-			 * if necessary. */
-			if (smp_resp->response.discover.protocols.u.bits.attached_sata_device
-			    && !smp_resp->response.discover.protocols.u.bits.attached_stp_target) {
-				smp_resp->response.discover.protocols.u.bits.attached_stp_target = 1;
-
-				dev_dbg(scic_to_dev(sci_req->owning_controller),
-					"%s: scic_sds_smp_request_await_response_frame_handler(0x%p) Found SATA dev, setting STP bit.\n",
-					__func__, sci_req);
-			}
-		}
-
 		/*
 		 * Don't need to copy to user space. User instead will refer to
 		 * core request's response buffer. */
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index fc79a5b..5ba3b5d 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1533,21 +1533,8 @@ static enum sci_status scic_remote_device_da_construct(struct scic_sds_port *sci
 	return SCI_SUCCESS;
 }
 
-static void scic_sds_remote_device_get_info_from_smp_discover_response(
-	struct scic_sds_remote_device *sci_dev,
-	struct smp_response_discover *discover_response)
-{
-	/* decode discover_response to set sas_address to sci_dev. */
-	sci_dev->device_address.high =
-		discover_response->attached_sas_address.high;
-
-	sci_dev->device_address.low =
-		discover_response->attached_sas_address.low;
-}
-
 /**
  * scic_remote_device_ea_construct() - construct expander attached device
- * @discover_response: data to build remote device
  *
  * Remote node context(s) is/are a global resource allocated by this
  * routine, freed by scic_remote_device_destruct().
@@ -1559,17 +1546,14 @@ static void scic_sds_remote_device_get_info_from_smp_discover_response(
  * SCI_FAILURE_INSUFFICIENT_RESOURCES - remote node contexts exhausted.
  */
 static enum sci_status scic_remote_device_ea_construct(struct scic_sds_port *sci_port,
-						       struct scic_sds_remote_device *sci_dev,
-						       struct smp_response_discover *discover_response)
+						       struct scic_sds_remote_device *sci_dev)
 {
 	struct scic_sds_controller *scic = sci_port->owning_controller;
 	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	enum sci_status status;
 
 	scic_remote_device_construct(sci_port, sci_dev);
-
-	scic_sds_remote_device_get_info_from_smp_discover_response(
-		sci_dev, discover_response);
+	memcpy(&sci_dev->device_address, dev->sas_addr, SAS_ADDR_SIZE);
 
 	status = scic_sds_controller_allocate_remote_node_context(
 		scic, sci_dev, &sci_dev->rnc.remote_node_index);
@@ -1605,7 +1589,7 @@ static enum sci_status scic_remote_device_ea_construct(struct scic_sds_port *sci
 	 * physical.  Furthermore, the SAS-2 and SAS-1.1 fields overlay
 	 * one another, so this code works for both situations. */
 	sci_dev->connection_rate = min_t(u16, scic_sds_port_get_max_allowed_speed(sci_port),
-			discover_response->u2.sas1_1.negotiated_physical_link_rate);
+					 dev->linkrate);
 
 	/* / @todo Should I assign the port width by reading all of the phys on the port? */
 	sci_dev->device_port_width = 1;
@@ -1632,117 +1616,35 @@ static enum sci_status scic_remote_device_start(struct scic_sds_remote_device *s
 	return sci_dev->state_handlers->start_handler(sci_dev);
 }
 
-/**
- * isci_remote_device_construct() - This function calls the scic remote device
- *    construct and start functions, it waits on the remote device start
- *    completion.
- * @port: This parameter specifies the isci port with the remote device.
- * @isci_device: This parameter specifies the isci remote device
- *
- * status from the scic calls, the caller to this function should clean up
- * resources as appropriate.
- */
-static enum sci_status isci_remote_device_construct(
-	struct isci_port *port,
-	struct isci_remote_device *isci_device)
+static enum sci_status isci_remote_device_construct(struct isci_port *iport,
+						    struct isci_remote_device *idev)
 {
-	enum sci_status status = SCI_SUCCESS;
-
-	if (isci_device->domain_dev->parent &&
-	    dev_is_expander(isci_device->domain_dev->parent)) {
-		int i;
-
-		/* struct smp_response_discover discover_response; */
-		struct discover_resp discover_response;
-		struct domain_device *parent =
-			isci_device->domain_dev->parent;
-
-		struct expander_device *parent_ex = &parent->ex_dev;
-
-		for (i = 0; i < parent_ex->num_phys; i++) {
-
-			struct ex_phy *phy = &parent_ex->ex_phy[i];
-
-			if ((phy->phy_state == PHY_VACANT) ||
-			    (phy->phy_state == PHY_NOT_PRESENT))
-				continue;
-
-			if (SAS_ADDR(phy->attached_sas_addr)
-			    == SAS_ADDR(isci_device->domain_dev->sas_addr)) {
-
-				discover_response.attached_dev_type
-					= phy->attached_dev_type;
-				discover_response.linkrate
-					= phy->linkrate;
-				discover_response.attached_sata_host
-					= phy->attached_sata_host;
-				discover_response.attached_sata_dev
-					= phy->attached_sata_dev;
-				discover_response.attached_sata_ps
-					= phy->attached_sata_ps;
-				discover_response.iproto
-					= phy->attached_iproto >> 1;
-				discover_response.tproto
-					= phy->attached_tproto >> 1;
-				memcpy(
-					discover_response.attached_sas_addr,
-					phy->attached_sas_addr,
-					SAS_ADDR_SIZE
-					);
-				discover_response.attached_phy_id
-					= phy->attached_phy_id;
-				discover_response.change_count
-					= phy->phy_change_count;
-				discover_response.routing_attr
-					= phy->routing_attr;
-				discover_response.hmin_linkrate
-					= phy->phy->minimum_linkrate_hw;
-				discover_response.hmax_linkrate
-					= phy->phy->maximum_linkrate_hw;
-				discover_response.pmin_linkrate
-					= phy->phy->minimum_linkrate;
-				discover_response.pmax_linkrate
-					= phy->phy->maximum_linkrate;
-			}
-		}
-
-
-		dev_dbg(&port->isci_host->pdev->dev,
-			"%s: parent->dev_type = EDGE_DEV\n",
-			__func__);
-
-		status = scic_remote_device_ea_construct(port->sci_port_handle,
-							 &isci_device->sci,
-				(struct smp_response_discover *)&discover_response);
-
-	} else
-		status = scic_remote_device_da_construct(port->sci_port_handle,
-							 &isci_device->sci);
+	struct scic_sds_port *sci_port = iport->sci_port_handle;
+	struct isci_host *ihost = iport->isci_host;
+	struct domain_device *dev = idev->domain_dev;
+	enum sci_status status;
 
+	if (dev->parent && dev_is_expander(dev->parent))
+		status = scic_remote_device_ea_construct(sci_port, &idev->sci);
+	else
+		status = scic_remote_device_da_construct(sci_port, &idev->sci);
 
 	if (status != SCI_SUCCESS) {
-		dev_dbg(&port->isci_host->pdev->dev,
-			"%s: scic_remote_device_da_construct failed - "
-			"isci_device = %p\n",
-			__func__,
-			isci_device);
+		dev_dbg(&ihost->pdev->dev, "%s: construct failed: %d\n",
+			__func__, status);
 
 		return status;
 	}
 
 	/* XXX will be killed with sci_base_object removal */
-	sci_object_set_association(&isci_device->sci, isci_device);
+	sci_object_set_association(&idev->sci, idev);
 
 	/* start the device. */
-	status = scic_remote_device_start(&isci_device->sci,
-					  ISCI_REMOTE_DEVICE_START_TIMEOUT);
+	status = scic_remote_device_start(&idev->sci, ISCI_REMOTE_DEVICE_START_TIMEOUT);
 
-	if (status != SCI_SUCCESS) {
-		dev_warn(&port->isci_host->pdev->dev,
-			 "%s: scic_remote_device_start failed\n",
-			 __func__);
-		return status;
-	}
+	if (status != SCI_SUCCESS)
+		dev_warn(&ihost->pdev->dev, "remote device start failed: %d\n",
+			 status);
 
 	return status;
 }
diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 285232f..59f878f 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -124,8 +124,9 @@ static void scic_sds_remote_node_context_construct_buffer(
 	rnc->ssp.logical_port_index =
 		scic_sds_remote_device_get_port_index(sci_dev);
 
-	rnc->ssp.remote_sas_address_hi = SCIC_SWAP_DWORD(sci_dev->device_address.high);
-	rnc->ssp.remote_sas_address_lo = SCIC_SWAP_DWORD(sci_dev->device_address.low);
+	/* address is always big endian, destination is always little */
+	rnc->ssp.remote_sas_address_hi = swab32(sci_dev->device_address.high);
+	rnc->ssp.remote_sas_address_lo = swab32(sci_dev->device_address.low);
 
 	rnc->ssp.nexus_loss_timer_enable = true;
 	rnc->ssp.check_bit               = false;

commit c8cec8e26f0d7c2228b2a14f451e9b187458cbb8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 26 09:41:52 2011 -0700

    isci: remove usage of sci_sas_address in scic_sds_remote_device
    
    The sas address can be retrieved from the domain device and then
    converted to the always little-endian format in the remote node context.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 5ba3b5d..1e9e222 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1501,8 +1501,6 @@ static enum sci_status scic_remote_device_da_construct(struct scic_sds_port *sci
 
 	sci_dev->rnc.remote_node_index = remote_node_index;
 
-	scic_sds_port_get_attached_sas_address(sci_port, &sci_dev->device_address);
-
 	if (dev->dev_type == SAS_END_DEV)
 		sci_dev->has_ready_substate_machine = false;
 	else if (dev->dev_type == SATA_DEV || (dev->tproto & SAS_PROTOCOL_STP)) {
@@ -1553,7 +1551,6 @@ static enum sci_status scic_remote_device_ea_construct(struct scic_sds_port *sci
 	enum sci_status status;
 
 	scic_remote_device_construct(sci_port, sci_dev);
-	memcpy(&sci_dev->device_address, dev->sas_addr, SAS_ADDR_SIZE);
 
 	status = scic_sds_controller_allocate_remote_node_context(
 		scic, sci_dev, &sci_dev->rnc.remote_node_index);
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 3982160..f0612d4 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -100,11 +100,6 @@ struct scic_sds_remote_device {
 	enum sas_linkrate connection_rate;
 
 	/**
-	 * This field contains the device SAS address.
-	 */
-	struct sci_sas_address device_address;
-
-	/**
 	 * This filed is assinged the value of true if the device is directly
 	 * attached to the port.
 	 */
diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 59f878f..e83657d 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -110,6 +110,7 @@ static void scic_sds_remote_node_context_construct_buffer(
 	struct domain_device *dev = sci_dev_to_domain(sci_dev);
 	union scu_remote_node_context *rnc;
 	struct scic_sds_controller *scic;
+	__le64 sas_addr;
 
 	scic = scic_sds_remote_device_get_controller(sci_dev);
 
@@ -124,9 +125,10 @@ static void scic_sds_remote_node_context_construct_buffer(
 	rnc->ssp.logical_port_index =
 		scic_sds_remote_device_get_port_index(sci_dev);
 
-	/* address is always big endian, destination is always little */
-	rnc->ssp.remote_sas_address_hi = swab32(sci_dev->device_address.high);
-	rnc->ssp.remote_sas_address_lo = swab32(sci_dev->device_address.low);
+	/* sas address is __be64, context ram format is __le64 */
+	sas_addr = cpu_to_le64(SAS_ADDR(dev->sas_addr));
+	rnc->ssp.remote_sas_address_hi = upper_32_bits(sas_addr);
+	rnc->ssp.remote_sas_address_lo = lower_32_bits(sas_addr);
 
 	rnc->ssp.nexus_loss_timer_enable = true;
 	rnc->ssp.check_bit               = false;

commit b3d5627b8574abbb6e550e1360bfdd65c2aa2e34
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 26 11:44:06 2011 -0700

    isci: remove scic_sds_remote_device_get_port_index
    
    Longer to type than the open-coded equivalent.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bbb7f7c517f67d3054c7105be1b4f6d2fadb3dec
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Tue Apr 26 12:31:37 2011 -0700

    isci: removing non-working ATAPI code
    
    Removing not used / bit-rotten ATAPI code. This needs to go back
    and debugged at a later date.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    [reflow against devel, delete dead sati headers]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 235bb93bd2647ec5ea5aeda88498886db495329f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 26 13:19:53 2011 -0700

    isci: allow fallback to option-rom if efi variable retrieval fails
    
    If the scu efi driver is disabled but the option-rom is enabled (during an efi
    boot) allow the code to fallback to scanning legacy option-rom space for the
    parameters.
    
    Reported-by: Yinghai Lu <yinghai.lu@oracle.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a89d81cb6bd3670ba55d32da7accaba34212bb08
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 26 13:31:02 2011 -0700

    isci: defer pci_map_biosrom
    
    The implementation was accepted into tip/x86/platform, but not 2.6.39.
    Add a dummy local definition to enable a self-contained a 2.6.39 merge.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ea04ff78fdbdc089e733569a93affcddd4aa2f83
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Thu Apr 21 05:36:23 2011 +0000

    isci: Remove excessive log noise with expander hot-unplug
    
    We are logging excessive output when hot unplug from expander. Moving
    that to debug.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e1577d24adf3500e36f789526113caac3dd9e8e0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 26 16:58:24 2011 -0700

    isci: fix CONFIG_EFI=n compile error
    
    When efi variable services are disabled the "efi" symbol is unavailable.
    
    Todo: sync up with 2.6.39 infrastructure for drivers to consume efi
    variable services.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


[1]: http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=refs/heads/x86/platform
[2]: http://marc.info/?l=linux-scsi&m=130170650423175&w=2

