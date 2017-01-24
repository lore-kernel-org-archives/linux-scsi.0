From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v4 00/12] qla2xxx: Feature updates for target.
Date: Tue, 24 Jan 2017 09:24:10 -0800
Message-ID: <490b1911-11be-5390-9776-ffbeec94254f@sandisk.com>
References: <1484893684-1255-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484893684-1255-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/19/2017 10:29 PM, Himanshu Madhani wrote:
> Please consider this updated series for inclusion in target-pending.
> 
> Changes from v3 --> v4
> 
> o Fixed warnings reported by smatch tool.
> o Fixed indentatation warnings reported by smatch tool.
> 
> Changes from v2 --> v3
> 
> o Cleaned up sparse warnings reported by you.
> 
> Changes from v1 --> v2
> 
> o Updated review comments and added Reviewed-by tags for necessary patches.
> o We left the one particular review comment to add helper routine to
>   be addressed at later time in the follow up bug fixes pathes which we
>   will be sending in few weeks.
> o Added patch to simplify SRB usage in driver.
> o Cleaned up warnings reported by sparse option w=1.

Hello Himanshu,

One newly introduced sparse warning has not yet been addressed. The
patch below addresses that warning. I would appreciate it if someone
from the qla2xxx team could review this patch.

Thanks,

Bart.


From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] qla2xxx: Avoid using variable-length arrays

This patch does not change any functionality but avoids that sparse
complains about using variable-length arrays.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Quinn Tran <quinn.tran@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 817c5940df76..ec7e36c33e26 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4272,8 +4272,8 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	spin_lock_init(&vha->cmd_list_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 
-	vha->gnl.size =
-	    sizeof(struct get_name_list_extended[ha->max_loop_id+1]);
+	vha->gnl.size = sizeof(struct get_name_list_extended) *
+			(ha->max_loop_id + 1);
 	vha->gnl.l = dma_alloc_coherent(&ha->pdev->dev,
 	    vha->gnl.size, &vha->gnl.ldma, GFP_KERNEL);
 	if (!vha->gnl.l) {
-- 
2.11.0
