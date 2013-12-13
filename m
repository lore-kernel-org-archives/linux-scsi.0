From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 3/3] drivers: message: Mark functions as static in mptsas.c
Date: Fri, 13 Dec 2013 11:40:35 +0530
Message-ID: <14b2696b781c98ce10a0075753bbe2cc7c7fc2e7.1386914148.git.rashika.kheria@gmail.com>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

This patch marks the function mptsas_refreshing_device_handles(),
mptsas_expander_add() and mptsas_shutdown() as static in fusion/mptsas.=
c
because they are not used outside this file.

Thus, it also eliminates the following warnings in fusion/mptsas.c:
drivers/message/fusion/mptsas.c:1579:1: warning: no previous prototype =
for =E2=80=98mptsas_refreshing_device_handles=E2=80=99 [-Wmissing-proto=
types]
drivers/message/fusion/mptsas.c:3654:1: warning: no previous prototype =
for =E2=80=98mptsas_expander_add=E2=80=99 [-Wmissing-prototypes]
drivers/message/fusion/mptsas.c:5327:1: warning: no previous prototype =
for =E2=80=98mptsas_shutdown=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/message/fusion/mptsas.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/m=
ptsas.c
index dd239bd..906f448 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1575,7 +1575,7 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mp=
tsas_phyinfo *phy_info)
 	mptsas_port_delete(ioc, phy_info->port_details);
 }
=20
-struct mptsas_phyinfo *
+static struct mptsas_phyinfo *
 mptsas_refreshing_device_handles(MPT_ADAPTER *ioc,
 	struct mptsas_devinfo *sas_device)
 {
@@ -3650,7 +3650,7 @@ mptsas_send_expander_event(struct fw_event_work *=
fw_event)
  * @handle:
  *
  */
-struct mptsas_portinfo *
+static struct mptsas_portinfo *
 mptsas_expander_add(MPT_ADAPTER *ioc, u16 handle)
 {
 	struct mptsas_portinfo buffer, *port_info;
@@ -5323,7 +5323,7 @@ mptsas_probe(struct pci_dev *pdev, const struct p=
ci_device_id *id)
 	return error;
 }
=20
-void
+static void
 mptsas_shutdown(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc =3D pci_get_drvdata(pdev);
--=20
1.7.9.5
