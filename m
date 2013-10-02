From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/3] target: Fixes for COMPARE_AND_WRITE backend I/O failure cases
Date: Wed,  2 Oct 2013 00:13:13 +0000
Message-ID: <1380672796-437-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series addresses a handful of COMPARE_AND_WRITE backend I/O failure
handling bugs reported recently by Thomas Glanzmann.

This includes a data_length handling bug that was specific to FILEIO
backends, and recursive callback bug that ended up triggered a double
complete OOPs, and another compare_and_write_callback() specific check
to avoid a bug with asychronous IBLOCK bio completion failures.

With these fixes in place, COMPARE_AND_WRITE emulation should now be
handling all backend specific I/O failure cases correctly.

Thomas, these are all fairly obvious fixes to me, and I've been able
to confirm them on my setup.  Please confirm on your end, and I'll
plan to push them for v3.12-rc4 by the end of the week.

Thanks!

--nab

Nicholas Bellinger (3):
  target: Reset data_length for COMPARE_AND_WRITE to NoLB * block_size
  target: Fix recursive COMPARE_AND_WRITE callback failure
  target: Fail on non zero scsi_status in compare_and_write_callback

 drivers/target/target_core_sbc.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

-- 
1.8.4.rc3
