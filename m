Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7ECC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8231A21D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:25:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vugkcxJo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgIOIZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:25:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42777 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgIOIPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 04:15:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600157724; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=pSgbry1PAaBdRWEhUEVxrVeaHzZFoZPrjHZu+EwHtIw=;
 b=vugkcxJoL2pQEKqtdBhXWIzscb1LWw9jjNLBf+7QevmUk3PflhLx2Y0xdmi1i4QS5YXeLMnq
 SaC+X9qFdcjBBHydEIcW7JOORYVQBtIBgXhknZns8Sppary3oWJIo/6fuP4vlUoQYB8wUQo/
 P3PjdgNfc/0nJXKvtbCppJ71FC8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f6077f8885efaea0a56a88e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 08:14:48
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 101CDC433CA; Tue, 15 Sep 2020 08:14:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4097EC433C8;
        Tue, 15 Sep 2020 08:14:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Sep 2020 01:14:47 -0700
From:   nguyenb@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Vinod Koul <vkoul@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: dt-bindings: ufs: Add vcc-voltage-level for
 UFS
In-Reply-To: <20200915044154.GB670377@yoga>
References: <cover.1598939393.git.nguyenb@codeaurora.org>
 <0a9d395dc38433501f9652a9236856d0ac840b77.1598939393.git.nguyenb@codeaurora.org>
 <20200915044154.GB670377@yoga>
Message-ID: <748d238a3d9e53834a498c6f37f9f3c9@codeaurora.org>
X-Sender: nguyenb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-14 21:41, Bjorn Andersson wrote:
> On Tue 01 Sep 01:00 CDT 2020, Bao D. Nguyen wrote:
> 
>> UFS's specifications supports a range of Vcc operating
>> voltage levels. Add documentation for the UFS's Vcc voltage
>> levels setting.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt 
>> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index 415ccdd..7257b32 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -23,6 +23,8 @@ Optional properties:
>>                            with "phys" attribute, provides phandle to 
>> UFS PHY node
>>  - vdd-hba-supply        : phandle to UFS host controller supply 
>> regulator node
>>  - vcc-supply            : phandle to VCC supply regulator node
>> +- vcc-voltage-level     : specifies voltage levels for VCC supply.
>> +                          Should be specified in pairs (min, max), 
>> units uV.
> 
> What exactly are these pairs representing?
The pair is the min and max Vcc voltage request to the PMIC chip.
As a result, the regulator output voltage would only be in this range.

> 
> Is this supposed to be 3 pairs of (min,max) for vcc, vcc and vccq2 to 
> be
> passed into a regulator_set_voltage() for each regulator?
Yes, that's right. I should include the other power supplies in this 
change as well.
> 
> Or are these some sort of "operating points" for the vcc-supply?
> 
> Regards,
> Bjorn
> 
>>  - vccq-supply           : phandle to VCCQ supply regulator node
>>  - vccq2-supply          : phandle to VCCQ2 supply regulator node
>>  - vcc-supply-1p8        : For embedded UFS devices, valid VCC range 
>> is 1.7-1.95V
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
