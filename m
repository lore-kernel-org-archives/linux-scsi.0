Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EB3C6FA99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCGC5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCGC5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:57:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428AA21947
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:57:43 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwuSR006093;
        Tue, 7 Mar 2023 02:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=H+jA5LTVy7MB+UZe7C0DqKIg+4BuoWJKGjXQ9ixY6Gs=;
 b=EUGiV5bzrLLXpMlUnMFm/rs8ozgigCyVg0zLUwfctTllaZbmXYf3m6LOBCNQT5coEbf8
 Ej0loNB8YnKJ2AIyov9fAxi4xAZqfXcOJHIZnMiyulloMN85gcMaSV4q6Ov/K/tF7ElA
 Dj8TrbKIFdRQ+JiOumZKSkfuaJSl/d82KYYVod4FViNKP25md+5DsjFY1T3OQiI34pHT
 D2y/OkETmIpvbp0Pk0EonrmpbU7Vqn6KYlF+dLSmjki5qfDzvFN0GLCV7LIczThajaW8
 02HImkVRVzsn3HxRZYi7XgLXa6pIv/yJP/jCsG7HSU/mMyRC3piF3QhyPM2eaqEPFwkc sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4161vfk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271GWBr037275;
        Tue, 7 Mar 2023 02:57:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvjka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:57:39 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3272vY2K009567;
        Tue, 7 Mar 2023 02:57:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3p4txdvjhj-6;
        Tue, 07 Mar 2023 02:57:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com,
        Kang Chen <void0red@gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: lpfc: add null check of kzalloc in lpfc_sli4_cgn_params_read
Date:   Mon,  6 Mar 2023 21:57:23 -0500
Message-Id: <167815780204.2075334.12489472252376882182.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230228044336.5195-1-justintee8345@gmail.com>
References: <20230228044336.5195-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=797 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: GGDYDSd9zvI7NJ7wFLHp1-z0XoTFWvy8
X-Proofpoint-ORIG-GUID: GGDYDSd9zvI7NJ7wFLHp1-z0XoTFWvy8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Feb 2023 20:43:36 -0800, Justin Tee wrote:

> If kzalloc fails in lpfc_sli4_cgn_params_read, then we rely on
> lpfc_read_object's routine to null check pdata.
> 
> Currently, an early return error is thrown from lpfc_read_object to
> protect us from null ptr dereference, but the errno code is -ENODEV.
> 
> Change the errno code to a more appropriate -ENOMEM.
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: lpfc: add null check of kzalloc in lpfc_sli4_cgn_params_read
      https://git.kernel.org/mkp/scsi/c/312320b0e0ec

-- 
Martin K. Petersen	Oracle Linux Engineering
