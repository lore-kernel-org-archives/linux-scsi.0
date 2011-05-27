From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] mptsas: Increase MPT_SAS_CAN_QUEUE
Date: Fri, 27 May 2011 12:52:15 -0700
Message-ID: <20110527195215.GR20579@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It seems that can_queue on mptsas controllers is clamped to 128 even though the
hardware can have much larger queues.  Clamp to a higher value to utilize the
hardware more effectively--with a large number of disks I see contention for
queue slots, and with the higher clamp I don't.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/message/fusion/mptbase.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index fe90233..5d8c57e 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -159,7 +159,7 @@
  */
 #define MPT_FC_CAN_QUEUE	1024
 #define MPT_SCSI_CAN_QUEUE	127
-#define MPT_SAS_CAN_QUEUE	127
+#define MPT_SAS_CAN_QUEUE	511
 
 /*
  * Set the MAX_SGE value based on user input.
