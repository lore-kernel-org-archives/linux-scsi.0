Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA7AC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB1521582
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SYHZqJya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHCyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43798 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHCyx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rgEv195084;
        Fri, 8 May 2020 02:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=GDuzAR7cfBdS59kHOBOXSQHR1eeCHBSM/ilFf/BqV5Y=;
 b=SYHZqJyabHNHbvEj1eBWtnVilhi5V0yQ4Jw3C2my79l1EnvdkhtU1WzBrA7PaMMal49l
 uL+2noZmf0qkrBI1eww+dzkCOWhDyxepf+3yqxxwEjGlwhgxHozi7SZfcF0O3p/lsc1U
 6o+/v7nFSYjnW+3Iph7IVMx/dkdTD0aCtMoSRlgtWSjK8ePCx0aPSMoA5eEL4uNz2YC/
 2+hrDKtgZK2o82l9dRW3NjinLppydL/4BIoH4iru1nbdAY84SV5ph81IkJXscYvbzchp
 VQcQtydyY/4jRXbruAtCZkvWc88qw7SPH3acvD0xdxh8JHjceezvUHW0+DUd6kugyQLe Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30vtewrrr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qggs012603;
        Fri, 8 May 2020 02:54:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30vtefqn9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0482sh2L003640;
        Fri, 8 May 2020 02:54:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:42 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, MPT-FusionLinux.pdl@broadcom.com,
        chaitra.basappa@broadcom.com, Jason Yan <yanaijie@huawei.com>,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: use true,false for ioc->use_32bit_dma
Date:   Thu,  7 May 2020 22:54:29 -0400
Message-Id: <158890633246.6466.16530284033755369229.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121738.15151-1-yanaijie@huawei.com>
References: <20200430121738.15151-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=932 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=994
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:17:38 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:7202:1-19: WARNING: Assignment of
> 0/1 to bool variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Use true, false for ioc->use_32bit_dma
      https://git.kernel.org/mkp/scsi/c/55d4ce458c77

-- 
Martin K. Petersen	Oracle Linux Engineering
