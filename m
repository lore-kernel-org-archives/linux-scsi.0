Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26D238CFEF;
	Tue, 23 Jun 2026 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178271; cv=none; b=tWFkhZ7OZwA1eX8jxBzo6EuBYwv7d5Yfr1qkl7ESO29iY7qhHOKJY8Z6EBrGOg1srd1jpaEpJNk5VnsCXCdm+2Arq1GavNYtgEEDEj9NlsDDwDXYU00DINZrouz4K/WaqKwKl+ZRxcd26sTanWFdX0wlc1/Ce84LxWbnphrzXiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178271; c=relaxed/simple;
	bh=v+ozxpzhJNBHtTxxuUGi6R2f++hyvbXbKvS5ASv/poo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNLurkaP3RKALjOCXmJdTe4k8C2hyPZ/L3UOyBR+Lkd5dK9WpmVCy5J2UM5Y04/XeDOlPrO/ZzawVZM7+GdsjCbAP1CkiOgv+a6S1QJAEEl4H7uq8gbBEyxkM8Re+U/bx6kBCv4aKYV1vB1tkv+nUjivF/l5SOgwYbY8L5VmMtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rP90zLqs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rP90zLqs"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mJxY550491;
	Tue, 23 Jun 2026 01:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0HMlFPOHKh0A83pTq
	gOxLyCXAosCSkTUMRboRslYXPM=; b=rP90zLqsB0iN2W11gJTIXEy/9fiyjKUKj
	XcLQwG+EVARN9Sg/pBYSaPBu9xKuXZOOUlNG6X+ZB45EZGSs5wjHvJJCiMyOQC3M
	g5fTgQRGs5GGxLo6pmYAjGMg4fEk83vj2ruvUA02Fh7B5iOvHEtrpZ4H9gF2escQ
	kljyNFiy8QAYbqVFcFDlwuQElKeeECjwr1kJzBxRRpWziy9KUTPvcgY/3df3zIpV
	B9UU7UcEzoxkN+dtcZdh21UQsJlgu3uDXw41z5KtjQCciLzUyda1PPxJpuX+qLIa
	lod9OTv211KdFdn8M3g6+CcVkygSO67xiSixSWRQk2zJ9v/k9ZtxA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjhqm1sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:57 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JjQ2014687;
	Tue, 23 Jun 2026 01:30:56 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6ph8vmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:56 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Us6c60752218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:55 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCD1C58056;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C08258052;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:54 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 23/29] ibmvfc: declare global function definitions
Date: Mon, 22 Jun 2026 18:30:29 -0700
Message-ID: <20260623013035.3436640-24-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=I4VVgtgg c=1 sm=1 tr=0 ts=6a39e1d1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=AEPiXkB1DSZsRdhttTEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX9hBlI8S/fb0G
 KBb5LyxHo0byclSsmiUfUypwiWbHjbVnUIRpHHdCkpDXsxykNgAivuGdPuxw6HWnoN9TSZLe1q2
 G2cPhJr4i/A3ZigeAbvNLWzBXlhU8liaS3vgBFf0K5fvyIAF3nUDSUUE+n/2PJPggsVeOccJdeJ
 VgqPxhOtfYGFjCQgfxY6D0hTMAJXEIdV4B2VCozk0fS2Pv4s/lJGRT3prmLn/5P0cLFb9a8wWTz
 AIHLW9QBvPP3hfKVD2NUUPVAWCg6Gz2daYzccIIXhbQZVXMxrNwWQn9MDrk0w5uU2vJq82KnomJ
 d4BLExctW73EcFb10RMHC//aJ/Piw5wkrx/xy/VBxD/UHaY94AdRyKMykzn+wEDxYIdikVnym8S
 FuMcLFNoeWa+sRnvnatl0nU9C9LEEztMYz9ZQcjUn8aBVCqJIFl77Jz7keUt2m0aLzFRKKGxyqq
 9YkZN4rCHfYXYBJbcCA==
X-Proofpoint-GUID: rbWG-cDogZEp0_taySXuWdVhm8KbLuHc
X-Proofpoint-ORIG-GUID: rbWG-cDogZEp0_taySXuWdVhm8KbLuHc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/J2BQWeDqPmJ
 xOqVP+JC8Y61cMoI0soZifxXSkhlqc0pDE0jFWmVWXeBTKPTj3Gs+gRVM6sJd8YxNp06KfZHmtm
 rnFVQAQ8b658OFptqSYAGFXID2WBFZ4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230008

Some common functions will require visibility by both SCSI and NVMe
protocols. Make common ibmvfc helper routines available to the NVMe
support code.

Remove static from the core event allocation, event initialization,
event free, target release, command error, and event send helpers, and
declare them in ibmvfc.h. This allows ibmvfc-nvme.c to reuse the
existing event and target infrastructure.

No functional change is intended.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 22 ++++++----------------
 drivers/scsi/ibmvscsi/ibmvfc.h      | 17 +++++++++++++++++
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7e6912fba899..177d341ce7bc 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -206,13 +206,6 @@ static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
 	return rc;
 }
 
-static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
-{
-	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
-
-	return (host_caps & cap_flags) ? 1 : 0;
-}
-
 static int ibmvfc_nvme_active(struct ibmvfc_host *vhost)
 {
 	return (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF) &&
@@ -354,7 +347,7 @@ static int ibmvfc_get_err_index(u16 status, u16 error)
  * Return value:
  *	error description string
  **/
-static const char *ibmvfc_get_cmd_error(u16 status, u16 error)
+const char *ibmvfc_get_cmd_error(u16 status, u16 error)
 {
 	int rc = ibmvfc_get_err_index(status, error);
 	if (rc >= 0)
@@ -1076,7 +1069,7 @@ static int ibmvfc_valid_event(struct ibmvfc_event_pool *pool,
  * @evt:	ibmvfc_event to be freed
  *
  **/
-static void ibmvfc_free_event(struct ibmvfc_event *evt)
+void ibmvfc_free_event(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_event_pool *pool = &evt->queue->evt_pool;
 	unsigned long flags;
@@ -1410,7 +1403,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
  * @kref:		kref struct
  *
  **/
-static void ibmvfc_release_tgt(struct kref *kref)
+void ibmvfc_release_tgt(struct kref *kref)
 {
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
 	kfree(tgt);
@@ -1588,7 +1581,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
  *
  * Returns a free event from the pool.
  **/
-static struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int reserved)
+struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int reserved)
 {
 	struct ibmvfc_event *evt = NULL;
 	unsigned long flags;
@@ -1612,9 +1605,6 @@ static struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int r
 	return evt;
 }
 
-#define ibmvfc_get_event(queue) __ibmvfc_get_event(queue, 0)
-#define ibmvfc_get_reserved_event(queue) __ibmvfc_get_event(queue, 1)
-
 /**
  * ibmvfc_locked_done - Calls evt completion with host_lock held
  * @evt:	ibmvfc evt to complete
@@ -1639,7 +1629,7 @@ static void ibmvfc_locked_done(struct ibmvfc_event *evt)
  * @done:	Routine to call when the event is responded to
  * @format:	SRP or MAD format
  **/
-static void ibmvfc_init_event(struct ibmvfc_event *evt,
+void ibmvfc_init_event(struct ibmvfc_event *evt,
 			      void (*done) (struct ibmvfc_event *), u8 format)
 {
 	evt->cmnd = NULL;
@@ -1764,7 +1754,7 @@ static void ibmvfc_timeout(struct timer_list *t)
  *
  * Returns the value returned from ibmvfc_send_crq(). (Zero for success)
  **/
-static int ibmvfc_send_event(struct ibmvfc_event *evt,
+int ibmvfc_send_event(struct ibmvfc_event *evt,
 			     struct ibmvfc_host *vhost, unsigned long timeout)
 {
 	__be64 *crq_as_u64 = (__be64 *) &evt->crq;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index d8c2e5f1fdec..ece1f379c269 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1021,6 +1021,23 @@ struct ibmvfc_host {
 	struct completion nvme_delete_done;
 };
 
+struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int reserved);
+#define ibmvfc_get_event(queue) __ibmvfc_get_event(queue, 0)
+#define ibmvfc_get_reserved_event(queue) __ibmvfc_get_event(queue, 1)
+
+void ibmvfc_init_event(struct ibmvfc_event *evt, void (*done) (struct ibmvfc_event *), u8 format);
+void ibmvfc_free_event(struct ibmvfc_event *evt);
+void ibmvfc_release_tgt(struct kref *kref);
+int ibmvfc_send_event(struct ibmvfc_event *evt, struct ibmvfc_host *vhost, unsigned long timeout);
+const char *ibmvfc_get_cmd_error(u16 status, u16 error);
+
+static inline int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
+{
+	u64 host_caps = be64_to_cpu(vhost->login_buf->resp.capabilities);
+
+	return (host_caps & cap_flags) ? 1 : 0;
+}
+
 static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channels *channels)
 {
 	if (channels->protocol == IBMVFC_PROTO_SCSI)
-- 
2.54.0

