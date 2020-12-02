Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0348EC64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F6B221E9
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgLBHhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 02:37:22 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:39157 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLBHhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 02:37:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606894622; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=zn9zKUogHkTpu4hqDPdgxv9s4TFFHlGGfE+xtDidB9c=;
 b=RlyQaZ325+l0q6PLvHamq7LOreDysgiYqwYNZ+wKlYKdjtg2jA4YkTG0iOEqATiIryTtDVhW
 B+DEvQ7OOaULZkoujmqCqmIvIrZc+2kIDiLMeZ8+nA1IQsGfVtWWI77aTj3KB8IjgCPooBJY
 AoY9Du7lDufgchazHPtpqjJ8KbA=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fc74401265512b1b2a82d07 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 07:36:33
 GMT
Sender: nguyenb=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5DECAC43462; Wed,  2 Dec 2020 07:36:33 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 727A0C433ED;
        Wed,  2 Dec 2020 07:36:31 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 01 Dec 2020 23:36:31 -0800
From:   nguyenb@quicinc.com
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, chaotian.jing@mediatek.com,
        cc.chou@mediatek.com, jiajie.hao@mediatek.com,
        alice.chao@mediatek.com
Subject: Re: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage
 values
In-Reply-To: <1606805690.23925.29.camel@mtkswgap22>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
 <568660cd-80e6-1b8f-d426-4614c9159ff4@codeaurora.org>
 <X8V83T+Tx6teNLOR@builder.lan>
 <4335d590-0506-d920-8e7f-f0f0372780f9@codeaurora.org>
 <1606785904.23925.25.camel@mtkswgap22>
 <d998857a-1744-a8bb-1a3e-77166c171f37@codeaurora.org>
 <1606805690.23925.29.camel@mtkswgap22>
Message-ID: <66ec58decfa1a0096cf5ed34560655ee@quicinc.com>
X-Sender: nguyenb@quicinc.com
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-30 22:54, Stanley Chu wrote:
> Hi Asutosh,
> 
> On Mon, 2020-11-30 at 19:07 -0800, Asutosh Das (asd) wrote:
>> On 11/30/2020 5:25 PM, Stanley Chu wrote:
>> > On Mon, 2020-11-30 at 15:54 -0800, Asutosh Das (asd) wrote:
>> >> On 11/30/2020 3:14 PM, Bjorn Andersson wrote:
>> >>> On Mon 30 Nov 16:51 CST 2020, Asutosh Das (asd) wrote:
>> >>>
>> >>>> On 11/30/2020 1:16 AM, Stanley Chu wrote:
>> >>>>> UFS specficication allows different VCC configurations for UFS devices,
>> >>>>> for example,
>> >>>>> 	(1). 2.70V - 3.60V (By default)
>> >>>>> 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>> >>>>>                              device tree)
>> >>>>> 	(3). 2.40V - 2.70V (Supported since UFS 3.x)
>> >>>>>
>> >>>>> With the introduction of UFS 3.x products, an issue is happening that
>> >>>>> UFS driver will use wrong "min_uV/max_uV" configuration to toggle VCC
>> >>>>> regulator on UFU 3.x products with VCC configuration (3) used.
>> >>>>>
>> >>>>> To solve this issue, we simply remove pre-defined initial VCC voltage
>> >>>>> values in UFS driver with below reasons,
>> >>>>>
>> >>>>> 1. UFS specifications do not define how to detect the VCC configuration
>> >>>>>       supported by attached device.
>> >>>>>
>> >>>>> 2. Device tree already supports standard regulator properties.
>> >>>>>
>> >>>>> Therefore VCC voltage shall be defined correctly in device tree, and
>> >>>>> shall not be changed by UFS driver. What UFS driver needs to do is simply
>> >>>>> enabling or disabling the VCC regulator only.
>> >>>>>
>> >>>>> This is a RFC conceptional patch. Please help review this and feel
>> >>>>> free to feedback any ideas. Once this concept is accepted, and then
>> >>>>> I would post a more completed patch series to fix this issue.
>> >>>>>
>> >>>>> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>> >>>>> ---
>> >>>>>     drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +---------
>> >>>>>     1 file changed, 1 insertion(+), 9 deletions(-)
>> >>>>>
>> >>>>> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> >>>>> index a6f76399b3ae..3965be03c136 100644
>> >>>>> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
>> >>>>> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
>> >>>>> @@ -133,15 +133,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
>> >>>>>     		vreg->max_uA = 0;
>> >>>>>     	}
>> >>>>> -	if (!strcmp(name, "vcc")) {
>> >>>>> -		if (of_property_read_bool(np, "vcc-supply-1p8")) {
>> >>>>> -			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
>> >>>>> -			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
>> >>>>> -		} else {
>> >>>>> -			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
>> >>>>> -			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
>> >>>>> -		}
>> >>>>> -	} else if (!strcmp(name, "vccq")) {
>> >>>>> +	if (!strcmp(name, "vccq")) {
>> >>>>>     		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
>> >>>>>     		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
>> >>>>>     	} else if (!strcmp(name, "vccq2")) {
>> >>>>>
>> >>>>
>> >>>> Hi Stanley
>> >>>>
>> >>>> Thanks for the patch. Bao (nguyenb) was also working towards something
>> >>>> similar.
>> >>>> Would it be possible for you to take into account the scenario in which the
>> >>>> same platform supports both 2.x and 3.x UFS devices?
>> >>>>
>> >>>> These've different voltage requirements, 2.4v-3.6v.
>> >>>> I'm not sure if standard dts regulator properties can support this.
>> >>>>
>> >>>
>> >>> What is the actual voltage requirement for these devices and how does
>> >>> the software know what voltage to pick in this range?
>> >>>
>> >>> Regards,
>> >>> Bjorn
>> >>>
>> >>>> -asd
>> >>>>
>> >>>>
>> >>>> --
>> >>>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
>> >>>> Linux Foundation Collaborative Project
>> >>
>> >> For platforms that support both 2.x (2.7v-3.6v) and 3.x (2.4v-2.7v), the
>> >> voltage requirements (Vcc) are 2.4v-3.6v. The software initializes the
>> >> ufs device at 2.95v & reads the version and if the device is 3.x, it may
>> >> do the following:
>> >> - Set the device power mode to SLEEP
>> >> - Disable the Vcc
>> >> - Enable the Vcc and set it to 2.5v
>> >> - Set the device power mode to ACTIVE
>> >>
>> >> All of the above may be done at HS-G1 & moved to max supported gear
>> >> based on the device version, perhaps?
>> >
>> > Hi Asutosh,
>> >
>> > Thanks for sharing this idea.
>> >
>> > 1. I did not see above flow defined in UFS specifications, please
>> > correct me if I was wrong.
>> >
>> > 2. For above flow, the concern is that I am not sure if all devices
>> > supporting VCC (2.4v - 2.7v) can accept higher voltage, say 2.95v, for
>> > version detection.
>> >
>> > 3. For version detection, another concern is that I am not sure if all
>> > 3.x devices support VCC (2.4v - 2.7v) only, or in other words, I am not
>> > sure if all 2.x devices support VCC (2.7v - 3.6v) only. The above rule
>> > will break any devices not obeying this "conventions".
>> >
>> > For platforms that support both 2.x (2.7v-3.6v) and 3.x (2.4v-2.7v),
>> >
>> > It would be good for UFS drivers detecting the correct voltage if the
>> > protocol is well-defined in specifications. Until that day, any
>> > "non-standard" way may be better implemented in vendor's ops?
>> >
>> > If the vop concept works on your platform, we could still keep struct
>> > ufs_vreg and allow vendors to configure proper min_uV and max_uV to make
>> > regulator_set_voltage() works during VCC toggling flow. Without specific
>> > vendor configurations, min_uV and max_uV would be NULL by default and
>> > UFS core driver will only enable/disasble VCC regulator only without
>> > adjusting its voltage.
>> >
>> 
>> I think this would work. Do you plan to implement this?
>> If not, I can take this up. Please let me know.
> 
> Thanks for the understanding and support.
> 
> I would like to re-post this patch to simply removing the pre-defined
> initial values of all device powers.
> 
> For vop idea supporting the voltage detection way, could you please 
> take
> it up since this would be better to fit what you need for fixing this
> issue?
> 
> Thanks,
> Stanley Chu
While we are on this topic, another similar concern is how to set the 
UFS's regulators loading to Low Power Mode (LPM).
Currently, the UFS_VREG_LPM_LOAD_UA is hardcoded to 1mA in the driver, 
and it is invoked by the ufshcd_config_vreg_lpm().
However, for some platforms, to put the regulators into LPM mode, it may 
be a different value than 1mA.
Should we be using ufs_vreg's min_uA in the ufshcd_config_vreg_lpm() 
instead of using the hardcoded value?
And the ufs_vreg's min_uA value would be parsed by the vendor's code?
We can post a proposal if this sounds ok.

Regards,
Bao

> 
> 
>> 
>> > Maybe one possible another idea is to decide the correct voltage and
>> > configure regulator properly before kernel?
>> >
>> > Thanks,
>> > Stanley Chu
>> >
>> >>
>> >> Am open to other ideas though.
>> >>
>> >> -asd
>> >>
>> >
>> 
>> -asd
>> 
>> 
