From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.2-rc7
Date: Tue, 18 Aug 2015 22:48:09 -0700
Message-ID: <1439963289.28553.124.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target-pending fixes for v4.2-rc7 code.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

It contains a v4.2-rc specific RCU module unload regression bug-fix, a
long-standing iscsi-target bug-fix for duplicate target_xfer_tags during
NOP processing from Alexei, and two more small REPORT_LUNs emulation
related patches to make Solaris FC host LUN scanning happy from Roland.

There is also one patch not included that allows target-core to limit
the number of fabric driver SGLs per I/O request using residuals, that
is currently required as a work-around for FC hosts which don't honor
EVPD block-limits settings.  At this point, it will most likely become
for-next material.

Thank you,

--nab

Alexei Potashnik (1):
  target/iscsi: Fix double free of a TUR followed by a solicited NOPOUT

Nicholas Bellinger (1):
  target: Perform RCU callback barrier before backend/fabric unload

Roland Dreier (2):
  target: REPORT LUNS should return LUN 0 even for dynamic ACLs
  target: Fix handling of small allocation lengths in REPORT LUNS

 drivers/target/iscsi/iscsi_target.c   |  4 ++--
 drivers/target/target_core_configfs.c |  9 ++++++-
 drivers/target/target_core_hba.c      | 10 +++++++-
 drivers/target/target_core_spc.c      | 44 ++++++++++++++++++++---------------
 4 files changed, 44 insertions(+), 23 deletions(-)
