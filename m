From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] scsi: qedi: select CONFIG_ISCSI_BOOT_SYSFS
Date: Mon, 24 Jul 2017 06:44:13 +0000
Message-ID: <D59B92EF.5A232%nilesh.javali@cavium.com>
References: <20170721161139.3330251-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:38887
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbdGXGoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jul 2017 02:44:17 -0400
In-Reply-To: <20170721161139.3330251-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <F04897D43C2C044AB85EE5E2D3BA9CF5@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Kashyap, Saurav" <Saurav.Kashyap@cavium.com>, "Rangankar, Manish" <Manish.Rangankar@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On 21/07/17, 9:41 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:

>Without the base library support, we get a link failure
>
>drivers/scsi/qedi/qedi_main.o: In function `__qedi_probe.constprop.0':
>qedi_main.c:(.text+0x2d8e): undefined reference to
>`iscsi_boot_create_target'
>qedi_main.c:(.text+0x2dee): undefined reference to
>`iscsi_boot_create_initiator'
>qedi_main.c:(.text+0x2e1c): undefined reference to
>`iscsi_boot_create_ethernet'
>
>This selects the Kconfig symbol like the other two users of that
>module do.
>
>Fixes: c57ec8fb7c02 ("scsi: qedi: Add support for Boot from SAN over
>iSCSI offload")
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>---
> drivers/scsi/qedi/Kconfig | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
>index 21331453db7b..8deb8723c4dd 100644
>--- a/drivers/scsi/qedi/Kconfig
>+++ b/drivers/scsi/qedi/Kconfig
>@@ -2,6 +2,7 @@ config QEDI
> 	tristate "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver Support"
> 	depends on PCI && SCSI && UIO
> 	depends on QED
>+	select ISCSI_BOOT_SYSFS
> 	select SCSI_ISCSI_ATTRS
> 	select QED_LL2
> 	select QED_ISCSI
>--=20
>2.9.0
>

NACK. The fix already posted to address this issue,
http://marc.info/?l=3Dlinux-scsi&m=3D150045528332067&w=3D2

Thanks,
Nilesh
