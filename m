Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A363C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 20:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F64022CA1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 20:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgHEULZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:11:25 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2578 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726718AbgHEQ1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Aug 2020 12:27:43 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 45AB6F258C251E3768F9;
        Wed,  5 Aug 2020 17:27:37 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.153) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 5 Aug 2020
 17:27:35 +0100
Subject: Re: [PATCH V6 2/2] pm80xx : Staggered spin up support.
To:     <Deepak.Ukey@microchip.com>, <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>,
        <chenxiang66@hisilicon.com>, <yanaijie@huawei.com>,
        <luojiaxing@huawei.com>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
 <20200804060235.GA28428@infradead.org>
 <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
 <1d09bf1a-f555-b5de-a369-9797f96b2e9d@huawei.com>
 <MWHPR11MB1568027073E64A535B278D32EF4A0@MWHPR11MB1568.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4a11caf7-933a-1079-526c-b5c97183ac04@huawei.com>
Date:   Wed, 5 Aug 2020 17:25:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1568027073E64A535B278D32EF4A0@MWHPR11MB1568.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.153]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/08/2020 10:51, Deepak.Ukey@microchip.com wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 04/08/2020 07:33,Deepak.Ukey@microchip.com  wrote:
>> Hi Christoph,
>>
>> Yes, It is better to be implemented in libsas. Since the out of box pm80xx driver has this support, we would like to push this for the time being. We will see how this can be moved to libsas.
>>
> Other libsas users may like this feature. And libsas does already support SATA spin-up hold events - as does pm8001 - but there's not really much to that in libsas.
> 
> Question: why have a module param to enable this feature? Why not solely rely on the seeprom spin-up interval, whereby a value of 0 means no staggered spin-up?
> - Setting spin-up interval may increase the time for device discovery.  Customer who has a valid spin up interval  

Please use standard mailing list practices in replying.

      - configured can still turn of this using module parameter. Or 
else, they have to reflash the seeprom.

So another knob to control the driver. Anyway I think that it would be 
good for libsas to support this feature to benefit all users.

All the tunables from the LLDD can be fed to libsas, and libsas just 
needs to do what you do in pm8001_spinup_timedout() to callback to the 
LLDD to enable the SPINUP.

BTW, out of interest, what is this change for:

 >   void pm8001_scan_start(struct Scsi_Host *shost)
 >   {
 >   	int i;
 > +	unsigned long lock_flags;
 >   	struct pm8001_hba_info *pm8001_ha;
 >   	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 > +	DECLARE_COMPLETION(comp);

note: this should be the _ONSTACK() variant, and is it safe to even 
reuse in the loop, below?

 >   	pm8001_ha = sha->lldd_ha;
 >   	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
 >   	if (pm8001_ha->chip_id == chip_8001)
 >   		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
 > -	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
 > -		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
 > +
 > +	if (pm8001_ha->pdev->device == 0x8001 ||
 > +		pm8001_ha->pdev->device == 0x8081 ||
 > +		(pm8001_ha->spinup_interval != 0)) {
 > +		for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
 > +			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
 > +	} else {
 > +		for (i = 0; i < pm8001_ha->chip->n_phy; ++i) {
 > +			spin_lock_irqsave(&pm8001_ha->lock, lock_flags);
 > +			pm8001_ha->phy_started = i;
 > +			pm8001_ha->scan_completion = &comp;
 > +			pm8001_ha->phystart_timedout = 1;
 > +			spin_unlock_irqrestore(&pm8001_ha->lock, lock_flags);
 > +			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
 > +			wait_for_completion_timeout(&comp,
 > +				msecs_to_jiffies(500));
 > +			if (pm8001_ha->phystart_timedout)
 > +				PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
 > +				"Timeout happened for phyid = %d\n", i));
 > +		}
 > +		spin_lock_irqsave(&pm8001_ha->lock, lock_flags);
 > +		pm8001_ha->phy_started = -1;
 > +		pm8001_ha->scan_completion = NULL;
 > +		spin_unlock_irqrestore(&pm8001_ha->lock, lock_flags);
 > +	}
 >   }
 >

Thanks,
John
