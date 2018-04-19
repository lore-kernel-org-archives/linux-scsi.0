From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/39] net/can: single_open_net needs to be
 paired with single_release_net
Date: Thu, 19 Apr 2018 14:41:02 +0200
Message-ID: <20180419124140.9309-2-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
 <mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-afs@lists.infradead.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Jiri Slaby <jslaby@suse.com>, linux-ext4@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Otherwise we will leak a reference to the network namespace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/can/bcm.c  | 2 +-
 net/can/proc.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index ac5e5e34fee3..8073fa14e143 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -249,7 +249,7 @@ static const struct file_operations bcm_proc_fops = {
 	.open		= bcm_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= single_release_net,
 };
 #endif /* CONFIG_PROC_FS */
 
diff --git a/net/can/proc.c b/net/can/proc.c
index fdf704e9bb8c..fde2fd55b826 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -279,7 +279,7 @@ static const struct file_operations can_stats_proc_fops = {
 	.open		= can_stats_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= single_release_net,
 };
 
 static int can_reset_stats_proc_show(struct seq_file *m, void *v)
@@ -449,7 +449,7 @@ static const struct file_operations can_rcvlist_sff_proc_fops = {
 	.open		= can_rcvlist_sff_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= single_release_net,
 };
 
 
@@ -492,7 +492,7 @@ static const struct file_operations can_rcvlist_eff_proc_fops = {
 	.open		= can_rcvlist_eff_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= single_release_net,
 };
 
 /*
-- 
2.17.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
