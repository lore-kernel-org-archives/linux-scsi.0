Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D49471CE0;
	Tue,  1 Sep 2026 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257663; cv=none; b=slO3JNR0/aqDX6A0MEzmqQumNvyqR9a1sFrqRokSOsmEqFJqCfB3npoBAlYuBkfDbGh8ULrLQ7fncakMgTwd9Db5tckHgv5tbS06N12vSbpKjVzfjftg/Kd3AcSmBNHB7vlHiuGExS7ULNaSHaE3zIrPROHPnag7oja4k49NRBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257663; c=relaxed/simple;
	bh=Kr0yAc3Xe6o0dLQLug8Fb4GxXx1hlBHlwG+EDFHOSwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JuHH+kaII3MScrcIYNNp6l9ma2uZS9qJcFeU2fhuCCNvdzBHjoqJsVM9YSPIXiVgQwNyGnM16zTq69KPh5JZdHQX8AbLQ92Yvkfu0C6jUoimVwOYtip4A5Lpu5N0xAQEujAtNV+gCpASsxJUIwe6mGrQdNWx8a4CJ/XbyaqIOHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xkol0OkS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xkol0OkS"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6817WA8v628207;
	Tue, 1 Sep 2026 10:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UTmzgb
	YLfFIzLmxtzodmEJF/oUrjIH+JjiIeh4b6ji8=; b=Xkol0OkStV9SHcAjStm9XP
	wh32+jBRv206fbY2Q6/yk/Kk5Em0zNLrQHINJQUBs6fXiUnWU4BYjeY+v0HLe1mL
	Lk8PIBVMk49e77BYL1mwtxc5L8d1rPkcCZsIsXo9FlHBtsSBTeCQuzvmpHb+BF0n
	jf/6GVZKAJ9XKCE3keoPgk2ruFWf3fH+xi0LRB3+XIi96jk5n5P5YtubM8Yb52M6
	4g4mRB9a5SAskL7u4XtQB+wggWojlMAM7Tr8CaAR0x6vDuZeUxJquJwZun88c0cZ
	xfeEAuAmWFqXbwNC4qeYWNhvUPH7AmseQeh2zmZyY2VyCqmyO9sht18lmZh97VRA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2t6se3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:14:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 681ABIHG024744;
	Tue, 1 Sep 2026 10:14:19 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcb8hb0u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:14:19 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 681AEImZ51904810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 10:14:18 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C68C5805E;
	Tue,  1 Sep 2026 10:14:18 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 236BA58045;
	Tue,  1 Sep 2026 10:14:16 +0000 (GMT)
Received: from [9.123.4.58] (unknown [9.123.4.58])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Sep 2026 10:14:15 +0000 (GMT)
Message-ID: <e0cdf828-7491-4a83-ac36-b9d874520084@linux.ibm.com>
Date: Tue, 1 Sep 2026 15:44:14 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
References: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
Content-Language: en-US
From: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>
In-Reply-To: <1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a96a57b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=dFoGALBOYwBndqBAbn4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA4OSBTYWx0ZWRfX1ngT6ulPBes3
 rXopP7Ck6v/RHc4vNd0c+OKAnIzoYcYrewJOrwikPjEgJ4ES0i6mmsgNRBotCgQJ/jxxswZ8tkR
 10dJ75TAy0PCUhNzZr/UuCPctJyV1xw=
X-Proofpoint-ORIG-GUID: idAaEFmIPsM_PUerVWiYS5O75Hiiug_L
X-Proofpoint-GUID: idAaEFmIPsM_PUerVWiYS5O75Hiiug_L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA4OSBTYWx0ZWRfXxHfmbL/oEtM4
 sXRTfNr8PhhTG9/Wc/gD6Fivr1DSSA8gc562YGg1s6McTgdd/1DdlFPU9uInsMl7Kly7WxVoaJj
 hWmBoBcJaHxb90SkyVXCr/f456XVEROyQVCBFvG+XWEzAYMgkuYnmh96xJSIpSNUT3npukSeQ3/
 zEIMBANqXIfTMpq+fHQpQyJxEx8TD0MgXCKQ4rpdj6MfBRVJXd4iedGEzpXbBskmfF4h3Gf/azm
 WUkvS876blvHuwlByJBRBuz/lHv0BM5kIs3Rbo/mzzswOqZXYILe8qEZIN3LUAlsbTqjROEF41i
 RV/GrKCAxLwUH6jss3mQnMvyeJ0gjCO2GX4la7P6vizUFCHr9xT+9ly0L2AIWHG/9hADZNEO42N
 Qo3cMvc0YrFH/emLFoNKo1XkTmibL46yNVe3wQECNaf4sbRoJRBTkBQ8rs+gyBaSSztOdS8BRvt
 tqMHIY8H5RJpkwEYzYg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010089


On 09/04/26 8:42 pm, Kyle Mahlkuch wrote:
> This patch addresses critical race conditions in the lpfc driver's ELS
> retry event handling that can lead to a use-after-free.
>
> The primary issue is a TOCTOU (Time-of-Check to Tim-of-Use) race in the
> lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
> before acquiring the lock to check if the retry event is queued, and the
> worker lpfc_els_retry_delay_handler(). This create a window where the
> timer can be rescheduled and fire, causing both the cancel path and the
> worker thread to release the same reference, resulting in a double-put
> and use-after-free.
>
> Fixes the primary TOCTOU race by
>  - moving the flag check inside section protected by hbalock
>  - Add a NULL checking in the work handler to gracefully handle cases
>    where the event payload has been consumed by the cancel path
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


>  drivers/scsi/lpfc/lpfc_els.c | 48 +++++++++++++++++++++++++-------
>  drivers/scsi/lpfc/lpfc_hbadisc.c |  9 ++++++
>  2 files changed, 47 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index b71db7d7d747..ccc0734f5daa 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4329,18 +4329,40 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, 
> uint8_t retry)
>  void
>  lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct 
> lpfc_nodelist *nlp)
>  {
> -    struct lpfc_work_evt *evtp;
> +    struct lpfc_hba *phba = vport->phba;
> +    struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
> +    struct lpfc_nodelist *arg_ndlp = NULL;
> +    unsigned long flags;
>
> -    if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
> +    /*
> +     * Check and clear NLP_DELAY_TMO flag inside critical section to
> +     * prevent TOCTOU race with timer rescheduling. If retry event is
> +     * queued, remove it and consume its payload to prevent double-put.
> +     * This protects against concurrent execution with 
> lpfc_work_list_done()
> +     * which may be processing this event. The event holds a 
> reference to
> +     * the nodelist that must be released exactly once.
> +     */
> +    spin_lock_irqsave(&phba->hbalock, flags);
> +    if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag)) {
> +        spin_unlock_irqrestore(&phba->hbalock, flags);
>          return;
> +    }
> +
> +    if (!list_empty(&evtp->evt_listp)) {
> +        list_del_init(&evtp->evt_listp);
> +        arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
> +        evtp->evt_arg1 = NULL;
> +    }
> +    spin_unlock_irqrestore(&phba->hbalock, flags);
> +
> +    /* Delete timer and clear state outside the lock */
>      timer_delete_sync(&nlp->nlp_delayfunc);
>      nlp->nlp_last_elscmd = 0;
> -    if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
> -        list_del_init(&nlp->els_retry_evt.evt_listp);
> -        /* Decrement nlp reference count held for the delayed retry */
> -        evtp = &nlp->els_retry_evt;
> -        lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
> -    }
> +
> +    /* Drop the event-held reference */
> +    if (arg_ndlp)
> +        lpfc_nlp_put(arg_ndlp);
> +
>      if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
>          if (vport->num_disc_nodes) {
>              if (vport->port_state < LPFC_VPORT_READY) {
> @@ -4422,10 +4444,16 @@ lpfc_els_retry_delay_handler(struct 
> lpfc_nodelist *ndlp)
>      spin_lock_irq(&ndlp->lock);
>      cmd = ndlp->nlp_last_elscmd;
>      ndlp->nlp_last_elscmd = 0;
> -    spin_unlock_irq(&ndlp->lock);
>
> -    if (!test_and_clear_bit(NLP_DELAY_TMO, &ndlp->nlp_flag))
> +    /*
> +     * Check and clear NLP_DELAY_TMO flag inside critical section to
> +         * prevent TOCTOU race with lpfc_cancel_retry_delay_tmo()
> +     */
> +    if (!test_and_clear_bit(NLP_DELAY_TMO, &ndlp->nlp_flag)) {
> +        spin_unlock_irq(&ndlp->lock);
>          return;
> +    }
> +    spin_unlock_irq(&ndlp->lock);
>
>      /*
>       * If a discovery event readded nlp_delayfunc after timer
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c 
> b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 43d246c5c049..e318e3f5aa7c 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -846,6 +846,15 @@ lpfc_work_list_done(struct lpfc_hba *phba)
>          switch (evtp->evt) {
>          case LPFC_EVT_ELS_RETRY:
>              ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
> +            /*
> +            * Consume the payload to prevent reuse or double-put.
> +            * evt_arg1 was populated when event was queued.
> +            */
> +            evtp->evt_arg1 = NULL;
> +            if (!ndlp) {
> +                /* Event already consumed by cancel path */
> +                break;
> +            }
>              if (!hba_pci_err) {
>                  lpfc_els_retry_delay_handler(ndlp);
>                  free_evt = 0; /* evt is part of ndlp */
