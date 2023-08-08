Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30200EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjHHCoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjHHCoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:44:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D961BE5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 19:43:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781jRh0011326;
        Tue, 8 Aug 2023 02:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=GjyOfZ8nVGrW54+DM9VVvM4zjQCQsMGNsNjrS0EWdZo=;
 b=GmdzFVQMrbLltv+oHIUEziIst4NJKKwlo/cDgnSF0GBoUhZVogtHO8m5WH+mJqO7Gh7N
 7KNwIbmcU6Uezx/VqIQm14qGStQiEaKIPYKnsZJVfO8i/byHxv1OGkyDStGaSuXJlwVF
 6vY3WKZDrMTG7A1Tuh63Sj9aipmxbvHvmBD0b6vdY2hfBz+SGOLZm5duEuXb6v4d25P+
 xppN7Ctb/rQNVyCSDwuN+PqLqi75eW70a9Hm71bElpf0RO5m13M1CTJ/KYCHIB/Y8sC9
 mg6d1+hiZjZfDFX8yNDZ5IYvRSH7e3XzEYRjcAMoKiY//xPzZeb2w7i82JGe0rlXqIpK ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eyuc437-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37823WRh027686;
        Tue, 8 Aug 2023 02:43:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv55wgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782hYGr038171;
        Tue, 8 Aug 2023 02:43:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv55wfu-5;
        Tue, 08 Aug 2023 02:43:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        nmusini@cisco.com, hare@suse.de, JBottomley@Odin.com,
        linux-scsi@vger.kernel.org, Zhu Wang <wangzhu9@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: snic: fix possible memory leak while device_add() fails
Date:   Mon,  7 Aug 2023 22:43:26 -0400
Message-Id: <169146257044.4040705.454027004174288780.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230801111421.63651-1-wangzhu9@huawei.com>
References: <20230801111421.63651-1-wangzhu9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=994 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080022
X-Proofpoint-GUID: MuRNXRLqtFH5K1vN41fxawHu04eTa1nq
X-Proofpoint-ORIG-GUID: MuRNXRLqtFH5K1vN41fxawHu04eTa1nq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 01 Aug 2023 19:14:21 +0800, Zhu Wang wrote:

> If device_add() returns error, the name allocated by dev_set_name() need
> be freed. As comment of device_add() says, it should use put_device() to
> give up the reference in the error path. So fix this by calling
> put_device, then the name can be freed in kobject_cleanp().
> 
> 

Applied to 6.5/scsi-fixes, thanks!

[1/1] scsi: snic: fix possible memory leak while device_add() fails
      https://git.kernel.org/mkp/scsi/c/41320b18a0e0

-- 
Martin K. Petersen	Oracle Linux Engineering
