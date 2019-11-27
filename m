Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244E2C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 04:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB19B2071E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 04:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pjEVQil8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfK0EPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 23:15:46 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46446 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfK0EPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 23:15:46 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAR4FL1f026273;
        Tue, 26 Nov 2019 22:15:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574828121;
        bh=wT3uBStmO0zs8CxdsXEg1fyzmCCiuamwhYlq5icphfU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=pjEVQil8AxS5Wu73HXta+uN5kXPDTns/4nN/OolK1peBL1nosjT0+L5MF4z3k1ZYp
         1pO8N52mZWPI5DZF8pK3UbxIYK01LnKFCiwWeSMos2HFxEZ1Mo1/SoNRSrLfSFhgmJ
         opCmtmRHviuHHmPAxMutSSxi0qo/MKCXGfy2FZDY=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAR4FL93065540;
        Tue, 26 Nov 2019 22:15:21 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 26
 Nov 2019 22:15:20 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 26 Nov 2019 22:15:20 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAR4FE36093524;
        Tue, 26 Nov 2019 22:15:16 -0600
Subject: Re: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>,
        "'sheebab'" <sheebab@cadence.com>
CC:     "'Avri Altman'" <avri.altman@wdc.com>,
        "'Pedro Sousa'" <pedrom.sousa@synopsys.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Bean Huo (beanhuo)'" <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <rafalc@cadence.com>,
        <mparab@cadence.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
 <1574147082-22725-3-git-send-email-sheebab@cadence.com>
 <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
 <CGME20191121105613epcas4p1a83df10f9f8dcf9edaa583648cad449e@epcas4p1.samsung.com>
 <cfc2c86f-f9ae-ac91-39ac-8bb48c41b243@ti.com>
 <08c701d5a4d4$b20c7300$16255900$@samsung.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <69e16181-e01c-1120-2074-80b9c1eb19ce@ti.com>
Date:   Wed, 27 Nov 2019 09:45:45 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <08c701d5a4d4$b20c7300$16255900$@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alim,

On 27/11/19 9:12 AM, Alim Akhtar wrote:
> 
[...]
>>>> Backup L4 attributes duirng manual hibern8 entry and restore the L4
>>>> attributes on manual hibern8 exit as per JESD220C.
>>>>
>>> Can you point me to the relevant section on the spec?
>>>
>>
>> Per JESD 220C 9.4 UniPro/UFS Control Interface (Control Plane):
>>
>> "NOTE After exit from Hibernate all UniPro Transport Layer attributes (including
>> L4 T_PeerDeviceID,
>>
>> L4 T_PeerCPortID, L4 T_ConnectionState, etc.) will be reset to their reset values.
>> All required attributes
>>
>> must be restored properly on both ends before communication can resume."
>>
>> But its not clear whether SW needs to restore these attributes or hardware
>>
> Thanks Vignesh for pointing out the spec section, yes it is not clear, one way to confirm this is just by read L4 attributes before 
> And after hinern8 entry/exit.

I know that on Cadence UFS controller L4 attributes are definitely lost
on hibernation entry/exit and therefore needs to be restored. But not
sure of other controllers. If this issue is seen on other controllers as
well, then we should probably consider moving this code to core driver
so that there is code reuse.

> (at least in the current platform it is not being done)
> AFA this patch is concerns, this looks ok to me.
> @ Avri , any thought on this?
> 
>> Regards
>> Vignesh
>>

[...]
-- 
Regards
Vignesh
