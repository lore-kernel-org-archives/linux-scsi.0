Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A038302146;
	Mon,  7 Sep 2026 02:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788747181; cv=none; b=gkUudUFykdYy9YylPdD98VCMUKl9Cr5Z1IheO599G4cHj3TPrgcuaPEw1EBp3jjULfx54LbnDvxMDmWWI8OHw5JOpau4lMa14WkFYrjrpzVfFpL1hXXXVGiY1RdJKnn7OABPPTXxYSEPPRqPMUoVfBc6mJ9t0j+HjkZfiIb1jfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788747181; c=relaxed/simple;
	bh=IFKNG3iTdWyCLXpKx5pdAWKWI+st8vYwpe72lVtIkLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAiMjKsPf24FIyUzkcMbE75OBsbyH1SLRbdraTyDS0j0R7ObMmWd3KkmH+WMRF21FlY3CjkQ7558c5wNFGZUNqgKXIe9+YFmez6I4RsE+AJNrPqsJCKCIZuStzkpiCATFeQ5VVU8HGinnPgYAaoHJJQlZLhy6ZNfo1fWDK/IxQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avklq9Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avklq9Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1192F1F00A3A;
	Mon,  7 Sep 2026 02:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788747179;
	bh=5VMYlcO8U4/qNmG4mGd0OW5lpBLOv+y4jCjNoS5ouwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=avklq9QlZnzna0kuF+7ecUEfKfK8yhw/ueb8HBKr7OXDJAKN3wAlNS1Z7gnaLdeEU
	 oSEm4mT8UBEdxi9b2nFR6gfeC4CNwQhHEhTL7S1Zpk08kFh096UX/YoTRAAjIn4/ll
	 49dhumpFDFY1u0unprz8Cy7RDeqb5sro76mnoCNYit5VfNFZwIWYnFfEbP6qQwKnNT
	 tHwBMQ6t+dVyPrGNVcVRune5lCb42DjlGajWKbCqOI/49ABBVgZVpr7u2l7oCuzta1
	 m0fIdBYoTnvy/pETEsNdTxPYLglXihzBmGr0T5SeeSMoJXXTumXaC90rl8GTH/33kk
	 137ScGfZ3pOhg==
Message-ID: <c21aa9cb-0451-4c29-b64b-6bb39d430bb9@kernel.org>
Date: Mon, 7 Sep 2026 11:12:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ecard: use module_driver() to avoid repeated boilerplate
 code
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-serial@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>
References: <20260906040153.105692-1-enelsonmoore@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260906040153.105692-1-enelsonmoore@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/6/26 13:01, Ethan Nelson-Moore wrote:
> Many Acorn expansion card drivers have module_init and module_exit
> functions that only call ecard_register_driver() and
> ecard_remove_driver(). The module_driver() macro automatically
> generates these functions given the register and unregister functions.
> Switch to it to simplify the code.
> 

Would be nice to have this separated into 4 different patches, one for each
subsystem modified.

Anyway, for the ATA bits,

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
