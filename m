Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773F6C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiF1DZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiF1DZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:25:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F95252AA
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:25:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S1RcSD026411;
        Tue, 28 Jun 2022 03:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=tS28WnwYNVHCNUZeN2R+9SlhT6WWlUTS0XQXdUXWMWQ=;
 b=lUENyNtQ/gvFHhIDlnorpcYnk1sX3U/ocGZZuElcWR8TGq37eyZmMcQBQk90q5SqZWUn
 MU+LwUhowvdXOrewSdbvk3qu8MPhrFK+CK0yN4aMd4uqtFOqGJTJyGNXsXhF3dkO/YAG
 ujmb3M9yp1BB+0De0+xadjq93OIkc9afUVrMQN2Ytegj3xRC3c+BB/tSSlWu9llmDPwU
 vU53Bxusuq32PsY15y5ABirvYH5rJdCm0+Lt5z9mujgpL8HLzOSlQpSkkyFbrEGJjwGJ
 49fNIaobr0U0dlTMvzyxRtTYB4j8EMCfhZcxkkU1gj8K8e6G3xPtLnWMVemnZzPRWq+9 eQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsyscrsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1ZE002538;
        Tue, 28 Jun 2022 03:25:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:00 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25S3NvqG016584;
        Tue, 28 Jun 2022 03:25:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkg-10;
        Tue, 28 Jun 2022 03:25:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        njavali@marvell.com, Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] iscsi fixes for 5.19 or 5.20
Date:   Mon, 27 Jun 2022 23:24:48 -0400
Message-Id: <165638665782.7726.6144583790272202432.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: gcVmP5uqs5zP122dlDvGFaIVsVWB-HHC
X-Proofpoint-GUID: gcVmP5uqs5zP122dlDvGFaIVsVWB-HHC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jun 2022 17:27:32 -0500, Mike Christie wrote:

> The following patches are some fixes for qla4xxx and qedi. They were built
> over linus's tree, but apply over Martin's staging and queueing branches.
> They do not have conflicts with the other iscsi patches that I've ackd on
> the list, so they can be applied before or after those patches.
> 
> The first patch is trivial and fixes a bug that can only be triggered with
> qla4xxx which should be rare. Patches 2 - 6 are more invassive and fix a
> regression in qedi where shutdown hangs when you are using that driver for
> iscsi boot. I was not sure if this was too much of an edge case and the
> pathes were too invassive for 5.19 so the patches do apply over either
> of your 5.19 or 5.20 branches.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/6] scsi: iscsi: Fix HW conn removal use after free
      https://git.kernel.org/mkp/scsi/c/c577ab7ba5f3
[2/6] scsi: iscsi: Allow iscsi_if_stop_conn to be called from kernel
      https://git.kernel.org/mkp/scsi/c/3328333b47f4
[3/6] scsi: iscsi: Cleanup bound endpoints during shutdown.
      https://git.kernel.org/mkp/scsi/c/da2f132d00d9
[4/6] scsi: iscsi: Add helper to remove a session from the kernel
      https://git.kernel.org/mkp/scsi/c/bb42856bfd54
[5/6] scsi: qedi: Use QEDI_MODE_NORMAL for error handling
      https://git.kernel.org/mkp/scsi/c/7bf01eb0d4f9
[6/6] scsi: iscsi: Fix session removal on shutdown
      https://git.kernel.org/mkp/scsi/c/31500e902759

-- 
Martin K. Petersen	Oracle Linux Engineering
