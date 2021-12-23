Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52387C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 05:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhLWFJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 00:09:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58216 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhLWFJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 00:09:22 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0bNjD026370;
        Thu, 23 Dec 2021 05:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=h1Gz3NmkkvAQalHSEv+c/ZfxMQ6PAkxx2LFttZmQzBU=;
 b=hR9E80P0+cZv0DH4LMOweUZO4BrDGm4+aUKpj/DR2ATWFZe0FQroLdTB7dkXwADSD73p
 Mf/MNuymVSvtxx0JDi3UcnbmUDgfM6oBvCZF0bwQb93C5gZZEq7b2GCX5QVIZcloQzd+
 FHXafEcHJ+88vsN3QqoND02bpb4OQaJCaEOldxIlcVyS8AG8wKxYefjRYzDtCyLu/18R
 jA3R2Xfj4LXWTjC4gEMixE1OLz6b3Mi+7NB01HBVlWf2Wp+D0QEudHeYgtfV1YQVOmrQ
 NjOFjwryajKcszUkqDGN4L3rbVbQdo92pLm2PtO0/9+QA4b5U3pnS3BPXLmrvwPYrE/w 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a1ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN511gq070356;
        Thu, 23 Dec 2021 05:09:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 05:09:00 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BN58xaB091703;
        Thu, 23 Dec 2021 05:08:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3d15pfm5se-2;
        Thu, 23 Dec 2021 05:08:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
Date:   Thu, 23 Dec 2021 00:08:56 -0500
Message-Id: <164023593111.32381.16067012034027216653.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214070527.GA27934@kili>
References: <20211214070527.GA27934@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: bXN7uAIM3-55gL28gT99Bq9OrSHEvM_q
X-Proofpoint-GUID: bXN7uAIM3-55gL28gT99Bq9OrSHEvM_q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Dec 2021 10:05:27 +0300, Dan Carpenter wrote:

> The "mybuf" string comes from the user, so we need to ensure that it is
> NUL terminated.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: lpfc: Terminate string in lpfc_debugfs_nvmeio_trc_write()
      https://git.kernel.org/mkp/scsi/c/9020be114a47

-- 
Martin K. Petersen	Oracle Linux Engineering
