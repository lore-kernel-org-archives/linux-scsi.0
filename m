Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18701E2610
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730830576; cv=none; b=R9Cv/EncLbaHXB6oKf67I6/QEcLWqI/5k+erjUFHIezwKOvb8hxoovcWIcMWHFx1myxoCvnTchubLuQWAYmIqHTV03OP2YeyKKIySGZLZ8e8w6pZDsxxMDXGz20WIiK5NO2/lQ5/lzsxWeDlxaxf6TjaSNCs+GhKUqIsM8Pqt8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730830576; c=relaxed/simple;
	bh=ImvPmtjk0Rj0OePcMNaSSiVMRPI2T2iFjjkLBqRCJ/k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=B06FChmekyJHJSJUa3ckH7DyzTNrtLn5md37H4tg/wW1fQsjYTIq307x/DdAe2hzJMpv+1sfF7dJI7TUdqQCTNW1rMLjiqLO8hg361doWZa4iIUdvXy73UHZnYQ08yu1u2uGx39fmL5MGTUjMPY/ifKJoCtbH6DdmqCi2qRVcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 067AE92009C; Tue,  5 Nov 2024 19:16:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 038B292009B;
	Tue,  5 Nov 2024 18:16:11 +0000 (GMT)
Date: Tue, 5 Nov 2024 18:16:11 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
    Magnus Lindholm <linmag7@gmail.com>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <20241105093416.773fb59e@samweis>
Message-ID: <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com> <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
 <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com> <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com> <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
 <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com> <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org> <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com> <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk>
 <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com> <20241105093416.773fb59e@samweis>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 5 Nov 2024, Thomas Bogendoerfer wrote:

> > > force 32-bit DMA addressing for pre-ISP1040C hardware and let the
> > > system determine whether 64-bit DMA addressing is available for
> > > ISP1040C and later devices?  
> > 
> > Yep, that is the correct approach.
> > 
> > Thomas: Can you confirm that your SGI hardware has a C rev 1040 ISP?
> 
> they are ISP1040B, so IMHO the revision is not the point.

 Yet there appears to be a difference somewhere between the two supposedly 
identical chips that makes one work with 64-bit addressing while the other 
does not.  Is it possible that the ISP1040B used in SGI systems has been 
modified on request and not relabeled before QLogic chose to put it on the 
general market?  I can see the spread is very narrow between the dates of 
the ISP1040B and ISP1040C datasheets available: Feb 5th vs Jul 29th, 1997.

 Thomas, Magnus, can you please check what hardware revision is actually 
reported by your devices?  Also a dump of the PCI configuration space 
would be very useful, or at the very least the value of the PCI Revision 
ID register, which is independent from the hardware revision reported via 
the device I/O registers.

 The firmware is loaded by us, so I presume it's the same version on both 
systems (I can see 7.65.06 in Debian, the same as in the report upthread), 
and that only leaves any variable to the PCI bus logic onchip.

 If all else fails, I would still recommend to disable by default 32-bit 
DMA addressing for pre-ISP1040C hardware, as that matches documentation, 
and then have a platform quirk to enable it specifically for ISP1040B for 
the relevant SGI configurations.  But I do hope there is a better approach 
possible.

  Maciej
