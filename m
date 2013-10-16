From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/11] target_core_mod: ALUA updates
Date: Wed, 16 Oct 2013 09:20:39 +0200
Message-ID: <1381908048-82014-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

here are some updates to TCM ALUA handling. Apart from some
minor fixes and spellchecks the main features are:
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

Hannes Reinecke (11):
  target core: rename (ex,im)plict -> (ex,im)plicit
  target_core_alua: Store supported ALUA states
  target_core_alua: Make supported states configurable
  target_core_alua: Rename ALUA_ACCESS_STATE_OPTIMIZED
  target_core_alua: spellcheck
  target_core_alua: Validate ALUA state transition
  target_core_alua: Allocate ALUA metadata on demand
  target_core_alua: store old and pending ALUA state
  target_core_alua: Use workqueue for ALUA transitioning
  target_core: simplify scsi_name_len calculation
  target_core_spc: Include target device descriptor in VPD page 83

 drivers/target/target_core_alua.c      | 456 ++++++++++++++++++++-------------
 drivers/target/target_core_alua.h      |  36 ++-
 drivers/target/target_core_configfs.c  |  76 +++++-
 drivers/target/target_core_device.c    |   6 +-
 drivers/target/target_core_file.c      |   2 +-
 drivers/target/target_core_pr.c        |  24 +-
 drivers/target/target_core_spc.c       |  62 ++++-
 drivers/target/target_core_transport.c |   4 +-
 drivers/target/target_core_ua.h        |   2 +-
 include/target/target_core_base.h      |  14 +-
 10 files changed, 442 insertions(+), 240 deletions(-)

-- 
1.7.12.4
