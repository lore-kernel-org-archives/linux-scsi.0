Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311C8C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D955A20809
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P3qE21si"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgIOWJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:09:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34206 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbgIOWJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 18:09:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FM4qIb007912;
        Tue, 15 Sep 2020 22:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TiQvDBOiDeHvXrk0wPszDyLRq76ZaDntgufRIQ2wyuI=;
 b=P3qE21si+n6ftiSwg0MU4tIN9nOPTx3GlSPeYhjEmhgt7fugVWF0c9a6ozqMs969ZqqL
 bgWc4VXnDQBwCXjva9/pIfp6TiauyLjXl6quqZtZR9SUmA/7KtnWizSLlauD1T1JSxtR
 hUZvh0d+7OlhoId6EO4f9D+Lsxo2wrXkORsq1NfdDBx3wpTTan2qVujl3RhSh+JlVKed
 6MSYm4Y9bfFsOncGdnxBCyO1H6x1VhfPVFJn/EC839uFtUKTzqYrNvszAwWkJI4Q2Fj9
 GsJsalCxPC+0fxarUJrRYsKWwz4UJarX2nd5v6LOZD9ywKE06ocBpsuG1/9W/IW21H59 DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dheub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 22:08:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FM1SqI101504;
        Tue, 15 Sep 2020 22:08:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88664de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 22:08:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FM8rsX027655;
        Tue, 15 Sep 2020 22:08:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 22:08:52 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <damien.lemoal@wdc.com>,
        <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: megaraid: make smp_affinity_enable static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sda4rrn.fsf@ca-mkp.ca.oracle.com>
References: <20200915083948.2826598-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 18:08:50 -0400
In-Reply-To: <20200915083948.2826598-1-yanaijie@huawei.com> (Jason Yan's
        message of "Tue, 15 Sep 2020 16:39:48 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=975
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150171
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This addresses the following sparse warning:
>
> drivers/scsi/megaraid/megaraid_sas_base.c:80:5: warning: symbol
> 'smp_affinity_enable' was not declared. Should it be static?

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
