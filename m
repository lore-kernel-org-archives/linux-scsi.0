From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] st: trivial: remove form feed characters
Date: Wed,  4 Nov 2015 10:52:13 +0100
Message-ID: <1446630733-19305-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbbKDJwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2015 04:52:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/st.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b37b9b0..7c4e518 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -226,7 +226,6 @@ static DEFINE_SPINLOCK(st_use_lock);
 static DEFINE_IDR(st_index_idr);
 
 
-

 #include "osst_detect.h"
 #ifndef SIGS_FROM_OSST
 #define SIGS_FROM_OSST \
@@ -305,7 +304,6 @@ static char * st_incompatible(struct scsi_device* SDp)
 		}
 	return NULL;
 }
-

 
 static inline char *tape_name(struct scsi_tape *tape)
 {
@@ -877,7 +875,7 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	return result;
 
 }
-

+
 /* Set the mode parameters */
 static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 {
@@ -952,7 +950,7 @@ static void reset_state(struct scsi_tape *STp)
 		STp->new_partition = STp->partition;
 	}
 }
-

+
 /* Test if the drive is ready. Returns either one of the codes below or a negative system
    error code. */
 #define CHKRES_READY       0
@@ -1241,7 +1239,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 }
 
 
-
/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
+/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
    module count. */
 static int st_open(struct inode *inode, struct file *filp)
 {
@@ -1334,7 +1332,6 @@ static int st_open(struct inode *inode, struct file *filp)
 	return retval;
 
 }
-

 
 /* Flush the tape buffer before close */
 static int st_flush(struct file *filp, fl_owner_t id)
@@ -1470,7 +1467,7 @@ static int st_release(struct inode *inode, struct file *filp)
 
 	return result;
 }
-

+
 /* The checks common to both reading and writing */
 static ssize_t rw_checks(struct scsi_tape *STp, struct file *filp, size_t count)
 {
@@ -1889,7 +1886,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 
 	return retval;
 }
-

+
 /* Read data from the tape. Returns zero in the normal case, one if the
    eof status has changed, and the negative error code in case of a
    fatal error. Otherwise updates the buffer and the eof state.
@@ -2085,7 +2082,6 @@ static long read_tape(struct scsi_tape *STp, long count,
 	}
 	return retval;
 }
-

 
 /* Read command */
 static ssize_t
@@ -2233,7 +2229,6 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	return retval;
 }
-

 
 
 DEB(
@@ -2447,7 +2442,7 @@ static int st_set_options(struct scsi_tape *STp, long options)
 
 	return 0;
 }
-

+
 #define MODE_HEADER_LENGTH  4
 
 /* Mode header and page byte offsets */
@@ -2665,7 +2660,7 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 
 	return retval;
 }
-

+
 #if DEBUG
 #define ST_DEB_FORWARD  0
 #define ST_DEB_BACKWARD 1
@@ -3091,7 +3086,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 
 	return ioctl_result;
 }
-

 
 /* Get the tape position. If bt == 2, arg points into a kernel space mt_loc
    structure. */
@@ -3283,7 +3277,7 @@ static int switch_partition(struct scsi_tape *STp)
 		STps->last_block_visited = 0;
 	return set_location(STp, STps->last_block_visited, STp->new_partition, 1);
 }
-

+
 /* Functions for reading and writing the medium partition mode page. */
 
 #define PART_PAGE   0x11
@@ -3396,7 +3390,6 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 	return result;
 }
-

 
 
 /* The ioctl command */
@@ -3766,7 +3759,6 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
 }
 #endif
 
-

 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
-- 
Maurizio Lombardi

