Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6D854652
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 04:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813370; cv=none; b=kjZkgUK85cqwOR7ZHH27SdZ5FPOwfOdynb3+iJAoaqkbqKO4icqzl+XGM8npJS6FQbUg6gCvTOfF/qqOdGAxQeE2gQiLFWkGh2pJJNYzwc7n78iVLUs5DESrqqr6fraxZWFxUaOyoCosHoDVnH+ww9ez1kccIQ/agt0vpapl1Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813370; c=relaxed/simple;
	bh=HIkwdtNOIjHkUKYV1Qzw17ucCZW9Kb2S4VyekkUSPrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfXKJ8Ly/OiFURI71ZFuVFEQlznrzkf7F454ASXkpSjossSePPVdZH8eiCq0B+OUpKu6Dspn/34R4yI7pdqvZajFd9oWy35jubcbE7N3dW5xdiT34AhMcX38eRWkKlufAtkElFvHuwDNXRfa4WU13nXEZuXV2ePdq6l+Ud0JBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOdyGrAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOdyGrAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA2C4CEF6;
	Fri, 18 Jul 2025 04:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752813369;
	bh=HIkwdtNOIjHkUKYV1Qzw17ucCZW9Kb2S4VyekkUSPrQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dOdyGrAzF8uTzO9SJukuUAvAAtNQ0koFQiAtqL3JyZPSrgoySBvP7NOkHbX7UHqP0
	 OLwLa5tbN/iHt7eLb/6MwF8u+rXkgZ0KVHraB9ygx3awz5yD4Oo0WNwoo2fh4y//i+
	 qK7ryp1tfbXt+QZxIxvHAvYtkko8yp4OBm7Md9lShq2dnj8hbLqxtQXYhuID8tXByG
	 T/2HjQuNBQMpFdnyWPU7y3Q72IgI2uqS9N66POo1SfU7uhWjZu8X4N9pmK3UAtcvgr
	 11R8f6I50/SSlMYSfHQmojJKvyec3xM/EKW/ZEz+Hu/Q+7c905jAPtZxN3QaXEzUlE
	 CgqYQWZZ8r0ww==
Message-ID: <c0a842a6-2028-4cac-b33b-fb38801a457a@kernel.org>
Date: Fri, 18 Jul 2025 13:36:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: pm80xx: Do not use libsas port ID"
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>,
 linux-scsi@vger.kernel.org
References: <20250717165606.3099208-2-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717165606.3099208-2-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/07/18 1:56, Niklas Cassel wrote:
> This reverts commit 0f630c58e31afb3dc2373bc1126b555f4b480bb2.
> 
> Commit 0f630c58e31a ("scsi: pm80xx: Do not use libsas port ID") causes
> drives behind a SAS enclosure (which is connected to one of the ports
> on the HBA) to no longer be detected.
> 
> Connecting the drives directly to the HBA still works. Thus, the commit
> only broke the detection of drives behind a SAS enclosure.
> 
> Reverting the commit makes the drives behind the SAS enclosure to be
> detected once again.
> 
> The commit log of the offending commit is quite vague, but mentions that:
> "Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
> to get the port ID."
> 
> This assumption appears false, thus revert the offending commit.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
