From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 12/44] ibmvfc: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:43 +0200
Message-ID: <fc142544c087dd2d889dcec1246f9f3b71602baa.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>, "open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <linuxppc-dev@lists.ozlabs.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8b55279..21c9d28 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1939,7 +1939,7 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 	bsg_reply->result = rc;
-	job->job_done(job);
+	fc_bsg_jobdone(job);
 	rc = 0;
 out:
 	dma_unmap_sg(vhost->dev, job->request_payload.sg_list,
-- 
1.8.5.6
