From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/03] mpt2sas: modified _scsih_sas_device_find_by_handle/sas_address
Date: Tue, 9 Mar 2010 16:32:17 +0530
Message-ID: <20100309110206.GD13969@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:58610 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab0CILcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 06:32:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

modified _scsih_sas_device_find_by_handle
so to handle the search on both list(device list and device_init_list)
Also, we moved the priority of the
search so the ioc->sas_device_list is done first.  The
"sas_device_init_list" is only used during the 1st port enable, so its
unlikely there=E2=80=99s devices on it.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sa=
s/mpt2sas_scsih.c
index 678ee0e..453e694 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -483,27 +483,17 @@ struct _sas_device *
 mpt2sas_scsih_sas_device_find_by_sas_address(struct MPT2SAS_ADAPTER *i=
oc,
     u64 sas_address)
 {
-	struct _sas_device *sas_device, *r;
+	struct _sas_device *sas_device;
=20
-	r =3D NULL;
-	/* check the sas_device_init_list */
-	list_for_each_entry(sas_device, &ioc->sas_device_init_list,
-	    list) {
-		if (sas_device->sas_address !=3D sas_address)
-			continue;
-		r =3D sas_device;
-		goto out;
-	}
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
+		if (sas_device->sas_address =3D=3D sas_address)
+			return sas_device;
=20
-	/* then check the sas_device_list */
-	list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
-		if (sas_device->sas_address !=3D sas_address)
-			continue;
-		r =3D sas_device;
-		goto out;
-	}
- out:
-	return r;
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
+		if (sas_device->sas_address =3D=3D sas_address)
+			return sas_device;
+
+	return NULL;
 }
=20
 /**
@@ -518,28 +508,17 @@ mpt2sas_scsih_sas_device_find_by_sas_address(stru=
ct MPT2SAS_ADAPTER *ioc,
 static struct _sas_device *
 _scsih_sas_device_find_by_handle(struct MPT2SAS_ADAPTER *ioc, u16 hand=
le)
 {
-	struct _sas_device *sas_device, *r;
+	struct _sas_device *sas_device;
=20
-	r =3D NULL;
-	if (ioc->wait_for_port_enable_to_complete) {
-		list_for_each_entry(sas_device, &ioc->sas_device_init_list,
-		    list) {
-			if (sas_device->handle !=3D handle)
-				continue;
-			r =3D sas_device;
-			goto out;
-		}
-	} else {
-		list_for_each_entry(sas_device, &ioc->sas_device_list, list) {
-			if (sas_device->handle !=3D handle)
-				continue;
-			r =3D sas_device;
-			goto out;
-		}
-	}
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
+		if (sas_device->handle =3D=3D handle)
+			return sas_device;
=20
- out:
-	return r;
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
+		if (sas_device->handle =3D=3D handle)
+			return sas_device;
+
+	return NULL;
 }
=20
 /**
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
