From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: towards the v3.0 merge candidate
Date: Mon, 06 Jun 2011 18:06:05 -0700
Message-ID: <1307408765.11482.40.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30966 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1FGBGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2011 21:06:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, sfr@canb.auug.org.au, David Milburn <dmilburn@redhat.com>, hare@suse.de

[ copying sfr to get his opinion on having exposure of this tree in
-next for a few weeks before  it hits James' tree.  isci.git#master
never rebases so I don't expect conflicts once scsi-misc.git starts
carrying the same ]

The following changes since commit b0733ad3d6efab9659bd77b405587b36d03fe276:

  isci: add some type safety to the state machine interface (2011-05-12 09:46:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master


This branch:
* retrieves oem parameters via legacy option-rom or efi mechanisms
* supports C0 silicon
* completes the priority cleanups that were identified for .39

The libsas-pending, x86-pending, and subsequently upstream-pending
branches are now closed with the inclusion of v3.0-rc2 into 'master'.

Conspicuously missing is significant progress toward the request to
merge the isci_ and scic_sds_ level of data structures.  This is mainly
due to taking a break on the cleanups to knock down bugs and missing
features, but it also comes back to biting the bullet on more rename
thrash.  Patches like "isci: remove 'min memory' infrastructure" give me
pause because they indicate we still have work to do on clarifying the
data structures and shrinking the number of members (the meat / hard
work of the cleanup).  A rename is icing (still necessary) at this
point, but working on closing out bugs before going down that road.

Questions / suggestions on how to proceed on the cleanup versus bug
fixing for the 3.0 merge are welcome.

--
Dan for this isci driver team

Adam Gruchala (1):
      isci: Added support for C0 to SCU Driver

Dan Williams (3):
      Revert "isci: Add missing PCI IDs"
      isci: remove 'min memory' infrastructure
      isci: use pci_map_biosrom

Dave Jiang (3):
      isci: removing the kmalloc in smp request construct
      isci: Retrieve the EFI variable for OEM parameter
      isci: Removing unused variables compiler warnings

Edmund Nadolski (10):
      isci: replace isci_timer list with proper embedded timers
      isci: convert port config agent timer to sci_timer
      isci: convert phy sata_timeout_timer to sci_timer
      isci: convert power control timer to sci_timer
      isci: convert scic_timeout_timer to sci_timer
      isci: convert phy_startup_timer to sci_timer
      isci: Remove tmf timeout_timer
      isci: remove isci_timer interface
      isci: state machine cleanup
      isci: additional state machine cleanup

 drivers/scsi/isci/Makefile                    |    3 +-
 drivers/scsi/isci/firmware/create_fw.h        |    8 +-
 drivers/scsi/isci/host.c                      |  815 +++++++++++--------------
 drivers/scsi/isci/host.h                      |   81 +--
 drivers/scsi/isci/init.c                      |   36 +-
 drivers/scsi/isci/isci.h                      |  142 ++---
 drivers/scsi/isci/phy.c                       |  311 ++++------
 drivers/scsi/isci/phy.h                       |   44 +-
 drivers/scsi/isci/port.c                      |  226 ++++----
 drivers/scsi/isci/port.h                      |   24 +-
 drivers/scsi/isci/port_config.c               |  122 ++---
 drivers/scsi/isci/probe_roms.c                |   96 ++--
 drivers/scsi/isci/probe_roms.h                |    2 +-
 drivers/scsi/isci/remote_device.c             |  349 +++++------
 drivers/scsi/isci/remote_device.h             |   34 +-
 drivers/scsi/isci/remote_node_context.c       |  156 +++---
 drivers/scsi/isci/remote_node_context.h       |   20 +-
 drivers/scsi/isci/request.c                   |  613 ++++++++++---------
 drivers/scsi/isci/request.h                   |  359 ++++++------
 drivers/scsi/isci/state_machine.c             |  162 -----
 drivers/scsi/isci/state_machine.h             |  124 ----
 drivers/scsi/isci/task.c                      |  109 +---
 drivers/scsi/isci/task.h                      |    2 -
 drivers/scsi/isci/timers.c                    |  245 --------
 drivers/scsi/isci/timers.h                    |   88 ---
 drivers/scsi/isci/unsolicited_frame_control.c |  186 ++-----
 drivers/scsi/isci/unsolicited_frame_control.h |   20 +-
 27 files changed, 1648 insertions(+), 2729 deletions(-)
 delete mode 100644 drivers/scsi/isci/state_machine.c
 delete mode 100644 drivers/scsi/isci/state_machine.h
 delete mode 100644 drivers/scsi/isci/timers.c
 delete mode 100644 drivers/scsi/isci/timers.h

commit 609f1a327d471e692f2286ce6569ba2370291705
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 19 16:44:53 2011 -0700

    Revert "isci: Add missing PCI IDs"
    
    This reverts commit c2af8ba9.  These ids are reserved for 3rd party
    vendors to deploy their own drivers.
    
    Acked-by: Havard Skinnemoen <hskinnemoen@google.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f7030d5ac2f9b2fc3e235622c311a38b4aa075ba
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 11:59:10 2011 +0000

    isci: replace isci_timer list with proper embedded timers
    
    Rather than preallocating a list of timers and doling them out at runtime,
    embed a struct timerlist in each object that needs one.  A struct sci_timer
    interface is introduced to manage the timer cancellation semantics which
    currently need to guarantee the timer is cancelled while holding
    spin_lock(ihost->scic_lock).  Since the timeout functions also need to acquire
    the lock it currently prevents the driver from using del_timer_sync() for
    runtime cancellations.
    
    del_timer_sync() is used however before the objects go out of scope.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 66a9ae8dfee11f8b8802845e94412a8266ea3b51
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 20:00:51 2011 -0700

    isci: convert port config agent timer to sci_timer
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    [squashed collateral cleanups]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2edbb65c1c91161fb02592d870b6fcdf68cd6621
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 11:59:36 2011 +0000

    isci: convert phy sata_timeout_timer to sci_timer
    
    Convert the sata_timeout_timer in the scic_sds_phy struct to
    use a struct sci_timer
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 940a12673794f35c3aa949b33885a423baa8385b
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 20:17:47 2011 -0700

    isci: convert power control timer to sci_timer
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1bd70781eb38910416706228c5053a66bfc8c1c5
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 11:59:56 2011 +0000

    isci: convert scic_timeout_timer to sci_timer
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a767e30e313744d1a9586e8392762359512ec1d8
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 20:26:02 2011 -0700

    isci: convert phy_startup_timer to sci_timer
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 18dda9d281b8370aa19a8f566a16d3bc079f9352
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 12:00:15 2011 +0000

    isci: Remove tmf timeout_timer
    
    Replace the timeout_timer in the isci_tmf with a call to
    wait_for_completion_timeout
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bde8b6f751a3d1e63f75118b063a39fc839b7159
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 19 12:00:22 2011 +0000

    isci: remove isci_timer interface
    
    Delete code which is no longer used.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a3d2722ed9ce83125c6b9605f9abc2f2d5fddeae
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 25 02:21:57 2011 +0000

    isci: removing the kmalloc in smp request construct
    
    It doesn't look like there is any reason to do a kmalloc. We can do the
    byte swap in place and avoid the allocation. This allow us to remove
    a kmalloc and a memcpy.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 048d97912579b4c8333806acaf72d1571142faa4
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 25 05:04:35 2011 +0000

    isci: Retrieve the EFI variable for OEM parameter
    
    We can call the EFI get_variable service routine directly to retrieve
    the EFI variable that holds the OEM parameters table.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0a6b9701c30ff0713187f55aa567f1212123763c
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Jun 1 09:03:08 2011 +0000

    isci: Removing unused variables compiler warnings
    
    Newer gcc's are better at identifying "set, but not used" variables.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c6f6b956b546b69bef92daf028c765d6cfee737d
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu Jun 2 00:10:43 2011 +0000

    isci: state machine cleanup
    
    This cleans up several areas of the state machine mechanism:
    
     o Rename sci_base_state_machine_change_state to sci_change_state
     o Remove sci_base_state_machine_get_state function
     o Rename 'state_machine' struct member to 'sm' in client structs
     o Shorten the name of request states
     o Shorten state machine state names as follows:
            SCI_BASE_CONTROLLER_STATE_xxx to SCIC_xxx
            SCI_BASE_PHY_STATE_xxx to SCI_PHY_xxx
            SCIC_SDS_PHY_STARTING_SUBSTATE_xxx to SCI_PHY_SUB_xxx
            SCI_BASE_PORT_STATE_xxx to SCI_PORT_xxx and
            SCIC_SDS_PORT_READY_SUBSTATE_xxx to SCI_PORT_SUB_xxx
            SCI_BASE_REMOTE_DEVICE_STATE_xxx to SCI_DEV_xxx
            SCIC_SDS_STP_REMOTE_DEVICE_READY_SUBSTATE_xxx to SCI_STP_DEV_xxx
            SCIC_SDS_SMP_REMOTE_DEVICE_READY_SUBSTATE_xxx to SCI_SMP_DEV_xxx
            SCIC_SDS_REMOTE_NODE_CONTEXT_xxx_STATE to SCI_RNC_xxx
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 291a959416dc1c6160805838b5474cdd3d3ae817
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu Jun 2 00:10:50 2011 +0000

    isci: additional state machine cleanup
    
    Additional state machine cleanups:
    
     o Remove static functions sci_state_machine_exit_state() and
       sci_state_machine_enter_state()
     o Combines sci_base_state_machine_construct() and
       sci_base_state_machine_start() into a single function,
       sci_init_sm()
     o Remove sci_base_state_machine_stop() which is unused.
     o Kill state_machine.[ch]
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    [fixed too large to inline functions]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fd8f925cf1740bdd0547ae08ee2f2cd3d5d48d20
Author: Adam Gruchala <adam.gruchala@intel.com>
Date:   Wed Jun 1 22:31:03 2011 +0000

    isci: Added support for C0 to SCU Driver
    
    C0 silicon updates the pci revision id and requires new AFE parameters
    for phy signal integrity.  Support for previous silicon revisions is
    deprecated (it's also broken for the theoretical case of multiple
    controllers at different silicon revisions, all the more reason to get
    it removed as soon as possible)
    
    Signed-off-by: Adam Gruchala <adam.gruchala@intel.com>
    [fixed up deprecated silicon support]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bc1c9bae18e900c7cfbdf6f66ff449c632ee6e4b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jun 1 16:00:01 2011 -0700

    isci: remove 'min memory' infrastructure
    
    The old 'core' had aspirations of running in severely memory constrained
    environments like bios option-rom, it's not needed for Linux and gets in
    the way of other cleanups (like unifying/reducing the number of structure
    members in scic_sds_controller/isci_host).
    
    This also fixes a theoretical bug in that the driver would blindly override
    the silicon advertised limits for number of ports, task contexts, and remote
    node contexts.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 24ddeace8923d1da9d9ea839d02afb1482f9c652
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 6 14:23:36 2011 -0700

    isci: use pci_map_biosrom
    
    Now that pci_map_biosrom is upstream we stop working around its absence.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


