From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: remote_device state_handlers and base_object removal
Date: Tue, 03 May 2011 09:45:42 -0700
Message-ID: <1304441142.20102.12.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6501 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1ECQ3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2011 12:29:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Christoph Hellwig <hch@lst.de>

The re-factoring continues, diffstat tells the story.

The following changes since commit e1577d24adf3500e36f789526113caac3dd9e8e0:

  isci: fix CONFIG_EFI=n compile error (2011-04-26 16:58:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Dan Williams (19):
      isci: merge remote_device substates into a single state machine
      isci: kill scic_remote_device_get_connection_rate
      isci: fix remote_device start_io regressions
      isci: unify remote_device start_handlers
      isci: unify remote_device stop_handlers
      isci: kill remote_device fail_handler
      isci: unify remote_device destruct_handlers
      isci: unify remote_device reset_handlers
      isci: unify remote_device reset_complete_handlers
      isci: unify remote_device start_io_handlers
      isci: unify remote_device complete_io_handlers
      isci: kill remote_device continue_io_handler
      isci: unify remote_device start_task_handlers
      isci: kill remote_device complete_task_handler
      isci: unify remote_device suspend_handlers
      isci: kill remote_device resume_handler
      isci: unify remote_device event_handlers
      isci: unify remote_device frame_handlers
      isci: kill scic_sds_remote_device.state_handlers

Maciej Patelczyk (9):
      isci: Implement SCU AFE recipe 10.
      isci: Removed struct sci_base_object from state machine.
      isci: Removed sci_base_object from scic_sds_controller.
      isci: Removed sci_base_object from scic_sds_phy.
      isci: Removed sci_base_object from scic_sds_port.
      isci: Removed sci_base_object from scic_sds_remote_device.
      isci: Removed sci_base_object from scic_sds_remote_node_context.
      isci: Removed sci_base_object from scic_sds_request.
      isci: Removed sci_object.h from project.

 drivers/scsi/isci/Makefile                         |    2 -
 drivers/scsi/isci/core/sci_base_state.h            |   10 +-
 drivers/scsi/isci/core/sci_base_state_machine.c    |    2 +-
 drivers/scsi/isci/core/sci_base_state_machine.h    |    4 +-
 drivers/scsi/isci/core/sci_object.h                |   98 --
 drivers/scsi/isci/core/sci_util.c                  |    5 +-
 drivers/scsi/isci/core/scic_io_request.h           |    9 +-
 drivers/scsi/isci/core/scic_sds_controller.c       |   89 +-
 drivers/scsi/isci/core/scic_sds_controller.h       |    8 +-
 drivers/scsi/isci/core/scic_sds_phy.c              |  198 +--
 drivers/scsi/isci/core/scic_sds_phy.h              |    5 +-
 drivers/scsi/isci/core/scic_sds_port.c             |  141 +-
 drivers/scsi/isci/core/scic_sds_port.h             |    8 +-
 .../isci/core/scic_sds_port_configuration_agent.c  |    2 +-
 drivers/scsi/isci/core/scic_sds_request.c          |   78 +-
 drivers/scsi/isci/core/scic_sds_request.h          |    6 +-
 drivers/scsi/isci/core/scic_sds_smp_request.c      |   20 +-
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |   12 +-
 drivers/scsi/isci/core/scic_sds_stp_request.c      |   57 +-
 drivers/scsi/isci/host.c                           |    2 +-
 drivers/scsi/isci/isci.h                           |    1 -
 drivers/scsi/isci/phy.c                            |    3 +-
 drivers/scsi/isci/port.c                           |   16 +-
 drivers/scsi/isci/remote_device.c                  | 1812 ++++++++------------
 drivers/scsi/isci/remote_device.h                  |  364 +----
 drivers/scsi/isci/remote_node_context.c            |   55 +-
 drivers/scsi/isci/remote_node_context.h            |    5 -
 drivers/scsi/isci/request.c                        |    4 +-
 drivers/scsi/isci/sci_environment.h                |   17 +-
 drivers/scsi/isci/smp_remote_device.c              |  314 ----
 drivers/scsi/isci/stp_remote_device.c              |  723 --------
 drivers/scsi/isci/task.c                           |    7 +-
 32 files changed, 1084 insertions(+), 2993 deletions(-)
 delete mode 100644 drivers/scsi/isci/core/sci_object.h
 delete mode 100644 drivers/scsi/isci/smp_remote_device.c
 delete mode 100644 drivers/scsi/isci/stp_remote_device.c


commit f7c5b6574c048a362a467f26156c6a2ce6233540
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Wed Apr 27 17:50:50 2011 +0000

    isci: Implement SCU AFE recipe 10.
    
    Updated SCU AFE initialization values accordingly to the recipe 10.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b3c54132a250b1f30fa072c330936e2e9ffa188f
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:01 2011 +0000

    isci: Removed struct sci_base_object from state machine.
    
    Changed any occurrence of struct sci_base_object into void.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0493b1b3771e91f9eafdaba49a8cf587f409572c
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:06 2011 +0000

    isci: Removed sci_base_object from scic_sds_controller.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_controller and was replaced by a pointer to
    struct isci_host.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3ba7589df279c2b40493b2e0172d94883048a8e4
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:11 2011 +0000

    isci: Removed sci_base_object from scic_sds_phy.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_phy and was replaced by a pointer to
    struct isci_phy.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 55c317c999e32b445054b15e0c5285cd921cfb35
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:16 2011 +0000

    isci: Removed sci_base_object from scic_sds_port.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_port and was replaced by a pointer to
    struct isci_port.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bb4b3e74e806984f5983ec94cc9a772b373b440e
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:21 2011 +0000

    isci: Removed sci_base_object from scic_sds_remote_device.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_remote_device.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    [cleaned up sci_dev_to_idev]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a82a6f0e6d5efbe18550454c85e6fa49cef40c7a
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:26 2011 +0000

    isci: Removed sci_base_object from scic_sds_remote_node_context.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_remote_node_context.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b04156f0dd9c348cc7511f67d12090faeb738f69
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:31 2011 +0000

    isci: Removed sci_base_object from scic_sds_request.
    
    The 'struct sci_base_object' was removed from the struct
    scic_sds_request and was replaced by a pointer to
    struct isci_request.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 60390210b4ee71874bdef2012e85f73115ac3ae6
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Thu Apr 28 22:06:36 2011 +0000

    isci: Removed sci_object.h from project.
    
    The sci_object.h file was removed. No sci_base_object
    is now in the code.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0879e6a69eda16c9729578a7d8afc0ed06bb65b0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Apr 27 16:32:45 2011 -0700

    isci: merge remote_device substates into a single state machine
    
    A substate is just a state, so uplevel the smp and stp device substates.
    Three tricks at work here:
    
    1/ scic_sds_remote_device_ready_state_enter: needs to know the the device type
       so it can immediately transition to a stp or smp ready substate.
    
    2/ scic_sds_remote_device_ready_state_exit: needs to know the device type. In
       the ssp case the device is no longer ready, in the stp, and smp case we have
       simply exited to a ready "substate".
    
    3/ scic_sds_remote_device_resume_complete_handler: The one location
       where we directly check the current state against
       SCI_BASE_REMOTE_DEVICE_STATE_READY needed to comprehend the possible ready
       substates.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit edda4fe6bee1365af97a535d0cd1cf3b26dc6f36
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 29 13:20:30 2011 -0700

    isci: kill scic_remote_device_get_connection_rate
    
    A function call to dereference a pointer is a tad much.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cbe330c22482936b4d9cce18b973144dae9da7d7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 10:13:04 2011 -0700

    isci: fix remote_device start_io regressions
    
    While reducing indentation commits 21eabe03 "isci: make a
    remote_node_context a proper member of a remote_device", 0879e6a6 "isci:
    merge remote_device substates into a single state machine" broke
    handling of situations where i/o's successfully started at the port
    level need to terminated when the remote_node declines to start the i/o.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bf6866754cd56093120968e3de4b71fec68f1a6e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:05:57 2011 -0700

    isci: unify remote_device start_handlers
    
    Implement all states in scic_remote_device_start() and delete the state
    handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 08156321312d8f8a7648f37e5c282e0956ff001b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:19:25 2011 -0700

    isci: unify remote_device stop_handlers
    
    Implement all states in scic_remote_device_stop() and delete the state
    handlers.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a3190f31c13bccb9b6f192815f00c722b8627d18
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:35:43 2011 -0700

    isci: kill remote_device fail_handler
    
    This is just unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6169b2a8d5c41046ebdcdb2f2a4e5b07c4fdebf8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:38:26 2011 -0700

    isci: unify remote_device destruct_handlers
    
    Implement all states in scic_remote_device_destruct() and delete the state
    handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a91a4f2f2d7db045ea98ec923d3b488140b4e9c0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:48:54 2011 -0700

    isci: unify remote_device reset_handlers
    
    Implement all states in scic_remote_device_reset() and delete the state
    handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7fde916c3d4105efbf1b3b4dff8a5877814c2760
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:53:00 2011 -0700

    isci: unify remote_device reset_complete_handlers
    
    Implement all states in scic_remote_device_reset_complete() and delete the
    state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9d552511ffde8f8f314df08428529b73664e6a50
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 14:57:11 2011 -0700

    isci: unify remote_device start_io_handlers
    
    Implement all states in scic_sds_remote_device_start_io() and delete the
    state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1541edcdf905a5ab53e93b3d66f36ab60b442284
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 15:33:43 2011 -0700

    isci: unify remote_device complete_io_handlers
    
    Implement all states in scic_sds_remote_device_complete_io() and delete
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 688168061881ad3abf918dbe31d418b4a603a0c1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 15:46:18 2011 -0700

    isci: kill remote_device continue_io_handler
    
    This is unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e2d72f5002fd3052f50cbffecd66bd155924d90f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 15:53:25 2011 -0700

    isci: unify remote_device start_task_handlers
    
    Implement all states in scic_sds_remote_device_start_task() and delete
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d7e65ea1ceef6577b1fc69b610b440c75559851a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:01:05 2011 -0700

    isci: kill remote_device complete_task_handler
    
    This is unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit de4f84b4f43a6435c293d02f1b6c20534707be62
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:15:47 2011 -0700

    isci: unify remote_device suspend_handlers
    
    Implement all states in scic_sds_remote_device_suspend() and delete
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 860ec34706ddbe54ab1661d1e6cf185a317afce2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:20:54 2011 -0700

    isci: kill remote_device resume_handler
    
    This is unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2b1d46b434b0a60c9371f250c35acef78f3e1cde
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:26:09 2011 -0700

    isci: unify remote_device event_handlers
    
    Implement all states in scic_sds_remote_device_event() and delete
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0f7ff148ce5da7025986b756625c7db5cce94361
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:51:11 2011 -0700

    isci: unify remote_device frame_handlers
    
    Implement all states in scic_sds_remote_device_frame() and delete
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 364815082e2069616a6129bc4e59a1e80e33853f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 1 16:58:46 2011 -0700

    isci: kill scic_sds_remote_device.state_handlers
    
    Remove the now unused state_handler infrastructure for remote_devices.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


