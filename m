From: Dan Williams <dan.j.williams@intel.com>
Subject: [for 4.1 PATCH resend] libsas: fix "sysfs group not found" warnings
 at port teardown time
Date: Wed, 17 Jun 2015 23:22:45 -0400
Message-ID: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: JBottomley@odin.com, hch@lst.de
Cc: Praveen Murali <pmurali@logicube.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Praveen reports:

    After some debugging this is what I have found

    sas_phye_loss_of_signal gets triggered on phy_event from mvsas
        sas_phye_loss_of_signal calls sas_deform_port
             sas_deform_port posts a DISCE_DESTRUCT event (sas_unregister_domain_devices-> sas_unregister_dev)
             sas_deform_port calls sas_port_delete
                     sas_port_delete calls sas_port_delete_link
                             sysfs_remove_group: kobject 'port-X:Y'
                     sas_port_delete calls device_del
                             sysfs_remove_group: kobject 'port-X:Y'

    sas_destruct_devices gets triggered for the destruct event (DISCE_DESTRUCT)
        sas_destruct_devices calls sas_rphy_delete
            sas_rphy_delete calls scsi_remove_device
                 scsi_remove_device calls __scsi_remove_device
                         __scsi_remove_device calls bsg_unregister_queue
                                 bsg_unregister_queue -> device_unregister -> device_del -> sysfs_remove_group: kobject 'X:0:0:0'

    Since X:0:0:0 falls under port-X:Y (which got deleted during
    sas_port_delete), this call results in the warning. All the later
    warnings in the dmesg output I sent earlier are trying to delete objects
    under port-X:Y. Since port-X:Y got recursively deleted, all these calls
    result in warnings. Since, the PHY and DISC events are processed in two
    different work queues (and one triggers the other), is there any way
    other than checking if the object exists in sysfs (in device_del) before
    deleting?

    WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:219 device_del+0x40/0x1c0()
    sysfs group ffffffff818b97e0 not found for kobject '2:0:4:0'
    [..]
    CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: P        W  O  3.16.7-ckt9-logicube-ng.3 #1
    Hardware name: To be filled by O.E.M. To be filled by O.E.M./VT6085, BIOS 4.6.5 01/23/2015
    Workqueue: scsi_wq_2 sas_destruct_devices [libsas]
     0000000000000009 ffffffff8151cd18 ffff88011b35bcd8 ffffffff810687b7
     ffff88011a661400 ffff88011b35bd28 ffff8800c6e5e968 ffff880000028810
     ffff8800c89f2c00 ffffffff8106881c ffffffff81733b68 0000000000000028
    Call Trace:
     [<ffffffff8151cd18>] ? dump_stack+0x41/0x51
     [<ffffffff810687b7>] ? warn_slowpath_common+0x77/0x90
     [<ffffffff8106881c>] ? warn_slowpath_fmt+0x4c/0x50
     [<ffffffff813ad2d0>] ? device_del+0x40/0x1c0
     [<ffffffff813ad46a>] ? device_unregister+0x1a/0x70
     [<ffffffff812a535e>] ? bsg_unregister_queue+0x5e/0xb0
     [<ffffffffa00781a9>] ? __scsi_remove_device+0xa9/0xd0 [scsi_mod]

It appears we've always been double deleting the devices below sas_port,
but recent sysfs changes now exposes this problem.  Libsas should delete
all the devices from rphy down before deleting the parent port.

Cc: <stable@vger.kernel.org>
Reported-by: Praveen Murali <pmurali@logicube.com>
Tested-by: Praveen Murali <pmurali@logicube.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_discover.c |    6 +++---
 drivers/scsi/libsas/sas_port.c     |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 60de66252fa2..a4db770fe8b0 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -362,11 +362,14 @@ static void sas_destruct_devices(struct work_struct *work)
 	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
 
 	list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_node) {
+		struct sas_port *sas_port = dev_to_sas_port(dev->rphy->dev.parent);
+
 		list_del_init(&dev->disco_list_node);
 
 		sas_remove_children(&dev->rphy->dev);
 		sas_rphy_delete(dev->rphy);
 		sas_unregister_common_dev(port, dev);
+		sas_port_delete(sas_port);
 	}
 }
 
@@ -400,9 +403,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone)
 
 	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node)
 		sas_unregister_dev(port, dev);
-
-	port->port->rphy = NULL;
-
 }
 
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index d3c5297c6c89..9a25ae3a52a4 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -219,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 
 	if (port->num_phys == 1) {
 		sas_unregister_domain_devices(port, gone);
-		sas_port_delete(port->port);
 		port->port = NULL;
 	} else {
 		sas_port_delete_phy(port->port, phy->phy);
