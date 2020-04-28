Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377B5C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 10:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E4D3206D6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 10:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgD1K5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 06:57:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbgD1K5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 06:57:10 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SAXGYn131434;
        Tue, 28 Apr 2020 06:57:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mguvve7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 06:57:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03SAkOUx023867;
        Tue, 28 Apr 2020 10:57:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5nx9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 10:57:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03SAtpxB59507004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 10:55:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81746A4051;
        Tue, 28 Apr 2020 10:56:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 592CBA404D;
        Tue, 28 Apr 2020 10:56:59 +0000 (GMT)
Received: from [9.145.22.231] (unknown [9.145.22.231])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 10:56:59 +0000 (GMT)
Subject: Re: [PATCH v2] scsi: iscsi: register sysfs for iscsi workqueue
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com
References: <20200417111545.30437-1-bob.liu@oracle.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <3c1e425c-d889-6585-0fd8-620c4d6c0d06@linux.ibm.com>
Date:   Tue, 28 Apr 2020 12:56:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417111545.30437-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_06:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0 suspectscore=2
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.04.20 13:15, Bob Liu wrote:
> Then users can set cpu affinity through "cpumask" for iscsi workqueues, so
> as to get performance isolation.
> 
> This patch changes the max number of active worker form 1 to 2,
> since ordered workqueue wont' be allowed to change "cpumask".
> 

Won't having 2 workers break the current ordering guarantees?
Did you check that no-one depends on this?

> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/scsi/libiscsi.c             | 4 +++-
>  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 70b99c0..adf9bb4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2627,7 +2627,9 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  	if (xmit_can_sleep) {
>  		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
>  			"iscsi_q_%d", shost->host_no);
> -		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
> +		ihost->workq = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, ihost->workq_name);

From looking at the documentation, __WQ_LEGACY doesn't seem to belong here.

>  		if (!ihost->workq)
>  			goto free_host;
>  	}
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index dfc726f..bdbc4a2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4602,7 +4602,9 @@ static __init int iscsi_transport_init(void)
>  		goto unregister_flashnode_bus;
>  	}
>  
> -	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
> +	iscsi_eh_timer_workq = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, "iscsi_eh");
>  	if (!iscsi_eh_timer_workq) {
>  		err = -ENOMEM;
>  		goto release_nls;
> 

