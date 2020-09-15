Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC02C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02BB2078D
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="CKJ/hiSZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgIOIMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:12:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34390 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgIOILz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 04:11:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600157471; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=WlQF3qAxIEc0TwSqSsrXzjj54EedKbjD6p1Mw3jMBh8=;
 b=CKJ/hiSZ7uk2h93EuQ1pFmMqEK5qK7/tzf9NJ+nBJ1665USAB4POFXLmhRDn0Sc2VY9wZ46t
 pPsFaDHpVrslht/9lJ5sedTNGnKyZaOUEypAtAcSLct/Uzis9vspMxYulT+tFXmFrVYO2mKl
 JwgixJVES8srJvyd5XHlvmjWAxc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f6076eebe06707b34b022cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 08:10:22
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54C7EC433FF; Tue, 15 Sep 2020 08:10:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC86FC433F0;
        Tue, 15 Sep 2020 08:10:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Sep 2020 01:10:20 -0700
From:   nguyenb@codeaurora.org
To:     Rob Herring <robh@kernel.org>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Vinod Koul <vkoul@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: dt-bindings: ufs: Add vcc-voltage-level for
 UFS
In-Reply-To: <20200914183505.GA357@bogus>
References: <cover.1598939393.git.nguyenb@codeaurora.org>
 <0a9d395dc38433501f9652a9236856d0ac840b77.1598939393.git.nguyenb@codeaurora.org>
 <20200914183505.GA357@bogus>
Message-ID: <d332e61cea4fef237507f1404efa724a@codeaurora.org>
X-Sender: nguyenb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-14 11:35, Rob Herring wrote:
> On Mon, Aug 31, 2020 at 11:00:47PM -0700, Bao D. Nguyen wrote:
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
> The expectation is the regulator pointed to by 'vcc-supply' has the
> voltage constraints. Those constraints are supposed to be the board
> constraints, not the regulator operating design constraints. If that
> doesn't work for your case, then it should be addressed in a common way
> for the regulator binding.
The UFS regulator has a min_uV and max_uV limits. Currently, the min and 
max are hardcoded
to UFS2.1 Spec allowed values of 2.7V and 3.6V respectively.
With this change, I am trying to fix a couple issues:
1. The 2.7V min value only applies to UFS2.1 devices. with UFS3.0+ 
devices, the VCC min should be 2.4V.
Hardcoding the min_uV to 2.7V does not work for UFS3.0+ devices.

2. Allow users to select a different Vcc voltage within the allowed 
range.
Using the min value, the UFS device is operating at marginal Vcc 
voltage.
In addition the PMIC and the board designs may add some variables 
especially at extreme
temperatures. We observe stability issues when using the min Vcc 
voltage.

> 
> Also, properties with units must have a unit suffix.
Yes, I agree.
> 
> Rob
