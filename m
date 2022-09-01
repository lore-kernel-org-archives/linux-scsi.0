Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E4FECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiIAFMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiIAFMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:12:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491271286CB
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:12:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmtqS026960;
        Thu, 1 Sep 2022 05:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=EIlWsqBswwE8HkrdLWSfxxQ0sUFIV8kw/QOkhlb5MIk=;
 b=wZJexVCssPBR2a26ZtAoerYu4Zz3HCT+xse3KftNxH/Hrlo+RtmAcJkEdpm1uQeBWOVd
 IoCgiS75HucB2bay6lcd+onjpZCFKZXZuhCRJ2/Y9e7t8tCtuiOTRJDI1s8JHcis9oHs
 yploSJUcBRb65fh39WR6VC13P/BqyD44P14abI7Hlnx4OS9J4PTIi0atMgAuteBJJ0B8
 LigiXJYgEQsFSvulO4ChIovUSUBd3mdc3buToVX13CxCrlAnkGM9DjbyLi7m+63S6pwO
 G1m+Qk0o+YSn26klgp9uZt6ay5Sxm6UA8fRlnxYRmssh4Q71WfLe+RRgiF/lByY5tvr2 Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avsk02k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813g6uO022886;
        Thu, 1 Sep 2022 05:12:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q61j1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CJTK026239;
        Thu, 1 Sep 2022 05:12:21 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3j79q61j0y-2;
        Thu, 01 Sep 2022 05:12:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: core: Fix a use-after-free
Date:   Thu,  1 Sep 2022 01:12:16 -0400
Message-Id: <166200876312.24183.15197711372350955087.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220826002635.919423-1-bvanassche@acm.org>
References: <20220826002635.919423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=992 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010022
X-Proofpoint-GUID: Lm1dtyn8rl4atTJ4ukuHXoM5uH33qIby
X-Proofpoint-ORIG-GUID: Lm1dtyn8rl4atTJ4ukuHXoM5uH33qIby
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Aug 2022 17:26:34 -0700, Bart Van Assche wrote:

> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by waiting inside
> scsi_remove_host() until the tag set has been freed.
> 
> This patch fixes the following use-after-free:
> 
> [...]

Applied to 6.0/scsi-fixes, thanks!

[1/1] scsi: core: Fix a use-after-free
      https://git.kernel.org/mkp/scsi/c/8fe4ce5836e9

-- 
Martin K. Petersen	Oracle Linux Engineering
