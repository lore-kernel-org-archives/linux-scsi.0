Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37211E7C2B;
	Tue, 11 Mar 2025 22:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741732211; cv=none; b=t0lteMztZZ1w6liDouJ/Arlm9Z2X9ClBBVP+zTUsHUJPLSImv33FwFptIb1Nqkaf4T5n9dg4k8sYU4GNd0dx6rRr1Dx7L0n+8NEbKVuJ/zGDPRVDBDd89EJCxz2aEzyfqmTrVhw5FWJ/b29kcToCh5GPSv7LnQtMP9TZrvjFwps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741732211; c=relaxed/simple;
	bh=D/ejxuliKp47/6IzAc6WRsye4a+L+qynFv35lbKIaLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EWKNRcc7hKd3x9zqr8LqaTkiKj4pm3WDFSjTgTLI2dGlSwRT3blE/2rkNdr6iZ2Kc/MHsuGluYtY1n0xayePh7nNb0ogr3eu9jkMdCKmiPkmZZSMJpKUlSyM2rGhoAkim088vn7vc/IlvohChaHqOjCdHx0WcadiYfyr2BKe3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiHPJ+nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiHPJ+nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184DEC4CEE9;
	Tue, 11 Mar 2025 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741732211;
	bh=D/ejxuliKp47/6IzAc6WRsye4a+L+qynFv35lbKIaLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BiHPJ+nwPHlDdP4oXGhcORfHsgcM4ttc+mb2rBRh9CEOhFHvfUmTjedK8SwgymQYZ
	 VXr1mo/6dJmpfC/SS0yu8oGrfspuKU2JoWJtf7EyjQlIJO0/rx6ZfoZNpDtVRoIfB+
	 oa0dmgJsTxfJppmd3CrGnagsijeotxf2wVZkocApISLbvIrdmWPf9O7PogNI8EXBlc
	 CSFaokKeoGkJTff4kus1apfzx+ay5JfinNkLd/VtICfuf64gg+Nyx69btjpKMHWniM
	 u8JDqy50+SPaO7hv6QqeI6gRzALAuH5PJTdjtTJd+Hj/13RNAaxCCJO72eZ+BeJ/0r
	 jluTKlrfvKbtQ==
Date: Tue, 11 Mar 2025 15:30:07 -0700
From: Kees Cook <kees@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] wireguard: noise: Add __nonstring annotations for
 unterminated strings
Message-ID: <202503111520.CF7527A@keescook>
References: <20250310222249.work.154-kees@kernel.org>
 <20250311111927.06120773@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311111927.06120773@kernel.org>

On Tue, Mar 11, 2025 at 11:19:27AM +0100, Jakub Kicinski wrote:
> On Mon, 10 Mar 2025 15:22:50 -0700 Kees Cook wrote:
> > When a character array without a terminating NUL character has a static
> > initializer, GCC 15's -Wunterminated-string-initialization will only
> > warn if the array lacks the "nonstring" attribute[1]. Mark the arrays
> > with __nonstring to and correctly identify the char array as "not a C
> > string" and thereby eliminate the warning.
> 
> Hi! Would marking all of u8 as non-string not be an option? How many 
> of such warnings do we have in the tree? Feel free to point me to a
> previous conversation.

*thread merge*

On Mon, Mar 10, 2025 at 06:38:01PM -0400, James Bottomley wrote[1]:
> This looks a bit suboptimal ... is there anywhere in the kernel u8[] is
> actually used for real strings?  In which case it would seem the better
> place to put the annotation is in the typedef for u8 arrays.

So both of you asked basically same question, and I think the simple answer
is "no we can't mark u8 as nonstring". The use of u8 has become
synonymous with "char" for a long while now, and it's gotten even more
common after we made char unsigned by default.

The number of warning sources is pretty small. I think I have identified
and proposed fixes most of them already[2]. ACPICA needs an upstream
change, which I've submitted[3]. And ACPI needed multidimensional
nonstring annotation support, which had the last needed bit added to GCC
today[4], and I've proposed support for it in the kernel[5]. With 4 and 5
ready, I can send the final patch, which is basically just this (and
actually accounts for the vast majority of warnings emitted):

-static const char table_sigs[][ACPI_NAMESEG_SIZE] __initconst = {
+static const char table_sigs[][ACPI_NAMESEG_SIZE] __nonstring_array __initconst = {

-Kees

[1] https://lore.kernel.org/lkml/98ca3727d65a418e403b03f6b17341dbcb192764.camel@HansenPartnership.com/
[2] https://lore.kernel.org/lkml/?q=f%3AKees+%22-Wunterminated-string-initialization%22
[3] https://github.com/acpica/acpica/pull/1006
[4] https://github.com/gcc-mirror/gcc/commit/afb46540d3921e96c4cd7ba8fa2c8b0901759455
[5] https://lore.kernel.org/lkml/20250310214244.work.194-kees@kernel.org/

-- 
Kees Cook
