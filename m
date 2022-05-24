Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364F2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiEXD1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiEXD12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:27:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EDE403DB
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 20:27:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMhk85029166;
        Tue, 24 May 2022 03:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=5zUg9hRSZGWycyunlsh2NQczklHFhlh58k/rLXoN75I=;
 b=HaeNmjr4f2eCn+r9XSly/BSbAWeJ9vRvAv7nnM9w/8zz5BhGQlxSUqD3Zpv8AArHkDOh
 3ZNGGDaMFqbEu04No4UEyh4dNetHaVTIlzs5VQwKhopIu1TKHI1Z898iy6Wr1r9JbaRv
 tSbXobyxoVbqNR3NCRNlmVxHS4adqtzDVlKJMkD5HhdvuL9gHRFd2RtcP66CSiuGMU4S
 Njiu27++rDQ1xLf9AAe17JEavDOKVFitCiKzD63mxgjx0fhEKDhNN+HbneJ4ci6ypUG/
 JjxDZMdLxPlbBwEwNICx7wk+9LCQIK1zSQ//AZhGHDk3iad5OYul9+jVH71kvSRpxzSz Zw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qps55gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:27:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3C2Ot028127;
        Tue, 24 May 2022 03:27:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1y34u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:27:25 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24O3P61N012957;
        Tue, 24 May 2022 03:27:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1y349-3;
        Tue, 24 May 2022 03:27:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/4] Add VMID support to nvme-fc transport and lpfc driver
Date:   Mon, 23 May 2022 23:27:21 -0400
Message-Id: <165336281522.11823.15564390546369620427.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220519123110.17361-1-jsmart2021@gmail.com>
References: <20220519123110.17361-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jGHShz8TCZgrdG8iLTh0Dt-wfD3yjMpz
X-Proofpoint-GUID: jGHShz8TCZgrdG8iLTh0Dt-wfD3yjMpz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 May 2022 05:31:06 -0700, James Smart wrote:

> This patch adds vmid support to the nvme-fc transport.
> 
> Various virtualization technologies used in Fibre Channel
> SAN deployments have the ability to identify and associate traffic
> with specific virtualized applications. The T11 standard defines
> an application services tag that can be added to FC traffic to aid
> in identification and monitoring of traffic associated with the
> applications.
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
      https://git.kernel.org/mkp/scsi/c/827fc630e4c8
[2/4] lpfc: commonize VMID code location
      https://git.kernel.org/mkp/scsi/c/ed913cf4a533
[3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol independent
      https://git.kernel.org/mkp/scsi/c/348efeca7487
[4/4] lpfc: Add support for vmid tagging of NVMe I/Os
      https://git.kernel.org/mkp/scsi/c/896325a8b165

-- 
Martin K. Petersen	Oracle Linux Engineering
