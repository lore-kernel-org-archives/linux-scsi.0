From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/3] target: Miscellaneous XCOPY bugfixes for v3.12-rc7 code
Date: Thu, 24 Oct 2013 07:30:56 +0000
Message-ID: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

The following series is a handful XCOPY related fixes for v3.12-rc7 code
based upon a recent bug-report from Thomas + Doug wrt to XCOPY local I/O
operations across source + destination devices with non-matching block_sizes.

The first patch adds the missing XCOPY I/O operation sense_buffer setup
that was triggering the original OOPs.  The second patch addresses the
case where a non-zero scsi_status was incorrectly returning GOOD status
for locally generated XCOPY I/O exceptions.

The final patch adds an explicit check + failure for XCOPY operations across
source + destination devices with non-matching block_sizes.

Note this limitiation is currently due to the fact that the scatterlist
memory allocated for the XCOPY READ operation is passed zero-copy for use
by the subsequent XCOPY WRITE operation.  For v3.12 code it makes sense to
go ahead and explicitly prevent this from occurring, and the plan is to add
a slow-path memcpy to address this special case in post v3.12 code.

Thanks!

--nab

Nicholas Bellinger (3):
  target: Add missing XCOPY I/O operation sense_buffer
  target: Generate failure for XCOPY I/O with non-zero scsi_status
  target: Fail XCOPY for non matching source + destination block_size

 drivers/target/target_core_xcopy.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

-- 
1.7.2.5
