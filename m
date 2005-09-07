From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/8]  qla4xxx: initialization routines
Date: Wed, 7 Sep 2005 08:46:26 +0200
Message-ID: <200509070846.35147@bilbo.math.uni-mannheim.de>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com> <20050906220901.11409.44281.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3967814.UCEsFCYA49";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:62874 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750994AbVIGGqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 02:46:49 -0400
In-Reply-To: <20050906220901.11409.44281.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

--nextPart3967814.UCEsFCYA49
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andrew Vasquez wrote:
>ISP4xxx driver initialization routines.
>
>Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
>---
>
> drivers/scsi/qla4xxx/ql4_init.c | 1753
> +++++++++++++++++++++++++++++++++++++++ drivers/scsi/qla4xxx/ql4_iocb.c |=
=20
> 595 +++++++++++++
> 2 files changed, 2348 insertions(+), 0 deletions(-)
> create mode 100644 drivers/scsi/qla4xxx/ql4_init.c
> create mode 100644 drivers/scsi/qla4xxx/ql4_iocb.c
>
>6755c3b78809194fe31f551b3862639ae513b9a9
>diff --git a/drivers/scsi/qla4xxx/ql4_init.c
> b/drivers/scsi/qla4xxx/ql4_init.c new file mode 100644
>--- /dev/null
>+++ b/drivers/scsi/qla4xxx/ql4_init.c
>@@ -0,0 +1,1753 @@
>+/*
>+ * Copyright (c)  2003-2005 QLogic Corporation
>+ * QLogic Linux iSCSI Driver
>+ *
>+ * This program includes a device driver for Linux 2.6 that may be
>+ * distributed with QLogic hardware specific firmware binary file.
>+ * You may modify and redistribute the device driver code under the
>+ * GNU General Public License as published by the Free Software
>+ * Foundation (version 2 or a later version) and/or under the
>+ * following terms, as applicable:

[huge licence stuff]

Wouldn't it be enough to include that in one of the files (or even better: =
in=20
an extra file in Documentation/scsi/ or somewhere) and then reference to it?


>+/************************************************************************=
**
>+ * qla4xxx_free_ddb
>+ *	This routine deallocates and unlinks the specified ddb_entry from the
>+ *	adapter's
>+ *
>+ * Input:
>+ * 	ha - Pointer to host adapter structure.
>+ *	ddb_entry - Pointer to device database entry
>+ *
>+ * Returns:
>+ *	None
>+ *
>+ * Context:
>+ *	Kernel context.
>+
> *************************************************************************=
*/

Please take a look at Documentation/kernel-doc-nano-HOWTO.txt. And kernel=20
context is pretty normal in a device driver.

>+/*
>+ * qla4xxx_init_rings
>+ *	This routine initializes the internal queues for the specified adapter.
>+ *
>+ * Input:
>+ * 	ha - Pointer to host adapter structure.
>+ *
>+ * Remarks:
>+ *	The QLA4010 requires us to restart the queues at index 0.
>+ *	The QLA4000 doesn't care, so just default to QLA4010's requirement.
>+ * Returns:
>+ *	QLA_SUCCESS - Always return success.
>+ *
>+ * Context:
>+ *	Kernel context.
>+ */

And here you have a different style just 2 functions later

>+int
>+qla4xxx_init_rings(scsi_qla_host_t * ha)
>+{
[...]
>+	/* Initialize active array */
>+	for (i =3D 0; i < MAX_SRBS; i++)
>+		ha->active_srb_array[i] =3D 0;
>+	ha->active_srb_count =3D 0;

memset() ?

>+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>+
>+	return QLA_SUCCESS;
>+}

I don't see it returning anything different. So this return value is rather=
=20
useless, isn't it? And from my point of view I prefer to use the normal err=
or=20
codes as much as possible instead of inventing my own.

Eike


--nextPart3967814.UCEsFCYA49
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDHozLXKSJPmm5/E4RAkyhAKCar+hwSta9W9yn+1scrUWGIQ38bgCdFqJc
okb1zvFFXDKabLuoIJtt1EU=
=8q6m
-----END PGP SIGNATURE-----

--nextPart3967814.UCEsFCYA49--
