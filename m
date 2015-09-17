From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] scsi_scan: don't dump trace when scsi_prep_async_scan()
 is called twice
Date: Thu, 17 Sep 2015 15:29:17 -0700
Message-ID: <1442528959-3298-1-git-send-email-kys@microsoft.com>
References: <1442528938-3252-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1442528938-3252-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

The only user of scsi_prep_async_scan() is scsi_scan_host() and it handles
the situation correctly. Move 'called twice' reporting to debug level as
well.

The issue is observed on Hyper-V: on any device add/remove event storvsc
driver calls scsi_scan_host() and in case previous scan is still running
we get the message and stack dump on console.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/scsi_scan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..01ad016 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1712,8 +1712,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
-		dump_stack();
+		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
 		return NULL;
 	}
 
-- 
1.7.4.1
