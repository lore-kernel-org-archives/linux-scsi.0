From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of sg_init
Date: Sun, 3 Nov 2002 18:25:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103182505.A7070@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Next step of my ->init removal series.  sg does a few to much wierd
things with it's global array thay I prefer to leave it to Doug to
get rid of it (if he wants to), but this patch at least gets rid of
sg_init.

Move the register_chrdev to init_sg - open properly checks whether
the device exists so this doesn't cause any harm.  Remove the initial
allocation of the device array - the resizing code in sg_attach will
properly take care of it when called the first time.

Tested with a DVD reader/CD writer combination and ide-scsi.


--- 1.35/drivers/scsi/sg.c	Fri Nov  1 07:28:19 2002
+++ edited/drivers/scsi/sg.c	Sun Nov  3 14:04:56 2002
@@ -110,7 +110,6 @@
 
 #define SG_DEV_ARR_LUMP 6	/* amount to over allocate sg_dev_arr by */
 
-static int sg_init(void);
 static int sg_attach(Scsi_Device *);
 static int sg_detect(Scsi_Device *);
 static void sg_detach(Scsi_Device *);
@@ -126,7 +125,6 @@
 	.tag = "sg",
 	.scsi_type = 0xff,
 	.detect = sg_detect,
-	.init = sg_init,
 	.attach = sg_attach,
 	.detach = sg_detach
 };
@@ -1344,55 +1342,6 @@
 	return 1;
 }
 
-/* Driver initialization */
-static int
-sg_init()
-{
-	static int sg_registered = 0;
-	unsigned long iflags;
-	int tmp_dev_max;
-	Sg_device **tmp_da;
-
-	if ((sg_template.dev_noticed == 0) || sg_dev_arr)
-		return 0;
-
-	SCSI_LOG_TIMEOUT(3, printk("sg_init\n"));
-
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	tmp_dev_max = sg_template.dev_noticed + SG_DEV_ARR_LUMP;
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-
-	tmp_da = (Sg_device **)vmalloc(
-				tmp_dev_max * sizeof(Sg_device *));
-	if (NULL == tmp_da) {
-		printk(KERN_ERR "sg_init: no space for sg_dev_arr\n");
-		return 1;
-	}
-	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-
-	if (!sg_registered) {
-		if (register_chrdev(SCSI_GENERIC_MAJOR, "sg", &sg_fops)) {
-			printk(KERN_ERR
-			       "Unable to get major %d for generic SCSI device\n",
-			       SCSI_GENERIC_MAJOR);
-			write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-			vfree((char *) tmp_da);
-			return 1;
-		}
-		sg_registered++;
-	}
-
-	memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
-	sg_template.dev_max = tmp_dev_max;
-	sg_dev_arr = tmp_da;
-
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
-#ifdef CONFIG_PROC_FS
-	sg_proc_init();
-#endif				/* CONFIG_PROC_FS */
-	return 0;
-}
-
 #ifndef MODULE
 static int __init
 sg_def_reserved_size_setup(char *str)
@@ -1643,9 +1592,21 @@
 static int __init
 init_sg(void)
 {
+	int rc;
+
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
-	return scsi_register_device(&sg_template);
+
+	rc = register_chrdev(SCSI_GENERIC_MAJOR, "sg", &sg_fops);
+	if (rc)
+		return rc;
+	rc = scsi_register_device(&sg_template);
+	if (rc)
+		return rc;
+#ifdef CONFIG_PROC_FS
+	sg_proc_init();
+#endif				/* CONFIG_PROC_FS */
+	return 0;
 }
 
 static void __exit
