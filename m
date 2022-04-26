Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E69C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 04:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbiDZEEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243745AbiDZEEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 00:04:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EAD1263F
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 21:00:59 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PNTE78017491;
        Tue, 26 Apr 2022 04:00:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=hN+44BCwUhCacNPQj3fs01DRNvC6Vofee0pfgkompGo=;
 b=coZMbmo/GjCVmd69Xm16rNympRMNOeuC7mpfSyeZL2BHbNTknm7lGbbBYBbLF4LGO3wm
 TdMTgwPA1Lkd+d7HvNKYRsmrQhoL1DzOTbYtxKqEr/MPIqm8jT/CQWyoOlq/oB+L0BdF
 ZMtwB9LzRN4DIO0tMsTvbXOKJl/cYgdKgqyqP19oMHF/Op2p7/pyiXTIicvj7PR/PStA
 Gw9FjyKRXj5Zf0CxaUBVQ3JdLX7znXx9IaRclBmkXnObd6yi/cfj0xS0hLGuh8XUAdE4
 oNAF4ufhd1AZYjTgy8NQhkFatAWM0/w9VZZqatUyAlBfdpigDp4tK4p5FZua/hcyXGL2 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4mt4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:00:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q40VkI029711;
        Tue, 26 Apr 2022 04:00:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yj3v2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 04:00:48 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 23Q40juX030030;
        Tue, 26 Apr 2022 04:00:48 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yj3v10-5;
        Tue, 26 Apr 2022 04:00:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Subject: Re: [PATCH] scsi: increase max device queue_depth to 4096
Date:   Tue, 26 Apr 2022 00:00:44 -0400
Message-Id: <165094528688.21993.15493001281989662965.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414103601.140687-1-sumit.saxena@broadcom.com>
References: <20220414103601.140687-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 0M7wjlpZrfGAYKjhgsFAn8KHyuWgIF45
X-Proofpoint-GUID: 0M7wjlpZrfGAYKjhgsFAn8KHyuWgIF45
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 14 Apr 2022 06:36:01 -0400, Sumit Saxena wrote:

> Maximum SCSI device queue depth limited to 1024 is not sufficient
> for RAID volumes configured behind Broadcom RAID controllers.
> For a 16 drives RAID volume with 1024 device QD, per drive
> 64 IOs(1024/16) can be issued which is not good enough to achieve
> performance target.
> 
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: increase max device queue_depth to 4096
      https://git.kernel.org/mkp/scsi/c/f9bdac31cf4b

-- 
Martin K. Petersen	Oracle Linux Engineering
