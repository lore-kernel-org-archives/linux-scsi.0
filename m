Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7060466AE6
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738456; cv=none; b=ttfQccJh7adqRnXEglbWShrpGNUGGHw0O37y2RNWCiALuy6wfZKJZWMgjP08drA/y5arcaHO8ia/DrKLNcn3OlE3MsEb/z+eifRwC96t2Uedds4x8jz7yGrTLCke1HLght5dWvoA6gto7LEno9di4Cy8Q15INDhwF2cV2z2/htU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738456; c=relaxed/simple;
	bh=YqaaR2yvQFiAgXoSPkLuP3Z9hr+gZfqGTsXDxSLvMcs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WZwCzjit/I8u+aLzqtsRA2dE/+ljNr3SJatfd8vE01qqnFoKssPwZVlNeF+Y3TvEl22lfMSlf4VBZMr1une2uAkOUDaEIPG2h++QBfnRaxo8Es1gkNuN5vmEEQWvf/IhyCU+vgcF+t/PHIyG4IKvVvRpgr9K7zf4BR7Krf7rd04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AH3e5agO; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AH3e5agO"
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784738439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1JCCJvfIsHl0qQrWNPmjNKh71QhXNjRnIzF3Gh+J1bE=;
	b=AH3e5agOwgA/LQCGJ/IukFEm4cl6/zgb7NhRqB5aWPhpdH5DuiEhk9U/bHugqpwNpU5GVZ
	wQRras16xSHR3KivkKC8MamTOOw4yiQefFTTjxbgKnwDY0bTQCXApJMxWO4BjOpj/CVwTV
	rma2MzyU9oUM4qM6TTZ4jsgz6b5Gh2w=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: How to fix problems with the sashiko review model
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>
Date: Wed, 22 Jul 2026 09:40:13 -0700
Cc: Guenter Roeck <linux@roeck-us.net>,
 Greg KH <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev,
 Chris Mason <clm@fb.com>, linux-scsi@vger.kernel.org,
 ksummit@lists.linux.dev
Message-Id: <8CC99AC2-E8E6-4644-A504-454C1FFD30CC@linux.dev>
References: <8cb7a4a8a13bb003daa1d1413517e104955772d3.camel@HansenPartnership.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
X-Migadu-Flow: FLOW_OUT

> On Jul 22, 2026, at 8:10=E2=80=AFAM, James Bottomley <James.Bottomley@hans=
enpartnership.com> wrote:
>=20
> =EF=BB=BFOn Wed, 2026-07-22 at 06:43 -0700, Guenter Roeck wrote:
> [...]
>> For Sashiko, fork and clone
>> https://github.com/sashiko-dev/sashiko.git,
>> submit your changes into the clone, and send a pull request. Or at
>> least that is how I do it.
>>=20
>> In the Sashiko source, per-subsystem prompts are located in directory
>> third_party/prompts/kernel/subsystem.
>=20
> OK, now I'm confused.  I thought
>=20
> https://github.com/masoncl/review-prompts
>=20
> was the source of truth for this, but that project seems to have been
> copied into sashiko rather than pulled in as a module.  If you want to
> improve the review prompts do you now have to submit to both (which is
> getting to be a bit wasteful)?

It=E2=80=99s a bit messy now, but Chris and me are working on something more=
 sane.
As of now, Sashiko is using per-subsystem prompts from Chris=E2=80=99s repos=
itory
with some changes around more generic prompts. I periodically pull updates
from Chris=E2=80=99s repository. Also several folks sent prompts changes dir=
ectly to
Sashiko repository, Idk if Chris is merging them back, probably not.

I also experiment with auto-generating prompts based on human feedback
to sashiko reviews, initial results are quite promising.

So as of now, I=E2=80=99d say send a pull request to Chris or me directly, w=
e=E2=80=99ll figure out
a better model going forward.

The hard part is testing: it=E2=80=99s quite easy to confuse a LLM with an u=
nlucky prompt change.
We need a stronger guidance and maybe LLM review for prompts too (sashiko fo=
r sashiko?!).
E.g. Sashiko implements a much smaller set of tools (intentionally) than a g=
eneric coding agent,
so if a prompt contains something like =E2=80=9Crun checkpatch.pl=E2=80=9D o=
r =E2=80=9Csearch lore for =E2=80=A6=E2=80=9D it might be
very confusing to the LLM. When I=E2=80=99m pulling significant prompt updat=
es from Chris=E2=80=99s repository,
I run the full benchmark to make sure we don=E2=80=99t get regressions.

Thanks!=
