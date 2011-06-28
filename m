From: "Bhanu Prakash Gollapudi" <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 10/12] bnx2fc: Do not arm CQ when there are no
	CQEs
Date: Mon, 27 Jun 2011 23:31:02 -0700
Message-ID: <1309242664-27252-11-git-send-email-bprakash@broadcom.com>
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
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 9f38c57..357a63d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1070,8 +1070,10 @@ unlock:
 				1 - tgt->cq_curr_toggle_bit;
 		}
 	}
-	bnx2fc_arm_cq(tgt);
-	atomic_add(num_free_sqes, &tgt->free_sqes);
+	if (num_free_sqes) {
+		bnx2fc_arm_cq(tgt);
+		atomic_add(num_free_sqes, &tgt->free_sqes);
+	}
 	spin_unlock_bh(&tgt->cq_lock);
 	return 0;
 }
-- 
1.7.0.6
