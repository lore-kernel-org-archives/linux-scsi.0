Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB427C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 21:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiGGVrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiGGVrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 17:47:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C2731920;
        Thu,  7 Jul 2022 14:47:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCoR8020654;
        Thu, 7 Jul 2022 21:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=xV7JS9yx+kBhWCmCxErBPpHQ0XqJb+g4b6cZdWUlrxg=;
 b=cysYlXIbv50L2MT3J0rc/5jC9/fJ5G+VXVcFf+xL1I6V9bgjE+R7PanH5p+1N+MIls7n
 Lo78COtGjHFw/1nSHVibWyUXvrwwzTKIf2Labc19I/JjaN/VelYcgqxNQwZAO0QRvOK1
 FAqyJkmi/KblCJczUHkGGKTaabvwcBP/RARhXd4I9QK/XEqzIkJrULlDzYbx9/rPYhy3
 zLmWr3/K11BlX3VpU7LaizG8nHi2nq4WbDA47svr+PO9C+C19MCX5KLKZFmws1FTLfWK
 cW3vfLRxweNXFFQAOoj03snrjld4cfSeK+0Y691iZoWIgp95yfbGlT0z7HM8fwCqIa5+ dA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby6gkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:47:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LjupU019817;
        Thu, 7 Jul 2022 21:47:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4udftp9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:47:13 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 267LlDRw021695;
        Thu, 7 Jul 2022 21:47:13 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4udftp92-1;
        Thu, 07 Jul 2022 21:47:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        james.bottomley@hansenpartnership.com, hch@infradead.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/1] target: Unmap fixes
Date:   Thu,  7 Jul 2022 17:47:11 -0400
Message-Id: <165723004399.1762.17536777347084196993.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628022325.14627-1-michael.christie@oracle.com>
References: <20220628022325.14627-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SUV0mOc21dKo2jwefDcvELmDG0cNRjZL
X-Proofpoint-GUID: SUV0mOc21dKo2jwefDcvELmDG0cNRjZL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Jun 2022 21:23:24 -0500, Mike Christie wrote:

> This patch made over Linus's tree fixes a crash hit when we get a
> WRITE SAME with the NDOB bit set or if the initiator has sent a malformed
> WRITE SAME that does not contain any data out buffer even though NDOB=0.
> 
> V2:
> - This version of patch only fixes the crash. It does not implement
> support. Plus other non fix patches put into a feature patchset.
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
      https://git.kernel.org/mkp/scsi/c/ccd3f4490524

-- 
Martin K. Petersen	Oracle Linux Engineering
