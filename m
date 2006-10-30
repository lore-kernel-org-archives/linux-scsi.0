From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] SCSI: ISCSI build failure
Date: Mon, 30 Oct 2006 08:32:30 -0800
Message-ID: <20061030083230.5e889415.randy.dunlap@oracle.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
	<20061029190357.98fc9c98.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0610301206240.6761@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:24307 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1030430AbWJ3QhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2006 11:37:23 -0500
In-Reply-To: <Pine.LNX.4.64.0610301206240.6761@scrub.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roman Zippel <zippel@linux-m68k.org>, jejb <james.bottomley@steeleye.com>
Cc: Toralf F_rster <toralf.foerster@gmx.de>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Mon, 30 Oct 2006 12:07:48 +0100 (CET) Roman Zippel wrote:

> Hi,
>=20
> On Sun, 29 Oct 2006, Randy Dunlap wrote:
>=20
> > On Sun, 29 Oct 2006 19:45:15 +0100 Toralf F=F6rster wrote:
> >=20
> > > Hello,
> >=20
> > config SCSI_ISCSI_ATTRS
> > 	tristate "iSCSI Transport Attributes"
> > 	depends on SCSI && NET
> > 	help
> > 	  If you wish to export transport-specific information about
> > 	  each attached iSCSI device to sysfs, say Y.
> > 	  Otherwise, say N.
> >=20
> > but NET is disabled, yet somehow SCSI_ISCSI_ATTRS is enabled.
> > I don't see how that happens.
> > Roman, any ideas?
> >=20
> > [...]
> > > CONFIG_SCSI_QLA_ISCSI=3Dy
>=20
> I guess, that needs a dependency on NET.

Yep, thanks, Roman.

James, should be in 2.6.19...

---

=46rom: Randy Dunlap <randy.dunlap@oracle.com>

SCSI_QLA_ISCSI needs to depend on NET to prevent build (link) failures
that are caused by selecting SCSI_ISCSI_ATTRS.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla4xxx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19-rc3-git6.orig/drivers/scsi/qla4xxx/Kconfig
+++ linux-2.6.19-rc3-git6/drivers/scsi/qla4xxx/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_QLA_ISCSI
 	tristate "QLogic ISP4XXX host adapter family support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	---help---
 	This driver supports the QLogic 40xx (ISP4XXX) iSCSI host
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
