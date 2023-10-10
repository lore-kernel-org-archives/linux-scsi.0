Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80677CD68E4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 02:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441849AbjJJCKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 22:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441846AbjJJCKN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 22:10:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B87AC9
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 19:10:12 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399NwkGI007700;
        Tue, 10 Oct 2023 02:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Oq3miOLf83toQPqrom6yizyYo/xrHlFPOk5WzgldhMM=;
 b=D7wEci+sJOY2+lxoPnFJH1PirVKWaWqg2TFcgNR4tCEOrKHqGFOyoNd4OveW+8oZszBy
 GWdUgi3Lea4lQirbE3C4Y7vPDtgny+37AD0g87+QbDQm89rnSRsgH4fDXU2768Nx38E4
 G9SBxzrFuTZf6sRuLX/+rG5WSbnbrU+aj6P+WCva3pUzUrMUXujxH0mKUR9LNuSDdUUw
 rN0eet/iS2sA5LymUffyyIVvYz5Cmv2X9FS34VJGrWL8wgoynTAFncLnkTqDZQ2He+9G
 ZSGaOoSb5Ur5i0omiAofreyWkTr9xU+XcsGSMHLkMGwjjKAPp8H/FY2drkbuygbAD4Cy NA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjycdm0h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 02:10:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39A29EI2014470;
        Tue, 10 Oct 2023 02:10:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tjwsbeyup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 02:09:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39A29xkB022040;
        Tue, 10 Oct 2023 02:09:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tjwsbeyue-1;
        Tue, 10 Oct 2023 02:09:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        peter.wang@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Subject: Re: [PATCH v2] ufs: core: correct clear tm error log
Date:   Mon,  9 Oct 2023 22:09:55 -0400
Message-Id: <169690372450.1616558.9192906127431586704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231003022002.25578-1-peter.wang@mediatek.com>
References: <20231003022002.25578-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_01,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=774 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310100013
X-Proofpoint-ORIG-GUID: oZuc0oH9qo8mUI0GNiG7hDkKXKDzBpr4
X-Proofpoint-GUID: oZuc0oH9qo8mUI0GNiG7hDkKXKDzBpr4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 03 Oct 2023 10:20:02 +0800, peter.wang@mediatek.com wrote:

> The clear tm function error log is inverted.
> 
> 

Applied to 6.6/scsi-fixes, thanks!

[1/1] ufs: core: correct clear tm error log
      https://git.kernel.org/mkp/scsi/c/a20c4350c6a1

-- 
Martin K. Petersen	Oracle Linux Engineering
