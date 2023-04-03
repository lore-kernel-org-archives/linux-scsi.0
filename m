Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87445C77B6D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 02:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjDCCPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 22:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDCCP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 22:15:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9B2B759;
        Sun,  2 Apr 2023 19:15:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332NIsYP013713;
        Mon, 3 Apr 2023 02:15:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=0yNubPRuMqD+8gBbGvGzJQPNv0waNQ/X8IEoEAFJyr8=;
 b=KYKpxZSVowe0leqS8jvX309t6jlxz5FekqlENzHPZmWGS3UolKkVaGN7DvwpK0Qth52A
 yMjl5cOGls4SWnXn/dxO70tOzhFxdwX+uPn5ZhjCeBJpwvyOraeHpdtwoVH0jLiuws9a
 kfm1430zHpT5+0JKMrhKTlbJa7P6may6GiywNAcSL2rJw+9EM+yXOwZZv/G5ARw/boK0
 JUb83LSuxELM+xKx4xReb53xzhoNxY6XiQ+pSTF2qIw+gIS0pUmiD5PSBHigGPFkLyPe
 FttYlGUt/PPdcSWGgv56prfbFsf4EgzvusU00ztWnC4+WUwL9ZGHqWEDDal35Gz2i9MY dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcgaj015-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:15:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332LJ9Yv013861;
        Mon, 3 Apr 2023 02:15:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3ddbqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:15:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3332FHwp010318;
        Mon, 3 Apr 2023 02:15:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ppt3ddbn7-6;
        Mon, 03 Apr 2023 02:15:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mlombard@redhat.com, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 0/9] target: TMF and recovery fixes
Date:   Sun,  2 Apr 2023 22:15:07 -0400
Message-Id: <168031383545.650124.7638093494713184488.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030015
X-Proofpoint-GUID: aUvWcmrRWVk4Qufmdq0Q5Bo0HrZGr0Bk
X-Proofpoint-ORIG-GUID: aUvWcmrRWVk4Qufmdq0Q5Bo0HrZGr0Bk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Mar 2023 20:56:11 -0500, Mike Christie wrote:

> The following patches apply over Martin's 6.4 branches and Linus's tree.
> They fix a couple regressions in iscsit that occur when there are TMRs
> executing and a connection is closed. It also includes Dimitry's fixes in
> related code paths for cmd cleanup when ERL2 is used and the write pending
> hang during conn cleanup.
> 
> This version of the patchset brings it back to just regressions and fixes
> for bugs we have a lot of users hitting. I'm going to fix isert and get it
> hooked into iscsit properly in a second patchset, because this one was
> getting so large. I've also moved my cleanup type of patches for a 3rd
> patchset.
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/9] scsi: target: Move sess cmd counter to new struct
      https://git.kernel.org/mkp/scsi/c/becd9be6069e
[2/9] scsi: target: Move cmd counter allocation
      https://git.kernel.org/mkp/scsi/c/4edba7e4a8f3
[3/9] scsi: target: Pass in cmd counter to use during cmd setup
      https://git.kernel.org/mkp/scsi/c/8e288be8606a
[4/9] scsi: target: iscsit/isert: Alloc per conn cmd counter
      https://git.kernel.org/mkp/scsi/c/6d256bee602b
[5/9] scsi: target: iscsit: stop/wait on cmds during conn close
      https://git.kernel.org/mkp/scsi/c/395cee83d02d
[6/9] scsi: target: iscsit: free cmds before session free
      https://git.kernel.org/mkp/scsi/c/d8990b5a4d06
[7/9] scsi: target: Fix multiple LUN_RESET handling
      https://git.kernel.org/mkp/scsi/c/673db054d7a2
[8/9] scsi: target: iscsit: Fix TAS handling during conn cleanup
      https://git.kernel.org/mkp/scsi/c/cc79da306ebb
[9/9] scsi: target: iscsi: handle abort for WRITE_PENDING cmds
      https://git.kernel.org/mkp/scsi/c/ea87981a0ee8

-- 
Martin K. Petersen	Oracle Linux Engineering
