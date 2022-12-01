Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC51C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLADrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLADqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5649FED6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:08 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B12cw7h018211;
        Thu, 1 Dec 2022 03:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=BW7noQPOnqYOgVDIRyO6nwBVr+117FyJcgW3HHmoPdc=;
 b=pvRTZNjgMDiSl/rxFnXXG3jfr7wrNEf+yQhpmmBhY1Kavjet5OkX+CVXLaA1g3tYcglR
 W2F3HfDFCewLie5MlrV6W4GXBb5dnv5DVqBU6jVKjPdn5OsrYEAP9sjihTf0FGx58BcH
 UIb3a3f0hdcWz3x5ipfawq+HskwzaZvsRoZ+V2aPoVRBy0CUO3h60SefhNc/GYoT7b4r
 UvffFG1egvrzN0GDXYGcdDbZ6TySL/H+48RV3bWTKH045KDSfZ+OAZdFQTnnQtAlgBGa
 Pj/sP3kp4alt+4xhgOuaZIvne8FwBghqM1d0i4kV85NAkXHS3WO0AZ9Q9pqfDDX4l4c5 FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12Of5s007679;
        Thu, 1 Dec 2022 03:46:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbq8033801;
        Thu, 1 Dec 2022 03:46:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-24;
        Thu, 01 Dec 2022 03:46:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hare@suse.de,
        jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: fcoe: fix possible name leak when device_register() fails
Date:   Thu,  1 Dec 2022 03:45:25 +0000
Message-Id: <166986602284.2101055.7879946819043519342.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112094310.3633291-1-yangyingliang@huawei.com>
References: <20221112094310.3633291-1-yangyingliang@huawei.com>
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
X-Proofpoint-GUID: V43f7z3aayTGouomeuCWzuWevc8RcRrm
X-Proofpoint-ORIG-GUID: V43f7z3aayTGouomeuCWzuWevc8RcRrm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Nov 2022 17:43:10 +0800, Yang Yingliang wrote:

> If device_register() returns error, the name allocated by
> dev_set_name() need be freed. As comment of device_register()
> says, it should use put_device() to give up the reference in
> the error path. So fix this by calling put_device(), then the
> name can be freed in kobject_cleanup().
> 
> The 'fcf' is freed in fcoe_fcf_device_release(), so the kfree()
> in the error path can be removed.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: fcoe: fix possible name leak when device_register() fails
      https://git.kernel.org/mkp/scsi/c/47b6a122c7b6

-- 
Martin K. Petersen	Oracle Linux Engineering
