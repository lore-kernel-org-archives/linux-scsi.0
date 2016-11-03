From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH v3 04/12] phy: qcom-ufs-14nm: Add new compatible for
 msm8996 based phy
Date: Thu, 3 Nov 2016 22:37:11 +0530
Message-ID: <CAFp+6iHDJEEiE0XHEi46X9xPL=5kmDRa2vUOqj2tkML5+W2h9g@mail.gmail.com>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
 <1477772534-14170-5-git-send-email-vivek.gautam@codeaurora.org> <bee1a974145c606c40d61781fc2f3c9c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758232AbcKCRHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 13:07:14 -0400
In-Reply-To: <bee1a974145c606c40d61781fc2f3c9c@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: kishon <kishon@ti.com>, jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Boyd <sboyd@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

Hi,


On Tue, Nov 1, 2016 at 2:41 AM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> On 2016-10-29 13:22, Vivek Gautam wrote:
>>
>> Add a new compatible string for 14nm ufs phy present on msm8996
>> chipset. This phy is bit different from the legacy 14nm ufs phy
>> in terms of the clocks that are needed to be handled in the driver.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>>
>> New patch in v3 of this cleanup series.
>>
>>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt | 7 +++++--
>>  drivers/phy/phy-qcom-ufs-qmp-14nm.c                | 1 +
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>> b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>> index 070baf4..b6b5130 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>> @@ -7,8 +7,11 @@ To bind UFS PHY with UFS host controller, the
>> controller node should
>>  contain a phandle reference to UFS PHY node.
>>
>>  Required properties:
>> -- compatible        : compatible list, contains "qcom,ufs-phy-qmp-20nm"
>> -                     or "qcom,ufs-phy-qmp-14nm" according to the relevant
>> phy in use.
>> +- compatible        : compatible list, contains one of the following -
>> +                       "qcom,ufs-phy-qmp-20nm" for 20nm ufs phy,
>> +                       "qcom,ufs-phy-qmp-14nm" for legacy 14nm ufs phy,
>> +                       "qcom,msm8996-ufs-phy-qmp-14nm" for 14nm ufs phy
>> +                        present on MSM8996 chipset.
>
> For future chipsets (after MSM8996), we have to use this same compatible
> strings? If yes, "msm8996" in compatible string name may cause confusions?
> may be we should start following v1/v2/... terminologies for this?
> something like "qcom,ufs-phy-qmp-v2" to start with?

Are we trying to complement the actual IP hardware versioning with this ?
Isn't it possible that we will end up using v2 for more than a couple of
actual IP hardware versions ?

I have seen cases wherein the IP versions are preceded by the
SOC names, the IPs appeared first in. And if the same IP is used in
subsequent SOCs, we use same compatible string. This, rather,
makes things easier to comprehend - it's the same IP that was
used on older SoC.

I am fine with adding versions to the compatible string as well.
But like i asked earlier - are we just creating versions for our
own understanding, or are we also complementing the actual
IP hardware versions ?


Thanks
Vivek

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
