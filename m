From: Linda Xie <lxiep@us.ibm.com>
Subject: [PATCH] imbvscsi: use 4k buffer  to transfer config data
Date: Fri, 08 Dec 2006 20:51:37 -0600
Message-ID: <457A24B9.2010804@us.ibm.com>
Reply-To: lxiep@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040107040606040404080807"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54019 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947509AbWLHXyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2006 18:54:13 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kB8NsDRB020786
	for <linux-scsi@vger.kernel.org>; Fri, 8 Dec 2006 18:54:13 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kB8NsDmP387040
	for <linux-scsi@vger.kernel.org>; Fri, 8 Dec 2006 16:54:13 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kB8NsCsi013704
	for <linux-scsi@vger.kernel.org>; Fri, 8 Dec 2006 16:54:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Dave C Boutcher <sleddog@us.ibm.com>, Santiago Leon <santil@us.ibm.com>

This is a multi-part message in MIME format.
--------------040107040606040404080807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi James,

This patch changes the size of the buffer used for transfering config 
data to 4K. It was tested against
2.6.19-rc2 tree.

Please consider it for inclusion in upstream.

Thanks,  

Linda Xie
IBM LTC

Signed-off-by: lxie@us.ibm.com




--------------040107040606040404080807
Content-Type: text/plain;
 name="ibmvscsi_config.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ibmvscsi_config.patch"

--- linux-2.6.17.ppc64/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-09-28 15:03:54.000000000 -0500
+++ linux-2.6.17.ppc64-linda/drivers/scsi/ibmvscsi/ibmvscsi.c	2006-09-28 15:00:56.000000000 -0500
@@ -86,8 +86,10 @@ static int max_id = 64;
 static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = 50;
+/* host data buffer size */
+#define buff_size	4096
 
-#define IBMVSCSI_VERSION "1.5.8"
+#define IBMVSCSI_VERSION "1.5.9"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -1347,7 +1349,7 @@ static ssize_t show_host_srp_version(str
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+	len = snprintf(buf, buff_size, "%s\n",
 		       hostdata->madapter_info.srp_version);
 	return len;
 }
@@ -1368,7 +1370,7 @@ static ssize_t show_host_partition_name(
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+	len = snprintf(buf, buff_size, "%s\n",
 		       hostdata->madapter_info.partition_name);
 	return len;
 }
@@ -1389,7 +1391,7 @@ static ssize_t show_host_partition_numbe
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n",
+	len = snprintf(buf, buff_size, "%d\n",
 		       hostdata->madapter_info.partition_number);
 	return len;
 }
@@ -1409,7 +1411,7 @@ static ssize_t show_host_mad_version(str
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n",
+	len = snprintf(buf, buff_size, "%d\n",
 		       hostdata->madapter_info.mad_version);
 	return len;
 }
@@ -1429,7 +1431,7 @@ static ssize_t show_host_os_type(struct 
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os_type);
+	len = snprintf(buf, buff_size, "%d\n", hostdata->madapter_info.os_type);
 	return len;
 }
 
@@ -1448,7 +1450,7 @@ static ssize_t show_host_config(struct c
 	    (struct ibmvscsi_host_data *)shost->hostdata;
 
 	/* returns null-terminated host config data */
-	if (ibmvscsi_do_host_config(hostdata, buf, PAGE_SIZE) == 0)
+	if (ibmvscsi_do_host_config(hostdata, buf, buff_size) == 0)
 		return strlen(buf);
 	else
 		return 0;

--------------040107040606040404080807--

