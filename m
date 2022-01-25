Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C704C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 05:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbiAYFna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 00:43:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43434 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235465AbiAYFlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 00:41:06 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20P3K9Br005517;
        Tue, 25 Jan 2022 05:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=xlHSmMMifEurCv+6d/bVV2vC8ZWoCeHFCgsfl586NDQ=;
 b=RWyZtQrmI1U0xfuV6x8qze1/EJATCsjnkk4xlHHrGn6OUXSdl+RkelzCHTUqHh7+t0UI
 V7sMstrDC3SwBvcexSsOow8HZ6pmctYEfke3QItLg7QKrDuFwAPker1OrCMXoAJytKLH
 uFQNZSb7IqnMccdF771BJ2QgviXEAquIspZ6YkZMMb3IKWK4JKhM59a1l09a+dJ6jk20
 6ua+XgnO1neyBCu59V07q44BPxhumFqGs6qCGnqv/FmUk9voX0YPB0Kb8P7qUytLs1ZV
 wb16bv5GcKWdmplPzk/RWCi5Bk927sG31/fhtlLkaghsZqrEpwDxwCPV+pxAW2rwPGrK TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dswh9j7u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20P5evWR181750;
        Tue, 25 Jan 2022 05:41:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dr71x1srd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 05:41:02 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20P5evOb181790;
        Tue, 25 Jan 2022 05:41:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dr71x1sgc-6;
        Tue, 25 Jan 2022 05:41:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH] zfcp: fix failed recovery on gone remote port with non-NPIV FCP devices
Date:   Tue, 25 Jan 2022 00:40:42 -0500
Message-Id: <164308671271.32373.2878476881217752247.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118165803.3667947-1-maier@linux.ibm.com>
References: <20220118165803.3667947-1-maier@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 7-NFqmQqRlV11snyO832LM7Pz__SOQyo
X-Proofpoint-GUID: 7-NFqmQqRlV11snyO832LM7Pz__SOQyo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 Jan 2022 17:58:03 +0100, Steffen Maier wrote:

> Suppose we have an environment with a number of non-NPIV FCP devices
> (virtual HBAs / FCP devices / zfcp "adapter"s) sharing the same physical
> FCP channel (HBA port) and its I_T nexus. Plus a number of storage target
> ports zoned to such shared channel. Now one target port logs out of the
> fabric causing an RSCN. Zfcp reacts with an ADISC ELS and subsequent port
> recovery depending on the ADISC result. This happens on all such FCP
> devices (in different Linux images) concurrently as they all receive a copy
> of this RSCN. In the following we look at one of those FCP devices.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] zfcp: fix failed recovery on gone remote port with non-NPIV FCP devices
      https://git.kernel.org/mkp/scsi/c/8c9db6679be4

-- 
Martin K. Petersen	Oracle Linux Engineering
