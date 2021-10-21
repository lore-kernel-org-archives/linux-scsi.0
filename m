Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2761C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3670611C7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhJUDpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUDpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L23hqD019155;
        Thu, 21 Oct 2021 03:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=cfxN/ty/4DJOfN/jAX6xqv6eqw18xg8beAtJrIXaGjY=;
 b=A06xmginDEXq1Y1UssUHOSNWngUP0ZQIjv025u7SI3eVVMdMWUPEUrC9xHtTsnCPw/tI
 onqG0uolAPjgp6zEa1o/Yoo5fqIqi1StZ0ALmriePgQ7P6wuGgVqfKSP4ZsclamJpK5g
 a65osuRd4pwHa+nGGcHZ6qbTydhqz4gUuowdXnGa2i1gPlYH3ojJUUPoBHb87PDVMEEs
 5aDzlhPfzbg3luurGM2oHNijvuRIzNKVO9fchgS2R0Siy1Y/vE3lZXMu+bQc8MBhyJGV
 dYhgHMawLm5vaOjY5T0V5PTSAIm8Xdn8wGrJRo6qUuEqIyZSH1D5F+UMDEYLofiGNuR7 jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esj1078017;
        Thu, 21 Oct 2021 03:42:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:58 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7s082116;
        Thu, 21 Oct 2021 03:42:58 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-5;
        Thu, 21 Oct 2021 03:42:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/46] Register SCSI sysfs attributes earlier
Date:   Wed, 20 Oct 2021 23:42:36 -0400
Message-Id: <163478764102.7011.9375895285870786953.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wGUD_CZF_r8-4SmTC-6FmjVBdztgBJCn
X-Proofpoint-GUID: wGUD_CZF_r8-4SmTC-6FmjVBdztgBJCn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2021 16:35:12 -0700, Bart Van Assche wrote:

> For certain user space software, e.g. udev, it is important that sysfs
> attributes are registered before the KOBJ_ADD uevent is emitted. Hence
> this patch series that removes the device_create_file() and
> sysfs_create_groups() calls from the SCSI core. Please consider this
> patch series for kernel v5.16.
> 
> Thanks,
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[01/46] scsi: core: Register sysfs attributes earlier
        https://git.kernel.org/mkp/scsi/c/92c4b58b15c5
[02/46] ata: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/c3f69c7f629f
[03/46] firewire: sbp2: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/5e88e67b6f3b
[04/46] RDMA/srp: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/a3cf94c96ede
[05/46] scsi: message: fusion: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/2899836f9430
[06/46] scsi: zfcp: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/d8d7cf3f7d07
[07/46] scsi: 3w-9xxx: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/bd21c1e9891f
[08/46] scsi: 3w-sas: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/8de1cc904e17
[09/46] scsi: 3w-xxxx: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/65bc2a7fd83e
[10/46] scsi: 53c700: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/90cb6538b5da
[11/46] scsi: aacraid: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/bd16d71185c8
[12/46] scsi: arcmsr: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/f2523502a40a
[13/46] scsi: be2iscsi: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/ebcbac342cb5
[14/46] scsi: bfa: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/e73af234a1a2
[15/46] scsi: bnx2fc: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/c3dd11d8ed4d
[16/46] scsi: bnx2i: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/eb78ac7a5474
[17/46] scsi: csiostor: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/623cf762c73e
[18/46] scsi: cxlflash: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/780c678912fb
[19/46] scsi: fnic: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/d6ddcd8b38ab
[20/46] scsi: hisi_sas: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/62ac8ccbb819
[21/46] scsi: hpsa: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/4cd16323b523
[22/46] scsi: hptiop: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/e8fbc28e7fc7
[23/46] scsi: ibmvscsi: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/c7da4e1cd040
[24/46] scsi: ibmvfc: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/7adbf68f4950
[25/46] scsi: ipr: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/47d1e6ae0e1e
[26/46] scsi: isci: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/7eae6af530a6
[27/46] scsi: lpfc: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/08adfa753743
[28/46] scsi: megaraid: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/09723bb252ca
[29/46] scsi: mpt3sas: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/1bb3ca27d2ca
[30/46] scsi: mvsas: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/88b8132cff99
[31/46] scsi: myrb: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/582c0360db90
[32/46] scsi: myrs: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/087c3ace6337
[33/46] scsi: ncr53c8xx: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/aec4b25c8572
[34/46] scsi: sym53c500_cs: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/e71eebf744e4
[35/46] scsi: pm8001: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/c03b72b86c77
[36/46] scsi: pmcraid: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/646bed7e6f45
[37/46] scsi: qedf: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/232cb469d24e
[38/46] scsi: qedi: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/1ebbd3b1d9a7
[39/46] scsi: qla2xxx: Remove a declaration
        https://git.kernel.org/mkp/scsi/c/f8f8f857e7df
[40/46] scsi: qla2xxx: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/66df386d0b74
[41/46] scsi: qla4xxx: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/a8b476fc86d9
[42/46] scsi: smartpqi: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/64fc9015fbeb
[43/46] scsi: snic: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/7500be62910d
[44/46] scsi: unisys: Remove the shost_attrs member
        https://git.kernel.org/mkp/scsi/c/7ce6000a77cc
[45/46] scsi: usb: Switch to attribute groups
        https://git.kernel.org/mkp/scsi/c/01e570febaaa
[46/46] scsi: core: Remove two host template members that are no longer used
        https://git.kernel.org/mkp/scsi/c/a47c6b713e89

-- 
Martin K. Petersen	Oracle Linux Engineering
