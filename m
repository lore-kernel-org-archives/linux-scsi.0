Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58A0CA0FF3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbjIEQFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354245AbjIEKTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 06:19:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C95518D
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 03:19:28 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853Nxn1007719;
        Tue, 5 Sep 2023 10:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Cpx7AJKafpZ66kRhp2gYo4d4upKVHPj0Ge3Ytotmm04=;
 b=Ea2xiiqoVPyr3ivEnYYO0voLtg1inSpsYqMUH4dZbvkZpULSa3ivqe1BFKFO8DWDbiH5
 d0im8WLq2Rdue563SpOQvN7cfodN12/XVw1exgItMTB2LowimmTjY1/wu9E2Y3vRtxga
 y94mr0W56ZpmVc9DIr9X07GeIEjMLqS1wmFaipjNlwW7HPJSHqwL8OoVwlLWdK8L9bO0
 +l5ZJo4AGGMl2YWCa4ebscgF777Xkws6xFpldC2YkRX9YzeDDGZdMOONaK58lx+HNQEO
 KcD6Nm/eoGxvEjDWoGLg2KKfmtUUduDAV9rlNwDlqHgW9eZDuzBqUZeb5TGAqGZ1n9ZS dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suw3cvx84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3859d34T029123;
        Tue, 5 Sep 2023 10:18:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug4j8d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:54 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 385AIlOd032271;
        Tue, 5 Sep 2023 10:18:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3suug4j85n-5;
        Tue, 05 Sep 2023 10:18:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        Nathan Chancellor <nathan@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        patches@lists.linux.dev, Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix unused variable warning in qla2xxx_process_purls_pkt()
Date:   Tue,  5 Sep 2023 06:18:28 -0400
Message-Id: <169390541189.1533355.3293116922945527160.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
References: <20230829-qla_nvme-fix-unused-fcport-v1-1-51c7560ecaee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_08,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=930 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050092
X-Proofpoint-GUID: yt4LHwr4CeeWxo0cPwTs9PPqQGx-AkzG
X-Proofpoint-ORIG-GUID: yt4LHwr4CeeWxo0cPwTs9PPqQGx-AkzG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Aug 2023 07:35:06 -0700, Nathan Chancellor wrote:

> When CONFIG_NVME_FC is not set, fcport is unused:
> 
>   drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2xxx_process_purls_pkt':
>   drivers/scsi/qla2xxx/qla_nvme.c:1183:20: warning: unused variable 'fcport' [-Wunused-variable]
>    1183 |         fc_port_t *fcport = uctx->fcport;
>         |                    ^~~~~~
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix unused variable warning in qla2xxx_process_purls_pkt()
      https://git.kernel.org/mkp/scsi/c/d4781807f050

-- 
Martin K. Petersen	Oracle Linux Engineering
