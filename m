From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/39] net: move seq_file_single_net to <linux/seq_file_net.h>
Date: Thu, 19 Apr 2018 14:41:13 +0200
Message-ID: <20180419124140.9309-13-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
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
