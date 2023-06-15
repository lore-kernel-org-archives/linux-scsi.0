Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92965EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 02:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241619AbjFOCQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbjFOCQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 22:16:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C6F2688
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 19:16:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EKJ3Jp021119;
        Thu, 15 Jun 2023 02:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=gyiLvTrF88JwSLnz0QhVvz+Yk2+BZVgq7+2A2ugev0w=;
 b=q3mxeZXRuKFVccpUo5BMXx5nyQnwbJqVYkPw6PMRp1R9hYecvrJcwKV97NNKCZ/9GEyz
 tkfRoMi2NWR/ZN5Iyu+N78Ltj7+oxOq6iEWNbiEvvlIifD39vcslgZ5crOp2vDiBBzuZ
 lv4SMcp1I34xSDCl0ZQ9IMEFPwYEocgW7f9AxI+LBtBnxsm3I9JAMj+jAQbgD4RbRaSC
 OKH4vnSDAjaufQpZYMTdhxzPrfQ+c55NBb1OVCSfk/xAkDltt/ZfQE8oGfcdmE6b3Z8a
 p0U+ZC3StpgZfzKnaO7oqjS0JIikm07YDK3ANvHANCbNjRiA7MDbhnfgRTm7XMX/kBsJ gA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fkdrsq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:16:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35F1eG0Y016307;
        Thu, 15 Jun 2023 02:16:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6bny1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:16:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35F2EE7N027953;
        Thu, 15 Jun 2023 02:16:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r4fm6bnx8-5;
        Thu, 15 Jun 2023 02:16:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] scsi: hisi_sas: Convert to platform remove callback returning void
Date:   Wed, 14 Jun 2023 22:16:24 -0400
Message-Id: <168679535177.3778526.40812618653119585.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
References: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150017
X-Proofpoint-ORIG-GUID: XS_U0zL6cof38ND-Dut66CAd74L9p1bJ
X-Proofpoint-GUID: XS_U0zL6cof38ND-Dut66CAd74L9p1bJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 May 2023 22:20:43 +0200, Uwe Kleine-König wrote:

> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Convert to platform remove callback returning void
      https://git.kernel.org/mkp/scsi/c/8cd6d0a39452

-- 
Martin K. Petersen	Oracle Linux Engineering
