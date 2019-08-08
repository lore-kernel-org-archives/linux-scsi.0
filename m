Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7CAC433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64EB6217F4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EkrZeOnj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfHHB5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:57:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfHHB5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:57:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781rvZR141595;
        Thu, 8 Aug 2019 01:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=sGIwswr/oRMfQCnm33aJIT8NtNxA1hmKk/VBp8cjfPM=;
 b=EkrZeOnj9lF5ld2eJP7rQSL3KbI5i2W29ki5bH53g0GLuY4FjyIeJmYlBtPS/FpEW+Bq
 FMq5aINYU1WsaLoNmXzDkBGihn5EFY8VKEDZJsf59y7bGXj5tuhV1vUrIw59RXpqEjMS
 cnbFI3hv8WFOYLfM+5Uk0VAv/1nHyiBpAxryvV/I4NhbHWhV7kiBzSFoncKw+oPX1VVD
 XGSFIWDkuM5pnqvI5KRkkI1h62W1sK5RsoznBiwOnhbrBN+IFfqBi0gddU+pU4g0qWLK
 Mgxck3mfvw1MG1YHeQQelc+QCyKiG8V97WBznLiKA/jSUo9UsG2hs4uuNOuCzZqSFFj1 AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u527pyhg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:57:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781r7j8074237;
        Thu, 8 Aug 2019 01:57:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u7578gp67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:57:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x781vI2c005948;
        Thu, 8 Aug 2019 01:57:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:57:17 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix crash when cpu count is 1 and null irq affinity mask
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190802202612.25799-1-jsmart2021@gmail.com>
Date:   Wed, 07 Aug 2019 21:57:15 -0400
In-Reply-To: <20190802202612.25799-1-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 2 Aug 2019 13:26:12 -0700")
Message-ID: <yq1k1boctc4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> When a configurations runs with a single cpu (such as a kdump kernel),
> which causes the driver to request a single vector, when the driver
> subsequently requests an irq affinity mask, the mask comes back null.
> The driver currently does nothing in this scenario, which leaves
> mappings to hardware queues incomplete and crashes the system.
>
> Fix by recognizing the null mask and assigning the vector to the first
> cpu in the system.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
