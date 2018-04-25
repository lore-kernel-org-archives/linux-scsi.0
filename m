From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/40] net/can: single_open_net needs to be paired with single_release_net
Date: Wed, 25 Apr 2018 17:47:48 +0200
Message-ID: <20180425154827.32251-2-hch@lst.de>
References: <20180425154827.32251-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180425154827.32251-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
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
