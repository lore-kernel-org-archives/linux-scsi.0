From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug version 1.67 for lk 2.5.52
Date: Sat, 21 Dec 2002 10:17:58 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E03A526.1040405@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070607080200040905010607"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: rusty@rustcorp.com.au

This is a multi-part message in MIME format.
--------------070607080200040905010607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses the module_param() facility introduced in
lk 2.5.52 (see linux/moduleparam.h) to simplify boot time
and module load time parameters for the scsi_debug driver.

The intent of module_param() is to unify
   - boot time parameters
   - module load time parameters
   - sysfs driver parameters
into a few simple calls (seen from the driver's point of view).
The sysfs capability hasn't been implemented yet. Using
module_param() removes over 100 lines of boilerplate code
from the scsi_debug driver.

Following the conventions suggested by Rusty, scsi_debug's
kernel boot time options have been changed to this form:
    scsi_debug.num_devs=2
while the module load options are now like this:
    modprobe scsi_debug num_devs=2

This patch also updates the Kconfig entry for the scsi_debug
driver.

Doug Gilbert

--------------070607080200040905010607
Content-Type: text/plain;
 name="scsi_debug_2552_167.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug_2552_167.diff"

--- linux/drivers/scsi/Kconfig	2002-12-17 11:25:18.000000000 +1100
+++ linux/drivers/scsi/Kconfig_2552mp	2002-12-21 09:58:17.000000000 +1100
@@ -1550,24 +1550,18 @@
 	  say M here and read <file:Documentation/modules.txt>.  The module
 	  will be called nsp32.o.
 
-#
-# Note - this is a very special 'host' adapter that simulates the presence of some disks.
-# It can come in very handy for troubleshooting.  Anyone else is welcome to use it - all
-# you do is hack it to simulate the condition you want to test for, and then use it.
-#
-# The actual configuration in any kernel release could change at any time as I hack it to
-# simulate various conditions that I am testing.
-#
 config SCSI_DEBUG
-	tristate "SCSI debugging host simulator (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SCSI
+	tristate "SCSI debugging host simulator"
+	depends on SCSI
 	help
-	  This is a host adapter simulator that can be programmed to simulate
-	  a large number of conditions that could occur on a real bus. The
-	  advantage is that many hard to reproduce problems can be tested in a
-	  controlled environment where there is reduced risk of losing
-	  important data. This is primarily of use to people trying to debug
-	  the middle and upper layers of the SCSI subsystem. If unsure, say N.
+	  This is a host adapter simulator that can simulate multiple hosts
+	  each with multiple dummy SCSI devices (disks). It defaults to one
+	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
+	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
+	  dummy disks are simulated, they share the same kernel RAM for 
+	  their storage. See http://www.torque.net/sg/sdebug.html for more
+	  information. This driver is primarily of use to those testing the
+	  SCSI and block subsystems. If unsure, say N.
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
--- linux/drivers/scsi/scsi_debug.c	2002-12-17 11:25:18.000000000 +1100
+++ linux/drivers/scsi/scsi_debug.c2552mp	2002-12-21 09:36:34.000000000 +1100
@@ -20,6 +20,8 @@
  *        add timers for delayed responses [20020721]
  *   Patrick Mansfield <patmans@us.ibm.com> max_luns+scsi_level [20021031]
  *   Mike Anderson <andmike@us.ibm.com> sysfs work [20021118]
+ *   dpg: change style of boot options to "scsi_debug.num_devs=2" and
+ *        module options to "modprobe scsi_debug num_devs=2" [20021221]
  */
 
 #include <linux/config.h>
@@ -37,6 +39,7 @@
 #include <linux/proc_fs.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
+#include <linux/moduleparam.h>
 
 #include <linux/blk.h>
 #include "scsi.h"
@@ -51,7 +54,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.66 (20021205)";
+static const char * scsi_debug_version_str = "Version: 1.67 (20021221)";
 
 #ifndef SCSI_CMD_READ_16
 #define SCSI_CMD_READ_16 0x88
@@ -63,7 +66,7 @@
 #define SDEBUG_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 
 /* Default values for driver parameters */
-#define DEF_NR_FAKE_DEVS   1
+#define DEF_NUM_DEVS   1
 #define DEF_DEV_SIZE_MB   8
 #define DEF_EVERY_NTH   100
 #define DEF_DELAY   1
@@ -82,7 +85,7 @@
 #define OPT_MEDIUM_ERR_ADDR   0x1234
 
 static int scsi_debug_dev_size_mb = DEF_DEV_SIZE_MB;
-static int scsi_debug_num_devs = DEF_NR_FAKE_DEVS;
+static int scsi_debug_num_devs = DEF_NUM_DEVS;
 static int scsi_debug_opts = DEF_OPTS;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
 static int scsi_debug_cmnd_count = 0;
@@ -1100,160 +1103,33 @@
 	}
 }
 
-#ifndef MODULE
-static int __init num_devs_setup(char *str)
-{   
-    int tmp; 
-    
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_num_devs = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_num_devs: usage scsi_debug_num_devs=<n> "
-               "(<n> can be from 1 to around 2000)\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_num_devs=", num_devs_setup);
-
-static int __init max_luns_setup(char *str)
-{   
-    int tmp; 
-    
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_max_luns = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_max_luns: usage scsi_debug_max_luns=<n> "
-               "(<n> is a postive integer (def=2))\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_max_luns=", max_luns_setup);
-
-static int __init scsi_level_setup(char *str)
-{   
-    int tmp; 
-    
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_scsi_level = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_scsi_level: usage "
-	"scsi_debug_scsi_level=<n> (<n> is 1..4 (def=3))\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_scsi_level=", scsi_level_setup);
-
-static int __init dev_size_mb_setup(char *str)
-{   
-    int tmp; 
-    
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_dev_size_mb = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_dev_size_mb: usage "
-	       "scsi_debug_dev_size_mb=<n>\n"
-               "    (<n> is number of MB ram shared by all devs\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_dev_size_mb=", dev_size_mb_setup);
-
-static int __init opts_setup(char *str)
-{   
-    int tmp; 
-    
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_opts = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_opts: usage "
-	       "scsi_debug_opts=<n>\n"
-               "    (1->noise, 2->medium_error, 4->... (can be or-ed)\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_opts=", opts_setup);
-
-static int __init every_nth_setup(char *str)
-{
-    int tmp;
-
-    if (get_option(&str, &tmp) == 1) {
-        if (tmp > 0)
-            scsi_debug_every_nth = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_every_nth: usage "
-               "scsi_debug_every_nth=<n>\n"
-               "    timeout every nth command (when ...)\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_every_nth=", every_nth_setup);
-
-static int __init delay_setup(char *str)
-{
-    int tmp;
-
-    if (get_option(&str, &tmp) == 1) {
-	scsi_debug_delay = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_delay: usage "
-               "scsi_debug_delay=<n>\n"
-               "    delay response <n> jiffies\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_delay=", delay_setup);
-
-static int __init add_host_setup(char *str)
-{
-    int tmp;
-
-    if (get_option(&str, &tmp) == 1) {
-	scsi_debug_add_host = tmp;
-        return 1;
-    } else {
-        printk(KERN_INFO "scsi_debug_add_host: usage "
-               "scsi_debug_add_host=<n>\n"
-               "    <n> 0..127 (default 1)\n");
-        return 0;
-    }
-}
-__setup("scsi_debug_add_host=", add_host_setup);
-
-#endif
+/* Set 'perm' (4th argument) to 0 to disable module_param's definition
+ * of sysfs parameters (which module_param doesn't yet support).
+ * Sysfs parameters defined explicitly below. 
+ */
+module_param_named(num_devs, scsi_debug_num_devs, int, 0);
+module_param_named(max_luns, scsi_debug_max_luns, int, 0);
+module_param_named(scsi_level, scsi_debug_scsi_level, int, 0);
+module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, 0);
+module_param_named(opts, scsi_debug_opts, int, 0); /* perm=0644 */
+module_param_named(every_nth, scsi_debug_every_nth, int, 0);
+module_param_named(delay, scsi_debug_delay, int, 0); /* perm=0644 */
+module_param_named(add_host, scsi_debug_add_host, int, 0); /* perm=0644 */
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
-MODULE_PARM(scsi_debug_num_devs, "i");
-MODULE_PARM_DESC(scsi_debug_num_devs, "number of SCSI devices to simulate");
-MODULE_PARM(scsi_debug_max_luns, "i");
-MODULE_PARM_DESC(scsi_debug_max_luns, "number of SCSI LUNs per target to simulate");
-MODULE_PARM(scsi_debug_scsi_level, "i");
-MODULE_PARM_DESC(scsi_debug_scsi_level, "SCSI level to simulate");
-MODULE_PARM(scsi_debug_dev_size_mb, "i");
-MODULE_PARM_DESC(scsi_debug_dev_size_mb, "size in MB of ram shared by devs");
-MODULE_PARM(scsi_debug_opts, "i");
-MODULE_PARM_DESC(scsi_debug_opts, "1->noise, 2->medium_error, 4->...");
-MODULE_PARM(scsi_debug_every_nth, "i");
-MODULE_PARM_DESC(scsi_debug_every_nth, "timeout every nth command(def=100)");
-MODULE_PARM(scsi_debug_delay, "i");
-MODULE_PARM_DESC(scsi_debug_delay, "# of jiffies to delay response(def=1)");
-MODULE_PARM(scsi_debug_add_host, "i");
-MODULE_PARM_DESC(scsi_debug_add_host, "0..127 hosts allowed(def=1)");
 MODULE_LICENSE("GPL");
 
+MODULE_PARM_DESC(num_devs, "number of SCSI devices to simulate");
+MODULE_PARM_DESC(max_luns, "number of SCSI LUNs per target to simulate");
+MODULE_PARM_DESC(scsi_level, "SCSI level to simulate");
+MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs");
+MODULE_PARM_DESC(opts, "1->noise, 2->medium_error, 4->...");
+MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");
+MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
+MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
+
+
 static char sdebug_info[256];
 
 static const char * scsi_debug_info(struct Scsi_Host * shp)

--------------070607080200040905010607--

