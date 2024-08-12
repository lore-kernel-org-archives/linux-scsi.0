Received: from mail-m12751.qiye.163.com (mail-m12751.qiye.163.com [115.236.127.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80B2136A;
	Mon, 12 Aug 2024 01:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723426793; cv=none; b=rNGWp9dA8c/qy7Gn7uQGSPbqt+DASxu1DpJsrf5PNUbf9Q2XQCHp/5g/4n2cubWM4qqCPQtfb9+D8A1npiUbHZhYjzgVetKwca1MHteWt1FBhVDMEXTeC/Ho9xpM+Ja8hXv02WZtwt5mqgsv7EDqGi3YWAHMpcVmDmglZYaEiiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723426793; c=relaxed/simple;
	bh=jvasnGtWS3SNaZEIRyeRH+9dj6mEY/FGZqnFyDDfYDQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uWN0MFrLzwIzSh7s0zsrGZTi3Y/0tkFSdwT9vPVtlSRW7JlYBYdVFjWQ/SrX8URQKH4SyuU8RkD/0kSY2rBZi1gBSJKCpnPxojbt6jI4+opvrns7XRIK1zEp0fwn+YB58euj0kmn6KcUKSty2tZ62QchAA+OO4UZ+XaLy5KeKJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=MyNzvHAx; arc=none smtp.client-ip=115.236.127.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="MyNzvHAx"
DKIM-Signature: a=rsa-sha256;
	b=MyNzvHAxJBRtHc5hRmvamjQtYeXVAePkgbjYKOhAUkWg9sOCrJttYRRdX76ke2+elUHbU/E0JTi6vjGpNC11pdYzE9Kj6MObYV3tiQolVVTL7llwGIChvDV+n893zZtFi0hZoEr8mTFGTxSrrDgpPH2DkRqcWyRKOio+468qdYM=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=0sTN93Z27hftIoKwG2LU0CkZ691/s//4DKhUCzjA24k=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.69] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 1313F4602AB;
	Mon, 12 Aug 2024 09:28:27 +0800 (CST)
Message-ID: <3b2617f5-acb1-45c6-993c-33249fd19888@rock-chips.com>
Date: Mon, 12 Aug 2024 09:28:26 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, Rob Herring <robh+dt@kernel.org>,
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
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
 <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
 <20240810092817.GA147655@thinkpad>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20240810092817.GA147655@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGkkaHlZDHx1IThofSklDTU9WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91443372a703aekunm1313f4602ab
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mww6Kgw*SjIwPQIKA1FDLhdD
	TRUwCSFVSlVKTElIT0lNSktDTkJNVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUpPTE5KNwY+

JHi Mani,

在 2024/8/10 17:28, Manivannan Sadhasivam 写道:
> On Fri, Aug 09, 2024 at 04:16:41PM +0800, Shawn Lin wrote:
> 
> [...]
> 
>>>> +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
>>>> +					 enum ufs_notify_change_status status)
>>>> +{
>>>> +	int err = 0;
>>>> +
>>>> +	if (status == PRE_CHANGE) {
>>>> +		int retry_outer = 3;
>>>> +		int retry_inner;
>>>> +start:
>>>> +		if (ufshcd_is_hba_active(hba))
>>>> +			/* change controller state to "reset state" */
>>>> +			ufshcd_hba_stop(hba);
>>>> +
>>>> +		/* UniPro link is disabled at this point */
>>>> +		ufshcd_set_link_off(hba);
>>>> +
>>>> +		/* start controller initialization sequence */
>>>> +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
>>>> +
>>>> +		usleep_range(100, 200);
>>>> +
>>>> +		/* wait for the host controller to complete initialization */
>>>> +		retry_inner = 50;
>>>> +		while (!ufshcd_is_hba_active(hba)) {
>>>> +			if (retry_inner) {
>>>> +				retry_inner--;
>>>> +			} else {
>>>> +				dev_err(hba->dev,
>>>> +					"Controller enable failed\n");
>>>> +				if (retry_outer) {
>>>> +					retry_outer--;
>>>> +					goto start;
>>>> +				}
>>>> +				return -EIO;
>>>> +			}
>>>> +			usleep_range(1000, 1100);
>>>> +		}
>>>
>>> You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.
>>
>> Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
>> which is very similar to ufshcd_hba_execute_hce(), before calling
>> ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
>> we can export ufshcd_hba_execute_hce() to make full use of it.
>>
> 
> But you are starting the controller using REG_CONTROLLER_ENABLE. Isn't that
> supposed to be broken if you set UFSHCI_QUIRK_BROKEN_HCE? Or I am
> misunderstanding the quirk?
> 

Our controller doesn't work with exiting code, whether setting
UFSHCI_QUIRK_BROKEN_HCE or not.


For UFSHCI_QUIRK_BROKEN_HCE case, it calls ufshcd_dme_reset（）first,
but we need to set REG_CONTROLLER_ENABLE first.

For !UFSHCI_QUIRK_BROKEN_HCE case, namly ufshcd_hba_execute_hce, it
sets REG_CONTROLLER_ENABLE  first but never send DMA_RESET and calls
ufshcd_dme_enable.

So the closet code path is to go through UFSHCI_QUIRK_BROKEN_HCE case,
and set REG_CONTROLLER_ENABLE by adding hce_enable_notify hook.

>>>
>>>> +	} else { /* POST_CHANGE */
>>>> +		err = ufshcd_vops_phy_initialization(hba);
>>>> +	}
>>>> +
>>>> +	return err;
>>>> +}
>>>> +
>>>> +static void ufs_rockchip_set_pm_lvl(struct ufs_hba *hba)
>>>> +{
>>>> +	hba->rpm_lvl = UFS_PM_LVL_1;
>>>> +	hba->spm_lvl = UFS_PM_LVL_3;
>>>> +}
>>>> +
>>>> +static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *hba)
>>>> +{
>>>> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
>>>> +
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(PA_LOCAL_TX_LCC_ENABLE, 0x0), 0x0);
>>>> +	/* enable the mphy DME_SET cfg */
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x40);
>>>> +	for (int i = 0; i < 2; i++) {
>>>> +		/* Configuration M-TX */
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, SEL_TX_LANE0 + i), 0x06);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, SEL_TX_LANE0 + i), 0x02);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, SEL_TX_LANE0 + i), 0x44);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, SEL_TX_LANE0 + i), 0xe6);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, SEL_TX_LANE0 + i), 0x07);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x94, SEL_TX_LANE0 + i), 0x93);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x93, SEL_TX_LANE0 + i), 0xc9);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x7f, SEL_TX_LANE0 + i), 0x00);
>>>> +		/* Configuration M-RX */
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, SEL_RX_LANE0 + i), 0x06);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, SEL_RX_LANE0 + i), 0x00);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, SEL_RX_LANE0 + i), 0x58);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, SEL_RX_LANE0 + i), 0x8c);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, SEL_RX_LANE0 + i), 0x02);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, SEL_RX_LANE0 + i), 0xf6);
>>>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, SEL_RX_LANE0 + i), 0x69);
>>>> +	}
>>>> +	/* disable the mphy DME_SET cfg */
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x00);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x08C);
>>>> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x110);
>>>> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x250);
>>>> +
>>>
>>> Why can't you do these settings in a PHY driver?
>>
>> As we have ->phy_initialization in struct ufs_hba_variant_ops,
>> which asks the host driver to use it to initialize phys. It doesn't
>> seem to need to create a whole new file to just add some smalls fixed
>> parameters. :)
>>
> 
> So the PHY doesn't need any resources (clocks, regulators, etc...) other than
> programming these sequences? If so, it is fine with me.

yes, it needn't.

> 
>>
>>>
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x134);
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x274);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x38, 0x0E0);
>>>> +	ufs_sys_writel(host->mphy_base, 0x38, 0x220);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x50, 0x164);
>>>> +	ufs_sys_writel(host->mphy_base, 0x50, 0x2A4);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x178);
>>>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x2B8);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x18, 0x1B0);
>>>> +	ufs_sys_writel(host->mphy_base, 0x18, 0x2F0);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x128);
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x268);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x20, 0x12C);
>>>> +	ufs_sys_writel(host->mphy_base, 0x20, 0x26C);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x120);
>>>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x260);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x094);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x1B4);
>>>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x2F4);
>>>> +
>>>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x08C);
>>>> +	udelay(1);
>>>> +	ufs_sys_writel(host->mphy_base, 0x00, 0x08C);
>>>> +
>>>> +	udelay(200);
>>>> +	/* start link up */
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_TX_ENDIAN, 0), 0x0);
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_RX_ENDIAN, 0), 0x0);
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID_VALID, 0), 0x1);
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_PEERDEVICEID, 0), 0x1);
>>>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, 0), 0x1);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
> 
> [...]
> 
>>>> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
>>>> +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
>>>> +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
>>>
>>> Why can't you use ufshcd PM ops as like other vendor drivers?
>>
>> It doesn't work from the test. We have many use case to power down the
>> controller and device, so there is no flow to recovery the link. Only
>> when the first accessing to UFS fails, the ufshcd error handle recovery the
>> link. This is not what we expect.
>>
> 
> What tests? The existing UFS controller drivers are used in production devices
> and they never had a usecase to invent their own PM callbacks. So if your
> controller is special, then you need to justify it more elaborately. If
> something is missing in ufshcd callbacks, then we can add them.
> 

All the register got lost each time as we power down both controller & 
PHY and devices in suspend. So we have to restore the necessary
registers and link. I didn't see where the code recovery the controller
settings in ufshcd_resume, except ufshcd_err_handler（）triggers that.
Am I missing any thing? Below is the dump we get if using
SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume).
It can work as ufshcd_err_handler () will fix the link, but we have to
suffer from getting the error log each time. Moreover, we need to gate
26MHz refclk for device when RPM is called. So our own rpm callback is
needed.

[   14.318444] <<GTP-INF>>[gt1x_wakeup_sleep:964] Wakeup by poweron
[   14.439723] ufshcd-rockchip 2a2d0000.ufs: Controller not ready to 
accept UIC commands
[   14.439730] ufshcd-rockchip 2a2d0000.ufs: pwr ctrl cmd 0x18 with mode 
0x0 uic error -5
[   14.439736] ufshcd-rockchip 2a2d0000.ufs: UFS Host state=1
[   14.439740] ufshcd-rockchip 2a2d0000.ufs: outstanding reqs=0x0 tasks=0x0
[   14.439744] ufshcd-rockchip 2a2d0000.ufs: saved_err=0x0, 
saved_uic_err=0x0
[   14.439748] ufshcd-rockchip 2a2d0000.ufs: Device power mode=2, UIC 
link state=2
[   14.439753] ufshcd-rockchip 2a2d0000.ufs: PM in progress=1, sys. 
suspended=1
[   14.439758] ufshcd-rockchip 2a2d0000.ufs: Auto BKOPS=0, Host self-block=0
[   14.439762] ufshcd-rockchip 2a2d0000.ufs: Clk gate=1
[   14.439766] ufshcd-rockchip 2a2d0000.ufs: last_hibern8_exit_tstamp at 
0 us, hibern8_exit_cnt=0
[   14.439770] ufshcd-rockchip 2a2d0000.ufs: last intr at 10807625 us, 
last intr status=0x440
[   14.439775] ufshcd-rockchip 2a2d0000.ufs: error handling flags=0x0, 
req. abort count=0
[   14.439779] ufshcd-rockchip 2a2d0000.ufs: hba->ufs_version=0x200, 
Host capabilities=0x187011f, caps=0x48c
[   14.439785] ufshcd-rockchip 2a2d0000.ufs: quirks=0x2100, dev. quirks=0xc4
[   14.439790] ufshcd-rockchip 2a2d0000.ufs: UFS dev info: SAMSUNG 
KLUDG2R1DE-B0F1  rev 0100
[   14.439796] ufshcd-rockchip 2a2d0000.ufs: clk: core, rate: 50000000
[   14.439822] host_regs: 00000000: 0187011f 00000000 00000200 00000000
[   14.439827] host_regs: 00000010: 00000000 000005e6 00000000 00000000
[   14.439831] host_regs: 00000020: 00000000 00000000 00000000 00000000
[   14.439835] host_regs: 00000030: 00000000 00000000 00000000 00000000
[   14.439839] host_regs: 00000040: 00000000 00000000 00000000 00000000
[   14.439843] host_regs: 00000050: 00000000 00000000 00000000 00000000
[   14.439847] host_regs: 00000060: 00000000 00000000 00000000 00000000
[   14.439851] host_regs: 00000070: 00000000 00000000 00000000 00000000
[   14.439855] host_regs: 00000080: 00000000 00000000 00000000 00000000
[   14.439859] host_regs: 00000090: 00000000 00000000 00000000 00000000
[   14.439863] ufshcd-rockchip 2a2d0000.ufs: No record of pa_err
[   14.439867] ufshcd-rockchip 2a2d0000.ufs: No record of dl_err
[   14.439871] ufshcd-rockchip 2a2d0000.ufs: No record of nl_err
[   14.439876] ufshcd-rockchip 2a2d0000.ufs: No record of tl_err
[   14.439880] ufshcd-rockchip 2a2d0000.ufs: No record of dme_err
[   14.439884] ufshcd-rockchip 2a2d0000.ufs: No record of auto_hibern8_err
[   14.439888] ufshcd-rockchip 2a2d0000.ufs: No record of fatal_err
[   14.439892] ufshcd-rockchip 2a2d0000.ufs: No record of link_startup_fail
[   14.439896] ufshcd-rockchip 2a2d0000.ufs: No record of resume_fail
[   14.439900] ufshcd-rockchip 2a2d0000.ufs: No record of suspend_fail
[   14.439905] ufshcd-rockchip 2a2d0000.ufs: dev_reset[0] = 0x0 at 
1418763 us
[   14.439910] ufshcd-rockchip 2a2d0000.ufs: dev_reset: total cnt=1
[   14.439914] ufshcd-rockchip 2a2d0000.ufs: No record of host_reset
[   14.439918] ufshcd-rockchip 2a2d0000.ufs: No record of task_abort
[   14.439930] ufshcd-rockchip 2a2d0000.ufs: ufshcd_uic_hibern8_exit: 
hibern8 exit failed. ret = -5
[   14.439935] ufshcd-rockchip 2a2d0000.ufs: __ufshcd_wl_resume: hibern8 
exit failed -5
[   14.439944] ufs_device_wlun 0:0:0:49488: ufshcd_wl_resume failed: -5
[   14.439950] ufs_device_wlun 0:0:0:49488: PM: dpm_run_callback(): 
scsi_bus_resume+0x0/0xa8 returns -5
[   14.440003] ufshcd-rockchip 2a2d0000.ufs: ufshcd_err_handler started; 
HBA state eh_fatal; powered 1; shutting down 0; saved_err = 0; 
saved_uic_err = 0; force_reset = 0; link is broken
[   14.440017] ufs_device_wlun 0:0:0:49488: PM: failed to resume async: 
error -5

> - Mani
> 
