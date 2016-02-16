From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] fusion-mptbase: handle failed allocation for workqueue
Date: Mon, 15 Feb 2016 21:50:41 -0500
Message-ID: <1455591041-8667-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
List-Id: linux-scsi@vger.kernel.org

the failure of ioc->reset_work_q is checked,
but not ioc->fw_event_q.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/message/fusion/mptbase.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5dcc031..d4907a1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1996,6 +1996,13 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	snprintf(ioc->fw_event_q_name, MPT_KOBJ_NAME_LEN, "mpt/%d", ioc->id);
 	ioc->fw_event_q = create_singlethread_workqueue(ioc->fw_event_q_name);
 
+	if (!ioc->fw_event_q) {
+		destroy_workqueue(ioc->reset_work_q);
+		pci_release_selected_regions(pdev, ioc->bars);
+		kfree(ioc);
+		return -ENOMEM;
+	}
+
 	if ((r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
 	    CAN_SLEEP)) != 0){
 		printk(MYIOC_s_ERR_FMT "didn't initialize properly! (%d)\n",
-- 
1.9.1
