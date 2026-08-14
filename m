Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A35B3947B8
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696288; cv=none; b=Jd8IW0LJzgmn+2HnBSJ9yWWf/8yIPXpcygt3Boucc5Iynj/sD8Ne2CRrQql5q3aTPkM9+8eHf32haN7mtVvJq7/ea1ptTYMXlLkzwAVdUAnxDdZLciDd+FHWaily6fAtIYPv25wk3sVemNA4Auax0y+LGlnr494ztmI/Na6saFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696288; c=relaxed/simple;
	bh=IGbKwXkQE1xEFf1yVrrv6uksXrxJ3Y6Zcv4TfGeD7gA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYZsla8wjoHwx+wFWxtZtnQdObmvW0fT7mTnj34LarPFMOJ2DDT8ZeH0aIPpA/EnEHDNelRsQHot8PhdMp0ye8XAT2HruD9zLXy11WQOOYhwMhoYhC5gQusf+6xPfONrA0AKPi4pEn0851vhsUqatoBv4UiXzHvyxZNmAKhTtw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7RjwQtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7RjwQtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55CA1F000E9;
	Fri, 14 Aug 2026 08:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786696279;
	bh=p3xr6MaZrJYCyUlDIktrbJQGrBUYz4XFSrLK2Z/KEWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h7RjwQtGNhGpw67GxHzwIiO4iyythxs+vSU1wG5U6Xlm2A57lnawqMzETMYZdPbBU
	 LBVHkoRtkq++LANLrErmkiKjvd5a/HaRT1tolNpoAcfiD7YeZ7TD3keeWg7bAAwZfk
	 MlDX15+oGRI1S9cXRsKCKCbPTq1Mg++7bA+EcANnQtizE08h2l3T8x5nmucDx3xvTQ
	 cm4Wr0SPjRm22hdGnhdghJCRGJMlE0xHZGbXdNTxEkKs65bxkSwQByx01AgR1CCXkn
	 iEvNA2WxRF8P4FphLU/dGCBs6NYwX2Ccomk43963A1sYbEJwC3uxmYABXXc6fOkL9D
	 adV8wzYJL0tAw==
Message-ID: <356cb94c-d8e0-41c5-b45b-dfdd98b00a03@kernel.org>
Date: Fri, 14 Aug 2026 17:31:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: leapraid: standardize NCQ priority sysfs attributes
To: Dongdong Hao <doubled@leap-io-kernel.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: hare@kernel.org, hare@suse.de, yjzhang@leap-io-kernel.com,
 kezijie@leap-io-kernel.com, jzzhang@leap-io-kernel.com,
 baikefan@leap-io-kernel.com, linux-scsi@vger.kernel.org
References: <20260814081412.394957-1-doubled@leap-io-kernel.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260814081412.394957-1-doubled@leap-io-kernel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/14/26 17:14, Dongdong Hao wrote:
> Replace the earlier LeapRAID ncq_cmd_prio_enable
> attribute with the standard sas_ncq_prio_supported and
> sas_ncq_prio_enable names documented in
> Documentation/ABI/testing/sysfs-block-device, and rename
> the per-device NCQ priority state to match.
> 
> The earlier ncq_cmd_prio_enable name has not yet been
> established as part of a released userspace ABI, so no
> compatibility alias is needed.
> 
> For LeapRAID, sas_ncq_prio_enable is backed by the
> driver's per-device NCQ priority state and controls
> whether RT-class I/O requests are issued with command
> priority on supported SATA devices.
> 
> Update leapraid.rst to describe the standard attribute
> names and paths, and clean up the surrounding RST text
> for consistency with kernel documentation style.
> 
> Also switch the capability check from open-coded VPD
> page 0x89 parsing to sas_ata_ncq_prio_supported(), use
> kstrtobool() for the enable path, and expose the NCQ
> priority attributes only for SATA devices using
> LeapRAID's target-private SAS device state.
> 
> Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>

Your commit message lines are very short.
Please use up to 75 chars per line.

Other than that, looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
