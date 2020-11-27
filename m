Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC527C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EEAE22245
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 17:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M0vCfNC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbgK0RpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 12:45:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731398AbgK0RpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 12:45:18 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHVYU2036883;
        Fri, 27 Nov 2020 12:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3/ZVldWlmUIuJREyB1FkD2ej4pD6YkF1Luk5Fj3d0No=;
 b=M0vCfNC9KgfdSs1xC3Mgxm/SWoqau3dkh8ZGE8VwnmR1Dp4bI7DeBfG3pYjagcmI/k+F
 oPCqzykzpBXCCxKJEayMO/U6HOMAtqdd3onhY9jbYjVazZ2RxrJrbgn9wphrNMB1D2VQ
 6bRuK0/12tIO7BxgI9FVew/lw2GQ0xaFvI7j8La7Sbs85ouh0pqRRZoPs4TTOJeOR7To
 I8+CBXehbGzkw9zTa4ZbDxZ4F/9kmy0AU33oIe4w9s9aASwrB1FmpobQfZ6PDthwpbbQ
 x7O57oqTervzxQlbync8rpokPscTHr6AJdwh93/i/KDHMWWZTaa2wTO4y3ynzXOKve7r vg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3535utgbjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 12:45:05 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARHhD6k027669;
        Fri, 27 Nov 2020 17:45:05 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 34xthav05c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 17:45:05 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARHisCM28508526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 17:44:54 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F2DDC605B;
        Fri, 27 Nov 2020 17:45:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF892C6057;
        Fri, 27 Nov 2020 17:45:02 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.163.79.105])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 17:45:02 +0000 (GMT)
Subject: Re: [PATCH 01/13] ibmvfc: add vhost fields and defaults for MQ
 enablement
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20201126014824.123831-1-tyreld@linux.ibm.com>
 <20201126014824.123831-2-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <97e577a0-50f5-3ade-a377-7479f0f1c890@linux.vnet.ibm.com>
Date:   Fri, 27 Nov 2020 11:45:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201126014824.123831-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_10:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/20 7:48 PM, Tyrel Datwyler wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
> index 9d58cfd774d3..8225bdbb127e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -41,6 +41,11 @@
>  #define IBMVFC_DEFAULT_LOG_LEVEL	2
>  #define IBMVFC_MAX_CDB_LEN		16
>  #define IBMVFC_CLS3_ERROR		0
> +#define IBMVFC_MQ			0

Given that IBMVFC_MQ is getting set to 0 here, that means mq_enabled is also
always zero, so am I correct that a lot of this code being added is not
yet capable of being executed?

> +#define IBMVFC_SCSI_CHANNELS		0

Similar comment here...

> +#define IBMVFC_SCSI_HW_QUEUES		1

I don't see any subsequent patches in this series that would ever result
in nr_hw_queues getting set to anything other than 1. Is that future work
planned or am I missing something?

> +#define IBMVFC_MIG_NO_SUB_TO_CRQ	0
> +#define IBMVFC_MIG_NO_N_TO_M		0
>  
>  /*
>   * Ensure we have resources for ERP and initialization:
> @@ -826,6 +831,10 @@ struct ibmvfc_host {
>  	int delay_init;
>  	int scan_complete;
>  	int logged_in;
> +	int mq_enabled;
> +	int using_channels;
> +	int do_enquiry;
> +	int client_scsi_channels;
>  	int aborting_passthru;
>  	int events_to_log;
>  #define IBMVFC_AE_LINKUP	0x0001
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

