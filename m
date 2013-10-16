From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] TCM Referrals support
Date: Wed, 16 Oct 2013 09:25:22 +0200
Message-ID: <1381908324-82135-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: Doug Gilber <dgilbert@interlog.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

I've finally bitten the bullet and implemented referrals
support for TCM. It has been on my to-do list for a long
time, but finally I've gotten around to actually _do_ anything about it.

TCM now will enable referrals support when an appropriate
map is being fed into 'lba_map'. Format there is:
  <segment size> <segment multiplier>
  <start lba> <end lba> <pgX:stateY> ... <pgN:stateM>
  ...
  
<pgX> is the number of the first target port group,
<stateY> is a character denominating the ALUA access state:
'O' for 'Active/Optimized', 'A' for 'Active/Non-Optimized',
'S' for 'Standby', and 'U' for 'Unavailable'.
For further details see SBC-3, Section 'Referrals'.
  
Yes, I know, it's far from perfect and violates the
'one item per attribute' rule. But breaking this
down into several attributes and ensure the update
is done consistently _and_ atomically is beyond my
configfs skills. So there.

Hannes Reinecke (2):
  target_core_alua: Referrals infrastructure
  target_core_alua: Referrals configfs integration

 drivers/target/target_core_alua.c      | 252 +++++++++++++++++++++++++++++++++
 drivers/target/target_core_alua.h      |  12 +-
 drivers/target/target_core_configfs.c  | 183 +++++++++++++++++++++++-
 drivers/target/target_core_device.c    |   3 +
 drivers/target/target_core_sbc.c       |   5 +-
 drivers/target/target_core_spc.c       |  20 +++
 drivers/target/target_core_transport.c |  28 +++-
 include/scsi/scsi.h                    |   1 +
 include/target/target_core_base.h      |  18 +++
 9 files changed, 517 insertions(+), 5 deletions(-)

-- 
1.7.12.4
