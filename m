Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596F246BB9
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 02:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755137687; cv=none; b=qm4xb7Pn8IHT2G2NnB7r3JH+M0yc5URiOElPiIJUESutlxY8fFM0OBIl07N8I7hw08wYyQeKEHan72ZhRy3MGuk8FAXOIWcoVfn0B7CzxjeWmh2SSqmguz52kuQwiu9RR3g66kl98PM5CJndI76vlvVajUF2/7Cnr4l3TIzVRBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755137687; c=relaxed/simple;
	bh=WSD+fDydUxHmXDhCFzq2dZtw+C2IxnKSdQmrZol3xhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esMc6mSHF4atyz2Ng+8i8hxaAXRcuIORhPAhg7Zc8kIMUybY5V0wgcwFjNANQXXDrTqHRRLEcEd7ihhvqelY5nB6N5L5iKPcSPk8WFCShBjACrw1oEf+CyKGhivnWoXT5rraGfhNLg6TeZKVz06GnRtriEAG1SmVCCPUXbUP/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9En8aVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9En8aVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079F4C4CEEB;
	Thu, 14 Aug 2025 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755137686;
	bh=WSD+fDydUxHmXDhCFzq2dZtw+C2IxnKSdQmrZol3xhc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J9En8aVMMJ3iggAuHfpcnkrnMlW4aLsYsAEfCZzJRCEgbbEjqjms8XY9meCuNizLM
	 AOFskusS1WecY5T4Zjj7EouEChObpUqBC7GOiEhtk9LyK0zj6JAH/Yg6JPHwba7Tl7
	 5DGuf+inJoppZZy7vqqMLL7/HZDbgvmU+mMlY4Mncl0sf9Kvvy7PUa5erXOgHkYte3
	 1ORuh/Ig6fGKeWnxxq8coxYk61tUFl1xTbEY6QYmdWUTLbsWXCSXhGqd3wHr6uylD8
	 rdDaw3vSK51LwGKJ052UoSxbvntlBUxDmxTfCO2qTA7O8opiDfXh4na4TNbxoiJfLd
	 vxAexdD4pKwXg==
Message-ID: <dff41dc4-b634-470f-97a9-3c58e28143c2@kernel.org>
Date: Thu, 14 Aug 2025 11:12:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: pm80xx: Use pm80xx_get_local_phy_id() to access
 phy array
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>,
 linux-scsi@vger.kernel.org
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-12-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250813114107.916919-12-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/25 8:41 PM, Niklas Cassel wrote:
> While the current code is perfectly fine (because we verify that the
> device is directly attached before using attached_phy to index the
> pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
> anyway, to reduce the chance that someone will copy paste this pattern to
> other parts of the driver.
> 
> Note that in this specific case, we still need to keep the check that the
> device is not behind an expander, because we do not want to clear
> attached_phy of the expander if a device behind the expander disappears
> (as that would disable all the other devices behind the expander).
> 
> However, if it is the expander itself that disappears, attached_phy will
> be cleared, just like it would for any other directly attached device.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index b3bd61827ad6..96ecc5e63f53 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -782,8 +782,11 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
>  		 * The phy array only contains local phys. Thus, we cannot clear
>  		 * phy_attached for a device behind an expander.
>  		 */
> -		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
> -			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
> +		if (!(parent_dev && dev_is_expander(parent_dev->dev_type))) {

This pattern/check is repeated a lot. It may be good to have a
dev_parent_is_expander() helper:

static inline bool dev_parent_is_expander(struct domain_device *dev)
{
	if (!dev->parent)
		return false;

	return dev_is_expander(dev->parent->dev_type);
}

Which will allow simplifying the the test everywhere to:

	if (dev_parent_is_expander(dev))
or
	if (!dev_parent_is_expander(dev))

No ?

> +			u32 phy_id = pm80xx_get_local_phy_id(dev);
> +
> +			pm8001_ha->phy[phy_id].phy_attached = 0;
> +		}
>  		pm8001_free_dev(pm8001_dev);
>  	} else {
>  		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");


-- 
Damien Le Moal
Western Digital Research
