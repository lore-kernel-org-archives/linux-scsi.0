From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/2] iscsi_ibft: Add prefix-len attribute
Date: Fri, 22 Jan 2016 11:49:12 -0800
Message-ID: <d3149ad6dd01934a080fcd634d4dbfbaa35b3500.1453419653.git.lduncan@suse.com>
References: <cover.1453419653.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbcAVTvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 14:51:31 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C9E51AC86
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 19:51:28 +0000 (UTC)
In-Reply-To: <cover.1453419653.git.lduncan@suse.com>
In-Reply-To: <cover.1453419653.git.lduncan@suse.com>
References: <cover.1453419653.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, Lee Duncan <lduncan@suse.com>

From: Hannes Reinecke <hare@suse.de>

The iBFT table only specifies a prefix length, not a netmask.
And the netmask is pretty much pointless for IPv6.
So introduce a new attribute 'prefix-len' and display the
netmask attribute only for IPv4 addresses.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/firmware/iscsi_ibft.c    | 12 +++++++++++-
 drivers/scsi/iscsi_boot_sysfs.c  |  5 +++++
 include/linux/iscsi_boot_sysfs.h |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 72791232e46b..2dd1fbb8cccc 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -319,6 +319,9 @@ static ssize_t ibft_attr_show_nic(void *data, int type, char *buf)
 		val = cpu_to_be32(~((1 << (32-nic->subnet_mask_prefix))-1));
 		str += sprintf(str, "%pI4", &val);
 		break;
+	case ISCSI_BOOT_ETH_PREFIX_LEN:
+		str += sprintf(str, "%d\n", nic->subnet_mask_prefix);
+		break;
 	case ISCSI_BOOT_ETH_ORIGIN:
 		str += sprintf(str, "%d\n", nic->origin);
 		break;
@@ -460,10 +463,17 @@ static umode_t ibft_check_nic_for(void *data, int type)
 		if (address_not_null(nic->ip_addr))
 			rc = S_IRUGO;
 		break;
-	case ISCSI_BOOT_ETH_SUBNET_MASK:
+	case ISCSI_BOOT_ETH_PREFIX_LEN:
 		if (nic->subnet_mask_prefix)
 			rc = S_IRUGO;
 		break;
+	case ISCSI_BOOT_ETH_SUBNET_MASK:
+		if (!memcmp(nic->ip_addr, nulls, 10) &&
+		    (nic->ip_addr[10] == 0xff) &&
+		    (nic->ip_addr[11] == 0xff) &&
+		    nic->subnet_mask_prefix)
+			rc = S_IRUGO;
+		break;
 	case ISCSI_BOOT_ETH_ORIGIN:
 		rc = S_IRUGO;
 		break;
diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index 680bf6f0ce76..8f0ea97cf31f 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -166,6 +166,7 @@ static struct attribute_group iscsi_boot_target_attr_group = {
 iscsi_boot_rd_attr(eth_index, index, ISCSI_BOOT_ETH_INDEX);
 iscsi_boot_rd_attr(eth_flags, flags, ISCSI_BOOT_ETH_FLAGS);
 iscsi_boot_rd_attr(eth_ip, ip-addr, ISCSI_BOOT_ETH_IP_ADDR);
+iscsi_boot_rd_attr(eth_prefix, prefix-len, ISCSI_BOOT_ETH_PREFIX_LEN);
 iscsi_boot_rd_attr(eth_subnet, subnet-mask, ISCSI_BOOT_ETH_SUBNET_MASK);
 iscsi_boot_rd_attr(eth_origin, origin, ISCSI_BOOT_ETH_ORIGIN);
 iscsi_boot_rd_attr(eth_gateway, gateway, ISCSI_BOOT_ETH_GATEWAY);
@@ -181,6 +182,7 @@ static struct attribute *ethernet_attrs[] = {
 	&iscsi_boot_attr_eth_index.attr,
 	&iscsi_boot_attr_eth_flags.attr,
 	&iscsi_boot_attr_eth_ip.attr,
+	&iscsi_boot_attr_eth_prefix.attr,
 	&iscsi_boot_attr_eth_subnet.attr,
 	&iscsi_boot_attr_eth_origin.attr,
 	&iscsi_boot_attr_eth_gateway.attr,
@@ -208,6 +210,9 @@ static umode_t iscsi_boot_eth_attr_is_visible(struct kobject *kobj,
 	else if (attr ==  &iscsi_boot_attr_eth_ip.attr)
 		return boot_kobj->is_visible(boot_kobj->data,
 					     ISCSI_BOOT_ETH_IP_ADDR);
+	else if (attr ==  &iscsi_boot_attr_eth_prefix.attr)
+		return boot_kobj->is_visible(boot_kobj->data,
+					     ISCSI_BOOT_ETH_PREFIX_LEN);
 	else if (attr ==  &iscsi_boot_attr_eth_subnet.attr)
 		return boot_kobj->is_visible(boot_kobj->data,
 					     ISCSI_BOOT_ETH_SUBNET_MASK);
diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index 2a8b1659bf35..548d55395488 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -23,6 +23,7 @@ enum iscsi_boot_eth_properties_enum {
 	ISCSI_BOOT_ETH_INDEX,
 	ISCSI_BOOT_ETH_FLAGS,
 	ISCSI_BOOT_ETH_IP_ADDR,
+	ISCSI_BOOT_ETH_PREFIX_LEN,
 	ISCSI_BOOT_ETH_SUBNET_MASK,
 	ISCSI_BOOT_ETH_ORIGIN,
 	ISCSI_BOOT_ETH_GATEWAY,
-- 
1.8.5.2

