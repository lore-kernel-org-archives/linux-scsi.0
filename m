Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6443BFE3C;
	Thu,  9 Apr 2026 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747533; cv=none; b=os7PKfLAceGh6400EvC7PdxZVo0El61RZ537+SZ7nlLR1PZo1xuI+iX5dgV47gQX/uDTXuOB7SprJGeVGSrw3UhghTIqhdP2WrkwXXZH021VVcnQCzEWSeRDKSKtPhDbVtssKV/tXJhvHuRld5kxw3fbBeci0QY2N+1/AiqcIg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747533; c=relaxed/simple;
	bh=U4ddSgYUvrVZgHCOTXZVHGuW5Oxc5B3dd9+pKMvljA0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=oaucSA6HElmgZZZAHNse9UAbqDUeeMsXbCk4CNULeh/SdgGFqMxFaBaZOE/b2eMGFdgQR66ZokVFhtGqqTGy03FYcqpqRx1YampmWmkgxOYcAy4Km+HzWN+GCZGV8EEz7hlzmD0tbMtBr2vIHVPWE8CRBe3ADsFavSLRI7V8zX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oq8JJZeY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oq8JJZeY"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Al4OW2326338;
	Thu, 9 Apr 2026 15:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=ISxKajPxGm9uKk0nh3JFY9C3tOtj
	rKy/4mGFq6LwO5E=; b=oq8JJZeYRTkQjz4fIB35y73JwXLQley4nZMwS3cVn0A+
	9pSsktG3mr6gfXSUVm5Cu41F6t5ONGvtfve++vI5si67eVEG6tvnSp7eNQpvPrOM
	fQVJ/KsGb49h3NBCEKmTlfjvcxYFahMp4FErHjKxnvc9tEsLY7tQ0rCVj1AacFm2
	Np7k5468cYAyzFjbkdhdTWHCHeJG99nbu4xg3rYKhlR+j2kNapkCW8GHXiW6IquY
	NFUaDsyg+4VYQhE/B34keWBRk0nf9y544g3kW7mpjT40N+xs/yUsVJBM7m+oqDh8
	I0m7aiU+3kQmlmPimw4jXkw+mXGsuJZSxuHvjqM1Ew==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kmqq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639CURKR026642;
	Thu, 9 Apr 2026 15:12:09 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcmg842ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:09 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639FC9Mn53215658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 15:12:09 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1300A5805F;
	Thu,  9 Apr 2026 15:12:09 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A09358043;
	Thu,  9 Apr 2026 15:12:08 +0000 (GMT)
Received: from [9.61.156.97] (unknown [9.61.156.97])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 15:12:08 +0000 (GMT)
Message-ID: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
Date: Thu, 9 Apr 2026 10:12:07 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEzNSBTYWx0ZWRfXxxiv6vKG9h3C
 dJ3QO0bmdaWP3f61gu1xDNURjw0xwuPUkc2Ol5btgBFKK2REkv87MG+akW3MLM+W0gJlCGEIrII
 Dmpnhe4HRx2nQbBOnYEm1uV76AE2nVev/1Cidb5WhI7/OZaXNSgM2TwlmLQz4lnQZ4L2RheMJM/
 Edc17jcmIN4aFtim4e16t0nxe8OiZFrU8/DgR0QB7OY7WERKCC1Itj0DEZnFe5GhqWcMey2hTiZ
 rxrTrBj7TPlKD0+0/K2JjUrIcduaI/k2DoF2BLTNHqFpNx6yNALFgED0xV8lj7cFOn7Gw05cxmP
 IzcrsRtru2e+myyklOSMSvEp5a+DlOaX0n56/sVZLhgVM9oPL7qIsXuge5rUlemfMKirIHp7wY0
 KYrcOP0G17okkxt1q32eObn3GsOHUtI2WyDIh+UvhneoButObTUyrBxdJNPxKT75xnlMn7o04wF
 EJYNvHBeAKPi8Wn82VQ==
X-Proofpoint-ORIG-GUID: h2-VXbOlNdQBrzDMi1oUx3f6ncF48mVN
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d7c1ca cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=MNJAjjf2JKIQIniOXnMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: h2-VXbOlNdQBrzDMi1oUx3f6ncF48mVN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090135

This patch addresses critical race conditions in the lpfc driver's ELS
retry event handling that can lead to a use-after-free.

The primary issue is a TOCTOU (Time-of-Check to Tim-of-Use) race in the
lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
before acquiring the lock to check if the retry event is queued, and the
worker lpfc_els_retry_delay_handler(). This create a window where the
timer can be rescheduled and fire, causing both the cancel path and the
worker thread to release the same reference, resulting in a double-put
and use-after-free.

Fixes the primary TOCTOU race by
  - moving the flag check inside section protected by hbalock
  - Add a NULL checking in the work handler to gracefully handle cases
    where the event payload has been consumed by the cancel path

Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
---
  drivers/scsi/lpfc/lpfc_els.c     | 48 +++++++++++++++++++++++++-------
  drivers/scsi/lpfc/lpfc_hbadisc.c |  9 ++++++
  2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b71db7d7d747..ccc0734f5daa 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4329,18 +4329,40 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, 
uint8_t retry)
  void
  lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct 
lpfc_nodelist *nlp)
  {
-    struct lpfc_work_evt *evtp;
+    struct lpfc_hba *phba = vport->phba;
+    struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
+    struct lpfc_nodelist *arg_ndlp = NULL;
+    unsigned long flags;

-    if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
+    /*
+     * Check and clear NLP_DELAY_TMO flag inside critical section to
+     * prevent TOCTOU race with timer rescheduling. If retry event is
+     * queued, remove it and consume its payload to prevent double-put.
+     * This protects against concurrent execution with 
lpfc_work_list_done()
+     * which may be processing this event. The event holds a reference to
+     * the nodelist that must be released exactly once.
+     */
+    spin_lock_irqsave(&phba->hbalock, flags);
+    if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag)) {
+        spin_unlock_irqrestore(&phba->hbalock, flags);
          return;
+    }
+
+    if (!list_empty(&evtp->evt_listp)) {
+        list_del_init(&evtp->evt_listp);
+        arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
+        evtp->evt_arg1 = NULL;
+    }
+    spin_unlock_irqrestore(&phba->hbalock, flags);
+
+    /* Delete timer and clear state outside the lock */
      timer_delete_sync(&nlp->nlp_delayfunc);
      nlp->nlp_last_elscmd = 0;
-    if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
-        list_del_init(&nlp->els_retry_evt.evt_listp);
-        /* Decrement nlp reference count held for the delayed retry */
-        evtp = &nlp->els_retry_evt;
-        lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
-    }
+
+    /* Drop the event-held reference */
+    if (arg_ndlp)
+        lpfc_nlp_put(arg_ndlp);
+
      if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
          if (vport->num_disc_nodes) {
              if (vport->port_state < LPFC_VPORT_READY) {
@@ -4422,10 +4444,16 @@ lpfc_els_retry_delay_handler(struct 
lpfc_nodelist *ndlp)
      spin_lock_irq(&ndlp->lock);
      cmd = ndlp->nlp_last_elscmd;
      ndlp->nlp_last_elscmd = 0;
-    spin_unlock_irq(&ndlp->lock);

-    if (!test_and_clear_bit(NLP_DELAY_TMO, &ndlp->nlp_flag))
+    /*
+     * Check and clear NLP_DELAY_TMO flag inside critical section to
+         * prevent TOCTOU race with lpfc_cancel_retry_delay_tmo()
+     */
+    if (!test_and_clear_bit(NLP_DELAY_TMO, &ndlp->nlp_flag)) {
+        spin_unlock_irq(&ndlp->lock);
          return;
+    }
+    spin_unlock_irq(&ndlp->lock);

      /*
       * If a discovery event readded nlp_delayfunc after timer
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c 
b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 43d246c5c049..e318e3f5aa7c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -846,6 +846,15 @@ lpfc_work_list_done(struct lpfc_hba *phba)
          switch (evtp->evt) {
          case LPFC_EVT_ELS_RETRY:
              ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
+            /*
+            * Consume the payload to prevent reuse or double-put.
+            * evt_arg1 was populated when event was queued.
+            */
+            evtp->evt_arg1 = NULL;
+            if (!ndlp) {
+                /* Event already consumed by cancel path */
+                break;
+            }
              if (!hba_pci_err) {
                  lpfc_els_retry_delay_handler(ndlp);
                  free_evt = 0; /* evt is part of ndlp */
-- 
2.52.0
