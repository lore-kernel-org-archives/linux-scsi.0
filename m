From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm_vhost: Fix tv_cmd completion -> release SGL memory leak
Date: Thu,  5 Jul 2012 04:14:23 +0000
Message-ID: <1341461663-13434-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The SGL memory allocated during vhost_scsi_map_iov_to_sgl() setup was never
getting freed during tv_cmd completion -> release path.  Fix this up by releasing
tv_cmd->tvc_sgl in vhost_scsi_free_cmd() ahead of tv_cmd descriptor free.

Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/tcm_vhost.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
index cd86633..9692153 100644
--- a/drivers/vhost/tcm_vhost.c
+++ b/drivers/vhost/tcm_vhost.c
@@ -387,6 +387,8 @@ static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
 		u32 i;
 		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
 			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+
+		kfree(tv_cmd->tvc_sgl);
 	}
 
 	kfree(tv_cmd);
-- 
1.7.2.5
