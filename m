Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE21D278A;
	Thu,  5 Dec 2024 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390481; cv=none; b=PsbMTVAI4zB7VE9zbZYwg3Wq4qXf7vw5nhL/M4rV2eo7um1A1S1VhnG8JV/H4n3n5ntayOObp/ac0qR8xW4BKzr01VCrRkxzZhbmcS8CTH2R27z1rTh/vzGSAjV3jljiGbkejfbXg+/bNZ202ITbL1MpzC1cRUhbc1Qk5R7qXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390481; c=relaxed/simple;
	bh=McHjG8OwZGNDnbXe/yojBntjPI6YEZb2UANyYbLxMlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYeCyvpdXM5MUHyWW0Y3NVcAeIKgQcG9Zd+b74zw1z5tDo2YA1tiqab9Vq64X0S9puSR9simOyySjtwb/vTAXpQBBd0k3xcN2tW4bLkD42BhJcXGdtYdREVi7UDsEIQD7fU2WRAT/4U5uPIIr3UjoHWC9p6lPGf4G+OMTmZm/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbH12lnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbH12lnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261E3C4CED6;
	Thu,  5 Dec 2024 09:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733390481;
	bh=McHjG8OwZGNDnbXe/yojBntjPI6YEZb2UANyYbLxMlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RbH12lnGLu9H2X+Ru0wugobk/9MZivqUr4dXb2LHFMt8RQ66l69u7FLE6GiP75CBZ
	 NdwgKDL6TeV5t7oARPMgPfTCoKMwv9W8rb/dftYdYOvJc7BfQKJK6vUex3D2ENIVcP
	 IRBJ2SUchudMMrxep1Q45YalEsliZLXIIuguGybOdB30HhHaFHvz9VJ1Nh1zcNdoNr
	 cvgB7TUS2D8uRI1Oa1l2L3eXVhGdYrE5uebRFkbxydJckjH4kBI1Vv54YTRtr51QIw
	 W9/Co4Uw3DLYlYjOD/1uHqm0hFeKQFNGkDUaRPgdOyWn16oJ94jWA/pU4TZGizyM4B
	 vATnI1xcX0t/g==
Date: Thu, 5 Dec 2024 09:21:16 +0000
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
Subject: Re: [PATCH 4/5] firmware: google: gsmi: Use BIN_ATTR_ADMIN_WO() for
 bin_attribute definition
Message-ID: <Z1FwjMaeNQINYPRB@google.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
 <20241202-sysfs-const-bin_attr-admin_wo-v1-4-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-4-f489116210bf@weissschuh.net>

On Mon, Dec 02, 2024 at 08:00:39PM +0100, Thomas Weiﬂschuh wrote:
> Using the macro saves some lines of code and prepares the attribute for
> the general constifications of struct bin_attributes.
> 
> While at it also constify the callback parameter.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Acked-by: Tzung-Bi Shih <tzungbi@kernel.org>
