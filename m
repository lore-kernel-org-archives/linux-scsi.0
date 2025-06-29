Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F254685;
	Sun, 29 Jun 2025 12:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751199794; cv=none; b=u2+y87Q0FAB76je02rAi1XsMLIhe69gsjllfW2iAR+4wWRv8idTH7GuQU9mUcHbANDi7HAhdlw5uGi7HyUQV1UqMxXnaTzUhR7lNO/QpssJLTMrm22nDoOvMT3ylF29kZqLYYz6SbyUYVax9Mcr7ASQwkTyeRHgDFMHgSX40brQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751199794; c=relaxed/simple;
	bh=JiDWtDIw5elQ/Sp3UkR3s9Q7DdeWrSEJ7ueePtjtjpQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=n0GDXihwIHvRcHOM3cGlCdC3vcYTqpgLsB1Y/a86zC3t4YcGcFsEbsFDs4/drkoq4xcJcKpDGbfzgf2jirdLsAsqYzMlTnJLhM+MdHQuyFuYMIKgHet5bxUs942FKEK1qlnIeYRW+kYhEzWoWsA7AIPtlpoTe0jLayEtK50vmw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from localhost (25.205.forpsi.net [80.211.205.25])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 5e338b19 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 29 Jun 2025 14:16:27 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 29 Jun 2025 14:16:25 +0200
Message-Id: <DAZ0DFSD9PQS.1UG92BS9ZTTOZ@bsdbackstore.eu>
Cc: <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
 <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: generate correct string identifiers for PR OUT
 transport IDs
From: "Maurizio Lombardi" <mlombard@bsdbackstore.eu>
To: "Dmitry Bogdanov" <d.bogdanov@yadro.com>, "Maurizio Lombardi"
 <mlombard@redhat.com>
X-Mailer: aerc
References: <20250627145229.286252-1-mlombard@redhat.com>
 <20250627174022.GA19805@yadro.com>
In-Reply-To: <20250627174022.GA19805@yadro.com>

On Fri Jun 27, 2025 at 7:40 PM CEST, Dmitry Bogdanov wrote:
> On Fri, Jun 27, 2025 at 04:52:29PM +0200, Maurizio Lombardi wrote:
>>=20
>> Fix target_parse_pr_out_transport_id() to
>> return a dynamically allocated string representing the
>> transport ID in a standardized, human-readable format
>> (e.g., naa.xxxxxxxx...) for various SCSI protocol types
>> (SAS, FCP, SRP, SBP).
>
> There is no a single standard how to represent TransportId. There are
> several standards for the same port address. But TransportId itself is
> the single standard to represent different port names in binary format.
> So, the most correct solution would be have TransportId for ACLs and
> to match them.

That's right. I will avoid using the word "standardized", which is not
correct in this context.

>
>>=20
>> Previously, the function returned a pointer to the raw binary buffer.
>> The caller would then compared it to a human-readable string,
>> which obviously always failed.
>>
>> Now, the function constructs a string using kasprintf()
>> based on the protocol's offset and format:
>>=20
>> * SAS, FCP, SBP: 64-bit identifier
>> * SRP: 128-bit identifier
>> * iSCSI: duplicates the iqn string to match the new allocation behavior
>
> The caller compares it with a specifically prepared string buffer by
> fabric module in its own way. And they are not corresponded any
> standard and, that especially important, to your code.
> Mostly that string contains only hex-representation without any prefixes.
> You may grep target_setup_session to check which transport
> generates what a string.

Thanks for the hint. I was misled by rtslib which enforces those
prefixes. I will fix it and submit a V2.

Maurizio

