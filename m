Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923AAC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLADqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLADqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00F89D829
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1297Hc022941;
        Thu, 1 Dec 2022 03:45:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=+/6bzm60RWDYhofnaEsk6NithRREAph1NsXBCPa/obw=;
 b=B1B/ShzMctgajJUeUkiVQxUn/niq5aKxw7rGFdefVgsq9R7lxmGfhe/DpXPemcnJB8KR
 80JsyE4l9s5boy3EqBOsHOG3ljh48zbq5mVXkeembsQ6zxO4w52PhaciA8R+2caXn5jv
 i2qFY2W2fRe3plWLsstoRvrFhCydxu8mUZloETdry35+QsgTVFpJT2sVjamxc/uaplQM
 UbhPkd/mLyhsTBnFqpZ96Cu9S5zsUEbUBmXi//NYJmLzroGH0Rh2Mjy4L4BeWnoy/TEr
 mCTOJoMhJvUpv5B7UK/SsKgES8f36Ssd3/sAlLwzMBabpJNMPxbf4+sVyswVCl8XvT9t Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12EKV8007577;
        Thu, 1 Dec 2022 03:45:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:47 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpe033801;
        Thu, 1 Dec 2022 03:45:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-10;
        Thu, 01 Dec 2022 03:45:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com,
        jejb@linux.ibm.com, Chanwoo Lee <cw9316.lee@samsung.com>,
        linux-scsi@vger.kernel.org, stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unnecessary return code
Date:   Thu,  1 Dec 2022 03:45:11 +0000
Message-Id: <166986602295.2101055.17171571546813272562.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121003338.11034-1-cw9316.lee@samsung.com>
References: <CGME20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049@epcas1p1.samsung.com> <20221121003338.11034-1-cw9316.lee@samsung.com>
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
X-Proofpoint-GUID: S2KiU5HfExNVUmGEfy2GmJvDopIgUJTx
X-Proofpoint-ORIG-GUID: S2KiU5HfExNVUmGEfy2GmJvDopIgUJTx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Nov 2022 09:33:38 +0900, Chanwoo Lee wrote:

> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Modify to remove unnecessary 'return 0' code.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-mediatek: Remove unnecessary return code
      https://git.kernel.org/mkp/scsi/c/d29c32efebf3

-- 
Martin K. Petersen	Oracle Linux Engineering
