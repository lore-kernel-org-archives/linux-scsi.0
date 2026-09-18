Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AADF3ACA6A
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723581; cv=none; b=tMMEuWgUaaTilt43fbHUiKffF6mvQvFFzkTapf3VvZjCrUAe5Ar8ErFMAN1MUxIIL3NedB6E5kZfS6eNinFS3D+r8xKiGeFBGGov+1vqA1tiBAU6064ROjTKuPZOBtSv9n1tF1ArBccxhYN6ak3X6rA3FUkfpslzDSVQ5lBcgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723581; c=relaxed/simple;
	bh=3auTLym6hlj5vbaY/6HNIUy4NhOy0cfeP1f0bHnUL10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jheJWCUpYY/TQrnmMBb8p0jn14IZ4m+srm6eqWis8gqPb6HQoGL0k7nJU4MoqIhuXkmwOadOasIJ0SWVEP3Nk/tFlxFP3ciNuaGc7wRfbyd9p9blDcr46bWvMXQpbOFsHKDYXaR09jbRVj/KCkhHl1Nz8Ea4fTOtzL7ElkRRoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ER3r3hDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ER3r3hDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7875C1F000FF;
	Fri, 18 Sep 2026 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723578;
	bh=pRO+JxsL2rE+LRXGJe30yYgIZFYvH3gQP8+Tmsfrnz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ER3r3hDVWFP5S6l/4KufHbdHS5mdmuiiVPHfhbje/klN0ncQdd6t6lrM1ZAJbw8HS
	 loRvpkey1y99pLqHiuhvx84R3jrqAtCV9GLuLSFz1+jgOgt+E/5YrStyZqTXU5Qmxm
	 OWG9I0e340L9K7RcAjazQSriAbWluah6zN4VDby3Jik7D1q/S8SQ4hod7t22C8cVTa
	 v2jjHTkVEP4MPkh0J0v5CMLNC+BmawP9eqknhFjg8qalESEwv/nHJSpBde0NzLsuUP
	 scS5KUwf8zq+8ezbD49aEym4Z2ugcUATTebKOr9vE5VChn5Y7pBr9HcTUS/fPeQxmI
	 HUWnbSnbsAcZw==
Message-ID: <1071f4a1-eb73-45cc-ac71-e1f195432b63@kernel.org>
Date: Fri, 18 Sep 2026 16:26:15 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] scsi: scsi_debug: Refuse a zoned device with a
 non-zero lowest aligned LBA
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-13-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-13-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> The LOWEST ALIGNED LOGICAL BLOCK ADDRESS field indicates the LBA of the
> first logical block that is located at the beginning of a physical
> block, see SBC-6 r02 (T10/BSR INCITS 587), 5.20.2. scsi_debug reports
> the lowest_aligned module parameter in that field of the READ CAPACITY
> (16) parameter data, but nothing else in the driver acts on it: the data
> it stores begins at LBA 0 and has no physical block structure behind it.
> 
> That does not matter for a device that is not zoned, where a write need
> not end on a physical block boundary at all. It does matter for a zoned
> device: ZBC requires a write to a sequential write required zone to end
> on a physical block boundary, and a zone begins at a multiple of the
> zone size, so a non-zero lowest aligned LBA puts the beginning of every
> zone in the middle of a physical block. A host that writes in units of
> the zone write granularity that it was given can then never satisfy the
> requirement, and such a zone cannot be written at all.
> 
> Refuse the combination rather than emulate a device that cannot be used.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
