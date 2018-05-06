From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: simplify procfs code for seq_file instances V2
Date: Sun, 6 May 2018 20:19:49 +0300
Message-ID: <20180506171948.GA769@avx2>
References: <20180425154827.32251-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 25, 2018 at 05:47:47PM +0200, Christoph Hellwig wrote:
> Changes since V1:
>  - open code proc_create_data to avoid setting not fully initialized
>    entries live
>  - use unsigned int for state_size

Need this to maintain sizeof(struct proc_dir_entry):

Otherwise ACK fs/proc/ part.

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 6d171485c45b..a318ae5b36b4 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -48,8 +48,8 @@ struct proc_dir_entry {
 		const struct seq_operations *seq_ops;
 		int (*single_show)(struct seq_file *, void *);
 	};
-	unsigned int state_size;
 	void *data;
+	unsigned int state_size;
 	unsigned int low_ino;
 	nlink_t nlink;
 	kuid_t uid;
@@ -62,9 +62,9 @@ struct proc_dir_entry {
 	umode_t mode;
 	u8 namelen;
 #ifdef CONFIG_64BIT
-#define SIZEOF_PDE_INLINE_NAME	(192-139)
+#define SIZEOF_PDE_INLINE_NAME	(192-155)
 #else
-#define SIZEOF_PDE_INLINE_NAME	(128-87)
+#define SIZEOF_PDE_INLINE_NAME	(128-95)
 #endif
 	char inline_name[SIZEOF_PDE_INLINE_NAME];
 } __randomize_layout;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index baf1994289ce..7d94fa005b0d 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -40,7 +40,7 @@ static struct net *get_proc_net(const struct inode *inode)
 
 static int seq_open_net(struct inode *inode, struct file *file)
 {
-	size_t state_size = PDE(inode)->state_size;
+	unsigned int state_size = PDE(inode)->state_size;
 	struct seq_net_private *p;
 	struct net *net;
