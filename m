From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] scsi_debug: add evpd83_use_hostno option to
 generate multipath-like device ID
Date: Tue, 11 Jul 2006 17:41:54 -0400 (EDT)
Message-ID: <20060711.174154.41627690.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello,

This patch adds evpd83_use_hostno option to scsi_debug to generate
multipath-like device ID for the debug devices.
This option is useful for multipath testing, especially
device-mapper multipath, because the user-space tool of
device-mapper multipath uses storage device ID for auto-detection
of multipath devices.

scsi_debug generates the device ID by given host_no, target number
and lun by default (evpd83_use_hostno=1).
If the option is set to '0', it ignores host_no value so the resulting
device ID will be identical for the devices which has same target number
and lun.

The patch is for 2.6.18-rc1 (scsi_debug 1.79).
Please consider to apply.

Regards,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rup 2.6.18-rc1/drivers/scsi/scsi_debug.c 2.6.18-rc1.evpd83/drivers/scsi/scsi_debug.c
--- 2.6.18-rc1/drivers/scsi/scsi_debug.c	2006-07-11 15:57:32.000000000 -0400
+++ 2.6.18-rc1.evpd83/drivers/scsi/scsi_debug.c	2006-07-11 15:57:24.000000000 -0400
@@ -86,6 +86,7 @@ static const char * scsi_debug_version_d
 #define DEF_D_SENSE   0
 #define DEF_NO_LUN_0   0
 #define DEF_VIRTUAL_GB   0
+#define DEF_EVPD83_USE_HOSTNO 1
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -127,6 +128,7 @@ static int scsi_debug_ptype = DEF_PTYPE;
 static int scsi_debug_dsense = DEF_D_SENSE;
 static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
 static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
+static int scsi_debug_evpd83_use_hostno = DEF_EVPD83_USE_HOSTNO;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -940,7 +942,10 @@ static int resp_inquiry(struct scsi_cmnd
 		int lu_id_num, target_dev_id, len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
-		
+
+		if (cmd[2] == 0x83 && !scsi_debug_evpd83_use_hostno)
+			host_no = 0;
+
 		lu_id_num = devip->wlun ? -1 : (((host_no + 1) * 2000) +
 			    (devip->target * 1000) + devip->lun);
 		target_dev_id = ((host_no + 1) * 2000) +
@@ -2164,6 +2169,8 @@ module_param_named(opts, scsi_debug_opts
 module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
 module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
+module_param_named(evpd83_use_hostno, scsi_debug_evpd83_use_hostno, int,
+		   S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2183,6 +2190,7 @@ MODULE_PARM_DESC(opts, "1->noise, 2->med
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
+MODULE_PARM_DESC(evpd83_use_hostno, "include host_no in device id (def=1 -> include)");
 
 
 static char sdebug_info[256];
@@ -2227,7 +2235,7 @@ static int scsi_debug_proc_info(struct S
 	    "%s [%s]\n"
 	    "num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
 	    "every_nth=%d(curr:%d)\n"
-	    "delay=%d, max_luns=%d, scsi_level=%d\n"
+	    "delay=%d, max_luns=%d, scsi_level=%d, evpd83_use_hostno=%d\n"
 	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
 	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
 	    "host_resets=%d\n",
@@ -2235,6 +2243,7 @@ static int scsi_debug_proc_info(struct S
 	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
 	    scsi_debug_cmnd_count, scsi_debug_delay,
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
+	    scsi_debug_evpd83_use_hostno,
 	    SECT_SIZE, sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
 	    num_aborts, num_dev_resets, num_bus_resets, num_host_resets);
 	if (pos < offset) {
@@ -2487,6 +2496,25 @@ static ssize_t sdebug_add_host_store(str
 DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show, 
 	    sdebug_add_host_store);
 
+static ssize_t sdebug_evpd83_use_hostno_show(struct device_driver * ddp,
+					       char * buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_evpd83_use_hostno);
+}
+static ssize_t sdebug_evpd83_use_hostno_store(struct device_driver * ddp,
+					      const char * buf, size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		scsi_debug_evpd83_use_hostno = n;
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(evpd83_use_hostno, S_IRUGO | S_IWUSR, sdebug_evpd83_use_hostno_show,
+	    sdebug_evpd83_use_hostno_store);
+
 static void do_create_driverfs_files(void)
 {
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_add_host);
@@ -2500,10 +2528,12 @@ static void do_create_driverfs_files(voi
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_ptype);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_opts);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
+	driver_create_file(&sdebug_driverfs_driver, &driver_attr_evpd83_use_hostno);
 }
 
 static void do_remove_driverfs_files(void)
 {
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_evpd83_use_hostno);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_opts);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ptype);
