Received: from mail-m127174.xmail.ntesmail.com (mail-m127174.xmail.ntesmail.com [115.236.127.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144619470;
	Tue, 13 Aug 2024 03:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521236; cv=none; b=jffLW6ZZTDka/a1o4e48jj5zH9QjrOxxCATPj1xupjbSj1/P0j5uN5F/wj49GZ55AcTUWdKJGrbqxP/2d92lDnoShlphpLF2Kn0HNI1rK5LN2uprDFtIY7An3kO8FbvjNJOT8mNihGgVqnaLbtcgHgBST+KgW+8ONnDdcUNwu3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521236; c=relaxed/simple;
	bh=Ytc72JkFDjs88ZEnCsYhEG87oAU/LtotvAWBMk/c2Zc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L2xFGaKoTY54DXtLXgpUn7xAoJS4psp+LR7uvYKWC8jHHTBj63X9/ID+n7yZE6iiUfVnumo8q7T0G54ZiWOGgseBQzAqdJSeOBUmLnUFS8jfYcv/kGbSA+MUdhf33y3VJb8GSq+MQQlauSgclifPGoWQGTWv1Qgeyt1BWSzxEC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=F/sw05CG; arc=none smtp.client-ip=115.236.127.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="F/sw05CG"
DKIM-Signature: a=rsa-sha256;
	b=F/sw05CGbBqjYyN8QXb/N+3CtICJH/2jd7Tqjn6RlzzC2k+MLGbkGOK6HEEXKCgu6c/k698lDznTE3oGQFVwjUwMbcNp0IKFMZq9gfbyPTdm36Qwxrk+IJnc1IdbhSR0V7W0rIlKhwTpDv5Lu0uTHQgDGR8Tm6H8NIEyLPbME5Q=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=lSpIWy5SrkQpqtUiLjei0gYEY0FrtYcWevfcfIyZkOw=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.45] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 138B54603C4;
	Tue, 13 Aug 2024 11:52:29 +0800 (CST)
Message-ID: <b91b18fa-7af0-46c0-a3f7-550676b7a222@rock-chips.com>
Date: Tue, 13 Aug 2024 11:52:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, YiFeng Zhao <zyf@rock-chips.com>,
 Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
 <20240810092817.GA147655@thinkpad>
 <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>
 <20240812041051.GA2861@thinkpad>
 <49659932-5caf-433b-a140-664b61617c43@rock-chips.com>
 <20240812165504.GB6003@thinkpad>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20240812165504.GB6003@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGRgYTlZPTUxMTR9JTB1DTkhWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a9149ddad1403aekunm138b54603c4
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mhg6FTo*TjI*KUsXQxlNMTc1
	CUsaCjlVSlVKTElITklKSk5LTE9MVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUpLT09PNwY+

Hi Mani,

在 2024/8/13 0:55, Manivannan Sadhasivam 写道:
> On Mon, Aug 12, 2024 at 02:24:31PM +0800, Shawn Lin wrote:
>> 在 2024/8/12 12:10, Manivannan Sadhasivam 写道:
>>> On Mon, Aug 12, 2024 at 09:28:26AM +0800, Shawn Lin wrote:
>>>> JHi Mani,
>>>>
>>>> 在 2024/8/10 17:28, Manivannan Sadhasivam 写道:
>>>>> On Fri, Aug 09, 2024 at 04:16:41PM +0800, Shawn Lin wrote:
>>>>>
>>>>> [...]
>>>>>
>>>>>>>> +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
>>>>>>>> +					 enum ufs_notify_change_status status)
>>>>>>>> +{
>>>>>>>> +	int err = 0;
>>>>>>>> +
>>>>>>>> +	if (status == PRE_CHANGE) {
>>>>>>>> +		int retry_outer = 3;
>>>>>>>> +		int retry_inner;
>>>>>>>> +start:
>>>>>>>> +		if (ufshcd_is_hba_active(hba))
>>>>>>>> +			/* change controller state to "reset state" */
>>>>>>>> +			ufshcd_hba_stop(hba);
>>>>>>>> +
>>>>>>>> +		/* UniPro link is disabled at this point */
>>>>>>>> +		ufshcd_set_link_off(hba);
>>>>>>>> +
>>>>>>>> +		/* start controller initialization sequence */
>>>>>>>> +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
>>>>>>>> +
>>>>>>>> +		usleep_range(100, 200);
>>>>>>>> +
>>>>>>>> +		/* wait for the host controller to complete initialization */
>>>>>>>> +		retry_inner = 50;
>>>>>>>> +		while (!ufshcd_is_hba_active(hba)) {
>>>>>>>> +			if (retry_inner) {
>>>>>>>> +				retry_inner--;
>>>>>>>> +			} else {
>>>>>>>> +				dev_err(hba->dev,
>>>>>>>> +					"Controller enable failed\n");
>>>>>>>> +				if (retry_outer) {
>>>>>>>> +					retry_outer--;
>>>>>>>> +					goto start;
>>>>>>>> +				}
>>>>>>>> +				return -EIO;
>>>>>>>> +			}
>>>>>>>> +			usleep_range(1000, 1100);
>>>>>>>> +		}
>>>>>>>
>>>>>>> You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.
>>>>>>
>>>>>> Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
>>>>>> which is very similar to ufshcd_hba_execute_hce(), before calling
>>>>>> ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
>>>>>> we can export ufshcd_hba_execute_hce() to make full use of it.
>>>>>>
>>>>>
>>>>> But you are starting the controller using REG_CONTROLLER_ENABLE. Isn't that
>>>>> supposed to be broken if you set UFSHCI_QUIRK_BROKEN_HCE? Or I am
>>>>> misunderstanding the quirk?
>>>>>
>>>>
>>>> Our controller doesn't work with exiting code, whether setting
>>>> UFSHCI_QUIRK_BROKEN_HCE or not.
>>>>
>>>
>>> Okay. Then this means you do not need this quirk at all.
>>>
>>>>
>>>> For UFSHCI_QUIRK_BROKEN_HCE case, it calls ufshcd_dme_reset（）first,
>>>> but we need to set REG_CONTROLLER_ENABLE first.
>>>>
>>>> For !UFSHCI_QUIRK_BROKEN_HCE case, namly ufshcd_hba_execute_hce, it
>>>> sets REG_CONTROLLER_ENABLE  first but never send DMA_RESET and calls
>>>> ufshcd_dme_enable.
>>>>
>>>
>>> I don't see where ufshcd_dme_enable() is getting called for
>>> !UFSHCI_QUIRK_BROKEN_HCE case.
>>>
>>>> So the closet code path is to go through UFSHCI_QUIRK_BROKEN_HCE case,
>>>> and set REG_CONTROLLER_ENABLE by adding hce_enable_notify hook.
>>>>
>>>
>>> No, that is abusing the quirk. But I'm confused about why your controller wants
>>> resetting the unipro stack _after_ enabling the controller? Why can't it be
>>> reset before?
>>>
>>
>> It can't be. The DME_RESET to reset the unipro stack will be failed
>> without enabling REG_CONTROLLER_ENABLE. And the controller does want us
>> to reset the unipro stack before other coming UICs.
>>
>> So I considered it's a kind of broken HCE case as well. Should I add a
>> new quirk or add a new hba_enable hook in ufs_hba_variant_ops? Or just
>> use UFSHCI_QUIRK_BROKEN_HCE ?
>>
> 
> IMO, you should add a new quirk and use it directly in ufshcd_hba_execute_hce().
> But you need to pick the quirk name as per the actual quirky behavior of the
> controller.
> 

Thanks, Main. I'll add a new quirk for
ufshcd_hba_execute_hce() as per the actual quirky behavour.

>>>>>>>
>>>>>>>> +	} else { /* POST_CHANGE */
>>>>>>>> +		err = ufshcd_vops_phy_initialization(hba);
>>>>>>>> +	}
>>>>>>>> +
>>>>>>>> +	return err;
>>>>>>>> +}
>>>>>>>> +
>>>
>>> [...]
>>>
>>>>>>>> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
>>>>>>>> +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
>>>>>>>> +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
>>>>>>>
>>>>>>> Why can't you use ufshcd PM ops as like other vendor drivers?
>>>>>>
>>>>>> It doesn't work from the test. We have many use case to power down the
>>>>>> controller and device, so there is no flow to recovery the link. Only
>>>>>> when the first accessing to UFS fails, the ufshcd error handle recovery the
>>>>>> link. This is not what we expect.
>>>>>>
>>>>>
>>>>> What tests? The existing UFS controller drivers are used in production devices
>>>>> and they never had a usecase to invent their own PM callbacks. So if your
>>>>> controller is special, then you need to justify it more elaborately. If
>>>>> something is missing in ufshcd callbacks, then we can add them.
>>>>>
>>>>
>>>> All the register got lost each time as we power down both controller & PHY
>>>> and devices in suspend.
>>>
>>> Which suspend? runtime or system suspend? I believe system suspend.
>>
>> Both.
>>
> 
> With {rpm/spm}_lvl = 3, you should not power down the controller.
> 
>>>
>>>> So we have to restore the necessary
>>>> registers and link. I didn't see where the code recovery the controller
>>>> settings in ufshcd_resume, except ufshcd_err_handler（）triggers that.
>>>> Am I missing any thing?
>>>
>>> Can you explain what is causing the powerdown of the controller and PHY?
>>> Because, ufshcd_suspend() just turns off the clocks and regulators (if
>>> UFSHCD_CAP_AGGR_POWER_COLLAPSE is set) and spm_lvl 3 set by this driver only
>>> puts the device in sleep mode and link in hibern8 state.
>>>
>>
>> For runtime PM case, it's the power-domain driver will power down the
>> controller and PHY if UFS stack is not active any more（autosuspend）.
>>
>> For system PM case, it's the SoC's firmware to cutting of all the power
>> for controller/PHY and device.
>>
> 
> Both cases are not matching the expectations of {rpm/spm}_lvl. So the platform
> (power domain or the firmware) should be fixed. What if the user sets the
> {rpm/spm}_lvl to 1? Will the platform power down the controller even then? If
> so, then I'd say that the platform is broken and should be fixed.

Ok, it seems I need to set {rpm/spm}_lvl = 6 if I want platform to power
down the controller for ultra power-saving. But I still need to add my
own system PM callback in that case to recovery the link first. Do I
misunderstand it?

And for the user who sets the rpm/spm level via
ufs_sysfs_pm_lvl_store(), I think there is no way to block it currently,
except that we need to fix the power-domain driver and Firmware to
respect the level and choose correct policy.


So in summary for what the next step I should to:
(1) Set {rpm/spm}_lvl = 6 in host driver to reflect the expectation
(2) Add own PM callbacks to recovery the link to meet the expectation
(3) Fix the broken behaviour of PD or Firmware to respect the actual
desired pm level if user changes the pm level.


Does that sound feasible to you?


Thanks.

> 
> - Mani
> 
