From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] iscsi_ibft: filter null v4-mapped v6 addresses
Date: Thu,  7 May 2015 22:14:31 -0700
Message-ID: <1431062071-7074-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBU4MWGVAKGQEORTS4LI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konrad Rzeszutek Wilk <konrad-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I've had reports of UEFI platforms failing iSCSI boot in various
configurations, that ended up being caused by network initialization
scripts getting tripped up by unexpected null addresses (0.0.0.0) being
reported for gateways, dhcp servers, and dns servers.

The tianocore EDK2 iSCSI driver generates an iBFT table that always uses
IPv4-mapped IPv6 addresses for the NIC structure fields.  This results
in values that are "not present or not specified" being reported as
::ffff:0.0.0.0 rather than all zeros as specified.

The iscsi_ibft module filters unspecified fields from the iBFT from
sysfs, preventing userspace from using invalid values and making it easy
to check for the presence of a value.  This currently fails in regard to
these mapped null addresses.

In order to remain consistent with how the iBFT information is exposed,
we should accommodate the behavior of the tianocore iSCSI driver as it's
already in the wild in a large number of servers.

Tested under qemu using an OVMF build of tianocore EDK2.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/iscsi_ibft.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 071c2c9..7279123 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -186,8 +186,20 @@ struct ibft_kobject {
 
 static struct iscsi_boot_kset *boot_kset;
 
+/* fully null address */
 static const char nulls[16];
 
+/* IPv4-mapped IPv6 ::ffff:0.0.0.0 */
+static const char mapped_nulls[16] = { 0x00, 0x00, 0x00, 0x00,
+                                       0x00, 0x00, 0x00, 0x00,
+                                       0x00, 0x00, 0xff, 0xff,
+                                       0x00, 0x00, 0x00, 0x00 };
+
+static int address_not_null(u8 *ip)
+{
+	return (memcmp(ip, nulls, 16) && memcmp(ip, mapped_nulls, 16));
+}
+
 /*
  * Helper functions to parse data properly.
  */
@@ -445,7 +457,7 @@ static umode_t ibft_check_nic_for(void *data, int type)
 		rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_IP_ADDR:
-		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
+		if (address_not_null(nic->ip_addr))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_SUBNET_MASK:
@@ -456,21 +468,19 @@ static umode_t ibft_check_nic_for(void *data, int type)
 		rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_GATEWAY:
-		if (memcmp(nic->gateway, nulls, sizeof(nic->gateway)))
+		if (address_not_null(nic->gateway))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_PRIMARY_DNS:
-		if (memcmp(nic->primary_dns, nulls,
-			   sizeof(nic->primary_dns)))
+		if (address_not_null(nic->primary_dns))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_SECONDARY_DNS:
-		if (memcmp(nic->secondary_dns, nulls,
-			   sizeof(nic->secondary_dns)))
+		if (address_not_null(nic->secondary_dns))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_DHCP:
-		if (memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
+		if (address_not_null(nic->dhcp))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_ETH_VLAN:
@@ -536,23 +546,19 @@ static umode_t __init ibft_check_initiator_for(void *data, int type)
 		rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_INI_ISNS_SERVER:
-		if (memcmp(init->isns_server, nulls,
-			   sizeof(init->isns_server)))
+		if (address_not_null(init->isns_server))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_INI_SLP_SERVER:
-		if (memcmp(init->slp_server, nulls,
-			   sizeof(init->slp_server)))
+		if (address_not_null(init->slp_server))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_INI_PRI_RADIUS_SERVER:
-		if (memcmp(init->pri_radius_server, nulls,
-			   sizeof(init->pri_radius_server)))
+		if (address_not_null(init->pri_radius_server))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_INI_SEC_RADIUS_SERVER:
-		if (memcmp(init->sec_radius_server, nulls,
-			   sizeof(init->sec_radius_server)))
+		if (address_not_null(init->sec_radius_server))
 			rc = S_IRUGO;
 		break;
 	case ISCSI_BOOT_INI_INITIATOR_NAME:
-- 
2.1.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
