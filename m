Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7436854652
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 04:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813316; cv=none; b=OGOndRX8qQ0QDMi5Bq7yShEMfvQSfkw4atnbT2rqxjXrxWDJxuWp/9d/VrS0I27KZgYVvrZaU5px1qk/i8hk1ey8nXjmV38vHxpF3aRmbL18FCRmEJhkMPuf7m7FhcO4s9gWY52BoTkDUqeX75zoyfr6q/JhJa6rsbCL3JyX5WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813316; c=relaxed/simple;
	bh=aZizLHVeOGLM8UycJD3TRipjLDXfXIU47Vfq7VPUZnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nTdNy7CK+6oXN+mj1WjwF57yfXPKFV8U99WJl8ohVKkC0PJp8TaiOsEuLF/W4FyYKm4C2pGLb9mCtvlxOUy426ZAR/NEFM4SXAxyrmjPOTUnpXnThSXhw+o+zlUa6EQq17hG2NKFItIuLBNGp6HPG7NM6a3Kdb0nV2uKVlt0HFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOSY+xrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOSY+xrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD026C4CEED;
	Fri, 18 Jul 2025 04:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752813316;
	bh=aZizLHVeOGLM8UycJD3TRipjLDXfXIU47Vfq7VPUZnI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BOSY+xrxRVpIjX2elgmVLxg3w5Sfoac8LBB4zWeei/kvciOD7OfFHCG0y17ZUUhuZ
	 j4+1wSSxVGcx5CaoCFwbHcDSzmHqaYDA3+Gysndq0H8ZHDXl538AmL7O9lQV6tl4KZ
	 2RD2y2RY4gnaadl5sGtv9A65cgWBACGUBoMuW054x9yAsuavZTI9NIV7Sq3Bv0F4UP
	 0QV/ectqQU6i+7uTDA/PadslguSd09b95vkAMzcAYUOt4B8Kv9qOp35gJzMpBiagFt
	 EY/v9Y9hXVpC2hYQ1Qz8CJnpX8ABADtkCEKx6hZWLrMSdnlrciF5yFGVwe19mldyr7
	 Lmv5us9eQkZrQ==
Message-ID: <a09dea31-0de3-4859-95d9-2d83fc1ccc73@kernel.org>
Date: Fri, 18 Jul 2025 13:35:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
To: Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Terrence Adams <tadamsjr@google.com>, linux-scsi@vger.kernel.org
References: <20250717165606.3099208-2-cassel@kernel.org>
 <aHlpNRsPbmrTgv0O@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aHlpNRsPbmrTgv0O@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/07/18 6:20, Igor Pylypiv wrote:
> On Thu, Jul 17, 2025 at 06:56:07PM +0200, Niklas Cassel wrote:
>> This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2.
>>
>> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
>> drives behind a SAS enclosure (which is connected to one of the ports
>> on the HBA) to no longer be detected.
>>
>> Connecting the drives directly to the HBA still works. Thus, the commit
>> only broke the detection of drives behind a SAS enclosure.
>>
>> Reverting the commit makes the drives behind the SAS enclosure to be
>> detected once again.
>>
>> The commit log of the offending commit is quite vague, but mentions that:
>> "Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
>> to get the port ID."
>>
>> This assumption appears false, thus revert the offending commit.
> 
> Thanks for bisecting and reverting the commit, Niklas!
> 
> Let me review the changes and send a proper fix that takes into account
> drives behind a SAS enclosure. I would appretiate if you could test that
> new fix since I don't have a setup with a SAS enclosure.

s/enclosure/expander
(the important point here is if there is an expander between the HBA and the
devices, not how the devices are installed. E.g. a simple enclosure may not have
any expander and act similar to a fan-out cable connection)

I think the issue is that if you do not have an expander and use fan-out cables
to connect drives directly to the HBA, you essentially get HBA SAS port ==
device port and it works (My setup is like this with an -8e model, so 8 ports, 0
to 7). That is the case for "if (!pdev)" in sas_find_local_port.

But if there is an expander, you can have multiple devices per HBA port, so you
need to search backward using the parent device until you hit the HBA device
itself, which gives you the port to use to communicate with the device.

So not sure if we can simplify/remove the loop in sas_find_local_port(). Maybe
if we add "local_port" field to struct domain_device ? But then any topology
change event would potentially need to update this.


-- 
Damien Le Moal
Western Digital Research
