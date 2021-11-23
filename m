Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE49C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhKWDsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:48:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15210 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhKWDsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:48:20 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN26ZcR016036;
        Tue, 23 Nov 2021 03:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=IwCaccE5uESK6bsCOCsZ5flZFCL0KpfLjZngWepFAj0=;
 b=BXrHMn9jL9l5yES2tMwfcryjfNR2OnGcDMhVA4pZSqntZO1+uH1efOjGLz857jTVgzJa
 bwV2DZMnOEHYhcDu5c86NvvU+3UtGlQjEXRd6fWrNEp+cP+pw9BrQUZ8tR8QmPj4TOpi
 eeAFUsDdGDFZn42QNlqsaYEYp5tQaouifHsa+YtdYEhhcGwpHn5ujsjdb+FS4gOmSvwZ
 +CZiuTzFGqk3lt90rLAFGRCRg4tOyUWZsa6RF2vfBvK/oZHNhZyUIzHbVJOkHddpNWho
 GfNPirqFwVR9NAtb917IH6oss0aKcIm3B7vQX96Z4Et+3DkSl20MLlzZOyqWK+P8NExc uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55fxp38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3akxX044297;
        Tue, 23 Nov 2021 03:45:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:11 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3jATq070854;
        Tue, 23 Nov 2021 03:45:11 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd2x-2;
        Tue, 23 Nov 2021 03:45:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: Fix setting device state to running
Date:   Mon, 22 Nov 2021 22:45:08 -0500
Message-Id: <163763907099.20472.18043531962833246260.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211120164917.4924-1-michael.christie@oracle.com>
References: <20211120164917.4924-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Q2O_CI1kxRdDWZB9noZV7JuPj1DujBXt
X-Proofpoint-GUID: Q2O_CI1kxRdDWZB9noZV7JuPj1DujBXt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Nov 2021 10:49:17 -0600, Mike Christie wrote:

> This fixes an issue added in:
> 
> commit 4edd8cd4e86d ("scsi: core: sysfs: Fix hang when device state is set
> via sysfs")
> 
> where if userspace is requesting to set the device state to SDEV_RUNNING
> when the state is already SDEV_RUNNING, we return -EINVAL instead of
> count. The commmit above set ret to count for this case, when it should
> have set it to 0.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: Fix setting device state to running
      https://git.kernel.org/mkp/scsi/c/eb97545d6264

-- 
Martin K. Petersen	Oracle Linux Engineering
