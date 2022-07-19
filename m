Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917E5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiGSDJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbiGSDJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:09:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882D73C15C
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 20:09:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKt7jK008261;
        Tue, 19 Jul 2022 03:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=JiUTxZn8vt8h9NVLYOQN8JNe7C5S1ed55rTYL/yN2bw=;
 b=fwrWCB6BxfSeGZPgPrQyf8T6/6nusNkkTOWwzq0Wy/hlEA8Kbfktwbs8SAEdsx+zt5DK
 C0zP/J/LAcVB3EaPxUfBOx5owC0Is9oCYSlNgsYj/NEjYTlu8O2HnQkqAhs6GBE5kcdV
 LPCeYBkEYt1JoWe2Zq5aPdj7ePgsAli5xwdxgKtWGaLWrUUU8v53+K60cuo6jJszPq1O
 LuyBeC/j62bYTnxoyyCaZq6vyMYJeQQ2GEptWdGjgAESxouabhzwnVD/HRThu0L1/cua
 vvXNSLYVYSJwVfLcgG182/GS1aXHO4cmvLgPH9Q2GlDotqZKl/Xa550zH0H7Hxwx9JOF BA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc4wud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J0G261001895;
        Tue, 19 Jul 2022 03:09:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2ypu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 03:09:05 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J391UD016855;
        Tue, 19 Jul 2022 03:09:05 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hc1k2ypt1-7;
        Tue, 19 Jul 2022 03:09:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tony Battersby <tonyb@cybernetics.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND] sg: allow waiting for commands to complete on removed device
Date:   Mon, 18 Jul 2022 23:09:00 -0400
Message-Id: <165820009735.29375.16679071052940876274.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com>
References: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com>
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
X-Proofpoint-GUID: 5RtkTLi75zd4pPlmgFiKeUDp4fvkFTUH
X-Proofpoint-ORIG-GUID: 5RtkTLi75zd4pPlmgFiKeUDp4fvkFTUH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Jul 2022 10:51:32 -0400, Tony Battersby wrote:

> When a SCSI device is removed while in active use, currently sg will
> immediately return -ENODEV on any attempt to wait for active commands
> that were sent before the removal.  This is problematic for commands
> that use SG_FLAG_DIRECT_IO since the data buffer may still be in use by
> the kernel when userspace frees or reuses it after getting ENODEV,
> leading to corrupted userspace memory (in the case of READ-type
> commands) or corrupted data being sent to the device (in the case of
> WRITE-type commands).  This has been seen in practice when logging out
> of a iscsi_tcp session, where the iSCSI driver may still be processing
> commands after the device has been marked for removal.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] sg: allow waiting for commands to complete on removed device
      https://git.kernel.org/mkp/scsi/c/3455607fd7be

-- 
Martin K. Petersen	Oracle Linux Engineering
