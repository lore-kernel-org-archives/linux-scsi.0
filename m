Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB32C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 03:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCJDJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 22:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCJDJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 22:09:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17566F6037
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 19:09:53 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwxVK005720;
        Fri, 10 Mar 2023 03:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=iZdm4kr4avXj4/9ESwlkMUMVImAKTkSueRMsChULI1c=;
 b=ZLwT6dG0Hv4DW0mq5XQNDtJ3gshu2eDS8eQp5GnLaExz6cqd80Mo/IYJlny7RVzNiQLu
 4PHJp4NnjWE6pjH/s1IT1sPb0+nxEJu9YOgIdD7c+moZPGmWGbMRUu2PJyRlIPxmn/jm
 0aZFvCzKJe0t+k2ztuMJ4oe6om0AWoDLlelDbfx0SC2mAugNhH1jlAdBNQjxkhg7T6tY
 9Ue3mlbP3KNdXS2YgAS/aKbon/3WP3ubmE5HoYUfJUUvcF+4atwi7R4PVntjSVCEN0IE
 NZHZok6SxgbqKIZwtQylvyA40itF6K0hGSLR7S/8l2mpLFHXS0+L+yZ5xbSg3XoEYpqM jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416247ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:09:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A2mnjc020871;
        Fri, 10 Mar 2023 03:09:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fuac8k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:09:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32A39kGK002714;
        Fri, 10 Mar 2023 03:09:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6fuac8k1-1;
        Fri, 10 Mar 2023 03:09:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Fix a procfs host directory removal regression
Date:   Thu,  9 Mar 2023 22:09:38 -0500
Message-Id: <167841768712.2362238.16631516353302844772.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230307214428.3703498-1-bvanassche@acm.org>
References: <20230307214428.3703498-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=910 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100022
X-Proofpoint-GUID: -sFVhtu0kxgsdfJktGyjZ43dgd26a9yG
X-Proofpoint-ORIG-GUID: -sFVhtu0kxgsdfJktGyjZ43dgd26a9yG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 07 Mar 2023 13:44:28 -0800, Bart Van Assche wrote:

> scsi_proc_hostdir_rm() decreases a reference counter and hence must
> only be called once per host that is removed. This change does not
> require a scsi_add_host_with_dma() change since scsi_add_host_with_dma()
> will return 0 (success) if scsi_proc_host_add() is called.
> 
> 

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: core: Fix a procfs host directory removal regression
      https://git.kernel.org/mkp/scsi/c/be03df3d4bfe

-- 
Martin K. Petersen	Oracle Linux Engineering
