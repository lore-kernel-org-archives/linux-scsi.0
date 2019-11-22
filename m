Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2EAC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 11:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6660020714
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 11:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MmAtDb/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfKVLpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:45:23 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56622 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKVLpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 06:45:23 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAMBhpKa102645;
        Fri, 22 Nov 2019 05:43:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574423031;
        bh=5rJlm63UVTkhCHrw2W6wXofUd19jkVn8cXok6W3vCrE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=MmAtDb/SuOxLg/cMSBaFOuAFsMfYfo61hHvQprDVlsUUkX7UyoEZe39J+XDu4FTTh
         QiegjFzEu0YXUrQa6GBwC3UJ3d2FC1ME0Cx42j7162Ey3RkQme+DWa8vrAya0TpLT0
         YGPXzNwUJ1UN/FYXmgUFq5L6uvRlsLjtwAiEMQW0=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAMBhpOu066881;
        Fri, 22 Nov 2019 05:43:51 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 22
 Nov 2019 05:43:51 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 22 Nov 2019 05:43:51 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAMBhkWD086656;
        Fri, 22 Nov 2019 05:43:47 -0600
Subject: Re: [PATCH RESEND 0/2] scsi: ufs: hibern8 fixes
To:     sheebab <sheebab@cadence.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <pedrom.sousa@synopsys.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>
CC:     <rafalc@cadence.com>, <mparab@cadence.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <ae8a7e7e-f60c-0ba3-4a98-78c4c962ae4d@ti.com>
Date:   Fri, 22 Nov 2019 17:14:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 19/11/19 12:34 PM, sheebab wrote:
> Hi,
> 
> Resending this patch to include mailing list and miss out patches.
> 
> This patch set contains following patches
> for Cadence UFS controller driver.
> 
> 1. 0001-scsi-ufs-Enable-hibern8-interrupt-only-during-manual.patch
>    This patch is to fix false interrupt assertion during auto hibernation.
>    In this patch, hibern8 interrupt is Disabled during initialization
>    and later the interrupt is Enabled/Disabled during manual hibern8
>    Entry/Exit.
> 2. 0002-scsi-ufs-Update-L4-attributes-on-manual-hibern8-exit.patch
>    This patch is to update L4 attributes during manual hibern8 exit.
>    As per JESD220C spec, L4 attributes will be reset to their reset value 
>    during DME_HIBERNATION_EXIT. This patch will take backup of the L4 
>    parameters before DME_HIBERNATION_ENTER and restores the L4 parameters
>    after DME_HIBERNATION_EXIT
>  

While I don't see flood of hibernate related interrupts anymore, I
occasionally see "Unhandled Interrupt dump"[1] when using rootfs out of
UFS. I haven't be able to find a way to trigger the issue. But seems to
happen randomly while trying to input and execute something from console.


[1]
j7-evm login: root
[   55.300495] cdns-ufshcd 4e84000.ufs: ufshcd_intr: Unhandled interrupt
0x00000000
[   55.307884] host_regs: 00000000: 1587031f 00000000 00000210 00000000
[   55.314217] host_regs: 00000010: 00000000 00000000 00000c96 00000000
[   55.320551] host_regs: 00000020: 00000014 00030e15 00000000 00000000
[   55.326884] host_regs: 00000030: 0000010f 00000001 00000000 80000002
[   55.333217] host_regs: 00000040: 00000000 00000000 00000000 00000000
[   55.339551] host_regs: 00000050: c1ee0000 00000008 00008000 00000000
[   55.345884] host_regs: 00000060: 00000001 ffffffff 00000000 00000000
[   55.352217] host_regs: 00000070: c1ef0000 00000008 00000000 00000000
[   55.358550] host_regs: 00000080: 00000001 00000000 00000000 00000000
[   55.364884] host_regs: 00000090: 00000002 15710000 00000000 00000000

More such occurrence: https://pastebin.ubuntu.com/p/Df4dykkTmB/



> 
> Thanks,
> Sheeba B
> 
> sheebab (2):
>   scsi: ufs: Enable hibern8 interrupt only during manual hibern8 in
>     Cadence UFS.
>   scsi: ufs: Update L4 attributes on manual hibern8 exit in Cadence UFS.
> 
>  drivers/scsi/ufs/cdns-pltfrm.c | 172 +++++++++++++++++++++++++++++++++--
>  1 file changed, 167 insertions(+), 5 deletions(-)
> 

-- 
Regards
Vignesh
