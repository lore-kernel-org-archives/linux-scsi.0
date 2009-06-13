From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] a couple of SCSI bug fixes from the last update
Date: Sat, 13 Jun 2009 12:55:48 -0500
Message-ID: <1244915748.5323.30.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57504 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbZFMRzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 13:55:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This just fixes up a couple of config based problems in the cnic driver
(which is the broadcom iSCSI base).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog:

Ingo Molnar (1):
      cnic: fix error: implicit declaration of function =E2=80=98__symb=
ol_get=E2=80=99

Randy Dunlap (1):
      cnic: fix undefined reference to `ip6_route_output'

and the diffstat:

 drivers/net/cnic.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

=46ull diff below

James

---

diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
index 8d74037..44f77eb 100644
--- a/drivers/net/cnic.c
+++ b/drivers/net/cnic.c
@@ -25,6 +25,8 @@
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
+#include <linux/module.h>
+
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #define BCM_VLAN 1
 #endif
@@ -1454,6 +1456,7 @@ static inline u16 cnic_get_vlan(struct net_device=
 *dev,
 static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
 			     struct dst_entry **dst)
 {
+#if defined(CONFIG_INET)
 	struct flowi fl;
 	int err;
 	struct rtable *rt;
@@ -1465,12 +1468,15 @@ static int cnic_get_v4_route(struct sockaddr_in=
 *dst_addr,
 	if (!err)
 		*dst =3D &rt->u.dst;
 	return err;
+#else
+	return -ENETUNREACH;
+#endif
 }
=20
 static int cnic_get_v6_route(struct sockaddr_in6 *dst_addr,
 			     struct dst_entry **dst)
 {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MO=
DULE))
 	struct flowi fl;
=20
 	memset(&fl, 0, sizeof(fl));
@@ -1550,7 +1556,7 @@ static int cnic_get_route(struct cnic_sock *csk, =
struct cnic_sockaddr *saddr)
 	clear_bit(SK_F_IPV6, &csk->flags);
=20
 	if (is_v6) {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MO=
DULE))
 		set_bit(SK_F_IPV6, &csk->flags);
 		err =3D cnic_get_v6_route(&saddr->remote.v6, &dst);
 		if (err)



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
