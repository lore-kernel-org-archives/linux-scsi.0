Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE8CEB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjFVB0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjFVB0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:26:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783B71BD3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 18:26:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKQH2D003650;
        Thu, 22 Jun 2023 01:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=RCb8GFDkuIjEOCvWMCOlclG3FhwaP3K6p+tI0omrUF8=;
 b=Ii4NdhAg+9Srz2jwYuxZvk2dfwenAZvnK6IMFC2HhS2YHqUponmsvq1wcsEvxDNhCauP
 AlRXDlKcoSfiTwchQHjN07ZR3u8EdRc8GvvjeBOnjH3Z7ZJ6kxAPAwBOieOM/z74RKWN
 qL3WdC4B1ut6VucdnL03egsFvitJdYBeME+dzqft10DwhYRHxxjDeQQ96HttxEKJDkAJ
 l9maI/md8QhbVjvkPaa9BB8E9O+TnqAYOg2rfGRow9wGqUw0z0a0N/hQUBDKrYEk6eHU
 vSWytYvixRH6yqrQNtToSD8Y6zgc5ce6nickrQfkfXicGzTteEi9K5FXwqAMreXvKjz1 Rg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r95cu0qyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35LN4K22038647;
        Thu, 22 Jun 2023 01:26:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396thy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXat038374;
        Thu, 22 Jun 2023 01:26:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-3;
        Thu, 22 Jun 2023 01:26:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
Date:   Wed, 21 Jun 2023 21:26:21 -0400
Message-Id: <168739587258.247655.15465348998050283623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
References: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=607 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-GUID: gS9SDOk26Nu_rvaUF0ZhYrsnB_xUa__c
X-Proofpoint-ORIG-GUID: gS9SDOk26Nu_rvaUF0ZhYrsnB_xUa__c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Jun 2023 05:31:45 -0700, Johannes Thumshirn wrote:

> Use PAGE_SECTORS_SHIFT instead of open-coding it.
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
      https://git.kernel.org/mkp/scsi/c/ce31dc540a01

-- 
Martin K. Petersen	Oracle Linux Engineering
