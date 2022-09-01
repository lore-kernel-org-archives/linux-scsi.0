Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD64FECAAD8
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiIAFNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiIAFND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:13:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776AB122BF8
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:13:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmut8032272;
        Thu, 1 Sep 2022 05:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=/+gFyLX0x8tiAQvUSRGkIqvW3HF7yJxn/A/apZSJzt0=;
 b=QNxjSlSYJSjxUIzQ70T9GBoCt6U+Jxpwv7vomXVC5ZTXCeMoNJksRLfRmcRmJLzEdyXj
 ffVUfQhajs6aQF3gFRDOllXEc7VFYo7C2tQejIyOjhzogwQ7Eqgr9GqWwkLqHXYeGuzy
 vsZ4xZYphoywP/3uNagWZcsHCwvG+DTCpDDBIB4UVVoqkcx3Fa8an+r6faQ9Xn9znijE
 pkhflB2pzxchN9t6oo35SSOPndNv7wZ35kL1fOVovxAzxKzXDwu0AkRfCu01BrJSVcRH
 AerhC23RSQ49gHjJ5k0IjsIwSmH4xqrrhnhWEOBazxMVPDXvgILlo4CvKgS1Yxx4gb+h GQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b5a2tev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813SFLV033738;
        Thu, 1 Sep 2022 05:12:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr3g0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:54 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CsXF008754;
        Thu, 1 Sep 2022 05:12:54 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ja6gr3g0k-1;
        Thu, 01 Sep 2022 05:12:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Bradley Grove <bradley.grove@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Bradley Grove <bgrove@attotech.com>,
        Rob Crispo <rcrispo@attotech.com>
Subject: Re: [PATCH v2 1/2] scsi: mpt3sas: Add support for ATTO ExpressSAS H12xx GT devices
Date:   Thu,  1 Sep 2022 01:12:45 -0400
Message-Id: <166200877445.26143.5885033335077803469.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220805174609.14830-1-bgrove@attotech.com>
References: <20220805174609.14830-1-bgrove@attotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=918 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010022
X-Proofpoint-ORIG-GUID: RVybhyI5NvQjOvvH5Vd_I7une99NfiYd
X-Proofpoint-GUID: RVybhyI5NvQjOvvH5Vd_I7une99NfiYd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Aug 2022 13:46:08 -0400, Bradley Grove wrote:

> Adds ATTO's PCI IDs and modifies the driver to handle the unique NVRAM
> structure used by ATTO's devices.
> 
> 

Applied to 6.1/scsi-queue, thanks!

[1/2] scsi: mpt3sas: Add support for ATTO ExpressSAS H12xx GT devices
      https://git.kernel.org/mkp/scsi/c/91cf186aa1bf
[2/2] scsi: mpt3sas: Disable MPI2_FUNCTION_FW_DOWNLOAD for ATTO devices
      https://git.kernel.org/mkp/scsi/c/f45fadde91ec

-- 
Martin K. Petersen	Oracle Linux Engineering
