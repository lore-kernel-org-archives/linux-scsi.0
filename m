Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D10449A3AB
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721759; cv=none; b=QL3R83CWZm76U7TS9rb2ew42HaipbhXSeDJFU0cK9pnAnGr6QrFWBsZyCVru3/5jKt6Syawv4qoVy27UGJCkXoT+qOWK7+/Gtg/q+GLrl7YXaEcyYAjWOynYi27CaDHoYNgF9hpMEm9SupvUnB8ax/FKrNl3Jc2qYKnorSHSNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721759; c=relaxed/simple;
	bh=+NDNDxTfJEYnZ+NCOl6ju37K5VjjwIE9xszPJpYpRlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+Wed2SX9Dm9m8WneEPK3MOv24eju42cT6DFs1FOJ78blzLPKC7zYYibbDLwgDH+7g5qEqN0wWrqo9CeeUFw7Obx9V413fnqEOZtgiajvXms2mgp5RIgAk3i8yMjmr7KN+zPcqW9/qJ66EO4cInVag3PY8K7NHjLIaaMb/w7Ucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAOKYVch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAOKYVch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0946C1F00898;
	Fri, 18 Sep 2026 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721757;
	bh=XK+L3stjqWEGRUipzeigBKbgJtP49SiKU3bDxcnCgFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZAOKYVchGUFcKh2DDlvgiJfHc7SNNO+4+6+uixTzGIbRE40j1TOqi9McFg2fUbhAH
	 H5spnhDBYfZK5AmhSOb7lQcyFyHWmqIkvH+CAj4uBRDaCbD6HJkhgRr9zv9LotvEZN
	 7kOf2fHvakprs9UKppywD+pFDmdqOvPzesmJ/XFq+QBZaHoBsZN6rftzQIqCPfWTuw
	 oTsx5ekrUDjBe1cOAI3Cz0GoBDB4eVhatM5WzclB5PWNb4xT68eZsthIoNvQNsupVH
	 h522WbQu/gNc6fI5M40kH458iFcS7iEhSiiLzM/25YdCz1ZMi0svTgy/CAHKlCpNrI
	 f/CslXrjYopOA==
Date: Fri, 18 Sep 2026 10:55:53 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v4 10/10] scsi: scsi_debug: Validate the access
 parameters of WRITE ATOMIC (16)
Message-ID: <aqz8mZ_ilQhaqgyA@ryzen>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-22-cassel@kernel.org>
 <d9971f1c-6e8c-4e6b-889e-bb8d6449b451@linux.dev>
 <aqzuE6cV8TpVxJ5L@ryzen>
 <84ad8a55-1bd1-415f-a60f-fc0c00a1a545@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ad8a55-1bd1-415f-a60f-fc0c00a1a545@linux.dev>

On Fri, Sep 18, 2026 at 09:19:30AM +0100, John Garry wrote:
> On 9/18/26 08:53, Niklas Cassel wrote:
> > > > Call check_device_access_params(). The zone checks that it ends with are
> > > > unreachable, as atomic writes and ZBC emulation are mutually exclusive.
> > > These are quite verbose commit messages ... LLM-generated, by chance?
> > Yes, hence the Assisted-by tag just a few lines further down:
> 
> I didn't know which part was :)
> 
> > 
> > > > Assisted-by: LLM
> > > > Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> > > > Signed-off-by: Niklas Cassel<cassel@kernel.org>
> > The commit message does point out two actual problems resulting from the
> > missing check_device_access_params() call in resp_atomic_write() (which
> > exists in all other resp_write_*() functions):
> > 
> > - Fails to repect the write protect module parameter, so resp_atomic_write()
> >    fails to generate the proper sense data in this case.
> > 
> > - Fails to check if the command will write past that device capacity, so
> >    resp_atomic_write() fails to generate the proper sense data in this case.
> > 
> > The generated sense data differs in the two cases.
> > 
> > I suppose we could drop:
> > 
> >    As a consequence a WRITE ATOMIC (16) past the end of the device is not
> >    terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
> >    reduces the LBA modulo the size of the store, so the command writes
> >    somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
> >    a device whose wp module parameter is set, which every other write
> >    refuses with DATA PROTECT.
> > 
> > 
> >  From the commit message, as I suppose it might be a bit overly verbose to
> > mention the exact sense data that each missing check would generate.
> > If someone cares about that, they can just look at the mk_sense_buffer()
> > calls in check_device_access_params().
> 
> I don't really care too much. I personally just find these LLM-generated
> commit messages laborious to read.

I do also often find LLM-generated commit messages very verbose.

But at the same time, I often find commit messages written by (most) humans
way too sparse.

Linus himself is a big fan of very verbose commit messages:
https://lore.kernel.org/all/20150314075357.GA8319@gmail.com/

But of course, there is a difference between very verbose commit messages
written by a human, and very verbose commit messages written by an LLM.

I doubt that LLM-generated commit messages are going away (and for non-native
speakers, I very much think that they are an improvement to what we were used
to), but as AI models get better and better, hopefully, they will eventually
learn how to write more concise commit messages by default.

I can imagine that it is already possible with an AI kernel skill.md that
instructs the agent to write commit messages more concise than their default.


Kind regards,
Niklas
