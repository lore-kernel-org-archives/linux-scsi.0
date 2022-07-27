Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE403C19F28
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbiG0DPi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiG0DPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:15:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F3201BB
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 20:15:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2jY9s010356;
        Wed, 27 Jul 2022 03:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=QpFHXrWH1Dk9MGlQ4H6wgYQLo1CfRk2p+ERRQj3P3PA=;
 b=abnMjwvzT4PPtjtmhPaP9TKKQKkrguLvqmpJytwgeQ9Wz4xuhRa5akDNNeSF07aVTO2z
 pTcsDoxI5KwAlHrbZ2QwnXqTg2vjINp/LzZW65/7xUaX5S8Oo6PvvZy8zxN9HhKzq/m+
 4izhyncLf3sEVsgDLjRPjU9DULK98K8rWosA2JrWrCqxixYCaHyj4CfcAbt5SMW4CbF7
 scNiny6ajICJe2ugJH06QenhTAzTva+KbD7YVTuxCdrr+4nGozAH+/pbvYjhR3X1OAt3
 yx0PCarKDEbRS/jMe1hJ5oZ6JP1XdDOHUU1KQKr21oh2anlZ/9/iv757kZHj9lI+QgLv Fw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a9g7mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2sDnT019820;
        Wed, 27 Jul 2022 03:15:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh638mkt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:16 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3Dx7Z005078;
        Wed, 27 Jul 2022 03:15:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh638mkrj-3;
        Wed, 27 Jul 2022 03:15:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        jejb@linux.ibm.com, bvanassche@acm.org, beanhuo@micron.com,
        Liang He <windhl@126.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] ufs: host: ufshcd-pltfrm: Hold reference returned by of_parse_phandle()
Date:   Tue, 26 Jul 2022 23:15:12 -0400
Message-Id: <165889169551.689.16738523271749677204.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719071529.1081166-1-windhl@126.com>
References: <20220719071529.1081166-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270009
X-Proofpoint-GUID: Fa6yAJt4tIWIXHWgORNjOO9pNYdkW3nG
X-Proofpoint-ORIG-GUID: Fa6yAJt4tIWIXHWgORNjOO9pNYdkW3nG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jul 2022 15:15:29 +0800, Liang He wrote:

> In ufshcd_populate_vreg(), we should hold the reference returned by
> of_parse_phandle() and then use it to call of_node_put() for refcount
> balance.
> 
> 

Applied to 5.19/scsi-fixes, thanks!

[1/1] ufs: host: ufshcd-pltfrm: Hold reference returned by of_parse_phandle()
      https://git.kernel.org/mkp/scsi/c/a3435afba87d

-- 
Martin K. Petersen	Oracle Linux Engineering
