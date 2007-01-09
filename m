From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: [PATCH] qla2xxx: correct locking while call starget_for_each_device()
Date: Tue, 9 Jan 2007 11:37:52 -0800
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B8069EA@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C73425.A7CF6984"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:52906 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXAITwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 14:52:04 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C73425.A7CF6984
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Removed spin_unlock_irq()/spin_lock_irq() pairs surrounding
starget_for_each_device() calls.
As Matthew W. pointed out, starget_for_each_device() can be called under
a spinlock being held.
The change has been tested and verified on qla2xxx.ko module.
Thanks Matthew W. and Hisashi H. for help.

Signed-off-by: Andrew Vasquez <Andrew.vasquez@qlogic.com>
Signed-off-by: Seokmann Ju <Seokmann.ju@qlogic.com>
---
diff --git a/drivers/scsi/qla2xxx/qla_isr.c
b/drivers/scsi/qla2xxx/qla_isr.c index 39fd17b..ba67077 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -654,10 +654,8 @@ qla2x00_ramp_up_queue_depth(scsi_qla_host_t *ha,
srb_t
*sp)
 	    fcport->last_queue_full + ql2xqfullrampup * HZ))
 		return;

-	spin_unlock_irq(&ha->hardware_lock);
 	starget_for_each_device(sdev->sdev_target, fcport,
 	    qla2x00_adjust_sdev_qdepth_up);
-	spin_lock_irq(&ha->hardware_lock);
 }

 /**
@@ -927,10 +925,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void
*pkt)

 			/* Adjust queue depth for all luns on the port.
*/
 			fcport->last_queue_full =3D jiffies;
-			spin_unlock_irq(&ha->hardware_lock);
 			starget_for_each_device(cp->device->sdev_target,
 			    fcport, qla2x00_adjust_sdev_qdepth_down);
-			spin_lock_irq(&ha->hardware_lock);
 			break;
 		}
 		if (lscsi_status !=3D SS_CHECK_CONDITION)
---


------_=_NextPart_001_01C73425.A7CF6984
Content-Type: application/octet-stream;
	name="cor_qfull.diff"
Content-Transfer-Encoding: base64
Content-Description: cor_qfull.diff
Content-Disposition: attachment;
	filename="cor_qfull.diff"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9pc3IuYw0KaW5kZXggMzlmZDE3Yi4uYmE2NzA3NyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2lzci5jDQpAQCAtNjU0LDEwICs2NTQsOCBAQCBxbGEyeDAwX3JhbXBfdXBfcXVldWVf
ZGVwdGgoc2NzaV9xbGFfaG9zdF90ICpoYSwgc3JiX3QgKnNwKQ0KIAkgICAgZmNwb3J0LT5sYXN0
X3F1ZXVlX2Z1bGwgKyBxbDJ4cWZ1bGxyYW1wdXAgKiBIWikpDQogCQlyZXR1cm47DQogDQotCXNw
aW5fdW5sb2NrX2lycSgmaGEtPmhhcmR3YXJlX2xvY2spOw0KIAlzdGFyZ2V0X2Zvcl9lYWNoX2Rl
dmljZShzZGV2LT5zZGV2X3RhcmdldCwgZmNwb3J0LA0KIAkgICAgcWxhMngwMF9hZGp1c3Rfc2Rl
dl9xZGVwdGhfdXApOw0KLQlzcGluX2xvY2tfaXJxKCZoYS0+aGFyZHdhcmVfbG9jayk7DQogfQ0K
IA0KIC8qKg0KQEAgLTkyNywxMCArOTI1LDggQEAgcWxhMngwMF9zdGF0dXNfZW50cnkoc2NzaV9x
bGFfaG9zdF90ICpoYSwgdm9pZCAqcGt0KQ0KIA0KIAkJCS8qIEFkanVzdCBxdWV1ZSBkZXB0aCBm
b3IgYWxsIGx1bnMgb24gdGhlIHBvcnQuICovDQogCQkJZmNwb3J0LT5sYXN0X3F1ZXVlX2Z1bGwg
PSBqaWZmaWVzOw0KLQkJCXNwaW5fdW5sb2NrX2lycSgmaGEtPmhhcmR3YXJlX2xvY2spOw0KIAkJ
CXN0YXJnZXRfZm9yX2VhY2hfZGV2aWNlKGNwLT5kZXZpY2UtPnNkZXZfdGFyZ2V0LA0KIAkJCSAg
ICBmY3BvcnQsIHFsYTJ4MDBfYWRqdXN0X3NkZXZfcWRlcHRoX2Rvd24pOw0KLQkJCXNwaW5fbG9j
a19pcnEoJmhhLT5oYXJkd2FyZV9sb2NrKTsNCiAJCQlicmVhazsNCiAJCX0NCiAJCWlmIChsc2Nz
aV9zdGF0dXMgIT0gU1NfQ0hFQ0tfQ09ORElUSU9OKQ0K

------_=_NextPart_001_01C73425.A7CF6984--
