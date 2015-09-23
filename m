From: Zhengping Zhou <johnzzpcrystal@gmail.com>
Subject: [PATCH 1/1] scsi subsystem : fix function __scsi_device_lookup
Date: Thu, 24 Sep 2015 06:37:57 +0800
Message-ID: <1443047877-16929-1-git-send-email-johnzzpcrystal@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, linux-kernel@vger.kernel.org, Zhengping Zhou <johnzzpcrystal@gmail.com>
List-Id: linux-scsi@vger.kernel.org

when a scsi_device is unpluged from scsi controller, if the
scsi_device is still be used by application layer,it won't be
released until users release it. In this case, scsi_device_remove just set
the scsi_device's state to be SDEV_DEL. But if you plug the disk
just before the old scsi_device is released, then there will be two
scsi_device structures in scsi_host->__devices. when the next unpluging 
event happens,some low-level drivers will check whether the scsi_device 
has been added to host (for example, the megaraid sas series controller) 
by calling scsi_device_lookup(call __scsi_device_lookup). 
__scsi_device_lookup will return the first scsi_device. Because its 
state is SDEV_DEL, the scsi_device_lookup will return NULL finally, 
making the low-level driver assume that the scsi_device has been 
removed,and won't call scsi_device_remove,which will lead the 
failure of hot swap.
Signed-off-by: Zhengping Zhou <johnzzpcrystal@gmail.com>
---
Hi all:
	I find a bug about the failure of hot swap when I am using 
	megaraid sas series controller. Finally I have found that 
	when controller receives the event of hot swap, it will firstly 
	check whether the device is added to the system/host by calling 
	scsi_device_lookup.The logics in function megasas_aen_polling 
	is as follows:
            case MR_EVT_PD_REMOVED:
                    if (megasas_get_pd_list(instance) == 0) { 
                    for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
                            for (j = 0; 
                            j < MEGASAS_MAX_DEV_PER_CHANNEL;
                            j++) {

                            pd_index =
                            (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j; 

                            sdev1 = scsi_device_lookup(host, i, j, 0);

                            if (instance->pd_list[pd_index].driveState
                                    == MR_PD_STATE_SYSTEM) {
                                    if (sdev1)
                                            scsi_device_put(sdev1);
                            } else {
                                    if (sdev1) {
                                            scsi_remove_device(sdev1);
                                            scsi_device_put(sdev1);
                                    }    
                            }    
                            }    
                    }    
                    }    
	If the previous scsi_device is not released, this will lead the 
	appearance of two scsi_devices which correspond with the same disk.
	And when the disk is unpluged afterwards, the controller will assume
	that this disk has never been added into the system/host. Thus it won't 
	call scsi_device_remove. When I finish this modification, this problem
	is fixed.So far, I have successfully test PCI_DEVICE_ID_LSI_SAS0073SKINNY 
	and PCI_DEVICE_ID_LSI_FURY.
Thanks
Zhengping
---
 drivers/scsi/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 207d6a7..5251d6d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1118,6 +1118,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
 		if (sdev->channel == channel && sdev->id == id &&
 				sdev->lun ==lun)
 			return sdev;
-- 
1.8.3.1
