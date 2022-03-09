Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D63C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiCIEQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiCIEQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:16:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2CA3BFB4
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 20:15:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8nXp016933;
        Wed, 9 Mar 2022 04:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=3Xfsy+s+OQkYl6jbLfzFCJFTX9VupinNitLBF1CKatM=;
 b=Su6656qootKT4qPxduCkclVQ4gNGM0m7RZSgj6xy2nZWpRBSDFd0lHOpfPEhuo6qOgPb
 QkYZfvpdAokFkbZq19gC4HGwV5qKimUsgIAnIs5ouvfmGpOVHCYVqIBVRxMoXU9wHpcZ
 dy/if3j5eLza8TooVduDoGkf7CWxmzQ1eAjdYobp6cl4zOkP77HerJmFW7QQz8pud5Xc
 soLPdon03L1NKBvWVxFV6bnFGZbj4LA4SiiizZ8LSbjedLMSJxVemerc2LPxN94ugAcx
 lpnnIvHIVpSqocU4K6bJUPeEoM3i8Pzs8CAaHxBCJMZuolvfWUgIqlvt+/X2iSZ+GFlR eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cgq1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:15:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22945uBr037470;
        Wed, 9 Mar 2022 04:15:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ekwwcjsqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:15:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294FECj048146;
        Wed, 9 Mar 2022 04:15:14 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ekwwcjsqr-1;
        Wed, 09 Mar 2022 04:15:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 0/2] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Tue,  8 Mar 2022 23:15:13 -0500
Message-Id: <164679903743.29335.5784041654049598417.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220228113652.970857-1-adrian.hunter@intel.com>
References: <20220228113652.970857-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: zMBW35_oAs-516NKrTVE8EPXYjccfQMD
X-Proofpoint-GUID: zMBW35_oAs-516NKrTVE8EPXYjccfQMD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Feb 2022 13:36:50 +0200, Adrian Hunter wrote:

> Here is V4 to address comments by Martin.  See patches for version history.
> 
> Summary:
> 
> Kernel messages produced during runtime PM can cause a never-ending
> cycle because user space utilities (e.g. journald or rsyslog) write the
> messages back to storage, causing runtime resume, more messages, and so
> on.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/2] scsi: Add quiet_suspend flag for SCSI devices to suppress some PM messages
      https://git.kernel.org/mkp/scsi/c/af4edb1d50c6
[2/2] scsi: ufs: Fix runtime PM messages never-ending cycle
      https://git.kernel.org/mkp/scsi/c/71bb9ab6e351

-- 
Martin K. Petersen	Oracle Linux Engineering
