Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299A1D515B;
	Thu,  5 Dec 2024 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390464; cv=none; b=tqPxEUS986tF/fuiDu5v7J62HkP1foNz2SwNMgPTh6BG9N3OVX4ucGrSFW/QCXI/Wi/tqaY1krjwnAGe1H02eC9PkEGHrUuQwp7uAjGpPp7qFWOArykcURj2Ij61+g4tmuh5tp43G1+D5O/aLqX0gah7QcJ3c4Ng/wLnMvEF1kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390464; c=relaxed/simple;
	bh=ToTCGlDhZeWb307fMIu1lkFbt/mZmVrs0IkZOqW0GhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6kwlrYmgjR2psvNV/oYcIc4VbyoEafjE7lfSyntx6374mKkn+d3N3PLEg8kl2p0jURmPzu4KdTaajnFBqcjoOfnasRSfx6UdOJ4FSX0zDus+eZYMYJeAlxUYMHHM1j/a1BsWvutiUfqLVxAkVFSNyJAOggcs9WYtoW8rilR+Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfvweuEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfvweuEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A9BC4CED1;
	Thu,  5 Dec 2024 09:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733390464;
	bh=ToTCGlDhZeWb307fMIu1lkFbt/mZmVrs0IkZOqW0GhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KfvweuEtbQQYSiPUbmCtKLV+F6lG2isa7yDEEWXoGfN9QcvH2SJ6TAtNu8pBHDojN
	 bZBjlHQG/YZGEyv2Z3P0iD4Z3Flp7P8WOrk8eDWRS3WpsclKGvOtVv3PdLYg0ZbDfI
	 BnYAj3NtWcDR9q7tYripwoy0Q4OHT4awo6LAYFUVP+FaXl3AHsPUAP+Cgp+ad1dGqn
	 I1A5SLnFLN3TnFgzXmS08FJYW0cNhH1vQf5++lAJqKTqHjLlXwO/C3Ud9j7pFKZPKl
	 Pe5YOYiyALK7EYs7FoKODkw788Oms6mlDSLFDRURnFXKBZYahUHdrZ7XEte7dGAJzV
	 adBZUFBjQWhtw==
Date: Thu, 5 Dec 2024 09:20:59 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Brian Norris <briannorris@chromium.org>,
	Julius Werner <jwerner@chromium.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5] powerpc/powernv/flash: Use BIN_ATTR_ADMIN_WO() for
 bin_attribute definition
Message-ID: <Z1Fwe3HhUjaeUS9i@google.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
 <20241202-sysfs-const-bin_attr-admin_wo-v1-3-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-3-f489116210bf@weissschuh.net>

On Mon, Dec 02, 2024 at 08:00:38PM +0100, Thomas Weiﬂschuh wrote:
> Using the macro saves some lines of code and prepares the attribute for
> the general constifications of struct bin_attributes.
> 
> While at it also constify the callback parameter.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
