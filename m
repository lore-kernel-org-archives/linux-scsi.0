Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471C2C77B78
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 03:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjDSDUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 23:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjDSDU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 23:20:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C991739
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 20:20:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IM98sJ016686;
        Wed, 19 Apr 2023 03:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=KC5STehNquRn2LxCe0DCciuFUk0Fkj1JhpeAuhOZldM=;
 b=VOwNTnYQ/mem4oFtiOxSXPpAA2YKhpIgXHSMChXXD6fpjVa4ulKRuiFg4FV9mI7wXLTN
 gVoZ/UrlxZh1YV0KV0jqNsPPJjG6gOrV8hAwG18ODfKgKKWojn4u9XOwfQmKO17lPshk
 glIhnbyph8kWXAlSI1j9RLPDdoDL7JUffcAQg00TPoLM1sLwXrEtIoG/k7izAlIiTx1D
 QNNvViLZwTtjfYv/fDff9a8qUDJZoLcx+NYMzOuUOzadRHTQvx7IWFRbze6yePp0I7r+
 ZJ3kB7CLquLc1oEB5Gq81wzbZgZyvjinWdNXX1wicD3nysDnYKWYoj4Gg7l8IhlXR1Od uA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjq478uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:20:24 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33J2UF11037274;
        Wed, 19 Apr 2023 03:20:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcccvvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 03:20:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33J3KLpH012748;
        Wed, 19 Apr 2023 03:20:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pyjcccvts-6;
        Wed, 19 Apr 2023 03:20:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: fix an issue when driver's being removed
Date:   Tue, 18 Apr 2023 23:20:15 -0400
Message-Id: <168187437332.702980.17067470708272095598.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403184736.6399-1-thenzl@redhat.com>
References: <20230403184736.6399-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_17,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=733 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190029
X-Proofpoint-GUID: 7H4zM9AplBQzlwjz8xXBX0WMoVeFka6v
X-Proofpoint-ORIG-GUID: 7H4zM9AplBQzlwjz8xXBX0WMoVeFka6v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 03 Apr 2023 20:47:36 +0200, Tomas Henzl wrote:

> Warnings may be logged during driver removal:
> mpt3sas 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT ..,
> Fix it by deallocating dma memory later.
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: mpt3sas: fix an issue when driver's being removed
      https://git.kernel.org/mkp/scsi/c/85140baf096b

-- 
Martin K. Petersen	Oracle Linux Engineering
