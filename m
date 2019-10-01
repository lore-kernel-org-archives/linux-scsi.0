Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7808BC32793
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AEDA20842
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cFn7Ogo1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfJADnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:43:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfJADnp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:43:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913dR2q150536;
        Tue, 1 Oct 2019 03:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6h5wMy1DQG9fj2uMK60FL2PtvoFXb+IMA3n3pCr3OfA=;
 b=cFn7Ogo1nVG71bH0IzPNypI2FYwh14se8WaNdisJv0l4x2aWd/ggpBJgz2ri7bIkXEdK
 717VbYL1w3Jj/dsNSxwfdyvsnR0UBa+if5g4S1pXTZUsQEWZogh/syTw/W1mO2MbYRyO
 +TvDAtUADnPwrpVMH15ffzrdCvrNY7arNclht1t+Szuh2vfITm0zvFbqB/lrdOjRaQBw
 HYdFBBiK9iFySRe09Rf5pn2fnEokEenZHZPp32kGb35s3NjSMXfK+StyEjHcpFBq8aJ8
 SyCgHtwXgTEdzFfVhLM0PhsdYbTBHdYFmobGNieSTdUXGJBe3XDbbPsuOYJ9LS9UWdtZ 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2va05rjwqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:43:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913hB0o146729;
        Tue, 1 Oct 2019 03:43:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vbnqbxme3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:43:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x913hfYx022533;
        Tue, 1 Oct 2019 03:43:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:43:41 -0700
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        sankar.patra@broadcom.com, sasikumar.pc@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, anand.lodnoor@broadcom.com
Subject: Re: [PATCH] megaraid_sas: unique names for MSIx vectors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190913065515.22493-1-chandrakanth.patil@broadcom.com>
Date:   Mon, 30 Sep 2019 23:43:38 -0400
In-Reply-To: <20190913065515.22493-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth Patil's message of "Fri, 13 Sep 2019 12:25:15 +0530")
Message-ID: <yq1h84tw2ol.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=854
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010035
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> +#define MEGASAS_MSIX_NAME_LEN			16

[...]

> +		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%d-msix%d",
> +			"megasas", instance->host->host_no, i);

Seems like MEGASAS_MSIX_NAME_LEN is too small given that naming scheme?

Also, please use %u.

-- 
Martin K. Petersen	Oracle Linux Engineering
