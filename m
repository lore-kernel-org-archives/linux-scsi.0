Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23889C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EBD214D8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f7AlhIj3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgHaRng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:43:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgHaRn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:43:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHSrDR072950;
        Mon, 31 Aug 2020 17:43:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LP7KEZhg+XKWxIs/BSczmC1OoPoZUx3aWNFf7jH3Qe0=;
 b=f7AlhIj3J5T8JIrf1EOms30exoVXSEO8Rp89z0EioZ6Os1wfucGbgafkD55k1jI46liZ
 iPnYwRp2AM/dNRcWETy6qlzaaacr09THXbQSp2Uuiy9QeowUU2DtZX3W0Wk7/q5piwsu
 DLesClTUL2hp9fqzYgydCRgD0C4PZ4NS2NG7AFbjew+sbRUbAAokGxmege+vLaroc3/O
 NtXAF2fDIwY/Ih90dXetEqK0ZmIEOpXH/VhR8lXrerAW9sNzqwEn9w8WGH/Tx62OsNa0
 5rYpbdVBf0u0YxwyJIEtajDRr1MfksDqzNdNJiMGsJ2H+/eWZRvjH9ogWbkLnxDJFPFb 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqqms1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:43:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHf8G9078432;
        Mon, 31 Aug 2020 17:41:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3380kkynmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:18 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VHfGGH005072;
        Mon, 31 Aug 2020 17:41:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:16 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com,
        lalit.chandivade@qlogic.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        michaelc@cs.wisc.edu, vikas.chaudhary@qlogic.com,
        JBottomley@Parallels.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call
Date:   Mon, 31 Aug 2020 13:41:03 -0400
Message-Id: <159889566023.22322.17846122781525526855.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200802110721.677707-1-christophe.jaillet@wanadoo.fr>
References: <20200802110721.677707-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=797 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=787 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2 Aug 2020 13:07:21 +0200, Christophe JAILLET wrote:

> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.
> 
> While at it, remove a memset after a call to 'dma_alloc_coherent()'.
> This is useless since
> commit 518a2f1925c3 ("dma-mapping: zero memory returned from dma_alloc_*")

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call
      https://git.kernel.org/mkp/scsi/c/650b323c8e7c

-- 
Martin K. Petersen	Oracle Linux Engineering
