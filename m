From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvscsi: add vscsi hosts to global list_head
Date: Wed,  7 Dec 2016 16:04:35 -0600
Message-ID: <1481148276-5083-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 001b2d01.pphosted.com ([148.163.156.1]:45788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932752AbcLGWFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 17:05:35 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uB7M05XJ052912
        for <linux-scsi@vger.kernel.org>; Wed, 7 Dec 2016 17:05:32 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 276reeedfe-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Dec 2016 17:05:32 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Wed, 7 Dec 2016 17:05:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Add each vscsi host adatper to a new global list_head named
ibmvscsi_head. There is no functional change. This is meant primarily
as a convience for locating adatpers from within the debugger or crash
utility.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 3 +++
 drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index d9534ee..a0ee16f 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -95,6 +95,7 @@ static int fast_fail = 1;
 static int client_reserve = 1;
 static char partition_name[97] = "UNKNOWN";
 static unsigned int partition_number = -1;
+static LIST_HEAD(ibmvscsi_head);
 
 static struct scsi_transport_template *ibmvscsi_transport_template;
 
@@ -2270,6 +2271,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	}
 
 	dev_set_drvdata(&vdev->dev, hostdata);
+	list_add_tail(&hostdata->host_list, &ibmvscsi_head);
 	return 0;
 
       add_srp_port_failed:
@@ -2291,6 +2293,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 static int ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+	list_del(&hostdata->host_list);
 	unmap_persist_bufs(hostdata);
 	release_event_pool(&hostdata->pool, hostdata);
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
index e0f6c3a..3a78755 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -90,6 +90,7 @@ struct event_pool {
 
 /* all driver data associated with a host adapter */
 struct ibmvscsi_host_data {
+	struct list_head host_list;
 	atomic_t request_limit;
 	int client_migrated;
 	int reset_crq;
-- 
1.8.3.1

