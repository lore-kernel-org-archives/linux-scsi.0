From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 09/12] bnx2fc: hold tgt lock when calling
	cmd_release
Date: Mon, 27 Jun 2011 23:31:01 -0700
Message-ID: <1309242664-27252-10-git-send-email-bprakash@broadcom.com>
References: <1309242664-27252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1309242664-27252-1-git-send-email-bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 797b005..7154c44 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -752,7 +752,9 @@ retry_tmf:
 	rc = bnx2fc_init_mp_req(io_req);
 	if (rc == FAILED) {
 		printk(KERN_ERR PFX "Task mgmt MP request init failed\n");
+		spin_lock_bh(&tgt->tgt_lock);
 		kref_put(&io_req->refcount, bnx2fc_cmd_release);
+		spin_unlock_bh(&tgt->tgt_lock);
 		goto tmf_err;
 	}
 
-- 
1.7.0.6
