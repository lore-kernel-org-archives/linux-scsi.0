Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74087337B99;
	Wed, 11 Mar 2026 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773265343; cv=none; b=GByXCsHDQrte6gRi4D2Q5gbZkuIeJNiUlQmmCtl1Np7MuKNLkmiDaLA98rPWfVEercKtGd/JiIeS6e/qHXWimD42s6XUiQ8cQRAq3vQDAi4KYFdgUJuNuJakISLv/F1sjS9PCkDeipj8Pu7pNx0/olbsejUq1HZk7GWITdfwbRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773265343; c=relaxed/simple;
	bh=Prnb/1D+hdTcUtzQ7DayB0zDn0vGSs/5ja3y9/MdumQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cbK967AQ/O3LeMf5vcbEwLvtnOkFeNl3KF7L2fhie0eKnfUZTEWuIyVEpjWVOiiaO1UM49kFHRu1d+l3inzIal/k+3a9P4kUCIW06ExjVC7rA0mtukU4o2BWWx67k6bKmCUrUUB/0/YzDT1J2y6DatY/xURzj7NVtkIcdlcZum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s+LujL6U; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s+LujL6U"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fWPNR3XsTz1XM0pH;
	Wed, 11 Mar 2026 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773265326; x=1775857327; bh=Qx9K/t3ZE/eR6tRieLvRGViR
	u+SqIDSvom8zScavz/g=; b=s+LujL6UiDiRgFnZof1YdV05nnSoy4d0n6HIjzFB
	ncvjOlxwPEHpuTk8sxlZwoe+uO/giC8ir8G4dEdbLkcrcltZv4/xDWpIxbjG0DX+
	JGlMNgZ+BfjFDYTo7EJLRQe6FZZvgQ2WhizjwSBBryd+afEBx97el5kISlHDjv6e
	AdJrK5NkyELbYJKfGi+XxYWykv7Cv3aDB5I3aMmgq3bX9uzHfBloUC2N8x4ttSUc
	9wbhk9mV1EUWiXA0MX+yzC/88dW28ggL80KncUMJiS9w6d8HqpemLST8Ps/VUICw
	VLaWg7NkxT+NuA66JY4zaJNhfnsFMIq27khCcLAkxAVlgA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id meJ6nrvm1YDA; Wed, 11 Mar 2026 21:42:06 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fWPN967Zpz1XM0p7;
	Wed, 11 Mar 2026 21:42:01 +0000 (UTC)
Message-ID: <6d82e4f3-7fd6-48b9-b319-b5350d54e9d3@acm.org>
Date: Wed, 11 Mar 2026 14:42:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] driver core: separate function to shutdown one device
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
 driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
 linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
 =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
 Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>,
 John Meneghini <jmeneghi@redhat.com>,
 "Lombardi, Maurizio" <mlombard@redhat.com>,
 Stuart Hayes <stuart.w.hayes@gmail.com>,
 Laurence Oberman <loberman@redhat.com>, Marco Elver <elver@google.com>
References: <20260311213728.GA1024689@bhelgaas>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260311213728.GA1024689@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/26 2:37 PM, Bjorn Helgaas wrote:
> Maybe it's just the lock anti-pattern below?

Yes, that's my only concern.

> I guess avoiding the "conditional acquisition and later conditional
> release" pattern mentioned at [1] is what makes this compatible with
> lock context analysis?

Correct.

> I guess this is another way of expressing the "no conditionally held
> locks" rule [2], which is more concise and fits better in my pea
> brain.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/dev-tools/context-analysis.rst?id=v7.0-rc1#n42
> [2] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-conditionally-held-locks

Is this perhaps intended as a suggestion for simplifying the language in
Documentation/dev-tools/context-analysis.rst?

s/such as conditional acquisition and later conditional release in the 
same function/no conditionally held locks/

Thanks,

Bart.
