Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A64139934A;
	Mon, 31 Aug 2026 02:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143801; cv=none; b=g9UjLGul2uxtVLJ0/mxQ3HRauBuM/C6kUmT9w6eU3wH9vLSe2e9zPui3wFJy3ElKWsETQf27jThuXV8uy5u9yRAl0CcA/A6KM2wZNWKo+BcfHG4f9h4pqCRaKGBhbzcFaefDUIecrFWzqY9qTFZ3pxaUZohOz2SDoA0Eyr/T02M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143801; c=relaxed/simple;
	bh=r1C7GnYwLduXYMEJrOXyGJDt8ZLZKQxhYBdTN3i8vRo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=YFA2JaNrlNtsag07xR5vu8l6jHc3MeoK5h70+y7Im9xSuSYA9BK7nazvrpzR6LQDtQGvFZjZhcqWuZZK1qpovzYc93Neh58anh6yW0a11yWIv9IOo0SC05xtJhICftZkSqA0HaMlmbfGWBkgjoLz9XHWKpyniv37C+sNNtz3GzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOkF0kuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOkF0kuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267221F000E9;
	Mon, 31 Aug 2026 02:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143798;
	bh=j96XL+ikEWynERwj6I8Ro7MJ4JE2LhGGJR2I5M386OU=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=OOkF0kuAPR3Cz+rrDV/FGPp1CvXKsgW10/KriJrHluHHtAC39Nadn4HeQly5wfQjY
	 thQAUsXhUCYcrjeSkDaiNBNgGUmYCQFJ1X1N/Wk9kVQDNBkaJJ5pbB0xfw88RdFZPJ
	 6cZZmjC+ZMNEScDyJEN4f3B7UU1rbXq284D0k+0Cfn9bbQgeb3EIp8PjlOVkcWccwD
	 sGWjsq9Jr/KE5MKu5bnBdrZNAFMlMXoHCoJTy9QHJ9x2IzPzAIH8LYLaxlUGUrkPCN
	 rG6z308xKULwvahfaVLl6SL/awvbV+hLNKotV4+JiAKB9YpQ3Up/nol2+Jfq5LOIdP
	 gkdGdZIO+tAoQ==
Message-ID: <d9f9c3e8-a24e-4da7-82c4-862e4b85e3eb@kernel.org>
Date: Mon, 31 Aug 2026 11:36:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/37] Use defined 16-bits ASC/ASCQ combinations
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/31/26 11:04, Damien Le Moal wrote:
> Martin, James,
> 
> This patch series defines as macros all ASC/ASCQ combinations present in
> https://www.t10.org/lists/asc-num.txt and converts the SCSI core code and
> SCSI low level drivers to use these macros instead of hard-coded
> ASC/ASCQs. To do this, struct scsi_sense_hdr and struct scsi_failure are
> modified to replace the asc and ascq 8-bits fields with a 16-bits
> sense_code field.
> 
> This cleans up the code in many places and makes it easier, and self
> documented, to test sense codes in the case of errors.
> 
> Overall, there should be no functional chnages here.

Sashiko pointed out a couple of valid mistakes in this series that I fixed
locally. I will wait for further comments before sending v2.

Sashiko also pointed out further pre-existing issues that I am not going to
address with this series.


-- 
Damien Le Moal
Western Digital Research
