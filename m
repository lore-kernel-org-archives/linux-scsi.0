From: Roman Kagan <rkagan@mail.ru>
Subject: [PATCH] drivers/scsi: add hotplug with MODNAME env var
Date: Fri, 4 Mar 2005 13:49:07 +0300
Message-ID: <20050304104903.GA2311@katya>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from apachihuilliztli.mtu.ru ([195.34.32.124]:13578 "EHLO
	Apachihuilliztli.mtu.ru") by vger.kernel.org with ESMTP
	id S262762AbVCDKtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 05:49:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>, linux-hotplug-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

  Hi,

The patch below adds hotplug callout to scsi_bus_type, and makes it
generate MODNAME environment variable for use with modprobe.  Also it
adds a few matching MODULE_ALIAS() macros to the appropriate modules.

Two caveats:

 1) I'm not particularly certain about the "scsi-type-" prefix: it may
    resemble cases where request_module() is used;  the reason I used
    dashes was that MODULE_ALIAS() macros were put manually into the
    code, rather that automatically generated from a corresponding
    *_dev_id table;

 2) TYPE_* macros in include/scsi/scsi.h are in hex and can't be
    conveniently __stringify()-ed, so I've hardcoded the values and
    inserted comments next to them referring to those macros.

It handles only sd, sr, st, and osst cases.  I'd like to leave it to
scsi folks to decide whether sg should be "scsi-type-*" or the explicit
list of types not handled by other modules.

Roman.

Signed-off-by: Roman Kagan <rkagan@mail.ru>

 drivers/scsi/scsi_sysfs.c |   16 ++++++++++++++++
 drivers/scsi/sd.c         |    2 ++
 drivers/scsi/sr.c         |    3 +++
 drivers/scsi/st.c         |    2 ++
 drivers/scsi/osst.c       |    2 ++
 5 files changed, 25 insertions(+)

diff -rup linux-2.6.11/drivers/scsi/scsi_sysfs.c linux-2.6.11.modname/drivers/scsi/scsi_sysfs.c
--- linux-2.6.11/drivers/scsi/scsi_sysfs.c	2005-03-02 10:37:49.000000000 +0300
+++ linux-2.6.11.modname/drivers/scsi/scsi_sysfs.c	2005-03-04 13:18:05.000000000 +0300
@@ -202,9 +202,25 @@ static int scsi_bus_match(struct device 
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+static int scsi_hotplug(struct device *dev, char **envp,
+			int num_envp, char *buffer, int buffer_size)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int i = 0;
+	int length = 0;
+
+	if (add_hotplug_env_var(envp, num_envp, &i, buffer, buffer_size, &length,
+				"MODNAME=scsi-type-%d", sdev->type))
+		return -ENOMEM;
+
+	envp[i] = NULL;
+	return 0;
+}
+
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
+	.hotplug	= scsi_hotplug,
 };
 
 int scsi_sysfs_register(void)
diff -rup linux-2.6.11/drivers/scsi/sd.c linux-2.6.11.modname/drivers/scsi/sd.c
--- linux-2.6.11/drivers/scsi/sd.c	2005-03-02 10:38:17.000000000 +0300
+++ linux-2.6.11.modname/drivers/scsi/sd.c	2005-03-04 13:16:22.000000000 +0300
@@ -1653,6 +1653,8 @@ static void __exit exit_sd(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
+MODULE_ALIAS("scsi-type-0");	/*	TYPE_DISK	*/
+MODULE_ALIAS("scsi-type-7");	/*	TYPE_MOD	*/
 
 module_init(init_sd);
 module_exit(exit_sd);
diff -rup linux-2.6.11/drivers/scsi/sr.c linux-2.6.11.modname/drivers/scsi/sr.c
--- linux-2.6.11/drivers/scsi/sr.c	2005-03-02 10:38:37.000000000 +0300
+++ linux-2.6.11.modname/drivers/scsi/sr.c	2005-03-04 13:16:22.000000000 +0300
@@ -956,6 +956,9 @@ static void __exit exit_sr(void)
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
 
+MODULE_ALIAS("scsi-type-4");	/*	TYPE_WORM	*/
+MODULE_ALIAS("scsi-type-5");	/*	TYPE_ROM	*/
+
 module_init(init_sr);
 module_exit(exit_sr);
 MODULE_LICENSE("GPL");
diff -rup linux-2.6.11/drivers/scsi/st.c linux-2.6.11.modname/drivers/scsi/st.c
--- linux-2.6.11/drivers/scsi/st.c	2005-03-02 10:38:12.000000000 +0300
+++ linux-2.6.11.modname/drivers/scsi/st.c	2005-03-04 13:16:22.000000000 +0300
@@ -4090,6 +4090,8 @@ static void __exit exit_st(void)
 	printk(KERN_INFO "st: Unloaded.\n");
 }
 
+MODULE_ALIAS("scsi-type-1");	/*	TYPE_TAPE	*/
+
 module_init(init_st);
 module_exit(exit_st);
 
diff -rup linux-2.6.11/drivers/scsi/osst.c linux-2.6.11.modname/drivers/scsi/osst.c
--- linux-2.6.11/drivers/scsi/osst.c	2005-03-02 10:38:08.000000000 +0300
+++ linux-2.6.11.modname/drivers/scsi/osst.c	2005-03-04 13:20:45.000000000 +0300
@@ -5888,5 +5888,7 @@ static void __exit exit_osst (void)
 	printk(KERN_INFO "osst :I: Unloaded.\n");
 }
 
+MODULE_ALIAS("scsi-type-1");	/*	TYPE_TAPE	*/
+
 module_init(init_osst);
 module_exit(exit_osst);
