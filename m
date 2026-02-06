Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB30D1E3DCD;
	Fri,  6 Feb 2026 00:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770338366; cv=none; b=s4R8S07l0qo7oOmrsGXxkea38fP9jqKZvARU0yQm7q0dLIMUXwrAZtHGVXl7FTFOdCyaoKXkaTPXlUAGzeQN+i7bk95sFFLHbqBR01pfqAT/41BoO0HU9UF2lJ3Ck1JTH/LVieEZnlWRCE7no4qj62JB47MI6vhKheZRppvYS2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770338366; c=relaxed/simple;
	bh=azrVc2TDguDWWe9dsocpaHFjd1ZLoReJ5OuDTtfK788=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cQ1TlluKMNvywvIIDd76ZSB8pcd5pJrzQL88b7ohWuo/bfm9gfye9h/btCGN6LGM7nn7TL3RuFLrFyKAfejKm4lhHIIWCet0EClT6uIh09lzdDdVBvASfbt7KBzv4K8/swwc4qosVt6Rc0qojEq0287hsbeItVCoiSykVtnmkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 165FF92009C; Fri,  6 Feb 2026 01:39:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 100DB92009B;
	Fri,  6 Feb 2026 00:39:24 +0000 (GMT)
Date: Fri, 6 Feb 2026 00:39:23 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Arnd Bergmann <arnd@kernel.org>
cc: Khalid Aziz <khalid@gonehiking.org>, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, 
    Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>, 
    Alexey Gladkov <legion@kernel.org>, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCSI: buslogic: reduce stack usage
In-Reply-To: <20260203163321.2598593-1-arnd@kernel.org>
Message-ID: <alpine.DEB.2.21.2602060029161.17548@angie.orcam.me.uk>
References: <20260203163321.2598593-1-arnd@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 3 Feb 2026, Arnd Bergmann wrote:

> Some randconfig builds run into excessive stack usage with gcc-14 or
> higher, which use __attribute__((cold)) where earlier versions did
> not do that:
> 
> drivers/scsi/BusLogic.c: In function 'blogic_init':
> drivers/scsi/BusLogic.c:2398:1: error: the frame size of 1680 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

 Probably obviously correct, but still:

Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>

-- with GCC 15 and a BT-958 MultiMaster host adapter, and the rootfs as 
well as most other filesystems on devices downstream.  This is with 
slightly older 6.19.0-rc1 from the pci repo, which I've had handy from 
other verification and should not matter for the scope of this testing.

  Maciej
