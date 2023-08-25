Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0996DC727A0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbjHYBOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbjHYBNu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF641BF1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:48 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEVqD022022;
        Fri, 25 Aug 2023 01:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=DeZdOPYmhZH4UF2plKjQnlsNJHGTI0zOMYdwWCerHyo=;
 b=dviJlM1cQ3kMIatN4V8SVYFsOCaq8SmrSpYA15RalTNUX3UZyTTMGY9dfOMQ1A634pO6
 0xGb0YyAbiu86rLp+P2SX/5YxQzktkPMK0U8dUQ2Wx4lVg2qJyVkptWRI62h0zPAc5Av
 106W+HI/NLQVVcO3KaBoOAl0ia8OM6zC/6sdTOfIWdrKxqKiYKchPBf001TlfjIqBBto
 0TdXr2sXpvJgmeEYmdKZ5S/PZiwt02/ysC2pNv/ndmdkSNUmJ2C78Q8YcHSkNEuyaz7w
 NO7BOYZMNnEyGjVnRAc4QP94XDKAXph/CTsLwdX0U14jGcg05ew66wCsvuM0ighIp9fX Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yu5htr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37ONtSVs036111;
        Fri, 25 Aug 2023 01:13:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:40 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEI019787;
        Fri, 25 Aug 2023 01:13:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-13;
        Fri, 25 Aug 2023 01:13:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Xiang Yang <xiangyang3@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: arcmsr: Add __init and __exit for arcmsr_module_{init,exit}
Date:   Thu, 24 Aug 2023 21:12:59 -0400
Message-Id: <169292577125.789945.16016677536430672572.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230804022913.1917023-1-xiangyang3@huawei.com>
References: <20230804022913.1917023-1-xiangyang3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=813 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-GUID: KShgTCJh-emPnnGYGiCEDXG30w6kUXDB
X-Proofpoint-ORIG-GUID: KShgTCJh-emPnnGYGiCEDXG30w6kUXDB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 04 Aug 2023 10:29:13 +0800, Xiang Yang wrote:

> Add __init and __exit for arcmsr_module_{init,exit}
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: arcmsr: Add __init and __exit for arcmsr_module_{init,exit}
      https://git.kernel.org/mkp/scsi/c/e9b525b6ccbf

-- 
Martin K. Petersen	Oracle Linux Engineering
