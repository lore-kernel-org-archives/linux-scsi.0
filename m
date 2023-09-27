Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF46E82CC9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjI0TfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjI0Te6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:34:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802301B7
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 12:34:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIwvG5002843;
        Wed, 27 Sep 2023 19:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=b8sjo2X0ZXIo02ZiEiCu2kftRDzD1AAKlVUpdZlO1Zo=;
 b=dDgky/8WkDCVPHzP7N3XOz8g7rTrP81UrJdQ8GODSW5AzlXRNOt9v4/tgc7In4/hNVzr
 MIPN1UX20YA/9ns0KbYtFVHbZKbriSPkXxO7mUtGfsARs4H7Q8a5fMl8p6O1JeYhew2s
 1kkWaYWp06SgW2ENh+S+rZzKZxIKuBfIE/mVn4YAHWEN6fIG2yg7tsgOd/qcIS3T9FgQ
 rfbyAtJKu4VMPxaZlMptzw59sN3BjtiYBCudzZ/kggQm3ICpagYV0GO7JW/o7akzNQtV
 8s+BLMW0brABPywR6kifLNe5gscg0sAn0RVd/7hUsxl618lGgzSQyemLrQCKl16nUpfB kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pt3tgct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:34 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIHELE030561;
        Wed, 27 Sep 2023 19:34:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf8cv59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:34:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38RJYTlv010018;
        Wed, 27 Sep 2023 19:34:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t9pf8cuyr-4;
        Wed, 27 Sep 2023 19:34:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] scsi: ufs: Convert all platform drivers to return void
Date:   Wed, 27 Sep 2023 15:34:25 -0400
Message-Id: <169582723793.1126739.13243881654096292517.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
References: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=972 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270166
X-Proofpoint-ORIG-GUID: JHll8-e3aQo-7xI2kprDW3UlsKFmeTLn
X-Proofpoint-GUID: JHll8-e3aQo-7xI2kprDW3UlsKFmeTLn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 17 Sep 2023 16:57:22 +0200, Uwe Kleine-König wrote:

> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new() which already returns void. Eventually after all drivers
> are converted, .remove_new() is renamed to .remove().
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/1] scsi: ufs: Convert all platform drivers to return void
      https://git.kernel.org/mkp/scsi/c/0842b7617e34

-- 
Martin K. Petersen	Oracle Linux Engineering
