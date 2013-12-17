From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 0/8] Referrals support
Date: Tue, 17 Dec 2013 09:18:42 +0100
Message-ID: <1387268330-121064-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

as discussed here is now the third version of the referrals
infrastructure. All the configfs layout changes have been
removed as requested.

Main features of this patchset:

- Asynchronous transitioning: I've switched 'transitioning'
  handling to use a workqueue, that should allow us to simulate
  asynchronous transitioning modes. IE TCM should now be capable
  of handling requests while in transitioning, and properly terminate
  these with the correct sense code.
- Include target device descriptor in VPD page 83
  For the ALUA device handler we'd need to identify the target device
  where a given target port belongs to. So include the respective
  values in the VPD page.
- Referrals support: Adding a new configfs attribute 'lba_map'
  which contains the referrals access mapping. The 'LBD Dependent'
  ALUA state can only be selected if an lba_map is present; also
  explicit ALUA has to be disabled.

Hannes Reinecke (8):
  target_core_alua: validate ALUA state transition
  target_core_alua: Allocate ALUA metadata on demand
  target_core_alua: store old and pending ALUA state
  target_core_alua: Use workqueue for ALUA transitioning
  target_core: simplify scsi_name_len calculation
  target_core_spc: Include target device descriptor in VPD page 83
  target_core_alua: Referrals infrastructure
  target_core_alua: Referrals configfs integration

 drivers/target/target_core_alua.c      | 546 +++++++++++++++++++++++++++------
 drivers/target/target_core_alua.h      |  15 +-
 drivers/target/target_core_configfs.c  | 180 ++++++++++-
 drivers/target/target_core_device.c    |   3 +
 drivers/target/target_core_sbc.c       |   5 +-
 drivers/target/target_core_spc.c       |  76 ++++-
 drivers/target/target_core_transport.c |  28 +-
 include/scsi/scsi.h                    |   1 +
 include/target/target_core_base.h      |  27 +-
 9 files changed, 770 insertions(+), 111 deletions(-)

-- 
1.7.12.4
