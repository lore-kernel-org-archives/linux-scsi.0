From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 00/18] ALUA update and Referrals support
Date: Tue, 19 Nov 2013 09:07:45 +0100
Message-ID: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

here's the second version of my ALUA update & Referrals support patches.
As per request I've split up the supported states into individual
attributes, and while there I've also renamed the rather confusing
'alua_access_type' and 'alua_access_status' into 'alua_management_type'
and 'alua_status_modification', respectively.

The other features are:

- Make supported states configurable:
  We should make the list of supported ALUA states configurable,
  as some setups would possibly like to support a small subset
  of ALUA states only.
- Asynchronous transitioning: I've switched 'transitioning'
  handling to use a workqueue, that should allow us to simulate
  asynchronous transitioning modes. IE TCM should now be capable
  of handling requests while in transitioning, and properly terminate
  these with the correct sense code.
- Include target device descriptor in VPD page 83
  For the ALUA device handler we'd need to identify the target device
  where a given target port belongs to. So include the respective
  values in the VPD page.

And, of course, referrals support.

Hannes Reinecke (18):
  target core: rename (ex,im)plict -> (ex,im)plicit
  target_core_alua: spellcheck
  target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
  target_core_alua: Store supported ALUA states
  target_core_alua: Make supported states configurable
  target_core_configfs: split up ALUA supported states
  target_core_configfs: Verbose ALUA state display
  target_core_configfs: Split up ALUA access type
  target_core: Rename alua_access_type in alua_mgmt_type
  target_core: Rename alua_access_status to alua_status_modification
  target_core_alua: Validate ALUA state transition
  target_core_alua: Allocate ALUA metadata on demand
  target_core_alua: store old and pending ALUA state
  target_core_alua: Use workqueue for ALUA transitioning
  target_core: simplify scsi_name_len calculation
  target_core_spc: Include target device descriptor in VPD page 83
  target_core_alua: Referrals infrastructure
  target_core_alua: Referrals configfs integration

 drivers/target/target_core_alua.c      | 764 +++++++++++++++++++++++----------
 drivers/target/target_core_alua.h      |  55 ++-
 drivers/target/target_core_configfs.c  | 360 ++++++++++++++--
 drivers/target/target_core_device.c    |   9 +-
 drivers/target/target_core_file.c      |   2 +-
 drivers/target/target_core_pr.c        |  24 +-
 drivers/target/target_core_sbc.c       |   5 +-
 drivers/target/target_core_spc.c       |  84 +++-
 drivers/target/target_core_transport.c |  32 +-
 drivers/target/target_core_ua.h        |   2 +-
 include/scsi/scsi.h                    |   1 +
 include/target/target_core_base.h      |  34 +-
 12 files changed, 1050 insertions(+), 322 deletions(-)

-- 
1.7.12.4
