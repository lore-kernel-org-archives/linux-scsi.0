From: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: fcoe pull request for 3.9-rc
Date: Tue, 25 Jun 2013 20:55:30 +0000
Message-ID: <51CA03C1.1040901@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Language: en-US
Content-ID: <BD103AD665EDD848B3732F06C1EDA6D8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Neil Horman <nhorman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The following changes since commit 1e876e3b1a9df25bb04682b0d48aaa7e8ae1fc82:

   Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2013-06-25 
09:08:07 -1000)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/critical_fix_for_3.9

for you to fetch changes up to 2884d4230867c8a46cf701214051e923301e7429:

   fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs 
(2013-06-25 12:23:19 -0700)

----------------------------------------------------------------
This patch fixes a critical bug that was introduced in 3.9
related to VLAN tagging FCoE frames.

----------------------------------------------------------------
Robert Love (1):
       fcoe: Use correct API to set vlan tag for FCoE Ethertype skbs

  drivers/scsi/fcoe/fcoe.c |    7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 292b24f..32ae6c6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1656,9 +1656,12 @@ static int fcoe_xmit(struct fc_lport *lport, 
struct fc_frame *fp)

      if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN &&
          fcoe->realdev->features & NETIF_F_HW_VLAN_CTAG_TX) {
-        skb->vlan_tci = VLAN_TAG_PRESENT |
-                vlan_dev_vlan_id(fcoe->netdev);
+        /* must set skb->dev before calling vlan_put_tag */
          skb->dev = fcoe->realdev;
+        skb = __vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+                         vlan_dev_vlan_id(fcoe->netdev));
+        if (!skb)
+            return -ENOMEM;
      } else
          skb->dev = fcoe->netdev;
