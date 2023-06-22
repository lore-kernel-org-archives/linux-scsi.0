Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6934EEB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjFVB0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjFVB0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:26:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4131BD4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 18:26:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LL86dt023603;
        Thu, 22 Jun 2023 01:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=FxuvCbaXrb2EsC3vKXoLcICdX3lGqFlg6pvWyWyA0YM=;
 b=E2U0Qno67ReX2aiosblT2G3W8RSIZBZUnfF5XcUm0la8OswACAlRa01oKe1zXtObRgua
 KtvHc0V5SBkeWIfep03J2lCKmTp5YKM4JyXkvV92FPTLfsCUH6Jp4EDkjrjyuE0nc+SS
 ZjHVfiOFen/jXTzbGqpPuQnUfTfvPVXNl1UkFn4VGMV1ha0/YdJUhfzbmGrw/VeCL4gE
 aTWhKz+C7tVYYY0X/WEVf5jErNGBN+F7Z9cOrk5lVoxAouSLUxpZKAQ4Up436RxI17ar
 zF1hc7PDmRDOsJv1VC4MIm2c9Fpp3rTLKFriu4Gun9VPfxZsyir9Hk3O40TULJwdhuTb NQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r94qa8nsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M0CHMm038549;
        Thu, 22 Jun 2023 01:26:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396tj00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXb5038374;
        Thu, 22 Jun 2023 01:26:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-8;
        Thu, 22 Jun 2023 01:26:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH v2 0/8] qla2xxx klocwork fixes
Date:   Wed, 21 Jun 2023 21:26:26 -0400
Message-Id: <168739587261.247655.907050210545281340.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com>
References: <20230607113843.37185-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=640 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-GUID: Rn_Jv0NyUfiVu9m2Lp0xF1sbXwa5hcwU
X-Proofpoint-ORIG-GUID: Rn_Jv0NyUfiVu9m2Lp0xF1sbXwa5hcwU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 07 Jun 2023 17:08:35 +0530, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver klocwork fixes to
> the scsi tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/8] qla2xxx: klocwork - Array index may go out of bound
      https://git.kernel.org/mkp/scsi/c/d721b591b95c
[2/8] qla2xxx: klocwork - Fix potential null pointer dereference
      https://git.kernel.org/mkp/scsi/c/464ea494a40c
[3/8] qla2xxx: klocwork - avoid fcport pointer dereference
      https://git.kernel.org/mkp/scsi/c/6b504d06976f
[4/8] qla2xxx: klocwork - Check valid rport returned by fc_bsg_to_rport
      https://git.kernel.org/mkp/scsi/c/af73f23a2720
[5/8] qla2xxx: klocwork - Fix buffer overrun
      https://git.kernel.org/mkp/scsi/c/b68710a8094f
[6/8] qla2xxx: klocwork - pointer may be dereferenced
      https://git.kernel.org/mkp/scsi/c/00eca15319d9
[7/8] qla2xxx: klocwork - correct the index of array
      https://git.kernel.org/mkp/scsi/c/b1b9d3825df4
[8/8] qla2xxx: Update version to 10.02.08.400-k
      https://git.kernel.org/mkp/scsi/c/991e7ac609ee

-- 
Martin K. Petersen	Oracle Linux Engineering
