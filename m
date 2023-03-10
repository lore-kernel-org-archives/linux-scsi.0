Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0543C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 03:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCJDOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 22:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCJDOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 22:14:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCF3EB8BD;
        Thu,  9 Mar 2023 19:14:34 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LxaQp014176;
        Fri, 10 Mar 2023 03:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=FX/OQ7bCPx/NE6dsPjssCghj0birepQYqDNycPOlQwk=;
 b=D+L+GQh9QlFamuM6G5kiwbYiU5AKrxUHMedcTuLvQbVcNRoI95FTDHVUPliBlfUZTcJL
 0wFephJMdDdbsyqbWkba3BZbu4wDAZhX4+83kSgssxz5sriitxKMK75RUZZb5QSwfCZE
 /8WbhEklmgKHTyDQUGshtmD8BIVtYVJRU327A87OHZ/9yg15aJSWbeIOyT9VDtnzdSo4
 rhrnF6n+bd6F+PKnV0JNRRhplXpc5osUd7i9FsK1K8fjygeOHgbdbEZSMVlVXSp/BnaU
 wAuERY/XRMvn36yUfAmxD/d/Gbq+pmTOQp2MXFKU0gH3xkALh3dLvFNAwe/oaFlbY6i6 qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418y4d91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:14:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A2r05e026547;
        Fri, 10 Mar 2023 03:14:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9w39js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 03:14:29 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32A3ETDE023573;
        Fri, 10 Mar 2023 03:14:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p6g9w39jg-1;
        Fri, 10 Mar 2023 03:14:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     ketan.mukadam@broadcom.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] scsi: be2iscsi: Remove the unused variable internal_page_offset
Date:   Thu,  9 Mar 2023 22:14:21 -0500
Message-Id: <167841804065.2362455.17917613722897465256.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209035224.90327-1-jiapeng.chong@linux.alibaba.com>
References: <20230209035224.90327-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=884
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100023
X-Proofpoint-GUID: iLe4qhbIyMeuVPm957wv7ZdV64LdQWMK
X-Proofpoint-ORIG-GUID: iLe4qhbIyMeuVPm957wv7ZdV64LdQWMK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 09 Feb 2023 11:52:24 +0800, Jiapeng Chong wrote:

> Variable internal_page_offset is not effectively used, so delete it.
> 
> drivers/scsi/be2iscsi/be_cmds.c:1176:6: warning: variable 'internal_page_offset' set but not used.
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: be2iscsi: Remove the unused variable internal_page_offset
      https://git.kernel.org/mkp/scsi/c/d0b50c64def4

-- 
Martin K. Petersen	Oracle Linux Engineering
