From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 40/40] tty: replace ->proc_fops with ->proc_show
Date: Wed, 25 Apr 2018 17:48:27 +0200
Message-ID: <20180425154827.32251-41-hch@lst.de>
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

Just set up the show callback in the tty_operations, and use
proc_create_single_data to create the file without additional
boilerplace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/hp/sim/simserial.c        | 15 +--------------
 arch/xtensa/platforms/iss/console.c | 15 +--------------
 drivers/char/pcmcia/synclink_cs.c   | 15 +--------------
 drivers/mmc/core/sdio_uart.c        | 15 +--------------
 drivers/staging/fwserial/fwserial.c | 15 +--------------
 drivers/tty/amiserial.c             | 15 +--------------
 drivers/tty/cyclades.c              | 15 +--------------
 drivers/tty/serial/serial_core.c    | 15 +--------------
 drivers/tty/synclink.c              | 15 +--------------
 drivers/tty/synclink_gt.c           | 15 +--------------
 drivers/tty/synclinkmp.c            | 15 +--------------
 drivers/usb/serial/usb-serial.c     | 15 +--------------
 fs/proc/proc_tty.c                  |  6 +++---
 include/linux/tty_driver.h          |  2 +-
 14 files changed, 16 insertions(+), 172 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index a419ccf33cde..663388a73d4e 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -435,19 +435,6 @@ static int rs_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int rs_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rs_proc_show, NULL);
-}
-
-static const struct file_operations rs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= rs_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct tty_operations hp_ops = {
 	.open = rs_open,
 	.close = rs_close,
@@ -462,7 +449,7 @@ static const struct tty_operations hp_ops = {
 	.unthrottle = rs_unthrottle,
 	.send_xchar = rs_send_xchar,
 	.hangup = rs_hangup,
-	.proc_fops = &rs_proc_fops,
+	.proc_show = rs_proc_show,
 };
 
 static const struct tty_port_operations hp_port_ops = {
diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 92f567f9a21e..af81a62faba6 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -153,19 +153,6 @@ static int rs_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int rs_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rs_proc_show, NULL);
-}
-
-static const struct file_operations rs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= rs_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct tty_operations serial_ops = {
 	.open = rs_open,
 	.close = rs_close,
@@ -176,7 +163,7 @@ static const struct tty_operations serial_ops = {
 	.chars_in_buffer = rs_chars_in_buffer,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.proc_fops = &rs_proc_fops,
+	.proc_show = rs_proc_show,
 };
 
 int __init rs_init(void)
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index aa502e9fb7fa..66b04194aa9f 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2616,19 +2616,6 @@ static int mgslpc_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int mgslpc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mgslpc_proc_show, NULL);
-}
-
-static const struct file_operations mgslpc_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= mgslpc_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int rx_alloc_buffers(MGSLPC_INFO *info)
 {
 	/* each buffer has header and data */
@@ -2815,7 +2802,7 @@ static const struct tty_operations mgslpc_ops = {
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
 	.get_icount = mgslpc_get_icount,
-	.proc_fops = &mgslpc_proc_fops,
+	.proc_show = mgslpc_proc_show,
 };
 
 static int __init synclink_cs_init(void)
diff --git a/drivers/mmc/core/sdio_uart.c b/drivers/mmc/core/sdio_uart.c
index d3c91f412b69..25e113001a3c 100644
--- a/drivers/mmc/core/sdio_uart.c
+++ b/drivers/mmc/core/sdio_uart.c
@@ -1008,19 +1008,6 @@ static int sdio_uart_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int sdio_uart_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sdio_uart_proc_show, NULL);
-}
-
-static const struct file_operations sdio_uart_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= sdio_uart_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static const struct tty_port_operations sdio_uart_port_ops = {
 	.dtr_rts = uart_dtr_rts,
 	.carrier_raised = uart_carrier_raised,
@@ -1045,7 +1032,7 @@ static const struct tty_operations sdio_uart_ops = {
 	.tiocmset		= sdio_uart_tiocmset,
 	.install		= sdio_uart_install,
 	.cleanup		= sdio_uart_cleanup,
-	.proc_fops		= &sdio_uart_proc_fops,
+	.proc_show		= sdio_uart_proc_show,
 };
 
 static struct tty_driver *sdio_uart_tty_driver;
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index e8bfe5520bc7..fa0dd425b454 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1506,11 +1506,6 @@ static int fwtty_debugfs_peers_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int fwtty_proc_open(struct inode *inode, struct file *fp)
-{
-	return single_open(fp, fwtty_proc_show, NULL);
-}
-
 static int fwtty_stats_open(struct inode *inode, struct file *fp)
 {
 	return single_open(fp, fwtty_debugfs_stats_show, inode->i_private);
@@ -1537,14 +1532,6 @@ static const struct file_operations fwtty_peers_fops = {
 	.release =	single_release,
 };
 
-static const struct file_operations fwtty_proc_fops = {
-	.owner =        THIS_MODULE,
-	.open =         fwtty_proc_open,
-	.read =         seq_read,
-	.llseek =       seq_lseek,
-	.release =      single_release,
-};
-
 static const struct tty_port_operations fwtty_port_ops = {
 	.dtr_rts =		fwtty_port_dtr_rts,
 	.carrier_raised =	fwtty_port_carrier_raised,
@@ -1570,7 +1557,7 @@ static const struct tty_operations fwtty_ops = {
 	.tiocmget =		fwtty_tiocmget,
 	.tiocmset =		fwtty_tiocmset,
 	.get_icount =		fwtty_get_icount,
-	.proc_fops =		&fwtty_proc_fops,
+	.proc_show =		fwtty_proc_show,
 };
 
 static const struct tty_operations fwloop_ops = {
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 32d7ce430b02..34dead614149 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1566,19 +1566,6 @@ static int rs_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int rs_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rs_proc_show, NULL);
-}
-
-static const struct file_operations rs_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= rs_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*
  * ---------------------------------------------------------------------
  * rs_init() and friends
@@ -1620,7 +1607,7 @@ static const struct tty_operations serial_ops = {
 	.tiocmget = rs_tiocmget,
 	.tiocmset = rs_tiocmset,
 	.get_icount = rs_get_icount,
-	.proc_fops = &rs_proc_fops,
+	.proc_show = rs_proc_show,
 };
 
 static int amiga_carrier_raised(struct tty_port *port)
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index cf0bde3bb927..6d3c58051ce3 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -3972,19 +3972,6 @@ static int cyclades_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int cyclades_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, cyclades_proc_show, NULL);
-}
-
-static const struct file_operations cyclades_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= cyclades_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* The serial driver boot-time initialization code!
     Hardware I/O ports are mapped to character special devices on a
     first found, first allocated manner.  That is, this code searches
@@ -4024,7 +4011,7 @@ static const struct tty_operations cy_ops = {
 	.tiocmget = cy_tiocmget,
 	.tiocmset = cy_tiocmset,
 	.get_icount = cy_get_icount,
-	.proc_fops = &cyclades_proc_fops,
+	.proc_show = cyclades_proc_show,
 };
 
 static int __init cy_init(void)
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 0466f9f08a91..6ff9405954a6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1829,19 +1829,6 @@ static int uart_proc_show(struct seq_file *m, void *v)
 		uart_line_info(m, drv, i);
 	return 0;
 }
-
-static int uart_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, uart_proc_show, PDE_DATA(inode));
-}
-
-static const struct file_operations uart_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= uart_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
 #endif
 
 #if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(CONFIG_CONSOLE_POLL)
@@ -2415,7 +2402,7 @@ static const struct tty_operations uart_ops = {
 	.break_ctl	= uart_break_ctl,
 	.wait_until_sent= uart_wait_until_sent,
 #ifdef CONFIG_PROC_FS
-	.proc_fops	= &uart_proc_fops,
+	.proc_show	= uart_proc_show,
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 3c4ad71f261d..fbdf4d01c6a9 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3534,19 +3534,6 @@ static int mgsl_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int mgsl_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, mgsl_proc_show, NULL);
-}
-
-static const struct file_operations mgsl_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= mgsl_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* mgsl_allocate_dma_buffers()
  * 
  * 	Allocate and format DMA buffers (ISA adapter)
@@ -4298,7 +4285,7 @@ static const struct tty_operations mgsl_ops = {
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
 	.get_icount = msgl_get_icount,
-	.proc_fops = &mgsl_proc_fops,
+	.proc_show = mgsl_proc_show,
 };
 
 /*
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 255c49687877..a94086597ebd 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1316,19 +1316,6 @@ static int synclink_gt_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int synclink_gt_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, synclink_gt_proc_show, NULL);
-}
-
-static const struct file_operations synclink_gt_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= synclink_gt_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /*
  * return count of bytes in transmit buffer
  */
@@ -3721,7 +3708,7 @@ static const struct tty_operations ops = {
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
 	.get_icount = get_icount,
-	.proc_fops = &synclink_gt_proc_fops,
+	.proc_show = synclink_gt_proc_show,
 };
 
 static void slgt_cleanup(void)
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 75f11ce1f0a1..1e4d5b9c981a 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -1421,19 +1421,6 @@ static int synclinkmp_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int synclinkmp_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, synclinkmp_proc_show, NULL);
-}
-
-static const struct file_operations synclinkmp_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= synclinkmp_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* Return the count of bytes in transmit buffer
  */
 static int chars_in_buffer(struct tty_struct *tty)
@@ -3899,7 +3886,7 @@ static const struct tty_operations ops = {
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
 	.get_icount = get_icount,
-	.proc_fops = &synclinkmp_proc_fops,
+	.proc_show = synclinkmp_proc_show,
 };
 
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 790e0cbe3da9..268ffa6b51d2 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -476,19 +476,6 @@ static int serial_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int serial_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, serial_proc_show, NULL);
-}
-
-static const struct file_operations serial_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= serial_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static int serial_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1192,7 +1179,7 @@ static const struct tty_operations serial_ops = {
 	.get_icount =		serial_get_icount,
 	.cleanup =		serial_cleanup,
 	.install =		serial_install,
-	.proc_fops =		&serial_proc_fops,
+	.proc_show =		serial_proc_show,
 };
 
 
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index b1a4a8ddd246..c69ff191e5d8 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -135,11 +135,11 @@ void proc_tty_register_driver(struct tty_driver *driver)
 	struct proc_dir_entry *ent;
 		
 	if (!driver->driver_name || driver->proc_entry ||
-	    !driver->ops->proc_fops)
+	    !driver->ops->proc_show)
 		return;
 
-	ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
-			       driver->ops->proc_fops, driver);
+	ent = proc_create_single_data(driver->driver_name, 0, proc_tty_driver,
+			       driver->ops->proc_show, driver);
 	driver->proc_entry = ent;
 }
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 31c2b5b166de..71dbc891851a 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -293,7 +293,7 @@ struct tty_operations {
 	int (*poll_get_char)(struct tty_driver *driver, int line);
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
 #endif
-	const struct file_operations *proc_fops;
+	int (*proc_show)(struct seq_file *, void *);
 } __randomize_layout;
 
 struct tty_driver {
-- 
2.17.0
