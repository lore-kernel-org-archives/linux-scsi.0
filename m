Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB70C38A2D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 02:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiJ0C6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiJ0C6l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 22:58:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A20D8EEB
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 19:58:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM20DS014710;
        Thu, 27 Oct 2022 02:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=BiOz+DthjpMAuPk63qUNvw7e/6aknYYEU4x8+qKnq4o=;
 b=1GPxIz8pDpgjfI+ObXx54dJD5qxv+0/CWRl/Y3h6myrtc1GCu78+zBKgFVYtUMFhRHAz
 L9ZsoUhciWS8frxXX8s6CJv/s0lDrb5w1DZgD24rq1uku4uab4Bp3gwOraz291rvhvri
 KPoNFqrDzP1nA76/KOUAKQVJYZPZ9pcgoHap6KPYxXML16FGHHxjBksR2Un6OQOH95hn
 aylV1rVGTip9WXrIpF+6WDijlv2kAY5k70cI7NZmnJoL8SsSiZ4GoguPvgtd2QuTiweO
 Ucc+bKk7nKGuKnZbW32E8bfBVNH9evYliv3q9F+xPzgWWoBKrBHgyTvmYBA20CzlYIwJ mA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0t40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM21Rk006723;
        Thu, 27 Oct 2022 02:58:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggh3g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29R2wWsZ007945;
        Thu, 27 Oct 2022 02:58:34 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kfaggh3fk-2;
        Thu, 27 Oct 2022 02:58:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jolly Shah <jollys@google.com>,
        Andrew Konecki <awkonecki@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Remove unused reset_in_progress flag logic
Date:   Wed, 26 Oct 2022 22:58:27 -0400
Message-Id: <166683942541.3791741.6596091900111111737.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221007230751.309363-1-ipylypiv@google.com>
References: <20221007230751.309363-1-ipylypiv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270015
X-Proofpoint-ORIG-GUID: xNL4PtsnZfxd9vY2iJfLDAYn0zHRSdaZ
X-Proofpoint-GUID: xNL4PtsnZfxd9vY2iJfLDAYn0zHRSdaZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 7 Oct 2022 16:07:51 -0700, Igor Pylypiv wrote:

> The reset_in_progress flag was never set.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: pm80xx: Remove unused reset_in_progress flag logic
      https://git.kernel.org/mkp/scsi/c/5f62639dc2b6

-- 
Martin K. Petersen	Oracle Linux Engineering
