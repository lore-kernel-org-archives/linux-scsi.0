From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/7] cxlflash: Acquire semaphore before invoking ioctl services
Date: Fri, 11 May 2018 14:05:22 -0500
Message-ID: <1526065522-38933-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

When a superpipe process that makes use of virtual LUNs is terminated or
killed abruptly, there is a possibility that the cxlflash driver could
hang and deprive other operations on the adapter.

The release fop registered to be invoked on a context close, detaches
every LUN associated with the context. The underlying service to detach
the LUN assumes it has been called with the read semaphore held, and
releases the semaphore before any operation that could be time consuming.

When invoked without holding the read semaphore, an opportunity is created
for the semaphore's count to become negative when it is temporarily
released during one of these potential lengthy operations. This negative
count results in subsequent acquisition attempts taking forever, leading
to the hang.

To support the current design point of holding the semaphore on the
ioctl() paths, the release fop should acquire it before invoking any
ioctl services.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 04a3bf9..5ba6e62 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -988,6 +988,10 @@ static int cxlflash_disk_detach(struct scsi_device *sdev,
  * theoretically never occur), every call into this routine results
  * in a complete freeing of a context.
  *
+ * Detaching the LUN is typically an ioctl() operation and the underlying
+ * code assumes that ioctl_rwsem has been acquired as a reader. To support
+ * that design point, the semaphore is acquired and released around detach.
+ *
  * Return: 0 on success
  */
 static int cxlflash_cxl_release(struct inode *inode, struct file *file)
@@ -1026,9 +1030,11 @@ static int cxlflash_cxl_release(struct inode *inode, struct file *file)
 
 	dev_dbg(dev, "%s: close for ctxid=%d\n", __func__, ctxid);
 
+	down_read(&cfg->ioctl_rwsem);
 	detach.context_id = ctxi->ctxid;
 	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
 		_cxlflash_disk_detach(lun_access->sdev, ctxi, &detach);
+	up_read(&cfg->ioctl_rwsem);
 out_release:
 	cfg->ops->fd_release(inode, file);
 out:
-- 
2.1.0
