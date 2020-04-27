Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB35C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55B6206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OznUaaTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgD0UXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:23:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58512 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgD0UXi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:23:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKMsJU011292;
        Mon, 27 Apr 2020 20:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YrRivgbxZ2Ks1JHSiDXxgUp4WF3N3R2SKvh1yz6iErs=;
 b=OznUaaToKnPMQpuFoxqzpmsqMd2mH5DkDQKaBPGSrvklzBXCCf5PNVRT5CGwitNzwjdJ
 UQiuOqFWalRjKgw4Qg7PdD8uGTqEgfITve9O6uqgIwvmK0PHeK7LoARhL7StrUi0mIaj
 IaXDn9v729bx6OQz8Qaf3ax58zpPGC4iNOqv4EmcDMdkF2U1hjJ+FAtdS3PVWG90Nt+w
 nCkEBsGaFuL2i4iiSpwp+WubG2FlfCQvgvXGjybfgCzZ5ND4WaLLcUwIoMFh4EAs0kYQ
 Yy5XX2xlXJjuLVj1HQN/EXJBWhV53zUQP8pqd72e6waMo6Oi9IAFjh7P7uNApjTjnyfy uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucfuw9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:23:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKCcxS080844;
        Mon, 27 Apr 2020 20:21:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpe1xtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:31 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLTaf004203;
        Mon, 27 Apr 2020 20:21:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:29 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     artur.paszkiewicz@intel.com, linux-kernel@vger.kernel.org,
        intel-linux-scu@intel.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: isci: use true,false for bool variables
Date:   Mon, 27 Apr 2020 16:21:18 -0400
Message-Id: <158777063305.4076.13453813927930285183.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200421034050.28193-1-yanaijie@huawei.com>
References: <20200421034050.28193-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Apr 2020 11:40:50 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
>
> drivers/scsi/isci/isci.h:515:1-12: WARNING: Assignment of 0/1 to bool
> variable
> drivers/scsi/isci/isci.h:503:1-12: WARNING: Assignment of 0/1 to bool
> variable
> drivers/scsi/isci/isci.h:509:1-12: WARNING: Assignment of 0/1 to bool
> variable
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: isci: Use true, false for bool variables
      https://git.kernel.org/mkp/scsi/c/8d5e202802a5

-- 
Martin K. Petersen	Oracle Linux Engineering
