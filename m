From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: bfa: Avoid implicit enum conversion in bfad_im_post_vendor_event
Date: Tue, 25 Sep 2018 21:54:37 -0700
Message-ID: <20180926045435.9213-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when one enumerated type is implicitly converted to another.

drivers/scsi/bfa/bfa_fcs_lport.c:379:26: warning: implicit conversion
from enumeration type 'enum bfa_lport_aen_event' to different
enumeration type 'enum bfa_ioc_aen_event' [-Wenum-conversion]
                                  BFA_AEN_CAT_LPORT, event);
                                                     ^~~~~

The root cause of these warnings is the bfad_im_post_vendor_event
function, which expects a value from enum bfa_ioc_aen_event but there
are multiple instances of values from enums bfa_port_aen_event,
bfa_audit_aen_event, and bfa_lport_aen_event being used in this
function.

Given that this doesn't appear to be a problem since cat helps with
differentiating the events, just change evt's type to int so that no
conversion needs to happen and Clang won't warn.

Link: https://github.com/ClangBuiltLinux/linux/issues/147
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

The alternate way of fixing these warnings is to explicitly cast the
conversion when calling the function but since there are about 8-10 of
these warnings, it seems logical to just change the function definiton
which is cleaner in my opinion.

See commits 3eb95feac113 ("mm/zsmalloc.c: change stat type parameter to
int") and 04fecbf51b3c ("mm: memcontrol: use int for event/state
parameter in several functions") for similar fixes.

 drivers/scsi/bfa/bfad_im.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index e61ed8dad0b4..bd4ac187fd8e 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -143,7 +143,7 @@ struct bfad_im_s {
 static inline void bfad_im_post_vendor_event(struct bfa_aen_entry_s *entry,
 					     struct bfad_s *drv, int cnt,
 					     enum bfa_aen_category cat,
-					     enum bfa_ioc_aen_event evt)
+					     int evt)
 {
 	struct timespec64 ts;
 
-- 
2.19.0
