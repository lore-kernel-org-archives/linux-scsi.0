Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1577C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiGSDJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiGSDJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:09:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56623AE73;
        Mon, 18 Jul 2022 20:09:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IL35BA008091;
        Tue, 19 Jul 2022 03:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=Ts2tjqdli2TcFmf9Ob7Jq+NNJunS5Sw5HKuTUoyKUXI=;
 b=H0mitXkXS2bBPNrmK7Qf8qe6VJACFVBA2aKbbIjZnS3i04q9W5K1SHzFvpYVv0lwLk5g
 0RDKXg2SW5LDoVEkhz+DMKOhPv6X6H5G6SO0W6Cq1gPXXF6dnInMEMiax37N3+/X5o4V
 V2CbvGgxK/VzkDMaQatfU0e0Mn6igUx0mJr9TeEI2esD/qc0ua2knCeeQ+fLjUxhsV4H
 6H/WS4TgCCTCWLKzgKO6gwq2IMtflJRBXp2qg+gd06wL7qZ46WyM4TMikZfNkz8u0WUs
 3qb26tONpu1TAwDRDMuZLUtk+oTC1uCLG1spEeNt/CrmR2cvkVG7m4zxW8euI2inAfff Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4wuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J05m53001974;
        Tue, 19 Jul 2022 03:09:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2ypty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:05 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J391UB016855;
        Tue, 19 Jul 2022 03:09:05 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hc1k2ypt1-6;
        Tue, 19 Jul 2022 03:09:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org,
        Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH] scsi - gvp11.c: fix DMA mask calculation error
Date:   Mon, 18 Jul 2022 23:08:59 -0400
Message-Id: <165820009734.29375.9139589991224963788.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713074913.7873-1-schmitzmic@gmail.com>
References: <20220713074913.7873-1-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190011
X-Proofpoint-GUID: InpCSX4EH51Wle3-w5Up6TM8unMNw-xm
X-Proofpoint-ORIG-GUID: InpCSX4EH51Wle3-w5Up6TM8unMNw-xm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Jul 2022 19:49:13 +1200, Michael Schmitz wrote:

> DMA masks given in the Zorro ID table don't contain the 2 byte
> alignment quirk seen in the GVP11_XFER_MASK macro from gvp11.h
> so no need to account for that.
> 
> DMA masks passed to dma_set_mask_and_coherent() must be 64 bit,
> add the missing cast in the TO_DMA_MASK macro used to convert
> driver DMA masks to DMA API masks.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi - gvp11.c: fix DMA mask calculation error
      https://git.kernel.org/mkp/scsi/c/f712e24c0b2e

-- 
Martin K. Petersen	Oracle Linux Engineering
