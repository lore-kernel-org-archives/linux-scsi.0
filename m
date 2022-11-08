Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88B8C43219
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 04:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiKHECZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 23:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbiKHECO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 23:02:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4DF30F62
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 20:02:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80OaSf029245;
        Tue, 8 Nov 2022 04:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=b/62fdqAwU8doZE8w2gvuQwDc5nBHrIh5nrBMcGpxCY=;
 b=hYJHonBCxRWF7fSZfjfMdLaONF28M142d/s/7zCx8Z+YImqsBGiMPPlNCsaneNPleX2f
 HyJvR0/8LJPeisqlIWeZuR8/j5qnQ0zls53eigqNtv4b91M1N5GUmuKqNUSQ9ZBYfZWk
 /imYyZ0MaYSnbIn6N1GWaVb9vogMWuQk3RZ8jRZ9ssFZeHdcaHoGGELjI+PZU5yT6jDt
 FuQ6WO8YcFbtOHcg9JgicpgZZSMo1xoH9H/G66JysKUSaSGr9GbBcB9UYs5lzhnxh15s
 BpS7jT0rDxtw4r5VnNXaDpYfHGfCiyhfhIYABivuyPlP2JGPfTP+3O0uzc2Zdlh8vdFI 3A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfx5eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A817XML025561;
        Tue, 8 Nov 2022 04:02:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqfh3u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:02 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A841vcs022774;
        Tue, 8 Nov 2022 04:02:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kpcqfh3s5-8;
        Tue, 08 Nov 2022 04:02:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        avri.altman@wdc.com, stanley.chu@mediatek.com,
        peter.wang@mediatek.com, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        powen.kao@mediatek.com, lin.gui@mediatek.com,
        wsd_upstream@mediatek.com, alice.chao@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        cc.chou@mediatek.com, qilin.tan@mediatek.com,
        linux-mediatek@lists.infradead.org, chun-hung.wu@mediatek.com
Subject: Re: [PATCH v1] ufs: core: print more evt history
Date:   Mon,  7 Nov 2022 23:01:55 -0500
Message-Id: <166787988583.644518.9946543089058025051.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221024120602.30019-1-peter.wang@mediatek.com>
References: <20221024120602.30019-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080020
X-Proofpoint-ORIG-GUID: 4NX4GRN59D_FWRS2pKkDoi87T1kXq4W_
X-Proofpoint-GUID: 4NX4GRN59D_FWRS2pKkDoi87T1kXq4W_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Oct 2022 20:06:02 +0800, peter.wang@mediatek.com wrote:

> From: Peter Wang <peter.wang@mediatek.com>
> 
> Some error event is missing in ufshcd_print_evt_hist.
> Add print for this error event.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] ufs: core: print more evt history
      https://git.kernel.org/mkp/scsi/c/a301d487d7bd

-- 
Martin K. Petersen	Oracle Linux Engineering
