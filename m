Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A62C08D0;
	Tue, 28 Jul 2026 05:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785215637; cv=none; b=uaCQdoYby9jo7TZ9SqXrTKrcVM6ZGMQs7Lor+71nHyLLUl2qB59el5ofnLpsjQ5qh7j9wkQqqUruMI9XKHOSSUHutcVz0+iN+6XTwGj81Uyg1ubWB0yEOJuTJ/ZCGo9yOA/J3JY1IbNv7TuGfMgGRYO0vmA3ewrhpiap05Ywikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785215637; c=relaxed/simple;
	bh=jbTGYi+NLoyjJ3InitcHBgBts4nKXOxEzewOJVpnX6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEow4ATaGKJ7toB02RddJvX+jzXqNaJYPpvM/U69logZ+5u5dV4EMd2dlWr4A1L6IgjXKWmgqIQo/0ithmd1CTPHgUDts5tATX1BN6untAA/OToo3BtZ2BMFDhTLoZl/UWUkGCmVF+HMh3AWWlB2dg0wSdcGEdxxFWm8PKLbvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ev+fBIRD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ev+fBIRD"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3mjPM4034336;
	Tue, 28 Jul 2026 05:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1LbpDkW2BFy63bM+I
	nPi4RLXKXmMxDMkbbVpDS4ya14=; b=ev+fBIRDTcxpEoiNgd4w+qWLr1jBCj5lY
	v3bijYxJ47H39mgoarQK/Mko+Rq3AYk1IBLm5WWcyN9P9oeQOn3dqEiN87Ahoje1
	0nbzRrA3xRfGGry/3nVk604duiR39DdZGQsOOflbPlP3Hv8agDKsxSC7lVhV3+zG
	vALp4jC70l6c2FmnmNXW4pXjnK1W4lIn1J/aGEb+LmPvQMnEJPee/LhmamkldjrS
	lQev1nI/dD8XYMVlhjNHjxRN9nNbU3sQ7dleJP378eVejBVY0kIZspQsmd29pitV
	VuogD5ccUmTwbUl8xl16+kcSEAG+6i/GKK3wAP4RioHd8JSd+AgiA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyj312b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 05:13:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66S5BHwD016669;
	Tue, 28 Jul 2026 05:13:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk0d8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 05:13:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66S5Djih38535498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 05:13:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E91820182;
	Tue, 28 Jul 2026 04:49:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CF1A20181;
	Tue, 28 Jul 2026 04:49:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 04:49:12 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH v2 3/3] zfcp: trace return values of sysfs unit add store
Date: Tue, 28 Jul 2026 06:48:57 +0200
Message-ID: <20260728044857.2532646-4-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728044857.2532646-1-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfX1LA9qpFqqe6k
 EwnUBRQNhcqK6MoiYJ4F0hIUk2C35qmN41aAEGPD1hPbWCrPRrCf88UDdDmXHINBa6u6S9Z505R
 7zsRz8I7dioBh+t7wzojDF8LHJEOxt8=
X-Proofpoint-GUID: xdTgvpjPZ4vx2J91-WWgLQCOUzVrXBZh
X-Proofpoint-ORIG-GUID: xdTgvpjPZ4vx2J91-WWgLQCOUzVrXBZh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfX/vnS9DSSik1P
 N7JJ1Aj+gA3tdLkf/rqlHSAGNNxYxtvWhnKQ7BtfAU937XH0nk3FLSiFQUrBW+/3TVWNFEoaNJd
 +Yh+bQmw7Y6HHTd0MmDY3FT7govC8RCHWBKJ553MeMOfDjo91k6GqpipCTzIChc5R+uDutgl7T2
 GWNeyOlDgKk89t8JvEoo/CLZjEAWo1zZCpX7xPWK1IPBavpKeC1CybvB1u8u/TBoU2btQElLsMP
 sg58jFakvbEPeWiMc4KdKH01k2m2bgA9M3Q03fRe7gSsz27FCRxF8IxejQMTY1ESSD84pTc4dp+
 3R9Jy7tD2agmKy8Z/EHh6lgKqHkfJ2LgAGqKi9Jw3qtfpGYFKsE3l8MCrHexsqY/zJFP9zUvCiJ
 UgpAKZHq2HnLJ1T3XWgc/2iHlHLpX8bj4U4nN2rQdB5HJQDts27p0ncktxMezUXqTBPa2l52ncH
 rd0E6B67+WGdnA/9e4Q==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a683a91 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=i8TghgKPNKtOiMq2WZEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280041

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

---
v2 changes: initialize fcp_lun to 0.

Signed-off-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c   | 36 ++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_dbf.h   | 16 +++++++++++++++
 drivers/s390/scsi/zfcp_ext.h   |  4 +++-
 drivers/s390/scsi/zfcp_sysfs.c | 19 ++++++++++++------
 4 files changed, 68 insertions(+), 7 deletions(-)

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
index 42423549e511..4f23d585d062 100644
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
-	u64 fcp_lun;
-	int retval;
+	struct zfcp_adapter *adapter = port->adapter;
+	u64 fcp_lun = 0;
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

