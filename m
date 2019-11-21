Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9435AC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 10:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4C4208A1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 10:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="iW2Sym4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUK4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:56:15 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50126 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUK4O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 05:56:14 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xALAthcK026316;
        Thu, 21 Nov 2019 04:55:43 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574333743;
        bh=BN2cOGR0bwSm+uHqvrKwYNrZacJcbpFiZui1RldBkdA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=iW2Sym4SpEH0edQkHk1ql6Ls1TYm9nYirNeZR5AF6CsvcPnpQxFz5nUVM1brbVxXy
         J3vMh1iw7E6VN5QEFkx4+nlsqy22d70pqsGJ46WXFHUls2966LHBOvjTdMj9uXOhNK
         0Jpy0tpEogNoDVgVm97ivMFkPB9OsVpM/h3qPGiU=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xALAthZx068246
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 04:55:43 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 04:55:43 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 04:55:43 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xALAtcCc041419;
        Thu, 21 Nov 2019 04:55:39 -0600
Subject: Re: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
To:     Alim Akhtar <alim.akhtar@gmail.com>, sheebab <sheebab@cadence.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <rafalc@cadence.com>,
        <mparab@cadence.com>
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
 <1574147082-22725-3-git-send-email-sheebab@cadence.com>
 <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <cfc2c86f-f9ae-ac91-39ac-8bb48c41b243@ti.com>
Date:   Thu, 21 Nov 2019 16:26:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 20/11/19 9:50 PM, Alim Akhtar wrote:
> Hi Sheebab
> 
> On Tue, Nov 19, 2019 at 12:38 PM sheebab <sheebab@cadence.com> wrote:
>>
>> Backup L4 attributes duirng manual hibern8 entry
>> and restore the L4 attributes on manual hibern8 exit as per JESD220C.
>>
> Can you point me to the relevant section on the spec?
> 

Per JESD 220C 9.4 UniPro/UFS Control Interface (Control Plane):

"NOTE After exit from Hibernate all UniPro Transport Layer attributes (including L4 T_PeerDeviceID, 

L4 T_PeerCPortID, L4 T_ConnectionState, etc.) will be reset to their reset values. All required attributes 

must be restored properly on both ends before communication can resume."

But its not clear whether SW needs to restore these attributes or hardware

Regards
Vignesh

>> Signed-off-by: sheebab <sheebab@cadence.com>
>> ---
>>  drivers/scsi/ufs/cdns-pltfrm.c | 97 +++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 95 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
>> index adbbd60..5510567 100644
>> --- a/drivers/scsi/ufs/cdns-pltfrm.c
>> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
>> @@ -19,6 +19,14 @@
>>
>>  #define CDNS_UFS_REG_HCLKDIV   0xFC
>>  #define CDNS_UFS_REG_PHY_XCFGD1        0x113C
>> +#define CDNS_UFS_MAX 12
>> +
>> +struct cdns_ufs_host {
>> +       /**
>> +        * cdns_ufs_dme_attr_val - for storing L4 attributes
>> +        */
>> +       u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX];
>> +};
>>
>>  /**
>>   * cdns_ufs_enable_intr - enable interrupts
>> @@ -47,6 +55,77 @@ static void cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)
>>  }
>>
>>  /**
>> + * cdns_ufs_get_l4_attr - get L4 attributes on local side
>> + * @hba: per adapter instance
>> + *
>> + */
>> +static void cdns_ufs_get_l4_attr(struct ufs_hba *hba)
>> +{
>> +       struct cdns_ufs_host *host = ufshcd_get_variant(hba);
>> +
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
>> +                      &host->cdns_ufs_dme_attr_val[0]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
>> +                      &host->cdns_ufs_dme_attr_val[1]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
>> +                      &host->cdns_ufs_dme_attr_val[2]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
>> +                      &host->cdns_ufs_dme_attr_val[3]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
>> +                      &host->cdns_ufs_dme_attr_val[4]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
>> +                      &host->cdns_ufs_dme_attr_val[5]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
>> +                      &host->cdns_ufs_dme_attr_val[6]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
>> +                      &host->cdns_ufs_dme_attr_val[7]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
>> +                      &host->cdns_ufs_dme_attr_val[8]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
>> +                      &host->cdns_ufs_dme_attr_val[9]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
>> +                      &host->cdns_ufs_dme_attr_val[10]);
>> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
>> +                      &host->cdns_ufs_dme_attr_val[11]);
>> +}
>> +
>> +/**
>> + * cdns_ufs_set_l4_attr - set L4 attributes on local side
>> + * @hba: per adapter instance
>> + *
>> + */
>> +static void cdns_ufs_set_l4_attr(struct ufs_hba *hba)
>> +{
>> +       struct cdns_ufs_host *host = ufshcd_get_variant(hba);
>> +
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
>> +                      host->cdns_ufs_dme_attr_val[0]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
>> +                      host->cdns_ufs_dme_attr_val[1]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
>> +                      host->cdns_ufs_dme_attr_val[2]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
>> +                      host->cdns_ufs_dme_attr_val[3]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
>> +                      host->cdns_ufs_dme_attr_val[4]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
>> +                      host->cdns_ufs_dme_attr_val[5]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
>> +                      host->cdns_ufs_dme_attr_val[6]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
>> +                      host->cdns_ufs_dme_attr_val[7]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
>> +                      host->cdns_ufs_dme_attr_val[8]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
>> +                      host->cdns_ufs_dme_attr_val[9]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
>> +                      host->cdns_ufs_dme_attr_val[10]);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
>> +                      host->cdns_ufs_dme_attr_val[11]);
>> +}
>> +
>> +/**
>>   * Sets HCLKDIV register value based on the core_clk
>>   * @hba: host controller instance
>>   *
>> @@ -134,6 +213,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
>>                  * before manual hibernate entry.
>>                  */
>>                 cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
>> +               cdns_ufs_get_l4_attr(hba);
>>         }
>>         if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT) {
>>                 /**
>> @@ -141,6 +221,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
>>                  * after manual hibern8 exit.
>>                  */
>>                 cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
>> +               cdns_ufs_set_l4_attr(hba);
>>         }
>>  }
>>
>> @@ -245,15 +326,27 @@ static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
>>         const struct of_device_id *of_id;
>>         struct ufs_hba_variant_ops *vops;
>>         struct device *dev = &pdev->dev;
>> +       struct cdns_ufs_host *host;
>> +       struct ufs_hba *hba;
>>
>>         of_id = of_match_node(cdns_ufs_of_match, dev->of_node);
>>         vops = (struct ufs_hba_variant_ops *)of_id->data;
>>
>>         /* Perform generic probe */
>>         err = ufshcd_pltfrm_init(pdev, vops);
>> -       if (err)
>> +       if (err) {
>>                 dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
>> -
>> +               goto out;
>> +       }
>> +       host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
>> +       if (!host) {
>> +               err = -ENOMEM;
>> +               dev_err(dev, "%s: no memory for cdns host\n", __func__);
>> +               goto out;
>> +       }
>> +       hba =  platform_get_drvdata(pdev);
>> +       ufshcd_set_variant(hba, host);
>> +out:
>>         return err;
>>  }
>>
>> --
>> 2.7.4
>>
> 
> 

-- 
Regards
Vignesh
