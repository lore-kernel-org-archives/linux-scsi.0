Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C799D3C14
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730250153; cv=none; b=DAWd/Dr39gUO4mASjzbHAeYtUxn7+2vvaqGLSkphaVj/TH2QUTKPQpBg8VVvWJr8G/vraFJImTfUxC36uZVrBfnevrLZdjaup8HdNIkCYA1c3S5YvyikOOxU/UT4X7DKDhp999HSX1Belk2jje+TRDQwQQhypTOQ8TRmerE+yiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730250153; c=relaxed/simple;
	bh=XGinJIIeqaY5jbjYD3YskeA7t7qT3C3YAlEIQqCyEGM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WPb2tkGiSQUCAsaeF8TVObhcdYtGhjb22GsBOYrcVHgj9lLHKI7c6d5CqfdjO9V9iy0ikUATCsTmorxSxKCCfaCouO9srxDIs08bXnl8NyiSlBsBBycVeDrYzG6KpVt0YsUaFjg36qwSu1SohoypgxFFyMjVu15qTVUdUO1zjC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 4720E92009C; Wed, 30 Oct 2024 02:02:22 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 414AC92009B;
	Wed, 30 Oct 2024 01:02:22 +0000 (GMT)
Date: Wed, 30 Oct 2024 01:02:22 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Magnus Lindholm <linmag7@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
In-Reply-To: <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
Message-ID: <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com> <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com> <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 28 Oct 2024, Martin K. Petersen wrote:

> > I've made some changes to the qla1280 driver, the changes include
> > things like checking if the card is in a 64-bit slot and setting
> > DMA_BIT_MASK and enable_64bit_addressing accordingly. Also in the
> > driver information string, it now shows hardware revision on 1040
> > chips as well as printing info on its PCI slot (32 or 64 bit). I've
> > tested it with a ISP1040B card and a ISP1080 and it seems to work
> > fine. This may be of interest to others still running legacy qlogic
> > SCSI-controllers?
> 
> It would be great for the driver to have a solid heuristic for running
> the older ISP cards in 32-bit mode.

 The use of the 32-bit form factor does not preclude 64-bit addressing as 
long as the PCI bus logic supports the DAC command, both in the system's 
relevant host bridge and the device concerned.  Is there documentation 
available for the ISP devices that would provide such information or is 
that all we have is trial and error?

  Maciej
