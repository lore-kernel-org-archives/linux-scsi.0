Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5302E2856
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 08:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755160140; cv=none; b=E9AuyVjVA8qFa89vMqS1o628sHs2r6QwCGW7S6Y9m69ZNB/BMruM8lQkv2XL+Qte+EkYYVm+0CyHlL+1UihK/Se8gHZhjfsyROR8An1YwB3L4Ats12cVc1rLOsulr9dt0t0X6n2LWg/9txyjPC16ML/xC3hbKyIAWdO582fdN4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755160140; c=relaxed/simple;
	bh=3/3UJO6AbTUB916n74g0CIK/q9AxwJrWEhnqOWix9xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvvsJKtTY5Nnio4YUto1dXekHPsyEdMi3w/s+XMSgJgy1clWPppkWV6xaMUPMJCgsMp2Ji7t7UY/WP1mykaw+/DukhJBxBzEwCWNtHi+mU5+KYoDmcF5Fibldd+h5PnGymPqFHGDuXbd2Ups3/Nt0lSANY41oQ9Zb8WzVRGteHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOWEAnbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOWEAnbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C319C4CEEF;
	Thu, 14 Aug 2025 08:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160139;
	bh=3/3UJO6AbTUB916n74g0CIK/q9AxwJrWEhnqOWix9xA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lOWEAnbZd0dmtkqHSaBJKkVpzkg+Og4T1QizoYX1A+j5Jy70JIqEIa6OwPLHBSEom
	 uhc6HWFPz8aedRah0z5HBBmFi05gIZImtaSgWNnZIHn8P9T+gGnLTHQid3RoxeTICr
	 07kYUPZoo+YQ08UihMoHQLUna4xsWKLp9/lPL4Yz/svaHlVx9CD5GI92ZKfUffQMFW
	 UU13Mh6p2akq0zCNROLaAcFltFBVV9RTzVsgPt81js0OiE2iS1LGyYV4qWjayOLWGR
	 218k7sIIqI1+GHsh5ZWUcTANYn0lyHQYsMZbjRXKFXeR6X3uJCTUIhAbAm532sEdx7
	 1tD1pp+aNqL5g==
Message-ID: <9aa24eeb-0a61-4340-9f9d-c9950b551251@kernel.org>
Date: Thu, 14 Aug 2025 17:26:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] scsi: pm80xx: Fix expander support
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Terrence Adams <tadamsjr@google.com>, Igor Pylypiv <ipylypiv@google.com>,
 Salomon Dushimirimana <salomondush@google.com>,
 Viswas G <Viswas.G@microsemi.com>, Deepak Ukey <deepak.ukey@microsemi.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org
References: <20250813114107.916919-7-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250813114107.916919-7-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/25 8:41 PM, Niklas Cassel wrote:
> Hello all,
> 
> Some recent patches broke expander support for the pm80xx driver.
> 
> The first two patches in this series makes sure that expanders work with
> this driver again.
> 
> It also fixes a bug in pm8001_abort_task() that was found through code
> review.
> 
> The final two patches make the driver more robust, so that is less likely
> that the expander support will break again in the future.
> 
> Please test and review.

Tested device hot removal & insertion with a JBOD (with expander) and with
direct attached disks. All good.

Of note is that hot-unplug & re-plugging the JBOD does not result in the drives
coming back. The drives are correctly removed when the JBOD is unplugged but
when replugging it, all I see is the PHY UP events but no rescan/no drives. And
forcing a scan of the JBOD host does nothing either. I think that is a
different issue though that we should look into.

> 
> 
> Kind regards,
> Niklas
> 
> 
> Niklas Cassel (5):
>   scsi: pm80xx: Restore support for expanders
>   scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
>   scsi: pm80xx: Add helper function to get the local phy id
>   scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an
>     expander
>   scsi: pm80xx: Use pm80xx_get_local_phy_id() to access phy array
> 
>  drivers/scsi/pm8001/pm8001_hwi.c |  8 +++-----
>  drivers/scsi/pm8001/pm8001_sas.c | 34 +++++++++++++++++++++++++-------
>  drivers/scsi/pm8001/pm8001_sas.h |  1 +
>  drivers/scsi/pm8001/pm80xx_hwi.c |  7 ++-----
>  4 files changed, 33 insertions(+), 17 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
