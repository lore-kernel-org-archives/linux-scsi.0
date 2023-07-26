Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1547C41513
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 02:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjGZCGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 22:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjGZCGD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 22:06:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D4626B7
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 19:06:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PJIv4l019208;
        Wed, 26 Jul 2023 02:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=U13j6YtPx5DscvacaaOT1/IweLbSne0jJhniNCWwZ8g=;
 b=sqSWdrWRv9xkqAtAgyPk0prrnYqwKGVokdihk0/KrNle7mA8wnaakF+xxZoNq0B6CQO+
 l/kv3GSdVZiea2Z5nDFHwNKrRm3CBe5enKh0Php7ZzTBklOMLHgGIR7uFsBxRWkyB9dC
 2TupVBnqBpCxinnzDwicJbEsMU5cMz4avfsJT9dUtFWy8K7U3u2rjB9CypDTPpM4NDOt
 /l3RkitZXlmQ4RRWM17rQrLGZqKOWuoD8rosNPglmSEE0XULzp6fZ7TmawVBLZe3RPn2
 tucMBf3c1q1Dqj1lp5m1+PnZPDwhR0W41m+qSbMblAzPE21Vgq3dVBU8IbgEcKSKlqjs vA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070axdme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q0Rk8S023169;
        Wed, 26 Jul 2023 02:05:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j5jd09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 02:05:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q253NV038905;
        Wed, 26 Jul 2023 02:05:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s05j5jcwf-3;
        Wed, 26 Jul 2023 02:05:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2] scsi: ufs: Remove HPB support
Date:   Tue, 25 Jul 2023 22:04:48 -0400
Message-Id: <169033702318.2256288.8859146449679400468.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719165758.2787573-1-bvanassche@acm.org>
References: <20230719165758.2787573-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_14,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=975
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260016
X-Proofpoint-GUID: 9F7hmNbRAWQ6oBrDb2rE7nYQbxQgBLkq
X-Proofpoint-ORIG-GUID: 9F7hmNbRAWQ6oBrDb2rE7nYQbxQgBLkq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 Jul 2023 09:55:41 -0700, Bart Van Assche wrote:

> Interest among UFS users in HPB has reduced significantly. I am not
> aware of any current users of the HPB functionality. Hence remove HPB
> support from the kernel.
> 
> A note: the work in JEDEC on a successor for HPB is nearing completion.
> Zoned storage for UFS or ZUFS combines the UFS standard with ZBC-2.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: ufs: Remove HPB support
      https://git.kernel.org/mkp/scsi/c/7e9609d2daea

-- 
Martin K. Petersen	Oracle Linux Engineering
