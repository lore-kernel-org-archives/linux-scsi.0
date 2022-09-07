Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CE9ECAAD5
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 02:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiIGCPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 22:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiIGCPi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 22:15:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C048B998
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 19:15:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286LdCnu002465;
        Wed, 7 Sep 2022 02:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2022-7-12;
 bh=WJJhFLOsdUK+ZpdzBFdwqTDAJJ2WEb3j+Gqnx25Y3w8=;
 b=IKAE/RgBoJAruZ+qQZN4etlh0E/mi32rtPC/cRjEAeSTZImS93jlMkf1nZo2WCqz5vKU
 vMs8dzq6dTXWtsfsKwXogadKSGpImUEGz247K315zlyeogOQstHRQHRGZiau2WDLBac0
 oSzhFd/Sd5ooJQ0EiiqrqehZHCn3XFBzgRHgCPoHOjzW1L0HU30udZMUABX4YTI3/Xwq
 Uo/Wue4dkwMmZn4rAsrbCVLqKLXTwZbGrLK6MDJDeO8pZaw3Hz5uvxrJ1QdmUU4ft7UW
 EANxi2f7irTT/S6W5mKBCvYvBeKFNE8zhicBO9NOgrDq4sH4hgi/VqAqOBz2EGF6wB4I Kg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbxtafe7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 02:15:02 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 286MXdm7037484;
        Wed, 7 Sep 2022 02:15:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc3eb46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 02:15:01 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2872AUpF000952;
        Wed, 7 Sep 2022 02:15:01 GMT
Received: from ca-mkp.ca.oracle.com (dhcp-10-39-192-227.vpn.oracle.com [10.39.192.227])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3jbwc3eb38-1;
        Wed, 07 Sep 2022 02:15:01 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v2 00/10] scsi: Fix internal host code use
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czc8gcc1.fsf@ca-mkp.ca.oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Date:   Tue, 06 Sep 2022 22:14:59 -0400
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 11 Aug 2022 20:00:17 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_11,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070008
X-Proofpoint-ORIG-GUID: PN9px4KDQssJQTrA5lEER7p7hGJUSg-D
X-Proofpoint-GUID: PN9px4KDQssJQTrA5lEER7p7hGJUSg-D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches made over Martin's 5.20 staging branch fix an
> issue where we intended the host codes:

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
