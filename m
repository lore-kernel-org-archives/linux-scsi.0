From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL -v2] target fixes for v3.11
Date: Fri, 30 Aug 2013 20:53:10 -0700
Message-ID: <1377921190.32763.327.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, CAD <cad.ext@larioja.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here is a -v2 PULL request for the current set of target-pending fixes
for v3.11.  These fixes have not hit mainline yet, so I'm resending them
now to be sure they hit v3.11 before the merge window opens.  Please let
me know if you have any concerns with the series.

The original PULL request from last Saturday is here:

http://marc.info/?l=linux-kernel&m=137737916904812&w=2

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The first patch is to address a long standing issue where INQUIRY vendor
+ model response data was not correctly padded with ASCII spaces,
causing MSFT and Falconstor multipath stacks to not function with our
LUNs.

The remaining patches are additional iscsi-target regression fixes for
the post >= v3.10 iser-target changes.  The second and third are failure
cases that have appeared during further testing, and the forth is only
reproducible with malformed NOP packets.

The last three patches are CC'ed to stable, and the first one will be
sent to Greg-KH separately.

Thank you,

--nab

Nicholas Bellinger (4):
  target: Fix trailing ASCII space usage in INQUIRY vendor+model
  iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
  iscsi-target: Fix iscsit_transport reference leak during NP thread
    reset
  iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject

 drivers/target/iscsi/iscsi_target.c       |   17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 drivers/target/target_core_spc.c          |    9 ++++++---
 3 files changed, 20 insertions(+), 15 deletions(-)
