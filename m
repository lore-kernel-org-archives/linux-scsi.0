Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E114A8B;
	Wed, 16 Sep 2026 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789517198; cv=none; b=nsh23nYdC/GyMng6l0dWhb24gWxrszfvvldwEJQC80DPA9B1DeW3KfzJldEKJATqSxLxzMMSk/Jqyk6Sz1BTioH2cGj/2xvq0KIbQ2vbgr0boFlQ7QW8wWDtxMEiVgbl45Giodw90HPFjDy3WiJGemDykiZ+Jk5J6wJ99nAY88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789517198; c=relaxed/simple;
	bh=sIi2Nl9mdw7kw+TPf0jG4ls9mQZuecEUkfWu8yA5BcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CxpxaycYoRiPfvX2IXgHia80Jfi1pesddKBA9Em5Dok86ek41KWRVrNwDh825O9bjGmZM1iScKz7bkweV+8/q+1gZhDrwGL8qHiIc5sVT83C5RS2ggrtZITG1+6f1YtzHakqyZprxFMKNM6S08oIq4QAfzq5BeoUN4KY0YjiLTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WOq7evNK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WOq7evNK"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLVilX1963947;
	Wed, 16 Sep 2026 00:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=V5WpnStf+Rd0lBqWuatYSSuftAAMzABqYOVOc7JFF
	ic=; b=WOq7evNKWEU9/SejKo6XWTqVyr1I9bPEy2VnDpZXvZpi93z7VYhqLBei6
	3t7cgK4HndF798m9AxYCbKCPOieXhoOD/MAPs2Y90lDoVEzhbvEG5sc3lvBzl0fH
	g98gwSXz8PKjKhw5Fy8NhIwA+HoDj0E1oXZHyfn3nbAaWGoWytio0Yu1eRnb/1mD
	4PbLPBOH3JLBYqJbTFnTC7vTQem4jo+zM/ZyuNXEFBwUSzVU/9he4sE9+RLDsYtH
	JqwQxRUO85PbL04A4kl2ohx0IKZgpYaZYBKn2OICnmIxhIJrYYSg14Z5bKj1vVEk
	PzpJMsBg7l2Mw3QRQEHAWVAG4lczQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf51y8g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 00:06:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLa2MY464062;
	Wed, 16 Sep 2026 00:06:30 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vbweu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 00:06:30 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G06Ta739846254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 00:06:29 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B07D58054;
	Wed, 16 Sep 2026 00:06:29 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EBA95804E;
	Wed, 16 Sep 2026 00:06:28 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.83.139])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 00:06:27 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH] ibmvscsi: implement vio driver shutdown call back to quiesce ibmvscsi
Date: Tue, 15 Sep 2026 17:06:26 -0700
Message-ID: <20260916000626.1981569-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gtdjm5p1bXhy66eL3-7cQlO0vVQFUJgM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM1MiBTYWx0ZWRfX2sE1h8+o9prQ
 uy3mXomsh9BuggUUciUJ+h8hciBW9PmuJH7B2qBL3d6cSMT/kwNEHgt1dB1pzHeAY1IThPqOXka
 JR5Fo5jxJAA9bpxoViokonxzP5lNk6Y=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aa9dd87 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=_VdnjSN4jw3ftuXtCEsA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
X-Proofpoint-ORIG-GUID: gtdjm5p1bXhy66eL3-7cQlO0vVQFUJgM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM1MiBTYWx0ZWRfXyrCy0gjYeJCw
 g2XyFnk7p/gD6eNgK6trAMSnxkKLxey9XQHEtd143t9Ljscm1Ltbv0pWKqXBt/lj+FOnOBGIuVO
 Ixy3sjITphrTijDwKVOP3i5r3TVun7uqK59PV78TpYRvYd9Cmthk+xArZ5RYex+VaFytbDf2gJR
 aGOFZByZ7kSn5yPHGy+8/f6oyzZNNW/Sx2djbV77RkQIfm5ykU1hwxDAJ7BMTtYuSHoVXOyOrAM
 FXg3GC5UdwpNvT1FkIeB/rLKyREKQIIKMUD/i02oog6GMNSuDNQbKwexhjqeU29PFL3PLGjmAU+
 1AgWyqbTlDsrI2+S3CWcAL/6zz7fwdIqEtazqopisf9Z3naMoR1NnP8Fg2/rY5214K6et/KMn1A
 m6ldxETQa5G86BsDqjdZ4h3IWe6VNAlLDIXxbEFmuQ8GJlcyp8GInWlsRynd6NQv3Xxcjb43HB2
 D88eeCKTNSOyoibm2KQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150352

Currently during kexec the vio driver implementation calls a drivers
remove function as a big hammer when shutdown isn't implemented. This
results in filesystem errors in the log as a result of the block device
being removed while the filesystem is still mounted. Rectify this noise
by quiescing the ibmvscsi driver and stopping short of tearing down the
full host.

Move quiesce calls to their own helper function. Add a driver shutdown
call back and implement with call to ibmvscsi_quiesce such that any
outstanding commands are purged and failed back to the midlayer with
DID_REQUEUE. Update ibmvscsi_remove to also use the new ibmvscsi_quiesce
and failback outstanding commands with DID_ERROR prior to full transport
teardown.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 4ecd3db08875..bc8da31fdfbd 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2341,26 +2341,39 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return -1;
 }
 
-static void ibmvscsi_remove(struct vio_dev *vdev)
+static void ibmvscsi_quiesce(struct ibmvscsi_host_data *hostdata, int scsi_error_code)
 {
-	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
-
-	srp_remove_host(hostdata->host);
-	scsi_remove_host(hostdata->host);
-
-	purge_requests(hostdata, DID_ERROR);
-	release_event_pool(&hostdata->pool, hostdata);
+	scsi_block_requests(hostdata->host);
+	kthread_stop(hostdata->work_thread);
 
 	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
 					max_events);
 
-	kthread_stop(hostdata->work_thread);
+	purge_requests(hostdata, scsi_error_code);
+
+	release_event_pool(&hostdata->pool, hostdata);
 	unmap_persist_bufs(hostdata);
+}
+
+static void ibmvscsi_shutdown(struct vio_dev *vdev)
+{
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+
+	ibmvscsi_quiesce(hostdata, DID_REQUEUE);
+}
+
+static void ibmvscsi_remove(struct vio_dev *vdev)
+{
+	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
+
+	ibmvscsi_quiesce(hostdata, DID_ERROR);
 
 	spin_lock(&ibmvscsi_driver_lock);
 	list_del(&hostdata->host_list);
 	spin_unlock(&ibmvscsi_driver_lock);
 
+	srp_remove_host(hostdata->host);
+	scsi_remove_host(hostdata->host);
 	scsi_host_put(hostdata->host);
 }
 
@@ -2398,6 +2411,7 @@ static struct vio_driver ibmvscsi_driver = {
 	.id_table = ibmvscsi_device_table,
 	.probe = ibmvscsi_probe,
 	.remove = ibmvscsi_remove,
+	.shutdown = ibmvscsi_shutdown,
 	.get_desired_dma = ibmvscsi_get_desired_dma,
 	.name = "ibmvscsi",
 	.pm = &ibmvscsi_pm_ops,
-- 
2.55.0

