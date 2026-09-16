Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99852E053;
	Wed, 16 Sep 2026 23:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600196; cv=none; b=JsFh0DdCQuI5R+1GjiDqnZSDnOLN9DHbAjsOMcKgNqqSqIjt8/yDj+Mj/R3q/QzwzL0eCDWVB8AfMgNQpWkW+v5/qNeeiB+tQffuReyR9J4HD5eNPkgz62EAFEnOz5ISUor2AlN/7wsPOodCWo6DrV3SsFwwe6UL3ZEQsg2MZ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600196; c=relaxed/simple;
	bh=q0VKrKypSngHPkeBURFX+ac0Y0ef4psgidY6f3ov5gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL18KODfyKz5WqCfE4HsgRIlrkIfDWgk1IHAeIiaeDz8GbBKXANDLikKaBTp7eXDlHw9adwyAY87mzra4AJiSGY6tY2BekybnGKTyzpj0zEEI39zSVng/l2c9WK5v6ezdyB/AjDN53ljljPzWdIOoBDRT1H73KXMtqU29GRg2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gYzO/jE6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gYzO/jE6"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1k4v3041641;
	Wed, 16 Sep 2026 23:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Vj/mhw50k97v9Dqqi
	qcEkBZc5QnkHZWGkC6VJOmrH/U=; b=gYzO/jE6LmxTYsZgpzyz/f6OobU1P3x8F
	NCEVUmiZrdkpMsayXq2+7QvQ7uL8nN5J9qFn7mCqVEO4hVXutAaJG0a1LHptclSx
	I5bFB5OC1+KEPZyUWYHRQq1uMFq4poH4yfQ1FPiEcmnamA4TdcIvXJDNmfu6EGX+
	q9DPJOmL6cig8IKjvE5yyCEimcRZ2AE0c9ZGMWUlKoXp9bfdO5Y14iR6VRlN0/bA
	w+Dq3KO/I21sAFULIfzW0lLXiuGOyijqlO7YJvB4zKr32++FQkn0GRqvMgKM574A
	kiFAVTvY3aJHvGVc8bAiFfMs3ZczeQVYNY6ap6Lyp9XTD6xJG1+ug==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmw5e73jx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN12qE1713037;
	Wed, 16 Sep 2026 23:09:47 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpywf0w5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:47 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9kRP17171162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:46 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 409405804E;
	Wed, 16 Sep 2026 23:09:46 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5288458060;
	Wed, 16 Sep 2026 23:09:45 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:45 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 17/20] scsi: ibmvfc: fix TOCTOU race in ibmvfc_nvme_create_queue() on adapter removal
Date: Wed, 16 Sep 2026 16:09:18 -0700
Message-ID: <20260916230921.2204729-18-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX3hFBk2sWSeGK
 6CcBUhpGNRnfiehjvKNcJAr7EmGdUpIrTmM+uizG5tyixvSOCV0eX1wQdJPyCUasp9gxTt9Rb2u
 XWje7ToZk56vNQShBLNUdkiqFvOOXpooZjlKiK9BmbwrDofNDK3NC+VvnXXqOM8DNdx19RtHLgg
 vVacvf+bYvCred0RQ/+TFfUF6fW359A0cmuwZvNGOk0tePgJCY4wuhl6ckmtXThtlMP+WEcrPSx
 vVraimgRd9pTiDd89E1tKoQMVVeWvSG1wKWG3lr2i1VUUJizCIX29XmDTevM3aAj6VZk3MWAWBk
 ELWD9fup+QxgDLKg5tb30M7o/+PoTnDUEb5uby7+M976NSZvLer+kXuZg3Zzb9BbAdFN2zv/8rI
 MUKyumFYvU6ZwvQwiWODXKG5tjB18uh9zN8yw276ay9dBI6JUWUfK+UPEX9/HOckWev/Ue7IO5t
 eNRgm8Wpkwp0OHkPRwQ==
X-Authority-Analysis: v=2.4 cv=E/NYNqdl c=1 sm=1 tr=0 ts=6aab21bc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=M1I_nbD3KY5Z_so_vh8A:9
X-Proofpoint-ORIG-GUID: OeaXTyYp18V3aEvk-4z3Q1c3hLJLohuE
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX6J0s20Buri4a
 Fdw8Kd7iLLXi1qR9s1aS0Mqg9agGVWN2FvAZXskfRpOuMuAVk9Ue4zO1eE8oaGHGxBvstJW8G0M
 voTKFgeRduZ9iS5SEj9CGEwzTzznckU=
X-Proofpoint-GUID: OeaXTyYp18V3aEvk-4z3Q1c3hLJLohuE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

ibmvfc_remove() called ibmvfc_release_sub_crqs() before
ibmvfc_nvme_unregister().  ibmvfc_release_sub_crqs() frees the
nvme_scrqs.scrqs array and sets active_queues to 0, but the nvme-fc
transport is still live at that point and can call back into
ibmvfc_nvme_create_queue().  That callback reads active_queues and
dereferences scrqs without any lock, so the window between the guard
check and the actual use can race with the teardown, leading to:

  - divide-by-zero in '(qidx - 1) % vhost->nvme_scrqs.active_queues'
    when active_queues has been zeroed concurrently, and
  - NULL pointer dereference on 'vhost->nvme_scrqs.scrqs[qhandle->index]'
    when scrqs has been freed and set to NULL concurrently.

ibmvfc_nvme_unregister() already calls nvme_fc_unregister_localport()
followed by wait_for_completion(), which blocks until the transport has
fully quiesced all queue operations.  It just needs to happen before the
sub-CRQ memory is released.

Move ibmvfc_nvme_unregister() before ibmvfc_release_sub_crqs() in
ibmvfc_remove() so the transport is quiesced before the sub-CRQ arrays
are freed.  The reset path (ibmvfc_reset_crq) is unaffected: it only
deregisters sub-CRQs at the hypervisor level and never frees them, so
active_queues and scrqs remain valid across a reset.

Fixes: 186f72e38029 ("scsi: ibmvfc: implement LLDD callbacks for mapping nvme-fc queues")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 7af1867b69c5..93189692191e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6992,11 +6992,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	list_splice_init(&vhost->purge, &purge);
 	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 	ibmvfc_complete_purge(&purge);
+	ibmvfc_nvme_unregister(vhost);
 	ibmvfc_release_sub_crqs(vhost);
 	ibmvfc_release_crq_queue(vhost);
 
-	ibmvfc_nvme_unregister(vhost);
-
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
 	list_del(&vhost->queue);
-- 
2.55.0

