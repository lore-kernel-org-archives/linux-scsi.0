Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5821FC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 15:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjJ3PfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbjJ3PfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 11:35:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27401C9;
        Mon, 30 Oct 2023 08:35:03 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDQxP8020924;
        Mon, 30 Oct 2023 15:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=p787g9tCtGSYmhsx7EBnWI6VNOjz8tsSi4KPDBurUYc=;
 b=vD2DERB+ZuAJcfxe4r6JyGgWnKA40uRy3SQMcN2AlNU8O6xhYDJPRRO2VsO2UBsEkWeh
 9DZFnZB1QpyhUUhlMqbUlyNFtyOduEZwYqrM4MnkXxcnpifckL/0+jf0bs64KO7aYTsb
 zwCG+Uo9+Ofbf6zbNZmxvfUB63dVezvBc+vVIaIdQkfw0m3qC1uuTSYN1uLs1NPqTdhm
 JgJrsWX9J8YT1mcwCXSVDshvPWsAqGSEt/XO8ZMWYUMBvj6DJf035r9XZI5IOpPkou6p
 QEj0aXOuPMu9r6MOGkDaUzxjXjLWKBpQxIPbgttF+CsAhgjqzxhD+EsFzqWIF7Kcq4A8 aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0swtk33x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39UE42NQ038141;
        Mon, 30 Oct 2023 15:35:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rran8xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFVkmK023458;
        Mon, 30 Oct 2023 15:35:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3u0rran8wc-6;
        Mon, 30 Oct 2023 15:35:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: Improvised loop logic
Date:   Mon, 30 Oct 2023 11:34:50 -0400
Message-Id: <169868005494.2933713.2562282002343167126.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231020105849.6350-1-ranjan.kumar@broadcom.com>
References: <20231020105849.6350-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=676 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310300120
X-Proofpoint-ORIG-GUID: 19b4gbMtiTev9tUJcwKV82n93DKcyZg6
X-Proofpoint-GUID: 19b4gbMtiTev9tUJcwKV82n93DKcyZg6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Oct 2023 16:28:49 +0530, Ranjan Kumar wrote:

> The loop continues to iterate until the count reaches 30,
> even after receiving the correct value.That is fixed by
> breaking when non-zero value is read.
> 
> 

Applied to 6.7/scsi-queue, thanks!

[1/1] mpt3sas: Improvised loop logic
      https://git.kernel.org/mkp/scsi/c/3c978492c333

-- 
Martin K. Petersen	Oracle Linux Engineering
