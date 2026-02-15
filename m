Received: from mail.he1.boomer41.net (mail.he1.boomer41.net [178.63.148.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAED1EBA19
	for <linux-scsi@vger.kernel.org>; Sun, 15 Feb 2026 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.148.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771148065; cv=none; b=cMgow9siIv6DaJQOF8BPtZUEgUx+bPNKjA6JvZisfWV/RXp1vJSmeHnnfAUuGDsos1i59jL7JYP8oxs8XH2YpNpRva3mS2AZgxeRQjRnOm7OcOaUtM9UklGDc9bu1cBe3iJJ8OwaMJILq6ZBwKycrbxH3Rb2gIHoD0s8yP0EfKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771148065; c=relaxed/simple;
	bh=matFKPSlWMRTPp2YEcBdX3cOEZsZdpmsR9UFQ7TAOY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCaahiL6eXbSNmomiMdd3+TeG3SymIJM34oYci7W4F6W+OUF70YqmVARlGyvJvJCN3Q/SJWr9XoucDYFffdVxaHB6yc/TTOeU+VhQMl24V1fri7Da4BE7Wk+990ec9mXswua4WiTmou3My0HRcGzoMVSZ6Lu50tG8ojhRBxDWco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net; spf=pass smtp.mailfrom=stephan-brunner.net; dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b=bUdYSI34; arc=none smtp.client-ip=178.63.148.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stephan-brunner.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=stephan-brunner.net header.i=@stephan-brunner.net header.b="bUdYSI34"
Date: Sun, 15 Feb 2026 10:34:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stephan-brunner.net;
	s=mail; t=1771148055;
	bh=matFKPSlWMRTPp2YEcBdX3cOEZsZdpmsR9UFQ7TAOY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bUdYSI34rslKwHkpqrbG+6lmJ9dqdPmRySHXjib1mza1sR7rDA+Di4f97Sx7AP0F3
	 jMnAn5WalB6ozzWAGKNPMQ6fkEghIobDqzCFdL0k4nVGSktlYZtJdWb/UDHRxZmpGV
	 1+x4Oq4wCAKaj2GyTMsQVbaXx0/8Cg61nR2WQdKlNwSfA5qW4OIGxKqmczlMndbBrO
	 +UDPw3DFKrfJKiun/9OGvxC5UfonwapOfJz6uP7C/ni8/BLkWnxr3FFYE4pZeEmzHt
	 8iXuasjNhyKQk2QwcgflL0em2cGFtMMKlFSuZ1/XjnmQn3WPr3fAzRGiw/c+PaqBf2
	 IBdBEWrw4TMSNdwLjSde3ManJI62fgfy9xKI6Rl+xHB3vkBh4oG6AckLajgc+iHMQ0
	 qUX2i1mnkJidao3uUXbYj4TEVJVMCHUBtzrhBKsQC4OL1OIi2vzOXepQHr1IOe8oep
	 4/zkCoH56MgECPwJwKkj6k0Adn3oKLvd6J0xvmAYEzzkLZmcdpf9msF3t2kpv+S02t
	 tX6Uq0vd3qZeHMBfvF9RUP3I683MGR1LJ7MPIWwb8DtzHG5sdZQbfqmAS2jsGzphVI
	 9Jk+zMyOdhXMApDFzNfI1l8oO+FnHt5L75n98YnET6GK+iQY+2lCDdT0zo1/AOveHR
	 rIeqINsNggcgSZ4Zb9+swS08=
From: Stephan Brunner <s.brunner@stephan-brunner.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi: Log spin up retries as standalone messages
 instead of continuations
Message-ID: <aZGTF9Yfa8GpIFOJ@stephan-brunner.net>
References: <ea0a0facf69c1b3029292897d4b8cf90cab0d0aa.1771012198.git.s.brunner@stephan-brunner.net>
 <cf29eaeec0557ea2c3800746d1b34a74c56337d8.camel@HansenPartnership.com>
 <aY-Jjr5UYIMwrAIY@stephan-brunner.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY-Jjr5UYIMwrAIY@stephan-brunner.net>

On Fri, Feb 13, 2026 at 09:29:02PM +0100, Stephan Brunner wrote:
> I'll test again on mainline to see if the dmesg continuation bug still
> happens.

Now tested with very old spinning rust, as my Samsung 870s don't
want to log the "spin up" messages anymore.

Using vanilla mainline (6.19.0) as my kernel.

The log messages were emitted exactly like this, no messages were
omitted inbetween.

> [   70.573478] sd 0:0:0:0: [sda] Spinning up disk...
> [   71.591663] ...........ready
> [   81.868486] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)

-- 
Stephan
