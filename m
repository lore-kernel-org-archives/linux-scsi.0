Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2EE34BA20;
	Thu, 11 Jun 2026 05:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154386; cv=none; b=u9qIDQrj8NUQKHf/56cjgERzrEiFKrIzt4Q7zs9E/GN1r7cvkkSzIp9mOh6+fMkF0Gh6/cCmdoJqPlATxus7IZ2uXEzKpZ0cZfLXPVRr0iMbpvaiHaRnqn7U87B6hVqZE6AQhXCjs/XmKEGixq+07sKMNDAan2nygBYfaluzriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154386; c=relaxed/simple;
	bh=OXgwG+Wa6aXbPVMvUn4vvw1HztQG4DGxqa/2+BgC4Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF8TJnY4G1/PqhHBlgZ6dd1Thj9y/kwOi6kcEtfQoPVLDZoNPewcZHUMct0G6CnjhZmJTWTM0FYzDx+D19mQTbKiwE9iQbdOKkzNGV9lNj85XvFmFRVk6OJnBWOFOzemM+kH+BVNnFch7bKkRk66zWmR6byrqJcNGUnbqsq2yPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NANiWFrd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NANiWFrd"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJuZi61364529;
	Thu, 11 Jun 2026 05:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WmwzDQ7TTo6gTaa5C
	qPgeAIrCRNVK5wzy6C/XIGVsBo=; b=NANiWFrdBJu4DLAazvoZ9geKjOSF9XfOR
	0tS+uGlsoj39T9J4fSm9QTbQZv8MoJmSoRxLDB7UztVSwitIi1StRktdMfcmrOY2
	RWuDFepbYSKABVM6XpfRvDQYGTSxl68afJMU0SPfEwZ9sMTQjRvMKisLm24Hrbsp
	GRVN2kM2C8KPijcqyd2aK29QlILD8aVvr/nOLSE43SX9CmSDKJHUZ8d7DQerWSzb
	VsCCtY/e44K0ufNtgnJsrJoNnIAJJpDIttzrggdJ0fdsuMxjQnxSTIhUoPIyrf5Z
	jqe+W/VPnhYwnnEaJ1FnMhp3k/8/KObQAVMQ72o6BnjNZ41DeDoWw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8dsg1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B54ejG021336;
	Thu, 11 Jun 2026 05:06:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe0a1qb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B568da50397458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 05:06:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD00B20043;
	Thu, 11 Jun 2026 05:06:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D50E20040;
	Thu, 11 Jun 2026 05:06:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 05:06:08 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: [PATCH 3/3] zfcp: trace return values of sysfs unit add store
Date: Thu, 11 Jun 2026 07:05:25 +0200
Message-ID: <20260611050550.796772-5-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611050550.796772-1-niharp@linux.ibm.com>
References: <20260611050550.796772-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EsHt-I_m-VoSu8PZxRI1k4P78VrYjHcZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA0MiBTYWx0ZWRfX4nb4CgSe375I
 63/Z7HS05AyzwI1nw/T1Etw/MXZjFnr8zkLDyzGgK9jwSRYQ4iX4h+yHOhyqUgSHvS9+fvPsRYP
 +lsFd/YFltFa19ryqO1CfxqN30A36YpXpE7OIudmtVAdZILYVaqmtIhWFZYOx8emPPO4rhawKeG
 gUa1IL478dNnNrwE5R7H3i4hicOtiVRRelFSmCbMKYgkYQZKYgonIx9Vx/a9uj5j1xC8L/7+FLN
 pJRH1wW57Pi66h32hYrLmdFTyzSY86X5PCvYsuahJpoPeXZPdqLi1SfUILhUf9bxtkLDq2ZMJtE
 o2vquX+dl9VL9/yVvu/1Ae0ZYrrA1duK/Oysq6U9J7T1nooV5uGn7fuZHmvzF/1KaoeK1jKUSxX
 y+hdeOl7CVCvOe1kCIADGij6Hb2hvuLve0qF47CsD/qjbBVuUtNHvSw6vAko4WMgKUzP/QknzQ3
 wdNv5ELlEc/+VUAEP8A==
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a2a4247 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=i8TghgKPNKtOiMq2WZEA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA0MiBTYWx0ZWRfX/zF/vjWD002c
 fVoVac1eFBV6HtNJL1NanHSE7P8sA3wBcbFSyuIWW6j4hAAENC2N8w1lVgQybQqhYe6MGxtkTYH
 VuuNhVsBOl9Y4lOgR013xL4vw0q0jKA=
X-Proofpoint-ORIG-GUID: EsHt-I_m-VoSu8PZxRI1k4P78VrYjHcZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110042

From: Chinmaya Kajagar <chinmayk@linux.ibm.com>

Sysfs unit add failures are seen during FCP devices manual SCSI LUN
scans, indicating the kernel cannot add a LUN, usually because the
device is offline, already exists, no memory or the target port is
incorrectly configured.

Add a new trace to debug zfcp sysfs unit add failures with tag id
ZFCP_DBF_HBA_UAS. This traces wwpn, fcp lun id, return value (error
condition) and associated hba of the device.

Typical unit add store failures as seen below example syslog messages,

Feb  2 10:47:25 systemd-udevd[823]: rport-1:0-2: /etc/udev/
rules.d/41-zfcp-lun-0.0.50c0:0x500507680b26c449:0x01d2000000000000.rules:10
Failed to write ATTR{/sys/devices/css0/0.0.0015/0.0.50c0/0x500507680b26c449
/unit_add}, ignoring: File exists

Feb  2 10:50:03 systemd-udevd[801]: rport-2:0-3: /etc/udev/
rules.d/41-zfcp-lun-0.0.50c0:0x500507680b26c448:0x01d2000000000000.rules:10
Failed to write ATTR{/sys/devices/css0/0.0.0015/0.0.50c0/0x500507680b26c448
/unit_add}, ignoring: Cannot allocate memory

Example zfcpdbf traces for both the errors:

Timestamp      : 2026-03-05-07:28:34:029797
Area           : HBA
Subarea        : 00
Level          : 3
Exception      : -
CPU ID         : 0002
Caller         : 0x000001fe345e6d0e
Record ID      : 6
Tag            : syuast2
Description    : syuast2 HBA, unit add, failed, unable to add unit
Request ID     : 0x00000000ffffffff
Request status : 0xffffffff
FSF cmnd       : 0xffffffff
FSF sequence no: 0xffffffff
WWPN           : 0x500507680b25c448
LUN            : 0x01d3000000000000
Return Value   : 0xfffffff4

Timestamp      : 2026-03-05-07:33:04:151807 <== the last record
Area           : HBA
Subarea        : 00
Level          : 3
Exception      : -
CPU ID         : 0002
Caller         : 0x000001fe345e6d0e
Record ID      : 6
Tag            : syuast2
Description    : syuast2 HBA, unit add, failed, unable to add unit
Request ID     : 0x00000000ffffffff
Request status : 0xffffffff
FSF cmnd       : 0xffffffff
FSF sequence no: 0xffffffff
WWPN           : 0x500507680b25c449
LUN            : 0x01d0000000000000
Return Value   : 0xfffffff4

Signed-off-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c   | 36 ++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_dbf.h   | 16 +++++++++++++++
 drivers/s390/scsi/zfcp_ext.h   |  4 +++-
 drivers/s390/scsi/zfcp_sysfs.c | 17 +++++++++++-----
 4 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 4217b74baa38..81fb8af408e9 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -265,6 +265,42 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
+/**
+ * zfcp_dbf_hba_uas - trace event for sysfs unit add store
+ * @tag: tag indicating which kind of unit add store condition occurred
+ * @level: debug trace level
+ * @adapter: pointer to struct zfcp_adapter
+ * @wwpn: remote port wwn
+ * @fcp_lun: FCP LUN
+ * @ret: return value
+ */
+void zfcp_dbf_hba_uas(char *tag, int level, struct zfcp_adapter *adapter,
+		      u64 wwpn, u64 fcp_lun, int ret)
+{
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
+	unsigned long flags;
+
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
+	spin_lock_irqsave(&dbf->hba_lock, flags);
+	memset(rec, 0, sizeof(*rec));
+
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_HBA_UAS;
+	rec->fsf_req_id = ~0u;
+	rec->fsf_req_status = ~0u;
+	rec->fsf_cmd = ~0u;
+	rec->fsf_seq_no = ~0u;
+	rec->u.uas.wwpn = wwpn;
+	rec->u.uas.fcp_lun = fcp_lun;
+	rec->u.uas.ret = ret;
+
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_lock, flags);
+}
+
 /**
  * zfcp_dbf_hba_bit_err - trace event for bit error conditions
  * @tag: tag indicating which kind of bit error unsolicited status was received
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index c84f076440a8..79973fb24b1c 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -174,6 +174,18 @@ struct zfcp_dbf_hba_uss {
 	u8 res4[20];
 } __packed;
 
+/**
+ * struct zfcp_dbf_hba_uas - trace record for sysfs unit add store
+ * @wwpn: remote port wwn
+ * @fcp_lun: FCP LUN
+ * @ret: return value
+ */
+struct zfcp_dbf_hba_uas {
+	u64 wwpn;
+	u64 fcp_lun;
+	u32 ret;
+} __packed;
+
 /**
  * struct zfcp_dbf_hba_fces - trace record for FC Endpoint Security
  * @req_issued: timestamp when request was issued
@@ -200,6 +212,7 @@ struct zfcp_dbf_hba_fces {
  * @ZFCP_DBF_HBA_BIT: bit error trace record
  * @ZFCP_DBF_HBA_BASIC: basic adapter event, only trace tag, no other data
  * @ZFCP_DBF_HBA_FCES: FC Endpoint Security trace record
+ * @ZFCP_DBF_HBA_UAS: unit add store trace record
  */
 enum zfcp_dbf_hba_id {
 	ZFCP_DBF_HBA_RES	= 1,
@@ -207,6 +220,7 @@ enum zfcp_dbf_hba_id {
 	ZFCP_DBF_HBA_BIT	= 3,
 	ZFCP_DBF_HBA_BASIC	= 4,
 	ZFCP_DBF_HBA_FCES	= 5,
+	ZFCP_DBF_HBA_UAS        = 6,
 };
 
 /**
@@ -223,6 +237,7 @@ enum zfcp_dbf_hba_id {
  * @u.uss:  data for unsolicited status buffer
  * @u.be:   data for bit error unsolicited status buffer
  * @u.fces: data for FC Endpoint Security
+ * @u.uas:  data for unit add store
  */
 struct zfcp_dbf_hba {
 	u8 id;
@@ -237,6 +252,7 @@ struct zfcp_dbf_hba {
 		struct zfcp_dbf_hba_uss uss;
 		struct fsf_bit_error_payload be;
 		struct zfcp_dbf_hba_fces fces;
+		struct zfcp_dbf_hba_uas uas;
 	} u;
 } __packed;
 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 9f5152b42b0e..40bd597fb4cd 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -4,7 +4,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2023
+ * Copyright IBM Corp. 2002, 2026
  */
 
 #ifndef ZFCP_EXT_H
@@ -49,6 +49,8 @@ extern void zfcp_dbf_hba_fsf_fces(char *tag, const struct zfcp_fsf_req *req,
 extern void zfcp_dbf_hba_fsf_reqid(const char *const tag, const int level,
 				   struct zfcp_adapter *const adapter,
 				   const u64 req_id);
+extern void zfcp_dbf_hba_uas(char *tag, int level, struct zfcp_adapter *adapter,
+			     u64 wwpn, u64 fcp_lun, int ret);
 extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_def_err(struct zfcp_adapter *, u64, u16, void **);
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 42423549e511..729c9664a48f 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -4,7 +4,7 @@
  *
  * sysfs attributes.
  *
- * Copyright IBM Corp. 2008, 2020
+ * Copyright IBM Corp. 2008, 2026
  */
 
 #define pr_fmt(fmt) "zfcp: " fmt
@@ -442,17 +442,24 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 					 const char *buf, size_t count)
 {
 	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
+	struct zfcp_adapter *adapter = port->adapter;
 	u64 fcp_lun;
-	int retval;
+	int retval = -EINVAL;
 
-	if (kstrtoull(buf, 0, (unsigned long long *) &fcp_lun))
-		return -EINVAL;
+	if (kstrtoull(buf, 0, (unsigned long long *)&fcp_lun)) {
+		zfcp_dbf_hba_uas("syuast1", 3, adapter, port->wwpn,
+				 fcp_lun, retval);
+		return retval;
+	}
 
 	flush_work(&port->rport_work);
 
 	retval = zfcp_unit_add(port, fcp_lun);
-	if (retval)
+	if (retval) {
+		zfcp_dbf_hba_uas("syuast2", 3, adapter, port->wwpn,
+				 fcp_lun, retval);
 		return retval;
+	}
 
 	return count;
 }
-- 
2.53.0

