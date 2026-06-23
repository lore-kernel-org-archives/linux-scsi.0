Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6333770B;
	Tue, 23 Jun 2026 01:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178264; cv=none; b=mwVUsq+whSzF12AFd+wRwjx4nBG456Y2m2qYCissW1VYUt07AqCReDbRx817tEZoeVfLESrx/BGjkioyd+36D5sdgJ+NQQM5uH6Sq1NzBkLnX08pvh6xh6bDIIHnAN1BMbjdxeAcyI3NjGXaZ2LKPN8j6jZx0kcukWiw5rg+i4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178264; c=relaxed/simple;
	bh=YZyLsd1nYSr/Z129rWIyQmUeqzkAL33FR3Ijlz7LXe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqkMCt83t8SRqxSNo+ywHK/OxWXu4YJKoh6+VWWbgcd3e2wWT9Q+XMJomi2UmGSfoTfI5f52BsQnEohaU7PYqk1rFbPUBDb8vrSBP74N2+EFHwuX99JGutCUF8XykcXyXnqhVPTiOOJdBMxtRdub+emmE4uSAFFoPDby4Y+lBYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SOMXIM+W; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SOMXIM+W"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mJjw408203;
	Tue, 23 Jun 2026 01:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=k5VScfDahLgVssQxx
	4kWeRs6DRZCnWyWqlq8ZWEPG0E=; b=SOMXIM+WP0d8ET3GxK1nrDTNXJzTBg0Nb
	TeoWOV5FJ0Y/iAA31wOvN2yCAMm2u/gHGCQcDixfZbL3f7vakgcZyrsyGkKGCw9n
	sM668oqvd9o5MICkRLmcsPbVVo87e3hmczBm1H/nNrSfJZGO4U1thCpllCjcki0o
	5VMdywpb+ZuseBmUFN9gls2W5A+BI6UE/fg/wKzLdDExcH2Vj2ivO69kt8gy8yBC
	2jJDrGz7Cl/Tzo9wQKVIguu7nrJGA/Z5XaPcVDxrUCvclvS3fiwXo9TxJvVn0JlX
	mMZxihoT3lwRuv4pbHX90EMJMIdKGBWt+xwBt6tCPX2XJrPLatINg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jl6T005253;
	Tue, 23 Jun 2026 01:30:51 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex5jw92jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:51 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Uobe13632230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:50 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 795D758052;
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBFA058056;
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 17/29] ibmvfc: delete NVMe/FC targets as well as SCSI
Date: Mon, 22 Jun 2026 18:30:23 -0700
Message-ID: <20260623013035.3436640-18-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1cc cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=FlIHKPD9N9UiteZsW-UA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/Yheg/g3k+PK
 hxXZVIl9zh2Vj1IYgKLV450kFePt7lflLvSi6mvXDpCJ03CdFFaxwZ0WU4TPrXZwHSCMVeJLtIt
 K/tT4tX3FJqpix0agw7B0x0ueTyO7pU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX4VPlBsp6Vfwa
 ZuH7XY92TVA1Ksf7uLQ53aL2YfNzbI07+HZl2bSHAAXisfkbZi0pUcNWVl9EDVYbV3f+LAy4xOv
 pGoT1NvnscsKrZyRIQUPOET7XiPA4DP/9BmwY3XXroSSMsJoi+fQ7wFj9KdUNgp5T/5LqeOeOBb
 ed2UkUhQrDUaRXuIOhsTbelLbnOD7IySp9neYF8cJbDUN5iZaGLdolISADZ1DxfZEa1CWQ+2AIr
 EGJ8CiT7fac7umq6KFYdS0DHNaF9kiQ9BYje8GZhDY10S5d7UQLe8khDsVMu04w1Doy+qMbaAcZ
 NIgUotXu1wKvPFYZRvPnG02wJe9d3+0rQdnP+5REYWUZWYvieoR4bPS0szkfmSkFZujmx65kOea
 P3Bf5PaZnqMBtBIdzQk7tFWrYzsVhX6IRF2GfZe7X0j2kt3IBZqsuMIXnDLhrkNiIG71u1VA7cw
 F2ZZz/8uw/LRKpWGJwg==
X-Proofpoint-ORIG-GUID: ps9VWZinrFgTeGJrujdo8Y5y1-c6AQA3
X-Proofpoint-GUID: ps9VWZinrFgTeGJrujdo8Y5y1-c6AQA3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Extend target deletion paths to process NVMe targets as well as SCSI
targets.

Update link-down, and host reinitialization flows to walk both the SCSI
and NVMe target lists when marking targets for deletion. This ensures
that protocol-specific target state stays consistent across adapter
resets and fabric events.

Rename ibmvfc_relogin to ibmvfc_scsi_relogin as it acts on a scsi
command.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 4b95e4344947..13e513bfd0a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -714,6 +714,8 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
 	scsi_block_requests(vhost->host);
 	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 		ibmvfc_del_tgt(tgt);
+	list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
+		ibmvfc_del_tgt(tgt);
 	ibmvfc_set_host_state(vhost, state);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
 	vhost->events_to_log |= IBMVFC_AE_LINKDOWN;
@@ -751,6 +753,12 @@ static void ibmvfc_init_host(struct ibmvfc_host *vhost)
 			else
 				ibmvfc_del_tgt(tgt);
 		}
+		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
+			if (vhost->client_migrated)
+				tgt->need_login = 1;
+			else
+				ibmvfc_del_tgt(tgt);
+		}
 
 		scsi_block_requests(vhost->host);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
@@ -1868,7 +1876,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
  * @sdev:	scsi device struct
  *
  **/
-static void ibmvfc_relogin(struct scsi_device *sdev)
+static void ibmvfc_scsi_relogin(struct scsi_device *sdev)
 {
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
@@ -1920,7 +1928,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
 			if ((be16_to_cpu(vfc_cmd->status) & IBMVFC_VIOS_FAILURE) &&
 			    (be16_to_cpu(vfc_cmd->error) == IBMVFC_PLOGI_REQUIRED))
-				ibmvfc_relogin(cmnd->device);
+				ibmvfc_scsi_relogin(cmnd->device);
 
 			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
 				cmnd->result = (DID_ERROR << 16);
-- 
2.54.0

