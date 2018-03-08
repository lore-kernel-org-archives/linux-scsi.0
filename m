From: Stephen Kitt <steve@sk2.org>
Subject: [PATCH] bfa: remove VLA
Date: Thu,  8 Mar 2018 22:38:41 +0100
Message-ID: <20180308213841.13807-1-steve@sk2.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com
Cc: linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Stephen Kitt <steve@sk2.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wvla, remove VLAs and replace them with
fixed-length arrays instead.

bfad_bsg.c uses a variable-length array declaration to measure the
size of a putative array; this can be replaced by the product of the
size of an element and the number of elements, avoiding the VLA
altogether.

This was prompted by https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 3976e787ba64..7c884f881180 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -891,7 +891,7 @@ bfad_iocmd_fabric_get_lports(struct bfad_s *bfad, void *cmd,
 
 	if (bfad_chk_iocmd_sz(payload_len,
 		sizeof(struct bfa_bsg_fabric_get_lports_s),
-		sizeof(wwn_t[iocmd->nports])) != BFA_STATUS_OK) {
+		sizeof(wwn_t) * iocmd->nports) != BFA_STATUS_OK) {
 		iocmd->status = BFA_STATUS_VERSION_FAIL;
 		goto out;
 	}
-- 
2.11.0
