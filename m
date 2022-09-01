Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA28AECAAD2
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiIAFMb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiIAFMa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:12:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED449122BF8
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:12:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNn2eB032311;
        Thu, 1 Sep 2022 05:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=NpMXPQSaHhImK3eASItsDbHvVxK5ZoGF44tUJKGIC7s=;
 b=iCs6G8FZdw8vyWdDD8Yjki6Yegv75yrZdZVM8Iq1Co/lckXVaU6qNBnicrwQjyc6vcnF
 A1UEC/iwBjCtTKFIUYZ5ZWyQk0Zxi/8WlLkjQ/PsGZItv3buPGntsjOqIrEzuYp49m8j
 xh/gN0NUyN3StfHb5sZPKPkdASfupLwbl5PP5157BXK8Ai90jG8OlFwaYbVj3vaZgOgd
 tgCFq/Gacs/62LPK/LeAuRg/P1AbsMIxUldrzRsmsmwi5QjqKfWgT4KuN9dipRlQfKpU
 vrhIIt1/vHtIG/j6qB3UjGtl+0ULzKOB+IZ1R8JDJ8yfGLb522aLDC9ILFOKb0mSv31j 5g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b5a2tef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 281399Ml022880;
        Thu, 1 Sep 2022 05:12:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q61j27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:22 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CJTM026239;
        Thu, 1 Sep 2022 05:12:22 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3j79q61j0y-3;
        Thu, 01 Sep 2022 05:12:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
Date:   Thu,  1 Sep 2022 01:12:17 -0400
Message-Id: <166200876311.24183.6758302679291853819.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220824060033.138661-1-hare@suse.de>
References: <20220824060033.138661-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010022
X-Proofpoint-ORIG-GUID: qGocd2e6TQ4CXg3R7DS4ObGTvg9g1r5I
X-Proofpoint-GUID: qGocd2e6TQ4CXg3R7DS4ObGTvg9g1r5I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Aug 2022 08:00:33 +0200, Hannes Reinecke wrote:

> When the driver hits on an internal error condition returning
> DID_REQUEUE will cause I/O to be retried on the same ITL nexus.
> This will inhibit multipathing, resulting in endless retries
> even if the error could have been resolved by using a different
> ITL nexus.
> So return DID_TRANSPORT_DISRUPTED to allow for multipath to engage
> and route I/O to another ITL nexus.
> 
> [...]

Applied to 6.0/scsi-fixes, thanks!

[1/1] lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE
      https://git.kernel.org/mkp/scsi/c/c0a50cd389c3

-- 
Martin K. Petersen	Oracle Linux Engineering
