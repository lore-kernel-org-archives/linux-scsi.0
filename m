From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH] libsas: flush pending destruct work in sas_unregister_domain_devices()
Date: Mon, 27 Nov 2017 16:24:45 -0800
Message-ID: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We saw dozens of the following kernel waring:

 WARNING: CPU: 0 PID: 705 at fs/sysfs/group.c:224 sysfs_remove_group+0x54/0x88()
 sysfs group ffffffff81ab7670 not found for kobject '6:0:3:0'
 Modules linked in: cpufreq_ondemand x86_pkg_temp_thermal coretemp kvm_intel kvm microcode raid0 iTCO_wdt iTCO_vendor_support sb_edac edac_core lpc_ich mfd_core ioatdma i2c_i801 shpchp wmi hed acpi_cpufreq lp parport tcp_diag inet_diag ipmi_si ipmi_devintf ipmi_msghandler sch_fq_codel igb ptp pps_core i2c_algo_bit i2c_core crc32c_intel isci libsas scsi_transport_sas dca ipv6
 CPU: 0 PID: 705 Comm: kworker/u240:0 Not tainted 4.1.35.el7.x86_64 #1
 Hardware name: WIWYNN Lyra/JD/S2600GZ, BIOS SE5C600.86B.02.03.2004.030620151456 03/06/2015
 Workqueue: scsi_wq_6 sas_destruct_devices [libsas]
  0000000000000000 ffff88056c393ba8 ffffffff81544a6d ffff88056c393bf8
  0000000000000009 ffff88056c393be8 ffffffff81069b4c ffff88081790d078
  ffffffff811dad37 0000000000000000 ffffffff81ab7670 ffff88081b29dc10
 Call Trace:
  [<ffffffff81544a6d>] dump_stack+0x4d/0x63
  [<ffffffff81069b4c>] warn_slowpath_common+0xa1/0xbb
  [<ffffffff811dad37>] ? sysfs_remove_group+0x54/0x88
  [<ffffffff81069bac>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff811d77ad>] ? kernfs_find_and_get_ns+0x4d/0x58
  [<ffffffff811dad37>] sysfs_remove_group+0x54/0x88
  [<ffffffff81387835>] dpm_sysfs_remove+0x50/0x55
  [<ffffffff8137de7c>] device_del+0x47/0x1ec
  [<ffffffff815482f7>] ? mutex_unlock+0x16/0x18
  [<ffffffff8137e069>] device_unregister+0x48/0x54
  [<ffffffff8128eb82>] bsg_unregister_queue+0x5f/0x86
  [<ffffffff813aac83>] __scsi_remove_device+0x3a/0xc3
  [<ffffffff813aad32>] scsi_remove_device+0x26/0x33
  [<ffffffff813aaea2>] scsi_remove_target+0x134/0x19b
  [<ffffffffa0078725>] sas_rphy_remove+0x2c/0x72 [scsi_transport_sas]
  [<ffffffffa007877e>] sas_rphy_delete+0x13/0x1f [scsi_transport_sas]
  [<ffffffffa008817c>] sas_destruct_devices+0x58/0x79 [libsas]
  [<ffffffff8107cca1>] process_one_work+0x19b/0x2d1
  [<ffffffff8107d38e>] worker_thread+0x1dd/0x2bb
  [<ffffffff8107d1b1>] ? cancel_delayed_work+0x72/0x72
  [<ffffffff8108165a>] kthread+0xa5/0xad
  [<ffffffff81080000>] ? task_work_add+0xd/0x53
  [<ffffffff810815b5>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8154a492>] ret_from_fork+0x42/0x70
  [<ffffffff810815b5>] ? __kthread_parkme+0x61/0x61

It looks like we don't wait for sas destruct work properly
on tear down path, at least sas_deform_port() calls
sas_unregister_domain_devices() to schedule destruct work
to a workqueue and then calls sas_port_delete() to remove
the related sysfs files concurrently.

Dan tried to fix this with a different way:

 https://patchwork.kernel.org/patch/6450921/

but that patch is never applied. I take a better approach
as suggested by Johannes, that is waiting for pending destruct
work to remove child sysfs files and then removing the parent
sysfs files.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Praveen Murali <pmurali@logicube.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 drivers/scsi/libsas/sas_discover.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de66252fa2..27c11fc7aa2b 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -388,6 +388,11 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 }
 
+static void sas_flush_work(struct asd_sas_port *port)
+{
+	scsi_flush_work(port->ha->core.shost);
+}
+
 void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 {
 	struct domain_device *dev, *n;
@@ -401,8 +406,8 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 		sas_unregister_dev(port, dev);
 
+	sas_flush_work(port);
 	port->port->rphy = NULL;
-
 }
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
-- 
2.13.0
