Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968A9C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 02:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjHHCo6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjHHCoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 22:44:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0E61BC5;
        Mon,  7 Aug 2023 19:44:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3781iJ5M022421;
        Tue, 8 Aug 2023 02:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=chjmSLkGKsr7AS8UI/OE3uRsupMa4cpKaiHSR5qXeSc=;
 b=YzwuVwDm2kgI9mK4U2B/CnhKViQl8SeUTKkGBU5wlNEURfHMeFwrGrN+jUhLo9YhP/Hr
 Zl0MdtByF5QatC+6QYrh3HB1wkHhTMDZXFrB1t89bkBZu4/tEPjs9riIOwFKyUj/vzDZ
 MyyzSoTh1BazO4f2cLHTpOAHVDfZCLxDSax7GUNZeQ4xgEEejNUypTIJI9ySupuFNxs5
 bILn4+9DP1sBPdl2mI6QPJgniLWpYIfWEBXDckH4UuAJtQTbWs6jvdRiHkxln8isTe42
 DcsxvgM24l4pH3Xu6FaBlZeKTYTAtQlj2RduEIzhdhGROhiAUnY4lAk5OosaoosDo+FT aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9eaam3yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3782Apfn027958;
        Tue, 8 Aug 2023 02:43:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cv55wgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 02:43:37 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3782hYGv038171;
        Tue, 8 Aug 2023 02:43:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3s9cv55wfu-7;
        Tue, 08 Aug 2023 02:43:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] ufs: host: renesas: Fix private allocation
Date:   Mon,  7 Aug 2023 22:43:28 -0400
Message-Id: <169146257047.4040705.18148430080065409999.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230803081812.1446282-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230803081812.1446282-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308080022
X-Proofpoint-ORIG-GUID: UW7-8m5uC5qXi8tmZX97eVFejYXA4O5y
X-Proofpoint-GUID: UW7-8m5uC5qXi8tmZX97eVFejYXA4O5y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 03 Aug 2023 17:18:12 +0900, Yoshihiro Shimoda wrote:

> Should use devm_kzalloc() for struct ufs_renesas_priv because
> the .initialized should be false as default.
> 
> 

Applied to 6.5/scsi-fixes, thanks!

[1/1] ufs: host: renesas: Fix private allocation
      https://git.kernel.org/mkp/scsi/c/b6d128f89a85

-- 
Martin K. Petersen	Oracle Linux Engineering
