Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB9CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDDAF6128E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhJSDqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:46:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232126AbhJSDqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:46:05 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J32c3n004576;
        Tue, 19 Oct 2021 03:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=QNtqsw/iYvePm6QmzwvTX3bi//bhxeELnZhsV4gAUiI=;
 b=LHbcAtDRm9JEyBJMcVmiNJEKR6HxbH7vDzr/pMD9yb5dkmPwOJjsUJh7SElARzMk0o7s
 ByIyHDAiUGqhevYB+4N1zLpdyHG+3I5yJzsnlBrimX3uZxGyVMcTdtM1/E+6NNorS6oi
 lSR6iPWSpwlDC6iPLRn/oIR1X1stpVonfDqmMra1C70w+1a13EBLEeyQsGGNzZK7ZJG9
 nYWnjG0z6ZEBAUS3qrPgmDMtvAit+HS+8pTV262HXYG1x2Rbo+mmnUmS7PLnKPs9jzWL
 LjIhBpZuiGsNsJyEBfW5tHVcOk/h74bOMOejtNaaCXlPJPirJUZsXfMM6gPTD8RzMNi1 Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnnnftt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3ZUfh077135;
        Tue, 19 Oct 2021 03:43:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8grmmt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:45 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19J3hhHd101685;
        Tue, 19 Oct 2021 03:43:45 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8grmmrp-3;
        Tue, 19 Oct 2021 03:43:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Joy Gu <jgu@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org, GR-QLogic-Storage-Upstream@marvell.com,
        njavali@marvell.com
Subject: Re: [PATCH 0/2] scsi: qla2xxx: Fix bugs found by CodeSonar
Date:   Mon, 18 Oct 2021 23:43:39 -0400
Message-Id: <163461411521.13664.9885886658227492668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012191834.90306-1-jgu@purestorage.com>
References: <20211012191834.90306-1-jgu@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: yeVqjjwOVd1Hm-37Xq1ODgdO5oGef9C-
X-Proofpoint-GUID: yeVqjjwOVd1Hm-37Xq1ODgdO5oGef9C-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2021 12:18:32 -0700, Joy Gu wrote:

> Joy Gu (2):
>   scsi: qla2xxx: Fix a memory leak in an error path of
>     qla2x00_process_els()
>   scsi: qla2xxx: Initialize uninitialized variables
> 
> drivers/scsi/qla2xxx/qla_attr.c | 2 +-
>  drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 6 +++---
>  drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
>  drivers/scsi/qla2xxx/qla_nx2.c  | 2 +-
>  drivers/scsi/qla2xxx/qla_os.c   | 8 ++++----
>  6 files changed, 13 insertions(+), 13 deletions(-)
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/2] scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
      https://git.kernel.org/mkp/scsi/c/7fb223d0ad80

-- 
Martin K. Petersen	Oracle Linux Engineering
