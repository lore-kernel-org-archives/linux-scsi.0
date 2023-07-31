Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F377AC001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 19:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjGaTpW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 15:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGaTpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 15:45:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E11BB
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 12:45:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTR8A017392;
        Mon, 31 Jul 2023 19:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=t6JzJBcefAK6GJeL5fAYQ6a0/DnatIvNzGBv1lOd32E=;
 b=iclVmGddgxOjCwsFPtzDJJTVCL05vv4DxnKNY+W2DhDAirRZ/AJ/5Ird1DuJWynBiYPt
 GaV/o8YQ8NAfBLuyd+McuyjenaK6OK2IDaisLrgEE0GrVaUzQHyRg2ak4OFnonWxtTxi
 QQEQF69AgFLMjcvOhF4Zf09UIkIXI+img4CeLS5DkLVGfTUVxu9EYkFxf88j+fNF/E+q
 iwsG3gM8mrEhe4EYXkJEdp7qLioMaEbv77oBOjzl8A3T1N7EqOcK9Ilaa/4O9a3f/vos
 Yd7pUIPb6tn2//TpvSDCTaOPzRl+hZbfLKxt56ru+MkYrqyeD0XZwZcjSwreUCIfJi9W FQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sc2bf4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 19:45:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VIFhND013780;
        Mon, 31 Jul 2023 19:45:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s75cmj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 19:45:15 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36VJjEfb025102;
        Mon, 31 Jul 2023 19:45:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3s4s75cmf1-2;
        Mon, 31 Jul 2023 19:45:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2 0/2] Fix residual handling in two SCSI LLDs
Date:   Mon, 31 Jul 2023 15:45:03 -0400
Message-Id: <169083266396.2873709.14062193311339359109.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724200843.3376570-1-bvanassche@acm.org>
References: <20230724200843.3376570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_13,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=538 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307310179
X-Proofpoint-ORIG-GUID: 8f6JLMX3v2HrRccWrVy2ziAMB5aLFzLa
X-Proofpoint-GUID: 8f6JLMX3v2HrRccWrVy2ziAMB5aLFzLa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Jul 2023 13:08:28 -0700, Bart Van Assche wrote:

> This patch series fixes the documentation of scsi_set_resid() and also fixes
> residual handling in two SCSI LLDs. Please consider this patch series for the
> next merge window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/2] scsi: ufs: Fix residual handling
      https://git.kernel.org/mkp/scsi/c/2903265e27bf
[2/2] RDMA/srp: Fix residual handling
      https://git.kernel.org/mkp/scsi/c/89e637c19b24

-- 
Martin K. Petersen	Oracle Linux Engineering
