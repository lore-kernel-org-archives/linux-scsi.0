Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF23CA0FF8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjIEQF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354242AbjIEKTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 06:19:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8E918D
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 03:18:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853OxC8024407;
        Tue, 5 Sep 2023 10:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=wJ5b2TiYPo9yu2X9Lcwjdeb9+G7zTWdGA+TRaWadVKI=;
 b=oGzTarSfonvd+mU98wSBYGSURF8jUShWYdVV5FIEzXYrPOlVLzUumkgf1RlvirjJprIo
 Jbw+DJH5asUbxSXJb1QLRytTH/ak8lHbl6uckhu3u5XUmjbr94Wd+geoxCUdPfluN0qD
 nbvOZQtwXs92UI9VYE6FtvcwvxhSFG6sGcJ3Khd2H7pmknJLYDYJV9ftY5enYsoxZMTt
 Wv2T1bfKb+S4dWgysmNgwF+4FgNHguXL0CYQ68qhD4Xu9A7WQiEfI6V3kKEang9BNCBZ
 9ZokaE8H1tzDIZIgfCzp1Orkn3LA7XOy4nvA7GAp1ZJdtKrJlKv1iaLIP40UTyraUQ7d vA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suvntvvup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3859Ba3M029057;
        Tue, 5 Sep 2023 10:18:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug4j8bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:49 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 385AIlOX032271;
        Tue, 5 Sep 2023 10:18:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3suug4j85n-2;
        Tue, 05 Sep 2023 10:18:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Fix the build for the old ARM OABI
Date:   Tue,  5 Sep 2023 06:18:25 -0400
Message-Id: <169390541191.1533355.3501860660032738921.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230829163547.1200183-1-bvanassche@acm.org>
References: <20230829163547.1200183-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_08,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=558 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050092
X-Proofpoint-ORIG-GUID: GzxHq6FDG2mfh8Ez_pC9wOi2liRG6h1g
X-Proofpoint-GUID: GzxHq6FDG2mfh8Ez_pC9wOi2liRG6h1g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Aug 2023 09:35:42 -0700, Bart Van Assche wrote:

> All structs and unions are word aligned when using the OABI. Mark the union
> in struct utp_upiu_header as packed to prevent that the compiler inserts
> padding bytes.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: ufs: Fix the build for the old ARM OABI
      https://git.kernel.org/mkp/scsi/c/d0bac0ec89d6

-- 
Martin K. Petersen	Oracle Linux Engineering
