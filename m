From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Wed, 5 Jun 2019 21:17:48 +0000
Message-ID: <BN7PR08MB5684B63CABF148C279FD64C1DB160@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-3-bjorn.andersson@linaro.org>
 <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
 <20190604223025.GD4814@minitux>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604223025.GD4814@minitux>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Bjorn
I think I should give up my preview suggestion DME_ENDPOINTRESET.req softwa=
re reset,  go back to your HW reset.
Although SW reset can cover most of the requirement, and compatible with di=
fferent vendor UFS device, for some device
fatal error cases, UFS internal stuck and would not accept SW Reset. An HW =
reset is expected. =20
Please go on your reset way.

Thanks,
//Bean

>Andy Gross <agross@kernel.org>; Linus Walleij <linus.walleij@linaro.org>;
>Rob Herring <robh+dt@kernel.org>; Mark Rutland <mark.rutland@arm.com>;
>linux-arm-msm@vger.kernel.org; linux-gpio@vger.kernel.org;
>devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>scsi@vger.kernel.org
>Subject: Re: [EXT] [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
>
>On Tue 04 Jun 01:13 PDT 2019, Bean Huo (beanhuo) wrote:
>> >@@ -6159,6 +6179,9 @@ static int ufshcd_reset_and_restore(struct
>> >ufs_hba
>> >*hba)
>> > 	int retries =3D MAX_HOST_RESET_RETRIES;
>> >
>> > 	do {
>> >+		/* Reset the attached device */
>> >+		ufshcd_device_reset(hba);
>> >+
>>
>> what's problem you met, and you should reset UFS device here? could you
>give more info?
>>
>> It is true that we don't reset UFS device in case of device fatal
>> error. According to UFS host spec, Host should be device reset except
>> that in addition to resetting UIC. But as so far, We didn't experience a=
ny
>problems result from this missing reset.
>>
>> We have three UFS device reset ways.  Comparing to this hardware
>> reset, I prefer to use DME_ENDPOINTRESET.req software reset.
>>
>
>Hi Bean,
>
>Thanks for your questions. With some memories we see issues establishing
>the link during bootup, so that's the purpose of issuing this reset.
>
>Unfortunately the downstream Qualcomm patch [1] (which I should have
>remembered to attribute), does not mention why the reset during host
>controller reset is needed - but I'm fairly certain that this scenario wou=
ld be
>similar to the handover from bootloader to kernel that we do see an issue
>with.
>
>
>[1]
>https://nam01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsource
>.codeaurora.org%2Fquic%2Fla%2Fkernel%2Fmsm-
>4.4%2Fcommit%2F%3Fh%3Dmsm-
>4.4%26id%3D0c82737188e2d63a08196e078e411032dbbc3b89&amp;data=3D02%
>7C01%7Cbeanhuo%40micron.com%7Cf72404eb906440e1f9c408d6e93c401d%7
>Cf38a5ecd28134862b11bac1d563c806f%7C0%7C0%7C636952842324926509&a
>mp;sdata=3DI%2FH7km6b34jyoUa1RVEPApfYt5uSFtHqL3%2BvV1bvryM%3D&amp
>;reserved=3D0
>
>Regards,
>Bjorn
