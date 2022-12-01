Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D599FC47088
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLADqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLADqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C30E9B7B8
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B133ci7022994;
        Thu, 1 Dec 2022 03:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=JF/oWGr0RbTf6v14MgQr4yldbXY/1hu3FM2+RszZgfQ=;
 b=oFng8gCgif/oUg5UAcqBQbPAgZQkjsBs139iW9cWZ/BKVe0x7W2bzG9iIhl39FlowMtw
 0cQDCNhHp1S5NL2LRlmE5JU5cREQ8N7Ch50xbZR7VwYTSd6CZRj7R2li74bMsRvjQvOB
 +S1QX0zw5n76yg3LTwPmBAc9kILLrSFfyN0FU9U9Xg/DZlec9tjMpxAJMrQvqckk+hLx
 REyS0qhaxDns6/VBOPtqAlgptowxQhkcRL8Ph7YXhTIIKFW58HcEXoBHT8F3IFgHrqXn
 Mr9U3rcJ1kKNR/HpA7v++HHEVMFaH8QZ4EFBVfWEM70d2eKIsIzgUrdXkCP5TgFNUG3x ZA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y43ep8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12H7gH007610;
        Thu, 1 Dec 2022 03:45:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2crn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:49 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpi033801;
        Thu, 1 Dec 2022 03:45:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-12;
        Thu, 01 Dec 2022 03:45:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Remove duplicate of vha->iocb_work initialization
Date:   Thu,  1 Dec 2022 03:45:13 +0000
Message-Id: <166986602288.2101055.2738180888210845892.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <822b3823-f344-67d6-30f1-16e31cf68eed@scst.dev>
References: <822b3823-f344-67d6-30f1-16e31cf68eed@scst.dev>
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
X-Proofpoint-GUID: Pp9HGItjsMnDTWMXuEur0I4u0miul6HX
X-Proofpoint-ORIG-GUID: Pp9HGItjsMnDTWMXuEur0I4u0miul6HX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2022 12:38:05 +0300, Gleb Chesnokov wrote:

> Commit 9b3e0f4d4147 ("scsi: qla2xxx: Move work element processing
> out of DPC thread") introduced the initialization of vha->iocb_work in
> qla2x00_create_host() function.
> 
> This initialization is also called from qla2x00_probe_one() function,
> just after qla2x00_create_host().
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/2] qla2xxx: Remove duplicate of vha->iocb_work initialization
      https://git.kernel.org/mkp/scsi/c/3620e174d260

-- 
Martin K. Petersen	Oracle Linux Engineering
