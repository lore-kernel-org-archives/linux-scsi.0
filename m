Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBECC25B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjJYCUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjJYCUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:20:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DEA9C
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 19:20:09 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUVYp015146;
        Wed, 25 Oct 2023 02:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=ZDR2MQqDyKfrhY9VnTo0ZcIe6B70l3UEfwI/PWn3uC0=;
 b=FbvOWyyioD05ajEo7pYZ+PyKmORJzSE7T50gSNQGHst23NJDVjw72eTuTNE3rjU5D6GI
 yuzjH4w8R+7FpeohBNVXiT9UTRNNzfAcuJZi/ARPOUWc251Fl/0akYx3QobB9AVk3MRr
 x/bZw4oUSUUTI/nnb6c2hQOrnsInjIgHdZVZKEo2KckSxsG/GXWzYSRI3slHgGG5nVDn
 mVuPzlWG6u3EnBkypeY0mJltdLf6clnzVechiMmT/47kHlKQTM2Z5AgdIBxgpV4VTYSd
 H3y0hE8VNfFeEvNSL26NY26z5rbgJFftQsi9hjNV66CfA/fUWSa6ySs5GahKF9vjSMnk 9Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv5jberms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:19:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39P0ixvZ015230;
        Wed, 25 Oct 2023 02:19:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv536219t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:19:51 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39P2JpFI000926;
        Wed, 25 Oct 2023 02:19:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv5362196-1;
        Wed, 25 Oct 2023 02:19:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH] scsi: depopulation and restoration in progress
Date:   Tue, 24 Oct 2023 22:19:43 -0400
Message-Id: <169819964291.2667926.15035236582239451241.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231015050650.131145-1-dgilbert@interlog.com>
References: <20231015050650.131145-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=964
 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250018
X-Proofpoint-GUID: Zg8GmjoTomyylMe_3fsuOFWtQmGItZT7
X-Proofpoint-ORIG-GUID: Zg8GmjoTomyylMe_3fsuOFWtQmGItZT7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 15 Oct 2023 01:06:50 -0400, Douglas Gilbert wrote:

> The default handling of the NOT READY sense key is to wait
> for the device to become ready. The "wait" is assumed to
> be relatively short. However there is a sub-class of NOT
> READY that have the "... in progress" phrase in their
> additional sense code and these can take much longer.
> Following on from commit 505aa4b6a8834 we now have element
> depopulation and restoration that can take a long time.
> For example, over 24 hours for a 20 TB, 7200 rpm hard
> disk to depopulate 1 of its 20 elements.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/1] scsi: depopulation and restoration in progress
      https://git.kernel.org/mkp/scsi/c/2bbeb8d12404

-- 
Martin K. Petersen	Oracle Linux Engineering
