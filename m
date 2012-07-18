From: olaf@aepfle.de
Subject: [PATCH] scsi/ibmvscsi: /sys/class/scsi_host/hostX/config doesn't show any information
Date: Wed, 18 Jul 2012 18:49:17 +0200
Message-ID: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:62074 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2GRQtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2012 12:49:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>, Olaf Hering <olaf@aepfle.de>

From: Linda Xie <lxiep@us.ibm.com>

Expected result:
It should show something like this:
x1521p4:~ # cat /sys/class/scsi_host/host1/config
PARTITIONNAME='x1521p4'
NWSDNAME='X1521P4'
HOSTNAME='X1521P4'
DOMAINNAME='RCHLAND.IBM.COM'
NAMESERVERS='9.10.244.100 9.10.244.200'

Actual result:
x1521p4:~ # cat /sys/class/scsi_host/host0/config
x1521p4:~ #

This patch changes the size of the buffer used for transfering config
data to 4K. It was tested against 2.6.19-rc2 tree.

Reported by IBM during SLES11 beta testing:

https://bugzilla.novell.com/show_bug.cgi?id=439970
LTC49349

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index e580aa4..1513ca8 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -93,6 +93,8 @@ static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
 static int fast_fail = 1;
 static int client_reserve = 1;
+/* host data buffer size */
+#define HOST_BUFFER_SIZE 4096
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -1666,7 +1668,7 @@ static ssize_t show_host_srp_version(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+       len = snprintf(buf, HOST_BUFFER_SIZE, "%s\n",
 		       hostdata->madapter_info.srp_version);
 	return len;
 }
@@ -1687,7 +1689,7 @@ static ssize_t show_host_partition_name(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+       len = snprintf(buf, HOST_BUFFER_SIZE, "%s\n",
 		       hostdata->madapter_info.partition_name);
 	return len;
 }
@@ -1708,7 +1710,7 @@ static ssize_t show_host_partition_number(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n",
+       len = snprintf(buf, HOST_BUFFER_SIZE, "%d\n",
 		       hostdata->madapter_info.partition_number);
 	return len;
 }
@@ -1728,7 +1730,7 @@ static ssize_t show_host_mad_version(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n",
+       len = snprintf(buf, HOST_BUFFER_SIZE, "%d\n",
 		       hostdata->madapter_info.mad_version);
 	return len;
 }
@@ -1748,7 +1750,7 @@ static ssize_t show_host_os_type(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os_type);
+       len = snprintf(buf, HOST_BUFFER_SIZE, "%d\n", hostdata->madapter_info.os_type);
 	return len;
 }
 
@@ -1767,7 +1769,7 @@ static ssize_t show_host_config(struct device *dev,
 	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 
 	/* returns null-terminated host config data */
-	if (ibmvscsi_do_host_config(hostdata, buf, PAGE_SIZE) == 0)
+       if (ibmvscsi_do_host_config(hostdata, buf, HOST_BUFFER_SIZE) == 0)
 		return strlen(buf);
 	else
 		return 0;
-- 
1.7.10.4

