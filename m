Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4DA2D191C;
	Mon, 22 Dec 2025 21:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766440629; cv=none; b=k9zQR3BoLg5LquK/A0llAPz3NXyzAAZDEkDytSve7bpzx7FHBXVzN8kn9N7JCDV/2samENArBx7flZqbvLaj6UTkzLNFtu69w78WIZiEGuWC+EQOWexww/gaCkT32YLiDQ3yt/DYFXgPW2YQf6dXXUzFeBxrB2n3ncDTOKHgGaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766440629; c=relaxed/simple;
	bh=X5Ip7mYmMvWuOaqB2DPjVfQNu7VYRWI2yaL0nUY6FJw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GJ7xpLcIYe5TpBKsXf/rRfVsPO9KpL6QtWkCGQt0GTI8YXEY9+r+RqpNkLUt3lHtSUQg5fLHSSB59RHaMYysMGhU53XXXPFMjEoGCSdf2UdnBcGf8Dksb60VLrGEhyRHEhKErDnLf4c1Kw3sOJPcl0yDm7MYNHW5JAk/7NBm7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=VE1JIut7; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="VE1JIut7"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5127D4040B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1766440624; bh=X5Ip7mYmMvWuOaqB2DPjVfQNu7VYRWI2yaL0nUY6FJw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VE1JIut7GUbFPMzQpctI3A9FK1QEyp2Ldqfw0B0NieAbMk3CwtrUNCqg6Rsjwt1DP
	 34FmuAmhgyA9icj6YwpQ1JZ6LuReNA2mZfgfO7NbnNSwlovciw1C0ryi8uijzrqhZm
	 gbva7e8Vk3om/A8eF7w7UXp5AMcbdfVn1uIZEbPleLoPcUzXcEawE8OKyjjTbj38VQ
	 qd4HlmSJaKnHAKlurCK4vOukNA03/PUO0OW6KRon+U3A5gARjcSN1kbYgLCizbs1Rq
	 7dUqEtZ4Nq9QN875HzTdA9viuUXQOTfIbEJl0q4VNFTfBAiZGvedPvgW/bMPMmKrdR
	 3+w/pry6NPEpA==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 5127D4040B;
	Mon, 22 Dec 2025 21:57:04 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Max Nikulin <manikulin@gmail.com>
Cc: linux-doc@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bagas Sanjaya
 <bagasdotme@gmail.com>
Subject: Re: [PATCH v2 1/2] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
In-Reply-To: <f0a3e0aa-e4f9-41d3-8931-57837831d136@gmail.com>
References: <aSuj66nCF4r_5ksh@archie.me>
 <f0a3e0aa-e4f9-41d3-8931-57837831d136@gmail.com>
Date: Mon, 22 Dec 2025 14:57:03 -0700
Message-ID: <87o6nq18pc.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Max Nikulin <manikulin@gmail.com> writes:

> Don't claim that /dev/sr<N> device names for SCSI CD-ROM drives are
> deprecated and don't recommend /dev/scd<N> alternate names for them.
>
> /dev/scd<N> device names for SCSI CD-ROM drives are not in use for more
> than a decade, see commit [1] that was a part of udev release 174.
> Earlier, related rules were volatile, sometimes /dev/scd<N> were syminks
> to /dev/sr<N>, sometimes vice versa.
>
> Recognizing of root=/dev/scd<N> kernel command line argument was removed
> in kernel 2.5.45 [2].
>
> In the docs /dev/scd<N> became recommended names in 2.6.9 [3].
> Mention of these names appeared much earlier in 1.3.22 [4].

I've applied this one, thanks.

jon
