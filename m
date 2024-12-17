Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611E776034;
	Tue, 17 Dec 2024 03:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734405968; cv=none; b=YhkPUk6m42wKFA6MkXZ/8EMcUbRmEowX/fSFVNGHoWDBd+gmcUT3zNqflTZMeeCXX7xKZEx2rjzHNa8K+QGNN8J3JwHglkSCxud+KdKXsHswvDhhLBtM/95EZbTJho9uKTJ7UDoXqNWTHSWwGzXIs7/hCsdgU7Faak19N6J47EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734405968; c=relaxed/simple;
	bh=JlcQZlpEq87WaYonljOQJTcis2Rm4csqH0xDxg7Rw6U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q69uiMsO0CyG7WHeNaUaun3osqVJNuJnBggaw8gnH4m5KRIUhRbgHETfSkJ2H27Rgtzol2gNVjYrOzsQEgU86STe52vx6Try6UvuqXDLDdiYROj9ge39mNUIgQdchdjz3bh2nypaBq8GCHdwCdkYV54eTIFCWJbhWu5Iq98KvsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+wQKkJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+wQKkJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1812C4CED3;
	Tue, 17 Dec 2024 03:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734405968;
	bh=JlcQZlpEq87WaYonljOQJTcis2Rm4csqH0xDxg7Rw6U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=n+wQKkJGSneOniU6dmPRnpTp6ZH0m7z+9AfPZtTgG7u59zo3MSnLnATocr/Ra902Z
	 KB6QjK+ZTU8QoXTuf/C1fBQppIr17VtOZBBKWv+612jcR3eEqfErnQCabjXn3koyD+
	 Azbf5HxWiMNCUV8Lex/3FAVltxbTLEstz68dNpUP5t9MDPHGD99lQeBe39oelRLgES
	 PRVHDxbWDTXaIS6bYaubRMlvs35J3WszV2sosGZFwU9VwvLGQTud31a6ncxJNa2kK2
	 hCJB9fu5fKLEdNZ6tNGmUmK2hrUWVcC9A0fWhZztSygPbzxn8W5gVg0STF3mckYfaO
	 JgjKvR1u90EIw==
From: Michael Ellerman <mpe@kernel.org>
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com,
 ukrishn@linux.ibm.com, manoj@linux.ibm.com, clombard@linux.ibm.com,
 vaibhav@linux.ibm.com
Subject: Re: [PATCH 0/2] Remove cxl and cxlflash drivers
In-Reply-To: <20241210072721.157323-1-ajd@linux.ibm.com>
References: <20241210072721.157323-1-ajd@linux.ibm.com>
Date: Tue, 17 Dec 2024 14:26:04 +1100
Message-ID: <87y10f2do3.fsf@mpe.ellerman.id.au>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Andrew Donnellan <ajd@linux.ibm.com> writes:
> This series removes the cxl and cxlflash drivers for IBM CAPI devices.
>
> CAPI devices have been out of production for some time, and we're not
> aware of any remaining users who are likely to want a modern kernel.
> There's almost certainly some remaining driver bugs and we don't have much
> hardware available to properly test the drivers any more. Removing these
> drivers will also mean we can get rid of a non-trivial amount of support
> code in arch/powerpc.
>
> Thanks to everyone who's worked on these drivers over the last decade.

It would be good to explain that this only removes support for the
original CAPI interface - not the Power9 "OpenCAPI", which is still
supported by drivers/misc/ocxl.

cheers
