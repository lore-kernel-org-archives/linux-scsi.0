From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bfa: cleanup a memcpy()
Date: Thu, 11 Oct 2012 10:02:03 +0300
Message-ID: <20121011070203.GG31607@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Krishna C Gudipati <kgudipat@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Smatch complains that we are writing more data than ->srlid_base
member can hold.  In fact, we are over writing the whole struct.  I've
re-written it to be a bit more clear and to silence the static checker
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 0116c10..a6dc18e 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3624,11 +3624,9 @@ bfa_sfp_show_comp(struct bfa_sfp_s *sfp, struct bfi_mbmsg_s *msg)
 	bfa_trc(sfp, sfp->memtype);
 	if (sfp->memtype == BFI_SFP_MEM_DIAGEXT) {
 		bfa_trc(sfp, sfp->data_valid);
-		if (sfp->data_valid) {
-			u32	size = sizeof(struct sfp_mem_s);
-			u8 *des = (u8 *) &(sfp->sfpmem->srlid_base);
-			memcpy(des, sfp->dbuf_kva, size);
-		}
+		if (sfp->data_valid)
+			memcpy(sfp->sfpmem, sfp->dbuf_kva,
+					sizeof(*sfp->sfpmem));
 		/*
 		 * Queue completion callback.
 		 */
