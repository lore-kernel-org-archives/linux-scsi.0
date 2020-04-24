Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2378C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D09E82075A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:30:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3BZPpBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgDXRaC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:30:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52174 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgDXRaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 13:30:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHMYrl130647;
        Fri, 24 Apr 2020 17:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=CZLc1DZWz37/9j/SPagTNrIvn4Qv65Ju64jtxEuMjtI=;
 b=D3BZPpBLCiTfr1De+htHux2IB+H7ncfpqdOLokAVA1BiiF7E9jp+vOu3J17Umxlpgokj
 Va+sbDWpk4MATru0zNd5dIQKJdVo59gOcO4tsWGb3MyxUm1tG156XdyYnea/pcBv1aWh
 GaMJQ/B93D/4NVS7VfFSg3I9qK5sXokQoDc6k58ppovBCY88fvMV8Uy/enBBp26hSSTL
 CP0FcD75d6WDONEgC+3xkWpvsyBOaqwN/fJ+sV7M0conNz2PRYzV52D9eyHnfZ7lHZRp
 SXyYEDVziSSE5zaYL2XGexrH8EC7YKVXehVyH5B8bjuPkXFtHGo1lx27iAU0VPNAU/H0 mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30jvq52bmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:29:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OHLm4I162349;
        Fri, 24 Apr 2020 17:29:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3xrr56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:29:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OHTpGM016098;
        Fri, 24 Apr 2020 17:29:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 10:29:51 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: megaraid: use true,false for bool variables
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200421034111.28353-1-yanaijie@huawei.com>
Date:   Fri, 24 Apr 2020 13:29:49 -0400
In-Reply-To: <20200421034111.28353-1-yanaijie@huawei.com> (Jason Yan's message
        of "Tue, 21 Apr 2020 11:41:11 +0800")
Message-ID: <yq1zhb0dc6q.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following coccicheck warning:
>
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4242:6-16: WARNING:
> Assignment of 0/1 to bool variable
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4786:1-29: WARNING:
> Assignment of 0/1 to bool variable
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4791:1-29: WARNING:
> Assignment of 0/1 to bool variable
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4716:1-29: WARNING:
> Assignment of 0/1 to bool variable
> drivers/scsi/megaraid/megaraid_sas_fusion.c:4721:1-29: WARNING:
> Assignment of 0/1 to bool variable

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
