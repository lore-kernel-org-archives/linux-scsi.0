Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21832C83F2C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbjIEQFz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354243AbjIEKTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 06:19:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8210199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 03:18:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853P0vd024452;
        Tue, 5 Sep 2023 10:18:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=zOuHFfCIYixnxntRS2JZDcT6FL5JTUI9hIbbLOODDxA=;
 b=pMlvx4rJhpOATtTBTiWzsp4r8PaBv8bC9SgYHNPlkrPD8XZLme6ZBAZJ/p9jSLtj71z2
 WqFPT111OupXwiZljZYVgqxRhspiMJtgs6qBcLRRgOhPDkNDidgtwGVT89OIem6C3xmP
 ZJVDfV4/PYANVAnIEGG0PLkl09EPHkHEiOO8/MD2eZxzGJSrrCl1gaJcBlZeRpHycVpw
 pv2t2tF9ajitUQqDH0sZpESdsxO3PhESQUllQuFO/cPUt0jceOSZGj09rKeGiBsG0RH9
 jqQq0OIdpnQZrv4qBqKUtsIjw6F+jLattcJa0Wnfc9tQ0b7QIWAII9XpHMENkHlNfT6U 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suvntvvv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3859tHpN029112;
        Tue, 5 Sep 2023 10:18:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug4j8dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 10:18:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 385AIlOf032271;
        Tue, 5 Sep 2023 10:18:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3suug4j85n-6;
        Tue, 05 Sep 2023 10:18:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH v4 0/2] mpt3sas: Additional retries when reading specific registers
Date:   Tue,  5 Sep 2023 06:18:29 -0400
Message-Id: <169390541195.1533355.9679857953761981922.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
References: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_08,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=988 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050092
X-Proofpoint-ORIG-GUID: -55CSf-2eUh9WtwokKj_H6h0mPp0gf5l
X-Proofpoint-GUID: -55CSf-2eUh9WtwokKj_H6h0mPp0gf5l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Aug 2023 14:30:18 +0530, Ranjan Kumar wrote:

> Doorbell and Host diagnostic registers could return 0 even
> after 3 retries and that leads to occasional resets of the
> controllers, hence increased the retry count to thirty.
> 
> v1->v2:
> -added a new patch for volatile as suggested by Greg KH.
> -renamed macro as suggested by Damien Le Moal.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] mpt3sas: Perform additional retries if Doorbell read returns 0
      https://git.kernel.org/mkp/scsi/c/4ca10f3e3174
[2/2] mpt3sas: Removing volatile qualifier
      https://git.kernel.org/mkp/scsi/c/0854065092a7

-- 
Martin K. Petersen	Oracle Linux Engineering
