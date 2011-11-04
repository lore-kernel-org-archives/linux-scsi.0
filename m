From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mpt2sas: add missing allocation.
Date: Fri, 4 Nov 2011 21:25:01 +0300
Message-ID: <20111104182501.GF5796@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25167 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab1KDSZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2011 14:25:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Kashyap Desai <kashyap.desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>, Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>, Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There was supposed to be a kzalloc() here and the compiler complained
about it.
mpt2sas_scsih.c: In function =E2=80=98mpt2sas_scsih_reset_handler=E2=80=
=99:
mpt2sas_scsih.c:2807:21: warning: =E2=80=98fw_event=E2=80=99 may be use=
d uninitialized in this function [-Wuninitialized]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sa=
s/mpt2sas_scsih.c
index 8889b1b..4e041f6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2802,6 +2802,11 @@ _scsih_error_recovery_delete_devices(struct MPT2=
SAS_ADAPTER *ioc)
=20
 	if (ioc->is_driver_loading)
 		return;
+
+	fw_event =3D kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+
 	fw_event->event =3D MPT2SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc =3D ioc;
 	_scsih_fw_event_add(ioc, fw_event);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
