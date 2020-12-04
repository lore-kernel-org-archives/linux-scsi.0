Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A74C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 21:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FAE922CF7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 21:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgLDVhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 16:37:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25716 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbgLDVha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 16:37:30 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4L3rPS195890;
        Fri, 4 Dec 2020 16:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mq0Py58u7yVQMGnTGvPD5H4RBHRUXUVsbgY2eBrKMWw=;
 b=KF42hkEb7PMPmHjmnQZslNNKg3QrgJLyoTg0LkIwllFzt0pVJ3zQvE/UYp6LxHR9tFNQ
 fHKt/9VvnrW0kMuxXY+XF/Gn9wDCb/XXrlTafb0y/X+sT+Mtt0xiAsT9gXonsih0FUmT
 BIYfJUznqDvDilzaSgkTU3EPz03c0/Eg6gFkN1fdNzA7VOUupinx2Jy7JyUIo7j4Z4hd
 LtUoIcEWrziWHwqeKOhlmdCPBW59b/7oPYS/AhRM9GDAQQ/ZlD3lfQFmrJ6qU/FBlKaD
 krpkDWqq6Qb/9v6W/Z3dr8YdS27Y02tZdKaJ2gLqH9GAa8725esUAU7wbwfRpRFk6YR8 oQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 357m8gyuca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 16:36:43 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4LLwtB003116;
        Fri, 4 Dec 2020 21:36:43 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 355vrgdxsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 21:36:43 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4LZQSs3474112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 21:35:26 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D12E712405A;
        Fri,  4 Dec 2020 21:35:26 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F4229124058;
        Fri,  4 Dec 2020 21:35:25 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.73.174])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Dec 2020 21:35:25 +0000 (GMT)
Subject: Re: [PATCH v3 18/18] ibmvfc: drop host lock when completing commands
 in CRQ
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201203020806.14747-1-tyreld@linux.ibm.com>
 <20201203020806.14747-19-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <b048ede5-e673-4ba9-3c28-df077aa4467a@linux.vnet.ibm.com>
Date:   Fri, 4 Dec 2020 15:35:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203020806.14747-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_11:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040119
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/20 8:08 PM, Tyrel Datwyler wrote:
> The legacy CRQ holds the host lock the even while completing commands.
> This presents a problem when in legacy single queue mode and
> nr_hw_queues is greater than one since calling scsi_done() introduces
> the potential for deadlock.
> 
> If nr_hw_queues is greater than one drop the hostlock in the legacy CRQ
> path when completing a command.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index e499599662ec..e2200bdff2be 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2969,6 +2969,7 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>  {
>  	long rc;
>  	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
> +	unsigned long flags;
>  
>  	switch (crq->valid) {
>  	case IBMVFC_CRQ_INIT_RSP:
> @@ -3039,7 +3040,12 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>  	del_timer(&evt->timer);
>  	list_del(&evt->queue);
>  	ibmvfc_trc_end(evt);
> -	evt->done(evt);
> +	if (nr_scsi_hw_queues > 1) {
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		evt->done(evt);
> +		spin_lock_irqsave(vhost->host->host_lock, flags);
> +	} else
> +		evt->done(evt);

Similar comment here as previously. The flags parameter is an output for
spin_lock_irqsave but an input for spin_unlock_irqrestore. You'll need
to rethink the locking here. You could just do a spin_unlock_irq / spin_lock_irq
here and that would probably be OK, but probably isn't the best. 

>  }
>  
>  /**
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

