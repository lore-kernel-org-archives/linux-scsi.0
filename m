From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/42] net: move seq_file_single_net to <linux/seq_file_net.h>
Date: Wed, 16 May 2018 11:43:20 +0200
Message-ID: <20180516094346.20506-17-hch@lst.de>
References: <20180516094346.20506-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180516094346.20506-1-hch@lst.de>
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

This helper deals with single_{open,release}_net internals and thus
belongs here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/seq_file_net.h | 13 +++++++++++++
 include/net/ip_vs.h          | 12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index 43ccd84127b6..ed20faa99e05 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -28,4 +28,17 @@ static inline struct net *seq_file_net(struct seq_file *seq)
 #endif
 }
 
+/*
+ * This one is needed for single_open_net since net is stored directly in
+ * private not as a struct i.e. seq_file_net can't be used.
+ */
+static inline struct net *seq_file_single_net(struct seq_file *seq)
+{
+#ifdef CONFIG_NET_NS
+	return (struct net *)seq->private;
+#else
+	return &init_net;
+#endif
+}
+
 #endif
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index eb0bec043c96..aea7a124e66b 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -41,18 +41,6 @@ static inline struct netns_ipvs *net_ipvs(struct net* net)
 	return net->ipvs;
 }
 
-/* This one needed for single_open_net since net is stored directly in
- * private not as a struct i.e. seq_file_net can't be used.
- */
-static inline struct net *seq_file_single_net(struct seq_file *seq)
-{
-#ifdef CONFIG_NET_NS
-	return (struct net *)seq->private;
-#else
-	return &init_net;
-#endif
-}
-
 /* Connections' size value needed by ip_vs_ctl.c */
 extern int ip_vs_conn_tab_size;
 
-- 
2.17.0
