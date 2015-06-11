From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] target: Update UA handling
Date: Thu, 11 Jun 2015 10:01:23 +0200
Message-ID: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

lio-target is very minimalistic when it comes to generate UAs;
primarily they are generated for persistent reservations, but
generic changes tend to be ignored.

This patchset updates the UA handling and generates UA for internal
state changes (REPORTED LUNS DATA CHANGED, INQUIRY DATA CHANGED,
and LUN RESET OCCURRED).

Funnily enough this triggers some issues with the SCSI stack;
I'll be sending out patches for that, too.

Hannes Reinecke (6):
  target_core_alua: Correct UA handling when switching states
  target: Remove 'ua_nacl' pointer from se_ua structure
  target: use 'se_dev_entry' when allocating UAs
  target: Send UA on ALUA target port group change
  target: Send UA upon LUN RESET tmr completion
  target: Send UA when changing LUN inventory

 drivers/target/target_core_alua.c      | 56 +++++++++++++++++++++++++---------
 drivers/target/target_core_device.c    | 26 +++++++++++++++-
 drivers/target/target_core_pr.c        | 31 +++++++++++++++----
 drivers/target/target_core_transport.c | 29 ++++++++++++++----
 drivers/target/target_core_ua.c        | 24 ++-------------
 drivers/target/target_core_ua.h        |  5 ++-
 include/target/target_core_base.h      |  1 -
 7 files changed, 121 insertions(+), 51 deletions(-)

-- 
1.8.5.2
