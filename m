Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F28DC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056E120715
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x2E/L8E7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLAFFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:05:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55574 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgLAFFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:05:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14nQx9008535;
        Tue, 1 Dec 2020 05:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Tfjmc6LfrOPX/TJW8fDDf2OOlnO1ghX4FNaqk4e3b+w=;
 b=x2E/L8E77Hw+zRC+u5J0JmJyWUfBR10pCWfsTMupPZCKKTHJm5KxX4D2xpjn+4c/TaFe
 GgXrgp2fgkT+hVmaOKQc+fgeMrn8BPO7wVe4Fz79TbsY8t8xmeU7fT28lBMJ+y0zSKv7
 K+m5f84W5MKmxkYIuHBgBF5iP+wlDqfAiza3ecO9nTZkXSCHelUM5FBM4AmdZYS9xCq/
 nsmLod1UiZMqMDVhHlLZa9AnCrAXGLkCZdIxBeIm5W++7Rhd+ntPxloKAt0+hD5XXMUn
 tWNbh2sKRRTXC//UCVtYk9mYWd5cCmii7VevIl6eOe2WhTuRb3M7g5/O16UxAaP7gQWL kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2arqdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:04:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14o3Kh114682;
        Tue, 1 Dec 2020 05:04:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540exfcs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:04:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B154RkG017364;
        Tue, 1 Dec 2020 05:04:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:04:27 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@telegraphics.com.au>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/NCR5380: Reduce NCR5380_maybe_release_dma_irq() call sites
Date:   Tue,  1 Dec 2020 00:04:17 -0500
Message-Id: <160636449893.25598.9528631656224076486.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
References: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 15:39:56 +1100, Finn Thain wrote:

> Refactor to avoid needless calls to NCR5380_maybe_release_dma_irq().
> This makes the machine code smaller and the source more readable.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: NCR5380: Reduce NCR5380_maybe_release_dma_irq() call sites
      https://git.kernel.org/mkp/scsi/c/bdd1cc0377d3

-- 
Martin K. Petersen	Oracle Linux Engineering
