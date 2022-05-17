Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1155BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiEQCQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEQCQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:16:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEA03BBDC
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 19:16:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKgPN8009394;
        Tue, 17 May 2022 02:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=fz6pcb2Wzi6kngupNdymDjuLX3eUpFjiPH5//OO98A0=;
 b=w85RasYvMYm0jHd/lhrl61kwL8L+vLtDcXHC7IyLt2ykBo0z3iWAsJC5JGzFz3JcBeTp
 prGeu2fovQiHD28H78uVNVn/unpL7gvPYMaIZY+FOP0d30jFmCidJAvW3MImcG36EWcU
 g8E/h0eNR1Hi/umtKILeHO1kitaEXZGVAmPsljQOS1hJhnVVDYP/BhdL5D0ePqKjU0EY
 sSvgfiDPHcB4aPFJ+icCmXwfd7Bz5bAwzLt1ycF68xos1QR1yQ5IqD9B2xQ6cFyZyCW6
 ShIgbzwwVwU8gPp8DabBuhTPrmiS4OBlSyaGUoeo1aa7Pj/3XJAQv/LsiQq6lcbI09k4 PA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytmwk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H2G8Bq019232;
        Tue, 17 May 2022 02:16:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:16:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24H2Ghw7019875;
        Tue, 17 May 2022 02:16:46 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v83hkf-7;
        Tue, 17 May 2022 02:16:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpi3mr: Increase IO timeout value to 60s
Date:   Mon, 16 May 2022 22:16:42 -0400
Message-Id: <165275376861.24722.12853184735182877372.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220505184808.24049-3-sreekanth.reddy@broadcom.com>
References: <20220505184808.24049-1-sreekanth.reddy@broadcom.com> <20220505184808.24049-3-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: r9N8OBfpZ7-ilhsZKWKt0uXn7K9VwUEn
X-Proofpoint-ORIG-GUID: r9N8OBfpZ7-ilhsZKWKt0uXn7K9VwUEn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 00:18:08 +0530, Sreekanth Reddy wrote:

> Set each SCSI device's default IO timeout and
> default error handling IO timeout to 60s.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] mpi3mr: Increase IO timeout value to 60s
      https://git.kernel.org/mkp/scsi/c/1aa529d40025

-- 
Martin K. Petersen	Oracle Linux Engineering
