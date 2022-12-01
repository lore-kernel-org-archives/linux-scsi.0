Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344D1C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiLADrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiLADrK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:47:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69062A055C
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B13PNEn016224;
        Thu, 1 Dec 2022 03:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=EfLLIZYkS6Z5sVSbXeISb2yK4LFN406Aq3HB8t71qGU=;
 b=tzZJIEUM9lrGbSsltEDsLernwDbO+BisieHdfTSsY982saAEJcRngSIy3EnjQnJsq7I8
 JBprqGo8Qpx1CfBy06/GMxHt7oX3QfH3ApfSLtommg6o2UN/sa7qYkreGwmO8ezDPW5e
 LOrnIg9bQvA2Cmc7C+9xYg/qgdCxqwnfAy2w3KMhXW/8u51XDAzv49gb0kSsGwBbJ8O+
 jLiONrzMrAOa7bimCCevwidO83oma1SbFhUugkaO+JdaLncON93YhYdllXwpkqyNutp6
 zaVCHD621qG10QVAa9aV9xixTEc4AMEOIOwNbCtERfwJb368zOm5H/u5aP0xndEWRfWR dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemjjpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12Of5w007679;
        Thu, 1 Dec 2022 03:46:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2d27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:05 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbqI033801;
        Thu, 1 Dec 2022 03:46:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-29;
        Thu, 01 Dec 2022 03:46:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Yuan Can <yuancan@huawei.com>,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        ming.lei@redhat.com, don.brace@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
Date:   Thu,  1 Dec 2022 03:45:30 +0000
Message-Id: <166986602275.2101055.8131183691697707504.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122015751.87284-1-yuancan@huawei.com>
References: <20221122015751.87284-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-ORIG-GUID: DV2ppoJJEZR4hyNkcysveVV85tkvj3Ev
X-Proofpoint-GUID: DV2ppoJJEZR4hyNkcysveVV85tkvj3Ev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Nov 2022 01:57:51 +0000, Yuan Can wrote:

> The hpda_alloc_ctlr_info() allocates h and its field reply_map, however in
> hpsa_init_one(), if alloc_percpu() failed, the hpsa_init_one() jumps to
> clean1 directly, which frees h and leaks the h->reply_map.
> Fix by calling hpda_free_ctlr_info() to release h->replay_map and h
> instead free h directly.
> 
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
      https://git.kernel.org/mkp/scsi/c/9c9ff300e0de

-- 
Martin K. Petersen	Oracle Linux Engineering
