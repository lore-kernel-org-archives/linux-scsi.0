Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844DFC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiGNEXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiGNEWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D4327CF9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3nDAX009147;
        Thu, 14 Jul 2022 04:22:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=hgg9EWkXajbbbOvkLmnx/vdbF9z2MqBlp+KrAX85iqI=;
 b=wjMLALOPtoGDcZMFV0mOLXuizQe77WLZyQgr9PmuXlxOmBxCSWLD9PhujPaq3HVl4QuI
 XSPZZ2jR1jlte5C3+V+iP0zRtqiUUE8gIlWvYw9YYYVHJduIBMY4fT2hLC5yl7z25qXq
 g2nkAa8W6BYNw8LB0fPkTveShazX0UNxzrbnVGrpRcehOGTpu3eW+G8uyGC51MHU2FVs
 UlUzfKlNaX/oV0qD0QfaNlfHDGC6YiuB8UlwegDCaVdM8TROWLhT2MRWBws+N4JO5i2a
 OzF9dSbbdtJQaXVPxs+pXvlFMbl2a7gBDsFSyZ9QBSxErAkEb2TNiSZmVpFBKAMCzsPl Cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rg3tps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Aop8040444;
        Thu, 14 Jul 2022 04:22:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:38 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBx023864;
        Thu, 14 Jul 2022 04:22:37 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-10;
        Thu, 14 Jul 2022 04:22:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, Seunghui Lee <sh043.lee@samsung.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Junwoo Lee <junwoo80.lee@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: skip last hci reset to get valid register values
Date:   Thu, 14 Jul 2022 00:22:30 -0400
Message-Id: <165777182484.7272.8706649768499227373.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220705083538.15143-1-sh043.lee@samsung.com>
References: <CGME20220705080318epcas1p18896b13b2f7ad16509d7047584f1fe86@epcas1p1.samsung.com> <20220705083538.15143-1-sh043.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: iafcNspFF6xicG3esIr2NPTTzWs95qit
X-Proofpoint-ORIG-GUID: iafcNspFF6xicG3esIr2NPTTzWs95qit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 Jul 2022 17:35:38 +0900, Seunghui Lee wrote:

> Once the host fails to link startup 3 times, all host registers are reset value
> except ufshcd_hba_enable after linkstartup failure.
> 
> The ufs host controller is disabled and enabled in the ufshcd_hba_enable().
> That's why we need to skip last hci reset to get valid host register values.
> 
> e.g.
> [    1.898026] [2:  kworker/u16:2:  211] ufs: link startup failed 1
> [    1.898133] [2:  kworker/u16:2:  211] host_regs: 00000000: 1383ff1f 00000000 00000300 00000000
> [    1.898141] [2:  kworker/u16:2:  211] host_regs: 00000010: 00000106 000001ce 00000000 00000000
> [    1.898148] [2:  kworker/u16:2:  211] host_regs: 00000020: 00000000 00000470 00000000 00000000
> [    1.898155] [2:  kworker/u16:2:  211] host_regs: 00000030: 00000008 00000003 00000000 00000000
> [    1.898163] [2:  kworker/u16:2:  211] host_regs: 00000040: 00000000 00000000 00000000 00000000
> [    1.898171] [2:  kworker/u16:2:  211] host_regs: 00000050: 00000000 00000000 00000000 00000000
> [    1.898177] [2:  kworker/u16:2:  211] host_regs: 00000060: 00000000 00000000 00000000 00000000
> [    1.898186] [2:  kworker/u16:2:  211] host_regs: 00000070: 00000000 00000000 00000000 00000000
> [    1.898194] [2:  kworker/u16:2:  211] host_regs: 00000080: 00000000 00000000 00000000 00000000
> [    1.898201] [2:  kworker/u16:2:  211] host_regs: 00000090: 00000000 00000000 00000000 00000000
> All host registers(standard special function register) are reset value except
> ufshcd_hba_enable after linkstartup failure.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: ufs: skip last hci reset to get valid register values
      https://git.kernel.org/mkp/scsi/c/174e909b5435

-- 
Martin K. Petersen	Oracle Linux Engineering
