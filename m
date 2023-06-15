Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBB1EB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 02:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbjFOCQi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbjFOCQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 22:16:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278122103
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 19:16:35 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EK0BSa015413;
        Thu, 15 Jun 2023 02:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7IXOROoAtbvywmnqSLsc0MDP8rrg6D2N82htMwtt9Ps=;
 b=MgExZisSZff44ZYMZLfuS9+j196ZFxJ+FS3vPVBOUISnOI3c8dENMhJzS0CmRIdfYBO2
 ps1GVg2MDSp927FUuolpEgt2LP+RV9x2e2Cskd/7MkyFsMZpO2wXTOkhQ4MlTA+PNnT5
 CRRLjryhnoRJBdt92S0g+zN7jXe4kQzck39bSt3xBd6Qgli30zi/rEE9blc9icBKGc+l
 CVo1SSwwv1HP2qRGakdxkLNf5oAXmyWPBh8ntjTkbVTzRv4E+Zl0LUpApmTcSnAm/JeW
 Fsk+EOy4ZMm8raikxcuVytqiSVfpXPPMjnEuNbj3kpR7F3b2e8IK/02hO33jgY2tD6+D BQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2arvc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:16:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35F1MO0Q016305;
        Thu, 15 Jun 2023 02:16:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6bnxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:16:29 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35F2EE7J027953;
        Thu, 15 Jun 2023 02:16:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r4fm6bnx8-3;
        Thu, 15 Jun 2023 02:16:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3][next] scsi: lpfc: Use struct_size() helper
Date:   Wed, 14 Jun 2023 22:16:22 -0400
Message-Id: <168679535168.3778526.14503496950152410985.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230531223319.24328-1-justintee8345@gmail.com>
References: <20230531223319.24328-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=586 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150017
X-Proofpoint-ORIG-GUID: Rbd-t3PEDR9-kDKwXrzAW_tKajPBpMMg
X-Proofpoint-GUID: Rbd-t3PEDR9-kDKwXrzAW_tKajPBpMMg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 May 2023 15:33:19 -0700, Justin Tee wrote:

> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: lpfc: Use struct_size() helper
      https://git.kernel.org/mkp/scsi/c/bb26224ed47c

-- 
Martin K. Petersen	Oracle Linux Engineering
