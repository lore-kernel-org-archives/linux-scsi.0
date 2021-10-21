Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37014C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224A2611C7
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhJUDpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62900 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231354AbhJUDpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:36 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2C5o5019145;
        Thu, 21 Oct 2021 03:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=GKAa4PD1iXEx8fyyM+wyPuWDC8BXPH3PI/t2Zz0nrck=;
 b=LGPGjf+1gmtNvltpacu3PgMRd6XtFjUZKakEemRNqPrDoxrBTAuDf5mLvVk8W0gMD63u
 WidZuAhA48NlPcC+UiYWPSRRArXuQ/bkMZuDT8RPnsTTJ0xURQY6ne0UAmobCXTCep5T
 XNI5PJrhG/vc/3qtxXs78/3oDO1ik1fjfFNTDxLyBGek1yui9ADru4r/sDs7wp9xa+t6
 nUDYoCBwMLeW5fospx9rY4/tT/epp0SkaHHj20Ml8ZVLVu10rMlOEH9c/OscZeshm2Ry
 FBZQm7uPvdK2kfL51sxyis0CQILPT+NJoHPetWbGl42ASBIAu9D6xD8AyEHZ3OyX2jkX GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esRm078107;
        Thu, 21 Oct 2021 03:43:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshema6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8M082116;
        Thu, 21 Oct 2021 03:43:13 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-19;
        Thu, 21 Oct 2021 03:43:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        alice.chao@mediatek.com, cc.chou@mediatek.com,
        gray.jia@mediatek.com, tun-yu.yu@mediatek.com,
        peter.wang@mediatek.com, lin.gui@mediatek.com,
        chaotian.jing@mediatek.com, eddie.huang@mediatek.com,
        powen.kao@mediatek.com
Subject: Re: [PATCH v2 0/3] scsi: ufs-mediatek: Fix some defects in MediaTek UFS driver
Date:   Wed, 20 Oct 2021 23:42:50 -0400
Message-Id: <163478764104.7011.6113348192247417134.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211016005802.7729-1-stanley.chu@mediatek.com>
References: <20211016005802.7729-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: RTt1DOY23xfbv19yAGm1qSUkA1ttRei7
X-Proofpoint-GUID: RTt1DOY23xfbv19yAGm1qSUkA1ttRei7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 16 Oct 2021 08:57:59 +0800, Stanley Chu wrote:

> This series fixes some defects in MediaTek UFS drivers.
> 
> Change since v1:
> - Add patch [3/3] scsi: ufs-mediatek: Fix wrong place of ref-clk delay
> 
> Peter Wang (1):
>   scsi: ufs-mediatek: Fix wrong place of ref-clk delay
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] scsi: ufs-mediatek: Introduce default delay for reference clock
      https://git.kernel.org/mkp/scsi/c/fc65e933fbcc
[2/3] scsi: ufs-mediatek: Fix build error of using sched_clock()
      https://git.kernel.org/mkp/scsi/c/1eaff502a8f1
[3/3] scsi: ufs-mediatek: Fix wrong place of ref-clk delay
      https://git.kernel.org/mkp/scsi/c/25d542a85374

-- 
Martin K. Petersen	Oracle Linux Engineering
