Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939F11925B0
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 21:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730757132; cv=none; b=Z0zttSsLyRdpIqGSxE0YDe7battw5KAdZMCdqzMLab+c+eywwQxirC/WeQIIAQ7PTd97ODH5pz1NrUxKqlSSvwpkDOyT/uZYMKCX/XHwXcXBtRPUXqwGrj8kWRKR5+v+RU7GACLLtFxW9yaZpnaNxBxXCHJDDj12IKJwcxW1gnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730757132; c=relaxed/simple;
	bh=CtB0Gn+eu3LUDfoi78hVFVQmgZJWq1jS62yfzrI+opY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WCz4N89TFQKJyS65Wg4ZYxIYon3pffAGa1xjslpat14jX3AshQSgGrO4OJud7bXRMj72rGZxgFHhzT6DHKMJmpBPg3z9pvWJoztZOsNCvXfatKcuXxU53JXH6dgWBd2t1D6rjQmcon8Wjjsw+16h5SB0jVaYMyWkXNdkoTNi+Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 7636A92009C; Mon,  4 Nov 2024 22:52:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 6FD0F92009B;
	Mon,  4 Nov 2024 21:52:01 +0000 (GMT)
Date: Mon, 4 Nov 2024 21:52:01 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: linux-scsi@vger.kernel.org, Thomas Bogendoerfer <tbogendoerfer@suse.de>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com> <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com> <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
 <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com> <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org> <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Nov 2024, Magnus Lindholm wrote:

> I'm making another attempt at fixing the qla1280.c driver for ISP1040x
> on Alpha, while trying not to break anything on other platforms, like
> IP-30/MIPS. This time I'm using dma_get_required_mask(). Is my
> understanding that this function should provide the minimum required
> mask for the platform, assuming this works it should return something
> greater than 32-bits on IP-30/MIPS. From what I can tell by looking at
> the kernel source it should return something like a 64-bit MASK for
> the sgi/octane but I'm not in the possession of such a system so I'm
> unable to verify this.

 This is missing the point, the problem is your card and not the system.  
The chipset in the Alpha can do 64-bit DMA addressing just fine or we 
would have hit it long ago with something else.  Those systems have been 
around for 20+ years.

 Can you please implement what I told you before, that is force 32-bit DMA 
addressing for pre-ISP1040C hardware and let the system determine whether 
64-bit DMA addressing is available for ISP1040C and later devices?  This 
should cover your card, because it's an ISP1040B as you've told us.

 Does your ISP1080 cause trouble with 64-bit DMA as well?

  Maciej
