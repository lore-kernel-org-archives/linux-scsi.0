Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036A5C4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9973B20782
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 03:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mkTQS61g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgJHDHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:07:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59738 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgJHDHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 23:07:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09830DrR052573;
        Thu, 8 Oct 2020 03:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=2d1Gs+Ww3t6b9w2WH1v1HiN8e/dMdzRZ8fPD0u22was=;
 b=mkTQS61gzFnlTe2oEduObo8uFcf9x5YFAyhatVQZZKfKXtwf+9OYt1xfAEnrixaJzDnV
 KUpo7y5XsOmtfiuWZyfAbMElxrb04NYZXJ3Adza85I5OmZtQKrR0XrpvY6/IJOIHsjcq
 Ayw6gE9tV+qXz1OEKxZ5+X2tWGYRDv3m9XfFceEqdbrLCnAOxOCktILIknbnNv6Ypi2u
 uu4ahIvsXJbuGBu8X8Yh8V7PcnrmZQJYk3l9T1leT6MbF0D3ApBWLMCa90ku+4wLdO2P
 kuE4hXWGaVicdqdxcBjVeO1uHvKrS0cLRNwOLLS4EIs7uYtXy2wtGvFZVnhjvhL1mna+ Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb5d0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 03:07:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09834sQ2056185;
        Thu, 8 Oct 2020 03:05:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3410k0e3wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 03:05:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09835PA8025233;
        Thu, 8 Oct 2020 03:05:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 20:05:24 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Fix inconsistent of format with
 argument type in megaraid_sas_base.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1q9whb0.fsf@ca-mkp.ca.oracle.com>
References: <20200930022124.2840018-1-yebin10@huawei.com>
Date:   Wed, 07 Oct 2020 23:05:22 -0400
In-Reply-To: <20200930022124.2840018-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:21:24 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> @@ -5603,7 +5603,7 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
>  	for (i = 0; i < instance->msix_vectors; i++) {
>  		instance->irq_context[i].instance = instance;
>  		instance->irq_context[i].MSIxIndex = i;
> -		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%u",
> +		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%d",

It's probably better to make the index unsigned.

-- 
Martin K. Petersen	Oracle Linux Engineering
