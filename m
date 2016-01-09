From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 3/6] scsi: bfa: Use 'ktime_get_real_seconds()'
Date: Sat, 9 Jan 2016 20:01:06 +0530
Message-ID: <20160109143106.GA7491@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

This patch replaces u32 time storing variable with u64 variable to
store the 64 bit seconds value returned by ktime_get_real_seconds().

A cast to time_t has also been added to the assignment statement
which will cause a build error when we eventually remove the time_t
definition from the kernel.

We can't change the layout of the structure retrieving profile
data as it is being used in a vendor specific command that can get
sent from user space.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/scsi/bfa/bfa_fcpim.c | 6 +++---
 drivers/scsi/bfa/bfa_fcpim.h | 4 ++--
 drivers/scsi/bfa/bfad_bsg.c  | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index d7385d1..6730340 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -468,7 +468,7 @@ bfa_ioim_profile_start(struct bfa_ioim_s *ioim)
 }
 
 bfa_status_t
-bfa_fcpim_profile_on(struct bfa_s *bfa, u32 time)
+bfa_fcpim_profile_on(struct bfa_s *bfa, u64 time)
 {
 	struct bfa_itnim_s *itnim;
 	struct bfa_fcpim_s *fcpim = BFA_FCPIM(bfa);
@@ -1478,8 +1478,8 @@ bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
 		return BFA_STATUS_IOPROFILE_OFF;
 
 	itnim->ioprofile.index = BFA_IOBUCKET_MAX;
-	itnim->ioprofile.io_profile_start_time =
-				bfa_io_profile_start_time(itnim->bfa);
+	itnim->ioprofile.io_profile_start_time = (u32)(time_t)
+					bfa_io_profile_start_time(itnim->bfa);
 	itnim->ioprofile.clock_res_mul = bfa_io_lat_clock_res_mul;
 	itnim->ioprofile.clock_res_div = bfa_io_lat_clock_res_div;
 	*ioprofile = itnim->ioprofile;
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index e693af6..274e3af 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -135,7 +135,7 @@ struct bfa_fcpim_s {
 	struct bfa_fcpim_del_itn_stats_s del_itn_stats;
 	bfa_boolean_t		ioredirect;
 	bfa_boolean_t		io_profile;
-	u32			io_profile_start_time;
+	u64			io_profile_start_time;
 	bfa_fcpim_profile_t     profile_comp;
 	bfa_fcpim_profile_t     profile_start;
 };
@@ -309,7 +309,7 @@ bfa_status_t bfa_fcpim_port_iostats(struct bfa_s *bfa,
 			struct bfa_itnim_iostats_s *stats, u8 lp_tag);
 void bfa_fcpim_add_stats(struct bfa_itnim_iostats_s *fcpim_stats,
 			struct bfa_itnim_iostats_s *itnim_stats);
-bfa_status_t bfa_fcpim_profile_on(struct bfa_s *bfa, u32 time);
+bfa_status_t bfa_fcpim_profile_on(struct bfa_s *bfa, u64 time);
 bfa_status_t bfa_fcpim_profile_off(struct bfa_s *bfa);
 
 #define bfa_fcpim_ioredirect_enabled(__bfa)				\
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 023b9d4..92f5b0f 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -15,6 +15,7 @@
  * General Public License for more details.
  */
 
+#include <linux/ktime.h>
 #include <linux/uaccess.h>
 #include "bfad_drv.h"
 #include "bfad_im.h"
@@ -2093,13 +2094,12 @@ bfad_iocmd_fcpim_cfg_profile(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_profile_s *iocmd =
 				(struct bfa_bsg_fcpim_profile_s *)cmd;
-	struct timeval  tv;
 	unsigned long	flags;
 
-	do_gettimeofday(&tv);
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	if (v_cmd == IOCMD_FCPIM_PROFILE_ON)
-		iocmd->status = bfa_fcpim_profile_on(&bfad->bfa, tv.tv_sec);
+		iocmd->status = bfa_fcpim_profile_on(&bfad->bfa,
+						ktime_get_real_seconds());
 	else if (v_cmd == IOCMD_FCPIM_PROFILE_OFF)
 		iocmd->status = bfa_fcpim_profile_off(&bfad->bfa);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-- 
1.9.1
