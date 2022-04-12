Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8063C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 02:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiDLCj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 22:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiDLCjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 22:39:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0A419C3A
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 19:37:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMU6h4028126;
        Tue, 12 Apr 2022 02:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=H3HuBYHLCLvGDbLg1GhxvccUoTZph4mt+afssz8+8sM=;
 b=V09+ARNrouxlcqYUGiR9nHPsWQCQyuDZjUIVwqMrj03V4gUci16bbYURnLTRRm5nKSn1
 SyB0hegW0/whX299GNEmLhfIoGStrR8Z6nCx5byW+dgzQYh+jWMf+i0hPSk6Ygswox9s
 Us6yPPMzDO/24Rx6Denrm+UyPYsfjpXx2Au47me/mFh7VjJuodIXU9e2s/smpf3/Znn4
 jKwg39S6Z3hHD/XzkfgWdnVhYu3juJttVYbBBHXjTNtaufqtj/b9Sgaag6oUAT5OOVd4
 82M5LP3p3a/iLCXOfV5BSweZe4A07WKEyK3wjIhcw20q6gAcfY/7YmSsX0EhtvUbADEm hA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219w7vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C2VtEd032061;
        Tue, 12 Apr 2022 02:36:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2eg8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:58 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 23C2ar96002744;
        Tue, 12 Apr 2022 02:36:57 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2efv6-3;
        Tue, 12 Apr 2022 02:36:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, lduncan@suse.com, cleech@redhat.com,
        Mike Christie <michael.christie@oracle.com>,
        mrangankar@marvell.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, skashyap@marvell.com,
        njavali@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/10] iscsi fixes
Date:   Mon, 11 Apr 2022 22:36:51 -0400
Message-Id: <164973085492.8307.10541159052908143705.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: DFN2ONE-A4lkRfpx5oyR2SMot0JUKHxD
X-Proofpoint-ORIG-GUID: DFN2ONE-A4lkRfpx5oyR2SMot0JUKHxD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Apr 2022 19:13:04 -0500, Mike Christie wrote:

> The following patchset was made over Linus's tree and contains fixes for
> boot/iscsid restart, more fixes for the in-kernel recovery patch, a data
> corruption regression and fix for qedi connection error handling.
> 

Applied to 5.18/scsi-fixes, thanks!

[01/10] scsi: iscsi: Move iscsi_ep_disconnect
        https://git.kernel.org/mkp/scsi/c/c34f95e98d8f
[02/10] scsi: iscsi: Fix offload conn cleanup when iscsid restarts
        https://git.kernel.org/mkp/scsi/c/cbd2283aaf47
[03/10] scsi: iscsi: Release endpoint ID when its freed.
        https://git.kernel.org/mkp/scsi/c/3c6ae371b8a1
[04/10] scsi: iscsi: Fix endpoint reuse regression
        https://git.kernel.org/mkp/scsi/c/0aadafb5c344
[05/10] scsi: iscsi: Fix conn cleanup and stop race during iscsid restart
        https://git.kernel.org/mkp/scsi/c/7c6e99c18167
[06/10] scsi: iscsi: Fix unbound endpoint error handling
        https://git.kernel.org/mkp/scsi/c/03690d819745
[07/10] scsi: iscsi: Merge suspend fields
        https://git.kernel.org/mkp/scsi/c/5bd856256f8c
[08/10] scsi: iscsi: Fix nop handling during conn recovery
        https://git.kernel.org/mkp/scsi/c/44ac97109e42
[09/10] scsi: qedi: Fix failed disconnect handling.
        https://git.kernel.org/mkp/scsi/c/857b06527f70
[10/10] scsi: iscsi: Add Mike Christie as co-maintainer
        https://git.kernel.org/mkp/scsi/c/70a3baeec4e8

-- 
Martin K. Petersen	Oracle Linux Engineering
