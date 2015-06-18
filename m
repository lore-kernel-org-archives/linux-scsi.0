From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/8] tcm_loop updates
Date: Thu, 18 Jun 2015 11:43:34 +0200
Message-ID: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

As tcm_loop claims to be a SAS HBA I thought it a good idea to
hook it into the SAS transport class, so that we have the entire
(virtual) SAS topology in sysfs now.
And even lsscsi is happy:

# lsscsi -H -t
[10]    tcm_loopback  sas:0x6001405cc9332c5a
# lsscsi -t
[10:0:0:0]   disk    sas:0x6001405e41925ad3          /dev/sdf 
[10:0:1:0]   disk    sas:0x6001405e41925ad3          /dev/sdg 

I've also included some pending fixes / updates I did for
LIO target, mostly done to reproduce issues I've been facing:
- Disallow READ CAPACITY in standby
  This is a long-standing issue with the linux SCSI stack and
  multipathing, both assuming that READ CAPACITY will always
  succeed. With that patch we can finally debug and fix this.
- Export the 'write_protect' attribute for demo-mode LUNs
- Some more UAs to be issued

As usual, reviews and comments are welcome.

Hannes Reinecke (8):
  tcm_loop: Hook into SAS transport class
  tcm_loop: Add SAS transport topology
  tcm_loop: Remove SAS vestigies
  tcm_loop: Send I_T_NEXUS_LOSS_OCCURRED UA
  tcm_loop: Rescan SCSI target on transport online
  target: Issue Power-On/Reset UA upon LUN instantiation
  target_core_alua: disallow READ_CAPACITY when in standby
  target: display 'write_protect' attribute for demo-mode LUNs

 drivers/target/loopback/tcm_loop.c           | 186 +++++++++++++++++++++++----
 drivers/target/loopback/tcm_loop.h           |   3 +
 drivers/target/target_core_alua.c            |   9 --
 drivers/target/target_core_device.c          |  43 ++++++-
 drivers/target/target_core_fabric_configfs.c |  42 ++++++
 drivers/target/target_core_internal.h        |   1 +
 drivers/target/target_core_tpg.c             |  17 +++
 include/target/target_core_fabric.h          |   1 +
 8 files changed, 261 insertions(+), 41 deletions(-)

-- 
1.8.5.2
