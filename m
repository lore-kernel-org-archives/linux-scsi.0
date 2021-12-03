Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FF6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 03:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378357AbhLCDHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 22:07:46 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6512 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378342AbhLCDHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 22:07:45 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B31YGGv032323;
        Fri, 3 Dec 2021 03:04:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=mICSE0tJ+YwgUKhuQj0DsB/9BdWs0+amDLBXIOSly6s=;
 b=FWlzewhdiLQ6QlItgQL6g/VClMZHTUDMCDrfc6RmdeVknyj4mcIYKITmHcMvtipt3o+3
 /BPIE2XK/ep5UXropUniH8/5LUI41Pu3SlpbusknY1NGxNmYvIBNGASwuTVQNPsBynv7
 vWIZ2k57HlO/9dtVHCNVh3bFKD+JHfmf7lyXIO83xij2Ma4ejJ4+9yB70zLr8S5XAmy2
 IbG9q1ivfNIvSWwfO9x+rNBzHlHauiOurwYRKmRYWE9n73gulK1JLUonQb0JogaDPEbI
 ZH/OhsVimABwOX2CSDIrDig+G+DzESJJhiYfQgPiwcPh+l97GyNVEgbizxG/bTTROjzZ pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp7wewc69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:04:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B331qjJ188465;
        Fri, 3 Dec 2021 03:04:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3cnhvht9gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:04:01 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B3340iY003616;
        Fri, 3 Dec 2021 03:04:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3cnhvht9f3-2;
        Fri, 03 Dec 2021 03:04:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/12] A series of small SCSI patches
Date:   Thu,  2 Dec 2021 22:03:58 -0500
Message-Id: <163850060429.30297.12117097163872133765.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: a1tZHAnHHIYJB38AhDCqxoKNpei7sktZ
X-Proofpoint-GUID: a1tZHAnHHIYJB38AhDCqxoKNpei7sktZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Nov 2021 11:45:57 -0800, Bart Van Assche wrote:

> This patch series fixes a number of static checker warnings. Most of these
> patches fix warnings introduced during the merge window.
> 
> Please consider these patches for kernel v5.17.
> 
> Thanks,
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[01/12] scsi: core: Suppress a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/776141dda77f
[02/12] scsi: core: Declare 'scsi_scan_type' static
        https://git.kernel.org/mkp/scsi/c/7cc5aad6c98e
[03/12] scsi: core: Show SCMD_LAST in text form
        https://git.kernel.org/mkp/scsi/c/3369046e54ca
[04/12] scsi: a100u2w: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/332053e87cda
[05/12] scsi: atp870u: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/471d6840559a
[06/12] scsi: bfa: Declare 'bfad_im_vport_attrs' static
        https://git.kernel.org/mkp/scsi/c/69e623791eb3
[07/12] scsi: dc395x: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/013d14eafd5c
[08/12] scsi: initio: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/0addfa587797
[09/12] scsi: megaraid: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/acad9c432499
[10/12] scsi: pm8001: Fix kernel-doc warnings
        https://git.kernel.org/mkp/scsi/c/d6e71a43b11c
[11/12] scsi: pmcraid: Fix a kernel-doc warning
        https://git.kernel.org/mkp/scsi/c/b558fa11e4b5
[12/12] scsi: Remove superfluous #include <linux/async.h> directives
        https://git.kernel.org/mkp/scsi/c/db33028647a3

-- 
Martin K. Petersen	Oracle Linux Engineering
