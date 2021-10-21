Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F151C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39F22611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhJUDqM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49778 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhJUDpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:21 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1MeS1020970;
        Thu, 21 Oct 2021 03:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=iVIKReIR0D+Ffbg+eQf405Z3AO5z+gIgxczX5u+/OLE=;
 b=NtOtQH2+5xkwK6aNDWbWz6uKu1kuB3zbTjQUGHIYVjCUYb6RXp8NWsuGQa2iXxWUXpJK
 A3cq50as0TdqIQ4/2odbpLr+tdGcHlwNJEsi7HtA6VIeqabHe8CLahTYYhNpMSZ9h+ub
 S8rj24hAc+kzhLLojk2LHjhQVXjOhLc41qjROai52L0V0qAch5KVXhBM8Zt9Sw+d86dV
 yqCslxPWy/D09Ma/vcZuWws5n9sv+rlfHo8c+bw5u7/kiYzqmuO9L6e4UO1dimmpQkWZ
 3UX1GtGgq7Uad84m1x3RsajTy+VzA4+tBMKFRrqDBDzPbA+QM14bHOInPp17UNioTpXV KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3et8p078180;
        Thu, 21 Oct 2021 03:42:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:56 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7k082116;
        Thu, 21 Oct 2021 03:42:56 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-1;
        Thu, 21 Oct 2021 03:42:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH V2] scsi: ufs: core: Fix synchronization between scsi_unjam_host() and ufshcd_queuecommand()
Date:   Wed, 20 Oct 2021 23:42:32 -0400
Message-Id: <163478764101.7011.5576693484144291414.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008084048.257498-1-adrian.hunter@intel.com>
References: <20211008084048.257498-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: vNLLvZ0HOn472rZRs3MFR9fdXs3hngCc
X-Proofpoint-GUID: vNLLvZ0HOn472rZRs3MFR9fdXs3hngCc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Oct 2021 11:40:48 +0300, Adrian Hunter wrote:

> The SCSI error handler calls scsi_unjam_host() which can call the queue
> function ufshcd_queuecommand() indirectly. The error handler changes the
> state to UFSHCD_STATE_RESET while running, but error interrupts that
> happen while the error handler is running could change the state to
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL which would allow requests to go
> through ufshcd_queuecommand() even though the error handler is running.
> Block that hole by checking whether the error handler is in progress.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix synchronization between scsi_unjam_host() and ufshcd_queuecommand()
      https://git.kernel.org/mkp/scsi/c/d489f18ad1fc

-- 
Martin K. Petersen	Oracle Linux Engineering
