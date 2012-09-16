From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.6-rc6
Date: Sat, 15 Sep 2012 17:37:22 -0700
Message-ID: <1347755842.10711.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Fengguang Wu <wfg@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here is the current set of target-pending fixes headed for v3.6-final.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The main parts of this series include bug-fixes from Paolo Bonzini to
address an use-after-free bug in pSCSI sense exception handling, along
with addressing some long-standing bugs wrt the handling of zero-length
SCSI CDB payloads also specific to pSCSI pass-through device backends.

A heads up that the following patch of the series:

target: go through normal processing for zero-length PSCSI commands
http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=306c11b28d7bb85a7adda741798a2b6b60dd305a

does not compile due to a minor syntax error in the original patch, that
unfortunately had already been pushed to target-pending/master before
being caught by Wu's 0-day build script.

So it's ultimately my fault for not catching this during review +
testing, and to avoid this in the future if I don't have the immediate
time to compile test each patch headed into master, they will now go
into target-pending/queue (for a day or two) so that the 0-day build
scripts can do their thing and notify us of bi-sectable trouble ahead of
time.

Please let me know if you'd prefer a re-spin branch to address this, or
if you'd rather fix this up on your end before pushing.

Thank you,

--nab

Benjamin Wang (1):
  target: Check idr_get_new return value in iscsi_login_zero_tsih_s1

Nicholas Bellinger (1):
  target: Fix ->data_length re-assignment bug with SCSI overflow

Paolo Bonzini (9):
  target: move transport_get_sense_data
  target: simplify code around transport_get_sense_data
  target: fix use-after-free with PSCSI sense data
  target: go through normal processing for zero-length PSCSI commands
  target: report too-small parameter lists everywhere
  target: fail REPORT LUNS with less than 16 bytes of payload
  target: support zero-size allocation lengths in
    transport_kmap_data_sg
  target: support zero allocation length in REQUEST SENSE
  target: go through normal processing for zero-length REQUEST_SENSE

 drivers/target/iscsi/iscsi_target_login.c |   11 ++-
 drivers/target/target_core_alua.c         |    7 ++
 drivers/target/target_core_device.c       |    7 ++
 drivers/target/target_core_iblock.c       |   17 +++-
 drivers/target/target_core_pr.c           |    8 ++
 drivers/target/target_core_pscsi.c        |   29 ++----
 drivers/target/target_core_spc.c          |   35 ++++----
 drivers/target/target_core_transport.c    |  148 ++++++++++++-----------------
 include/target/target_core_backend.h      |    4 +-
 include/target/target_core_base.h         |    1 +
 10 files changed, 141 insertions(+), 126 deletions(-)
