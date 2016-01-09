From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH 4/6] scsi: bfa: Remove use of time_t
Date: Sat, 9 Jan 2016 20:03:25 +0530
Message-ID: <20160109143325.GA7531@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

32 bit systems using 'time_t' will break in the year 2038, so
we modify the code appropriately.

This patch removes the cast to 'time_t' in the assignment statement
since we are eventually removing the time_t definition from the kernel
as an effort to solve the y2038 problem. This change will avoid the
build error but the code is still broken and requires a change in the
ioctl interface.

Further, since the variable io_profile_start_time will break in 2038
or 2106 depending on user space interpreting it as signed or unsigned,
comments have been added to highlight the same.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---

Only apply this patch if it's seen as acceptable that the
io_profile_start_time remains truncated to 32 bits in
IOCMD_ITNIM_GET_IOPROFILE. If this is something that needs to
be fixed by adding a replacement vendor command, leave the
cast in place as a reminder.

 drivers/scsi/bfa/bfa_defs_svc.h | 4 ++++
 drivers/scsi/bfa/bfa_fcpim.c    | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 638f441f..8ab7964 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -1211,6 +1211,10 @@ struct bfa_itnim_ioprofile_s {
 	u32 clock_res_mul;
 	u32 clock_res_div;
 	u32 index;
+	/*
+	* Overflow in 2038 or 2106 depending on user space interpreting it as
+	* signed or unsigned.
+	*/
 	u32 io_profile_start_time;	/*  IO profile start time	*/
 	u32 iocomps[BFA_IOBUCKET_MAX];	/*  IO completed	*/
 	struct bfa_itnim_latency_s io_latency;
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 6730340..56df8d0 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -1478,7 +1478,8 @@ bfa_itnim_get_ioprofile(struct bfa_itnim_s *itnim,
 		return BFA_STATUS_IOPROFILE_OFF;
 
 	itnim->ioprofile.index = BFA_IOBUCKET_MAX;
-	itnim->ioprofile.io_profile_start_time = (u32)(time_t)
+	/* io_profile_start_time will overflow in 2038 or 2106 */
+	itnim->ioprofile.io_profile_start_time = (u32)
 					bfa_io_profile_start_time(itnim->bfa);
 	itnim->ioprofile.clock_res_mul = bfa_io_lat_clock_res_mul;
 	itnim->ioprofile.clock_res_div = bfa_io_lat_clock_res_div;
-- 
1.9.1
