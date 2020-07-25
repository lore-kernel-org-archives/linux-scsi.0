Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A824C433E5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385C12070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mSShgVL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGYCwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:52:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGYCwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:52:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lhoC049076;
        Sat, 25 Jul 2020 02:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=QGccruug/HS1ZoUIU96kqzA3s4oTcV23/plX+v0M9Bs=;
 b=mSShgVL530rdRjd5Qg11q1A3JMoSkP8Tcz5O2q/KMvg6wg/dd9XyMjMqvkmuFVViukTP
 vPmufVaStoOZKgBbN8qvlsrmp3WhVTtJq/vM9e9QOQH4J7dnGl3nAvg4JzIE2jvrSRkF
 jXzTRYahP6UO0l+1kvlt/YpE2YCP9VnJnHSDIFHfC2/rRwSTwNvY37yZ8CxIgi71Ml9z
 hStRAYW5qWiRjzKpA4HlfBquuCmQ/qMtnxLTfTDd3uQei3jUFOVmLZIcNR/nDGfiFe7A
 vxNG+braW/xx+R7YTsEaWwJ06qaQz7eVMR+9AAW2cjPzI6e62SYI6bqfKk+YCo/ZkIPF nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6kt6422-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mEIN001223;
        Sat, 25 Jul 2020 02:51:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32gam27gup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2p5Jh004231;
        Sat, 25 Jul 2020 02:51:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:51:04 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Wang Hai <wanghai38@huawei.com>,
        aacraid@microsemi.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: dpt_i2o: remove some not needed memset
Date:   Fri, 24 Jul 2020 22:50:45 -0400
Message-Id: <159564519423.31464.8874512705165332474.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200718123224.1202-1-wanghai38@huawei.com>
References: <20200718123224.1202-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=855 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=861 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Jul 2020 20:32:24 +0800, Wang Hai wrote:

> Fixes coccicheck warning:
> 
> ./drivers/scsi/dpt_i2o.c:3070:11-29: WARNING:
>  dma_alloc_coherent use in sys_tbl already zeroes out memory, so memset is not needed
> ./drivers/scsi/dpt_i2o.c:2780:10-28: WARNING:
>  dma_alloc_coherent use in status already zeroes out memory, so memset is not needed
> ./drivers/scsi/dpt_i2o.c:2834:20-38: WARNING:
>  dma_alloc_coherent use in pHba -> reply_pool already zeroes out memory, so memset is not needed
> ./drivers/scsi/dpt_i2o.c:1328:10-28: WARNING:
>  dma_alloc_coherent use in status already zeroes out memory, so memset is not needed

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: dpt_i2o: Remove superfluous memset()
      https://git.kernel.org/mkp/scsi/c/003015b890e1

-- 
Martin K. Petersen	Oracle Linux Engineering
