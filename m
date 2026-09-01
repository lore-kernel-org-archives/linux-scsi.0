Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4DE39AD3B;
	Tue,  1 Sep 2026 10:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259436; cv=none; b=ATxk3/2EjJThD4WrZ0hS4GOarbSc9ZgUhr8nhLGwjFPQg6KTqLYTl+MZOqrgjtAMJuLHtsfKfY3eVeB3fPltXhWeUhVEFweLhn49GhWolRy4uDvgMY5FOKoa6byjyKa4IGv7bYJOhOeNnMJJ7sFF/jgXu5WfdIRA90xHLP4RBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259436; c=relaxed/simple;
	bh=AwVkprVVozCCWLZHNVevA4JBMw4swDmqks9M95h0hjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XCsvevqJRK7WJPwOkkZCIiCtFfP5Lb0qneFbrQFAp2dinwYGWw3PPFkDOQ3siEiiIxPLaGNMWhDkMUVRDO5RFJk95P0d1+3OhZs7VOQhsbtc87Vm/1UBKmR4HwS9aqTMZDAxFRxEFuWmuArWy1oTfOJqr3fpME6cMmlShegTXro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BghCZjNs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BghCZjNs"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AVS8L952648;
	Tue, 1 Sep 2026 10:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fJeZyY
	9LABWBWOzXIvSzEXG0ICYsaSE723lDSLkj4Pg=; b=BghCZjNsv3T6GkUMbKqc0D
	LaV+ZVBWmGfCKF2ag0w623PYKFswZUl68TXGS6UYLEsksDu+zWxk8NM3uv4YvpBc
	n8V19lTQGADAAxXmq1a6LMnlbrok8Sz91QPUctbvHWSaSa9VsX2s7OjjAgTUGh+H
	JrUbGAkBlU2u46FQCkb5JwYXk99xrF4+5MPlw5tYYRzl49AWxzd7aL54XIMxVIxN
	/MmYq1GWVJXkCV0LatQ93EZv1/JaeuazsdgzwtxB7TAg9cJpsJAeuETEM9MZmCHC
	SmRbJej/oVzlvwU64KyccDNzJeH+yqXK4kN8s3gnd+OtngeQteUWHzJ66/rawM7A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx5f7rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:43:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 681AfIjn032599;
	Tue, 1 Sep 2026 10:43:52 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rqbc51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:43:52 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 681Ahosw6816278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 10:43:50 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B33E658045;
	Tue,  1 Sep 2026 10:43:50 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E28E158050;
	Tue,  1 Sep 2026 10:43:48 +0000 (GMT)
Received: from [9.123.4.58] (unknown [9.123.4.58])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Sep 2026 10:43:48 +0000 (GMT)
Message-ID: <cf63416f-c342-4698-bf66-5008aa01c91b@linux.ibm.com>
Date: Tue, 1 Sep 2026 16:13:47 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: fc_transport: Fix TOCTOU races and workqueue
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
References: <f4f4e9a7-e3bd-4cc5-a3df-829b981ae836@linux.ibm.com>
Content-Language: en-US
From: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>
In-Reply-To: <f4f4e9a7-e3bd-4cc5-a3df-829b981ae836@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a96ac69 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=RRYIC0uZBAMEc5xlNtoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: d25LdBmKV1qN5WchYJotak9gzTR0zMoR
X-Proofpoint-ORIG-GUID: d25LdBmKV1qN5WchYJotak9gzTR0zMoR
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5MyBTYWx0ZWRfX+y1FF5jRjZWt
 BPQ/R7awjRsWP4KI2YO+URU0ZxYE0OXqcDK4pHMb/p30s05apsyZ0riSSd0KI0b9OzB2wB0tvzg
 DlsYGJqqc8ZHW3vQId3iCyPoqC8P3lk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5MyBTYWx0ZWRfX6nLGJ25Or/dw
 dQpOsz+q20o/5ACiwVGpsbjPfXFQg0S0WoFR6SifptrH6NcFAf4CBBrtJ6KIW1ZBkUftu8CRXBE
 wZj9sOBoApeOa5v1IIwhBqBiPz12WZmIgazbhp23+kMRFPNbp0kg3UIQOZUdbiVtT085+ucSO1I
 x64c36F4pUVXGCxfVu6tcewEXRn5ukWnJRyqT6BCwXvHLqGGoLV5MmJ6beH3CjjHlo8tihVG8Ph
 SNmZWSyLtUVwCSaNWsUZCHHhIsLSR9WEoqOs1jo9PF12ZT+oo0ZpflszUYiDZBuM3D9AcYPa3sh
 nM3Gg/oislWmxHEnkf/n65xjgTVoHWJreZXn3lplw04Xa0O8cYGJz2U3BRxWLEgqRRGuZKmboT6
 qesJS8G/44PU6CiBVHs6sBtIKIOE+VrIX+vJi+YprFs8A98++glXbTn/WMcI72CurxAQfnSU7SS
 H0vCLy+qegBwBTjlEQg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010093


On 09/04/26 8:42 pm, Kyle Mahlkuch wrote:
> Fix the TOCTOU races in workqueue access, use READ_ONCE() in
> fc_queue_work(), fc_flush_work(), fc_queue_devloss_work(), and
> fc_flush_devloss().
>
> The workqueue destruction in fc_remove_host() uses WRITE_ONCE() to set
> the pointer to NULL to prevents new work, flushing the work queued
> before NULL, then safely destroying it.
>
> Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
> ---


Tested-by: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>

Tested the complete 3-patch series on an IBM Power11 (ppc64le) server 
equipped with an Emulex FC HBA.
The patches applied cleanly, and FC driver parameter validation testing 
was executed continuously for 36 hours.
No crashes, hangs, or functional issues were observed during the test 
period.

Thanks,
Maram Srimannarayana Murthy

>  drivers/scsi/scsi_transport_fc.c | 36 ++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_fc.c 
> b/drivers/scsi/scsi_transport_fc.c
> index 3a821afee9bc..123b22b52640 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2774,16 +2774,18 @@ EXPORT_SYMBOL(fc_release_transport);
>  static int
>  fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
>  {
> -    if (unlikely(!fc_host_work_q(shost))) {
> +    struct workqueue_struct *wq = READ_ONCE(fc_host_work_q(shost));
> +
> +    if (unlikely(!wq)) {
>          printk(KERN_ERR
>              "ERROR: FC host '%s' attempted to queue work, "
>              "when no workqueue created.\n", shost->hostt->name);
>          dump_stack();
> -
>          return -EINVAL;
>      }
>
> -    return queue_work(fc_host_work_q(shost), work);
> +    /* Use local copy to prevent TOCTOU race */
> +    return queue_work(wq, work);
>  }
>
>  /**
> @@ -2793,7 +2795,9 @@ fc_queue_work(struct Scsi_Host *shost, struct 
> work_struct *work)
>  static void
>  fc_flush_work(struct Scsi_Host *shost)
>  {
> -    if (!fc_host_work_q(shost)) {
> +    struct workqueue_struct *wq = READ_ONCE(fc_host_work_q(shost));
> +
> +    if (!wq) {
>          printk(KERN_ERR
>              "ERROR: FC host '%s' attempted to flush work, "
>              "when no workqueue created.\n", shost->hostt->name);
> @@ -2801,7 +2805,8 @@ fc_flush_work(struct Scsi_Host *shost)
>          return;
>      }
>
> -    flush_workqueue(fc_host_work_q(shost));
> +    /* Use local copy to prevent TOCTOU race */
> +    flush_workqueue(wq);
>  }
>
>  /**
> @@ -2818,16 +2823,18 @@ static int
>  fc_queue_devloss_work(struct Scsi_Host *shost, struct fc_rport *rport,
>                struct delayed_work *work, unsigned long delay)
>  {
> -    if (unlikely(!rport->devloss_work_q)) {
> +    struct workqueue_struct *wq = READ_ONCE(rport->devloss_work_q);
> +
> +    if (unlikely(!wq)) {
>          printk(KERN_ERR
>              "ERROR: FC host '%s' attempted to queue work, "
>              "when no workqueue created.\n", shost->hostt->name);
>          dump_stack();
> -
>          return -EINVAL;
>      }
>
> -    return queue_delayed_work(rport->devloss_work_q, work, delay);
> +    /* Use local copy to prevent TOCTOU race */
> +    return queue_delayed_work(wq, work, delay);
>  }
>
>  /**
> @@ -2838,7 +2845,9 @@ fc_queue_devloss_work(struct Scsi_Host *shost, 
> struct fc_rport *rport,
>  static void
>  fc_flush_devloss(struct Scsi_Host *shost, struct fc_rport *rport)
>  {
> -    if (unlikely(!rport->devloss_work_q)) {
> +    struct workqueue_struct *wq = READ_ONCE(rport->devloss_work_q);
> +
> +    if (unlikely(!wq)) {
>          printk(KERN_ERR
>              "ERROR: FC host '%s' attempted to flush work, "
>              "when no workqueue created.\n", shost->hostt->name);
> @@ -2846,7 +2855,7 @@ fc_flush_devloss(struct Scsi_Host *shost, struct 
> fc_rport *rport)
>          return;
>      }
>
> -    flush_workqueue(rport->devloss_work_q);
> +    flush_workqueue(wq);
>  }
>
>
> @@ -2905,7 +2914,12 @@ fc_remove_host(struct Scsi_Host *shost)
>      /* flush all stgt delete, and rport delete work items, then kill 
> it  */
>      if (fc_host->work_q) {
>          work_q = fc_host->work_q;
> -        fc_host->work_q = NULL;
> +        /* Prevent new work from being queued by setting work_q to 
> NULL */
> +        WRITE_ONCE(fc_host->work_q, NULL);
> +        /* Ensures NULL is visible to other CPUs before flush */
> +        smp_mb();
> +        /* Flush any work that was queued before NULL assignment */
> +        flush_workqueue(work_q);
>          destroy_workqueue(work_q);
>      }
>  }
