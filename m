Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980F0FA373F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJVDwk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJVDwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:52:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FE429F116
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:52:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29M3Bt7B029569;
        Sat, 22 Oct 2022 03:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=OmrGACJV30e8qMtewXChM/so/WEinNOjlUsnsJ9WMmk=;
 b=yidsQKBHfAEFTULCVuRU6jVmfauOJzQl21Eaf9AUscpj/KEEpqorCdKUO8Zhb9oNaF1t
 OOVNqB3KGIXIledCwEU8Etdk3X44M/opJaYNPkfoLRDtWnxtij42/duiuaTTGGkkKWG2
 HeD0CVDDDDoHCUQ9k+bYJC+1GnBGIHiUeTmRYEhREVjFINJxLLKLN2zFSTElZ9nSvIbz
 j9fPS62OfUnS+1xomRdBn2PY++s5Uo3EC8WilX1qLK3fp7kK5TclHq8F5ws1PpkwTxN+
 GXlOvgGdwTojk/M68aR0Bdpsxp4iGyeiR4oPu8bG9sl4ONCmXRVm1a1bAProSKqnOb4R XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db80pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1XVfn015245;
        Sat, 22 Oct 2022 03:52:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8hk7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:25 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29M3qOMG004796;
        Sat, 22 Oct 2022 03:52:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y8hk7g-2;
        Sat, 22 Oct 2022 03:52:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, Jinyoung CHOI <j-young.choi@samsung.com>,
        jejb@linux.ibm.com, Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        bvanassche@acm.org, avri.altman@wdc.com,
        cpgsproxy3 <cpgsproxy3@samsung.com>, linux-scsi@vger.kernel.org,
        beanhuo@micron.com, ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix the error log in ufshcd_query_flag_retry()
Date:   Fri, 21 Oct 2022 23:52:17 -0400
Message-Id: <166641048596.3488171.164153640940689454.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1891546521.01666080182092.JavaMail.epsvc@epcpadp4>
References: <CGME20221017022939epcms2p669fa5e5685ef5be1d6c4d1d3e74b6c51@epcms2p6> <1891546521.01666080182092.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210220021
X-Proofpoint-ORIG-GUID: sOEYSc9MqArjCghGxIrs4w6ePw0rTeS0
X-Proofpoint-GUID: sOEYSc9MqArjCghGxIrs4w6ePw0rTeS0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 Oct 2022 16:30:03 +0900, Dukhyun Kwon wrote:

> In ufshcd_query_flag_retry() failed log
> is incorrectly output as "ufs attibute"
> 
> 

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Fix the error log in ufshcd_query_flag_retry()
      https://git.kernel.org/mkp/scsi/c/48ee79528081

-- 
Martin K. Petersen	Oracle Linux Engineering
