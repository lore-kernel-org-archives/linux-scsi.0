Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1000124EA90;
	Mon,  7 Sep 2026 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753827; cv=none; b=IasxUeyJqASbQRV80xUpc1TtxU0EsOZihtbx/rdrJ5+LtT3fuwCGem1YCnwqHDSW9v2MmnFCoq4Q+7GTlEXLuJWVFoqN+bJlXYZLqyGweGEZHjdig2uM0g7cOvEoYK4FfglTAALMAzpyxNEq3JaHmyVNGVpcWv+Oi+OpwnLOuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753827; c=relaxed/simple;
	bh=qy+rrqoJuO1rVcHwSphbzs7pRftMwU1ZDnXzSpXQqY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EEv+h1GSRZ/19+/GZ1xeXNz90E+u2T4aNDu8L/duHBiMtfupi+0POap7lRN9FX2FHHakJ5GMK1gN+dzW1zJvLRnXDAUpJTEzsfAjjQkh4Gl/C3KvVhxin+vDuCLSiXiKste1IPxwdjzZXbBpA/p1+tHabEo24yxXhGnXFys65Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpocj/J9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpocj/J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8411F00A3A;
	Mon,  7 Sep 2026 04:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788753825;
	bh=+l2Ct03+eBT4GrlphGE1IIBrO/rNORAR4on5Wu4oVFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mpocj/J9F6UxR7CMuFpvwzZ6wIsIr3/gHq7yR13J6tusH7w5HiMFZKj6T81H773yo
	 f60ualVnI/D/mQT0shGwuBx4/BdIYQGzjRMzKvHTMDzY9XZedwtf9A80v/ElfunZPG
	 9Fn7H889j/RFVYSlzEJB9xiWrmMCfmWlsqHQZo0etNPJ5anUaXyv+UqjC+9lDKkW5W
	 kNf+OnTVQ+xsBNBullsvhlbNbe33jE+WbwDdcSG+Hu1Gmu4ydguBZzlQNbChfQxXxs
	 kN5oQQjPWRZTP4F/Rk2e8YFtKYFaJ9Ompd4nfOWOxA8nr4/9clSyvaN63DCYozBmTP
	 WEP2ngzbEMmPA==
Message-ID: <e5600160-56da-4285-939c-6b5648264cec@kernel.org>
Date: Mon, 7 Sep 2026 13:03:42 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Validate MODE SENSE lengths in
 scsi_cdl_enable()
To: Alberto Carboneri <acarboneri@drivesec.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: Flavian Dei <fdei@drivesec.com>, Willy Tarreau <w@1wt.eu>,
 Hannes Reinecke <hare@suse.de>, Niklas Cassel <niklas.cassel@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260904135410.360314-1-acarboneri@drivesec.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260904135410.360314-1-acarboneri@drivesec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 22:54, Alberto Carboneri wrote:
> scsi_cdl_enable() uses length fields returned by MODE SENSE to locate the
> ATA feature mode page in a 64-byte stack buffer. A target can report a
> total length shorter than its mode header and block descriptors. The
> unsigned subtraction used for the MODE SELECT length can wrap, and the
> separately computed buf_data can point beyond buf.
> 
> During automatic scan, enable is false, so the read-modify-write of
> buf_data[4] can clear the low two bits of a target-selected out-of-bounds
> stack byte. scsi_mode_select() can then copy up to 64 bytes from outside
> the buffer into the outgoing MODE SELECT payload, disclosing stack contents
> to the target.
> 
> This is reachable while scanning a USB storage device that identifies as
> an ATA device and advertises CDL support. No filesystem mount or userspace
> access to the block device is required.
> 
> On upstream commit cee9395acd80 ("Linux 7.3-rc1"), a build-specific,
> one-vCPU QEMU/Raw Gadget proof using QEMU-only multi-UDC allocator
> sampling executed a fixed proof command inside the guest and created a
> UID-0-owned marker during automatic enumeration, with KASLR and NX
> enabled.
> 
> The issue was independently found during security research at Drivesec
> S.r.l.
> 
> Cap the available length to the buffer size. Validate and consume the mode
> header and block descriptor lengths before using the page, and require the
> five bytes needed to access the CDL field.
> 
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/linux-scsi/20260717192313.93D791F000E9@smtp.kernel.org/
> Link: https://lore.kernel.org/linux-scsi/20260717222931.AC4EE1F000E9@smtp.kernel.org/
> Link: https://lore.kernel.org/linux-scsi/df13ec87ac9b28e3b0a2d9eb26477e276ff0278a.camel@HansenPartnership.com/
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Co-developed-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>
> Signed-off-by: Pimen Flavian Dei (Drivesec S.r.l.) <fdei@drivesec.com>
> Signed-off-by: Alberto Carboneri (Drivesec S.r.l.) <acarboneri@drivesec.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
