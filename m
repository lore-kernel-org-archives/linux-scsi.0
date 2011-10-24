From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/9] ib_srpt: Fix srpt_alloc_fabric_acl failure case return value
Date: Mon, 24 Oct 2011 05:33:36 +0000
Message-ID: <1319434422-15354-4-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in srpt_make_nodeacl(), where a failure of
srpt_alloc_fabric_acl() was not setting a proper error return code.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6aba709..fee78b0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3679,8 +3679,10 @@ static struct se_node_acl *srpt_make_nodeacl(struct se_portal_group *tpg,
 	}
 
 	se_nacl_new = srpt_alloc_fabric_acl(tpg);
-	if (!se_nacl_new)
+	if (!se_nacl_new) {
+		ret = -ENOMEM;
 		goto err;
+	}
 	/*
 	 * nacl_new may be released by core_tpg_add_initiator_node_acl()
 	 * when converting a node ACL from demo mode to explict
-- 
1.7.2.5
