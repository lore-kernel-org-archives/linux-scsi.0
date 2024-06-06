Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326421953A4
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717675872; cv=none; b=iCQUOkVTgHyQQRsQYwivAHY/dSuRU+P42RWisD24WCkhBiEYcR0khmxCRGhew7cV+I3lQmS9p+NcVzMj4bA2b/8Xvxyofv0YeNDUI0tZMSQvE4noe77nfutTDZIKNKc0btVXDA/NVvaDpG+CXcvqsKntNW//MHukkpVLOtoopU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717675872; c=relaxed/simple;
	bh=0EHidEDhi0TaJ4Ns+H4Mt2KWMA29OVMotZ3pKBw2O7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ma+v2Mq57nxcpR2QWfNNE1HP7Ihx51aRxxov/UVMLD05crbbIuqpqWGFcuuQiJ2CbKQVCctGN0IrRzOMonmhMOq3Y0G/FXL9GpFEoFgwixwMlp8bvQfyvvuKt3/daS3mg3oLL+7j6/5jIYkb+h7d0z9gjBiWFCvQW5vaS+jXXS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kAVhHYgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAVhHYgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68884C32782;
	Thu,  6 Jun 2024 12:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717675872;
	bh=0EHidEDhi0TaJ4Ns+H4Mt2KWMA29OVMotZ3pKBw2O7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kAVhHYgh3tGun5mBd6lbMomXNwcIdhm2Mmspci5YUaTE+zFFChk0O15FekuXW1Qpi
	 0arpJEeJpd+6qUunXec9lI46d4NcbA+xY+6VxDZXx8G9qCbMk7AtZdkb+i/OP0PZMY
	 MK5PgbUBgSvOAXgVeNFGASEjfzcfkU3/M3V3l9hLmLasvIDjhHsuaZThl4ZPaGa11n
	 pi/OekMiX0O/obL+LCTCRsLmVqFzS7UodFhALHmw0FrF95Ta9UWbBUY/eFSF0p+XOU
	 DYbPphAxQrS+l674Fpys4nluaCVmUxM2Bl4SrEMlXQdNPDuEaxMsftWKHhI8lQzdzx
	 asWUGKl9dEvvQ==
Message-ID: <5f464af3-4c57-46d9-b554-6c537b04e7eb@kernel.org>
Date: Thu, 6 Jun 2024 21:11:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>
References: <20240606054606.55624-1-dlemoal@kernel.org>
 <ZmGCQTIjZjEpTJUR@infradead.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZmGCQTIjZjEpTJUR@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 18:32, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 02:46:06PM +0900, Damien Le Moal wrote:
>> However, for ATA devices, a drive may spin-up with the CDL feature
>> either enabled or disabled by default, depending on the drive. But the
>> scsi device cdl_enable field is always initialized to false (CDL
>> disabled), regardless of the actual device CDL feature state.
> 
> The same should be true for native SCSI as well, right?

Nope, because SPC does not define a knob to turn CDL on/off on the device. For
SAS drives, if CDL is supported, it is always enabled/usable. This is why
scsi_enable_cdl() is reduced to setting sdev->cdl_enable only (and also why
there that ugly "if (is_ata)".

> 
> The patch itself looks good, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-- 
Damien Le Moal
Western Digital Research

