From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.8-rc7
Date: Fri, 01 Feb 2013 13:33:24 -0800
Message-ID: <1359754404.6300.103.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here's the current set of v3.8-rc fixes in the target-pending.git queue.
Apologies in advance for these missing the -rc6 release, and having to
be destined for -rc7 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The majority of these patches are regression bugfixes specific to
v3.8-rc code changes, namely the zero-length CDB handling breakage after
the sense_reason_t conversion, and preventing configfs port linking for
unconfigured devices after the recent struct se_subsystem_dev removal.  
These is also one (the divide by zero bug for unconfigured devices) that
is CC'ed to stable.

Thank you,

--nab

Michael S. Tsirkin (1):
  tcm_vhost: fix pr_err on early kick

Nicholas Bellinger (5):
  target: Fix zero-length INQUIRY additional sense code regression
  target: Fix zero-length MODE_SENSE regression
  target: Fix zero-length READ_CAPACITY_16 regression
  target: Fix regression allowing unconfigured devices to fabric port
    link
  target: Fix divide by zero bug in fabric_max_sectors for unconfigured
    devices

 drivers/target/target_core_device.c          |    8 ++++-
 drivers/target/target_core_fabric_configfs.c |    5 +++
 drivers/target/target_core_sbc.c             |   18 +++++------
 drivers/target/target_core_spc.c             |   44 ++++++-------------------
 drivers/vhost/tcm_vhost.c                    |    4 +--
 5 files changed, 32 insertions(+), 47 deletions(-)
