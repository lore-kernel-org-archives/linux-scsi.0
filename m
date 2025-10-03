Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D309D1DE4E1
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 04:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759465461; cv=none; b=ZuDV4mixNvWQFXet1wTpGJEqieu65+atJ1i+0PXKB7h9XXGUc4wJkd55DjupnMlordTtzHDSuzjszThjmiAkv93jxdVKRhvFAh9MMU6X3KMLXzzspgLqdq+xfNbkGPVK6+GlU0UaKTKegIE3zeZJl+nEb/Ebn+7NeDcYiVCD7/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759465461; c=relaxed/simple;
	bh=o0B7xK9bCjoRC8P9pLIhim8j/bfi3aW6kPIS/OZi7TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpXxe4ZAJnYbq7cofjQIdj49ojYabJtA6BLKJpICR9f0LleF0Gouu7ugwmnVLd3hOyvwQgitPkP6ZXzm+KxSPldg5+jE2zvnM74FklfWyaPZcCnE6qgCdF0q3HtKDCZBAIXA8w96HM7DN3uyaBomhESkw4EdcQL2Ia1L9C3jRy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLTBg7eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLTBg7eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAF5C4CEF5;
	Fri,  3 Oct 2025 04:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759465461;
	bh=o0B7xK9bCjoRC8P9pLIhim8j/bfi3aW6kPIS/OZi7TU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eLTBg7eCyiqhZJdtq2TwPzSeQ1YZqL+kLHnI4W15qV6T583V3fkZDjLUBMmBTbvb9
	 SG1yrOV5DFIXqchi+r1XAEUshd2dnHmZ3+TVyWAHfOxVvwF8xvx69/kDBBVv2h7hrp
	 gwkSsyeIaDfFRm86bwCiboLBL3uNpAqOCak2GFOGjT89HCsz1lvRMOEnPIR9fHoZEF
	 reksA5VyZUe2YRf3lNFUkZnnTlxWD0ONHst9f06Q2oYkVLrhnHvADql8ztqM1FVtDO
	 2CwWPcA3ue9OgYRDjicAAmwETgjhV6PISxRtZzb2frpE58dxs4Ek3zycd0dcsZE8yF
	 D/gb6SJsNLRSQ==
Message-ID: <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org>
Date: Fri, 3 Oct 2025 13:24:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in
 read_capacity_10() with any ASCQ
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-3-emilne@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> This makes the handling in read_capacity_10() consistent with other
> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> result in wildcard matching, it only handled ASCQ 0x00.  This patch
> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> if a nonzero ASCQ is ever returned.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Doesn't this need a Fixes tag ?

Other than that, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
