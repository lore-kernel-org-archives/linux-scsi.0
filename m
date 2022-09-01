Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7F9ECAAD2
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiIAFMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiIAFMX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:12:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E98E122BE1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:12:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNn1AH024986;
        Thu, 1 Sep 2022 05:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=C1FyM30f9PTRyBgmH3OECVx0Dvly2rAm7SFuXHiAg/A=;
 b=WJnPNd5FSkye9vqJO5NNF3HGRGdubKv1b/ba8SLHMKMeHrKZGKOcrY0R8R+RptrJf1yZ
 gR4B4fpbDWHhkXUJOxEL16dRn00CIdwZRa5IFwFT8RAtFhwOde8m8bs5XZwGmroUkKa6
 xvlVyPJd7jZYVufh3P0mbADy2FmSS8lneBmxei39fYmVfgXXmY9wiQeANhNrVju1vpbu
 ohy2AwuamUnOaGYy2K1kUWLB9c7zB6cRnS3yW90IZwJsn4X+V0vimF7zUXuOGuQirgnY
 OpdzIwV+JdNHtvykz1uIE43lBiNvSm8xPkTqZPJ/a2XwcvXYIDTmHUv+0Ae80wdsvD8T og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79pc2q92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813gjl3022879;
        Thu, 1 Sep 2022 05:12:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q61j1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:20 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CJTI026239;
        Thu, 1 Sep 2022 05:12:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3j79q61j0y-1;
        Thu, 01 Sep 2022 05:12:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Revert "Call blk_mq_free_tag_set() earlier"
Date:   Thu,  1 Sep 2022 01:12:15 -0400
Message-Id: <166200876312.24183.13230082646825894170.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220821220502.13685-1-bvanassche@acm.org>
References: <20220821220502.13685-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=915 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010022
X-Proofpoint-ORIG-GUID: gctQgzLaCR28DCfDM2dtEE8Ht8oCbldD
X-Proofpoint-GUID: gctQgzLaCR28DCfDM2dtEE8Ht8oCbldD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 21 Aug 2022 15:04:58 -0700, Bart Van Assche wrote:

> Since a device, target or host reference may be held when scsi_remove_host()
> or scsi_remove_target() is called and since te patch series "Call
> blk_mq_free_tag_set() earlier" makes these functions wait until all references
> are gone, that patch series may trigger a deadlock. Hence this request to
> revert the patch series "Call blk_mq_free_tag_set() earlier".
> 
> Thanks,
> 
> [...]

Applied to 6.0/scsi-fixes, thanks!

[1/4] scsi: core: Revert "Call blk_mq_free_tag_set() earlier"
      https://git.kernel.org/mkp/scsi/c/2b36209ca818
[2/4] scsi: core: Revert "Simplify LLD module reference counting"
      https://git.kernel.org/mkp/scsi/c/70e8d057bef5
[3/4] scsi: core: Revert "Make sure that hosts outlive targets"
      https://git.kernel.org/mkp/scsi/c/d94b2d00f7bf
[4/4] scsi: core: Revert "Make sure that targets outlive devices"
      https://git.kernel.org/mkp/scsi/c/f782201ebc2b

-- 
Martin K. Petersen	Oracle Linux Engineering
