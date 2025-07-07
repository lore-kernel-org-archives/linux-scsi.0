Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52826202997
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jul 2025 19:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751917917; cv=none; b=A6YBHqmKEdxS756dyUw4YLNWbBgQuyCJ3+XB+bBCHr84A6uHAkUr1zTV+jgA+uAxZRpuhY/qLbnpi/Ed4H5Ej13pOfy8iO8SP/CvIzrIRqUxTMNRaHWwyLLQdLmeCOSYXtekMZMxjANx5JxaN60NTDzUK1mQXMBIMLkbPLt8fEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751917917; c=relaxed/simple;
	bh=TCflArEoi9824b7JF7gyOy8b7RLj8UXoJZ81EvRXrYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NA4ogXauOfCnrycSyKqBPJi5SzTs0Eu5anbZ296Bsh1yqnVx+tuBO16E2ywjC479kTjubrXnu5rpgyxSIbNOQ408V+wsng0ruLVLCAFKof79F4DFQ+H4AUWYyubXP/fwaGfjdrPdzxsZUebjTzaw94D1s2flqwgVYEhUHAouYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0UK5rY3i; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0UK5rY3i"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bbZd61JMQzm0ySc;
	Mon,  7 Jul 2025 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751917912; x=1754509913; bh=UCB/IqFmuslA6VNhhGxTwgHv
	a4imOSOFIjDD87X2lfU=; b=0UK5rY3iDlcdNp643vPgn2TivXE+8MgY7cYMQraR
	QkpMC4bJkD9tvQBO6NA8+vY/ho6plmqt+3c5ca8e783tEYuauOax7YXQWTH4/PPW
	7h0b7wUDyy98rV+Frv5wsS4zV9fwRIfJZt/NQ52bZZNi67xVykw0sbruRhrFVE9e
	VpnCA/tnMenlPh0zCQt3fRuLE4/yPtgb6dpeZelfkQ4UtBv4JGdqqy/0TtSrKbWu
	AV1ydxY4ElafShdc41txAw48lvir8w5Rt2uZjVs39Dda8GTwEGaqb+MuMUCUTkTg
	ij7aXfzopAO/LTcDFNudoO/t4f05OvmHQzR6XWZD9UiVbw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dzUNowklffro; Mon,  7 Jul 2025 19:51:52 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bbZd10vwGzm0ySS;
	Mon,  7 Jul 2025 19:51:48 +0000 (UTC)
Message-ID: <4e28a401-6316-429f-b6b7-d682280190f1@acm.org>
Date: Mon, 7 Jul 2025 12:51:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: ufs: ufs-pci: Fix hibernate state transition
 for Intel MTL-like host controllers
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-2-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250703064322.46679-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 11:43 PM, Adrian Hunter wrote:
> UFSHCD core disables the UIC completion interrupt when issuing UIC
> hibernation commands, and re-enables it afterwards if it was enabled to
> start with, refer ufshcd_uic_pwr_ctrl(). For Intel MTL-like host
> controllers, accessing the register to re-enable the interrupt disrupts the
> state transition.
> 
> Use hibern8_notify variant operation to disable the interrupt during the
> entire hibernation, thereby preventing the disruption.
> 
> Fixes: 4049f7acef3eb ("scsi: ufs: ufs-pci: Add support for Intel MTL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Archana Patni <archana.patni@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/ufs/host/ufshcd-pci.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 996387906aa1..af1c272eef1c 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -216,6 +216,32 @@ static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> +static void ufs_intel_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
> +{
> +	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> +
> +	if (enable)
> +		set |= UIC_COMMAND_COMPL;
> +	else
> +		set &= ~UIC_COMMAND_COMPL;
> +	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
> +}
> +
> +static void ufs_intel_mtl_h8_notify(struct ufs_hba *hba,
> +				    enum uic_cmd_dme cmd,
> +				    enum ufs_notify_change_status status)
> +{
> +	/*
> +	 * Disable UIC COMPL INTR to prevent access to UFSHCI after
> +	 * checking HCS.UPMCRS
> +	 */
> +	if (status == PRE_CHANGE && cmd == UIC_CMD_DME_HIBER_ENTER)
> +		ufs_intel_ctrl_uic_compl(hba, false);
> +
> +	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT)
> +		ufs_intel_ctrl_uic_compl(hba, true);
> +}
> +
>   #define INTEL_ACTIVELTR		0x804
>   #define INTEL_IDLELTR		0x808
>   
> @@ -533,6 +559,7 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
>   	.init			= ufs_intel_mtl_init,
>   	.exit			= ufs_intel_common_exit,
>   	.hce_enable_notify	= ufs_intel_hce_enable_notify,
> +	.hibern8_notify		= ufs_intel_mtl_h8_notify,
>   	.link_startup_notify	= ufs_intel_link_startup_notify,
>   	.resume			= ufs_intel_resume,
>   	.device_reset		= ufs_intel_device_reset,

Having both the UFS core driver and UFS host drivers modify
REG_INTERRUPT_ENABLE makes the UFS core driver much harder to maintain
than necessary. Instead of introducing a new .hibern8_notify callback,
please integrate the above logic directly in the UFS core driver. One
possible approach is to add an argument to ufshcd_uic_pwr_ctrl()
that indicates from which context ufshcd_uic_pwr_ctrl() is being called
(ufshcd_uic_hibern8_enter(), ufshcd_uic_hibern8_exit() or another 
function). I think it is safe to activate the behavior from this patch
for all UFS host drivers.

Thanks,

Bart.
