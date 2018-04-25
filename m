From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 27/40] rtc/proc: switch to proc_create_single_data
Date: Wed, 25 Apr 2018 17:48:14 +0200
Message-ID: <20180425154827.32251-28-hch@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425154827.32251-1-hch@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

And stop trying to get a reference on the submodule, procfs code deals
with release after and unloaded module and thus removed proc entry.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/rtc/rtc-proc.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 31e7e23cc5be..a9dd9218fae2 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -107,40 +107,11 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 	return 0;
 }
 
-static int rtc_proc_open(struct inode *inode, struct file *file)
-{
-	int ret;
-	struct rtc_device *rtc = PDE_DATA(inode);
-
-	if (!try_module_get(rtc->owner))
-		return -ENODEV;
-
-	ret = single_open(file, rtc_proc_show, rtc);
-	if (ret)
-		module_put(rtc->owner);
-	return ret;
-}
-
-static int rtc_proc_release(struct inode *inode, struct file *file)
-{
-	int res = single_release(inode, file);
-	struct rtc_device *rtc = PDE_DATA(inode);
-
-	module_put(rtc->owner);
-	return res;
-}
-
-static const struct file_operations rtc_proc_fops = {
-	.open		= rtc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= rtc_proc_release,
-};
-
 void rtc_proc_add_device(struct rtc_device *rtc)
 {
 	if (is_rtc_hctosys(rtc))
-		proc_create_data("driver/rtc", 0, NULL, &rtc_proc_fops, rtc);
+		proc_create_single_data("driver/rtc", 0, NULL, rtc_proc_show,
+				rtc);
 }
 
 void rtc_proc_del_device(struct rtc_device *rtc)
-- 
2.17.0
