From: Yinghai Lu <yinghai.lu@oracle.com>
Subject: [PATCH] mpt2sas: Fix null reference in recovery_delete_devices
Date: Thu, 10 Nov 2011 08:05:26 -0800
Message-ID: <4EBBF646.8010705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Got panic:
[  752.590700] BUG: unable to handle kernel NULL pointer dereference at 00000000000000f6
[  752.598542] IP: [<ffffffff8160b5f3>] mpt2sas_scsih_reset_handler+0x168/0x183
[  752.605595] PGD 175d43067 PUD 175d44067 PMD 0 
[  752.610081] Oops: 0002 [#1] SMP 
[  752.613342] CPU 0 
[  752.615175] Modules linked in:
[  752.618428] 
[  752.619921] Pid: 9187, comm: sas2flash Not tainted 3.2.0-rc1-tip-yh-01580-g878f195-dirty #1288 Oracle Corporation Sun Blade
[  752.632632] RIP: 0010:[<ffffffff8160b5f3>]  [<ffffffff8160b5f3>] mpt2sas_scsih_reset_handler+0x168/0x183

it turns out it is introduced in

_scsih_error_recovery_delete_devices() forget to alloc the event before using.

It is introduced by:

| commit 921cd8024b908f8f49f772c8d3a02381b4db2ed2
| Author: nagalakshmi.nandigama@lsi.com <nagalakshmi.nandigama@lsi.com>
| Date:   Wed Oct 19 15:36:26 2011 +0530
|
|    [SCSI] mpt2sas: New feature - Fast Load Support

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-2.6.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ linux-2.6/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2802,6 +2802,9 @@ _scsih_error_recovery_delete_devices(str
 
 	if (ioc->is_driver_loading)
 		return;
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
 	fw_event->event = MPT2SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
