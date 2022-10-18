Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDD7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 03:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJRDwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJRDwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 23:52:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB3F1D2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 20:52:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HNYfeK019088;
        Tue, 18 Oct 2022 03:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=P081kBpIhz1iYs37V3YqKs6facfzNA7osDtalRqbHRE=;
 b=ZMwxdJe2zVGUmPE7nYx4BhITJ8XdgQjUrVdkkBoGgMhyeg+F/unVtOwtmd/iPxFeJZUs
 PYYU/oJyWtwUuKOkeVSR3JTpuSwHu0Bk2rwRyzOesI2dtFDsuhT/LUsJyvo8QpSWD/Ss
 kivlTnbis03xhTcJ3RxyRA0fMy9p4mJNVB8pMmyZj4eTBOJgus8vPMmABWNE4z9izzUn
 azNXnvGgksLpX9UwhtAs3CEhyJ8HDGUvvU42RUOtGejf02tKOBi1s6h694Tf2fCqqQnx
 zI0twLWIlrjZ7sP+UJUoqA1fmXqYt31GT01pqYbkd8Py/1KSOhPV+yFOHrw62BSMXtl0 5Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndtds2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:52:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29I0Jh9N036443;
        Tue, 18 Oct 2022 03:52:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htff2ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:52:09 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29I3q8fe029581;
        Tue, 18 Oct 2022 03:52:08 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3k8htff2b0-2;
        Tue, 18 Oct 2022 03:52:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] restrict legal sdev_state transitions via sysfs
Date:   Mon, 17 Oct 2022 23:52:07 -0400
Message-Id: <166606442642.2366633.1466217934304768342.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220924000241.2967323-1-ushankar@purestorage.com>
References: <20220924000241.2967323-1-ushankar@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=777 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180020
X-Proofpoint-ORIG-GUID: QkL20Qt9Fg3KSfJZpKDGr2KojN_FsAsy
X-Proofpoint-GUID: QkL20Qt9Fg3KSfJZpKDGr2KojN_FsAsy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 23 Sep 2022 18:02:42 -0600, Uday Shankar wrote:

> Userspace can currently write to sysfs to transition sdev_state to
> RUNNING or OFFLINE from any source state. This causes issues because
> proper transitioning out of some states involves steps besides just
> changing sdev_state, so allowing userspace to change sdev_state
> regardless of the source state can result in inconsistencies; e.g. with
> iscsi we can end up with sdev_state == SDEV_RUNNING while the device
> queue is quiesced. Any task attempting IO on the device will then hang,
> and in more recent kernels, iscsid will hang as well. More detail about
> this bug is provided in my first attempt:
> https://groups.google.com/g/open-iscsi/c/PNKca4HgPDs/m/CXaDkntOAQAJ
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] restrict legal sdev_state transitions via sysfs
      https://git.kernel.org/mkp/scsi/c/2331ce6126be

-- 
Martin K. Petersen	Oracle Linux Engineering
