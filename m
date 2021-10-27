Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AA9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD22610CA
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhJ0EC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 00:02:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3650 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229474AbhJ0EC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 00:02:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mtNJ014988;
        Wed, 27 Oct 2021 04:00:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=pwqxpzGNRZtOWd8MU2sYQAOSubU+t0EcPB64EXz+SHU=;
 b=c/53WKey/sutpzucP36ZcfZEEmRdlMy/xdIbEdQUtAtT+KxmZGJF174z61WMZQ1mJ7ae
 L+64GLR4fmMBKhBi9FPCt8yL/o7qipLkIPUuOpmsuMM8vm+IxcFi/rJi8jWlZr2RzaPr
 5iVciswtPmZ208/tDwWx1DICiumJGaeIPF5X9ivKcrmcktCswBFpCjk4XMYXwAn9fDhO
 7GNjlCGk0Z6Zj8Vn0Erz2WuYFWCeBz43XhaZPPb6ae206kmMHfwcTKi9tQInBUy/IOM/
 IgdhHvDbeCXj3JKuvnRjME8gnaIyG8EdDCO3QHF8Ee2S82JJisKlvzidyrYH3GbY1Tmr Vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0g91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3xwtn068726;
        Wed, 27 Oct 2021 04:00:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19R40O5E070915;
        Wed, 27 Oct 2021 04:00:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn88-2;
        Wed, 27 Oct 2021 04:00:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sathya.prakash@broadcom.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
Date:   Wed, 27 Oct 2021 00:00:20 -0400
Message-Id: <163530706457.10775.10874628422170650730.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: V_bdkzHpLFsrQw0xbqkvbJsN2XaPzVLT
X-Proofpoint-ORIG-GUID: V_bdkzHpLFsrQw0xbqkvbJsN2XaPzVLT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Oct 2021 18:27:19 +0800, Jiapeng Chong wrote:

> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> This symbol is not used outside of mpt3sas_ctl.c, so marks it static.
> 
> Fixes the following sparse warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_ctl.c:3988:18: warning: symbol
> 'mpt3sas_dev_attrs' was not declared. Should it be static?
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: mpt3sas: make mpt3sas_dev_attrs static
      https://git.kernel.org/mkp/scsi/c/0ae8f4785107

-- 
Martin K. Petersen	Oracle Linux Engineering
