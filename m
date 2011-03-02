From: Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Date: Wed,  2 Mar 2011 23:10:03 +0100
Message-ID: <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
List-Id: linux-scsi@vger.kernel.org

drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer to=
 incomplete type
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: =E2=80=98MODULE_STATE_LI=
VE=E2=80=99 undeclared (first use in this function)

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bn=
x2fc_fcoe.c
index e476e87..689db39 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1812,10 +1812,12 @@ static int bnx2fc_disable(struct net_device *ne=
tdev)
=20
 	mutex_lock(&bnx2fc_dev_lock);
=20
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
 	if (THIS_MODULE->state !=3D MODULE_STATE_LIVE) {
 		rc =3D -ENODEV;
 		goto nodev;
 	}
+#endif
=20
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
@@ -1875,10 +1877,12 @@ static int bnx2fc_enable(struct net_device *net=
dev)
 	BNX2FC_MISC_DBG("Entered %s\n", __func__);
 	mutex_lock(&bnx2fc_dev_lock);
=20
+#ifdef CONFIG_SCSI_BNX2X_FCOE_MODULE
 	if (THIS_MODULE->state !=3D MODULE_STATE_LIVE) {
 		rc =3D -ENODEV;
 		goto nodev;
 	}
+#endif
=20
 	/* obtain physical netdev */
 	if (netdev->priv_flags & IFF_802_1Q_VLAN)
--=20
1.7.0.4
