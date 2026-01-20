Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B444E3F0757;
	Tue, 20 Jan 2026 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919291; cv=none; b=G4nuwJpb/T3VmnOfzX7khaYtKxhCKsIKUL4I8QmX/fycyUgAj4KYD2pgeX0JZc9YKnZymVuxf59zmIPpwUtDfrSPnGJT5xw40ZDLb6bMiQ9wo1pwwmuQS9NdpG6ZW+xfYh1tKtzLFTP0ZWEXzi56Bos3LqlPehWb++UDYcd4CWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919291; c=relaxed/simple;
	bh=YKcShu87x9+9YkmTw/b+/cQFVsXiNnyIMJX0xtaRqkQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gTDEJlaoJLqXx0ybmuQj1OGvbrAWEjKHP0vWxEvByqFc9A7AyNjjXAwYBNwa8jdGXOEES1RAQYHRQNqu1itAfrDeOXzAGAYOJ/zWDJOlFOd2KC9+Bjr1hrMs0utOFE1NKhkTVvWp/B23qgj8BOTzG/kernTsP+UGIGrH2aWjYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=G68vxuO7; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="G68vxuO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1768919288;
	bh=YKcShu87x9+9YkmTw/b+/cQFVsXiNnyIMJX0xtaRqkQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=G68vxuO7TJHWNzU9Enkqd1lf2/F7OFCovKG99WhzBZ3ft1hutHr+6V8jbjCba1KUB
	 aD1ANiWx3ajuWdHNCZTjwdL2lPNL5NsG58qDzVtUmD2EubwUazq99yBK6iPekeYcN4
	 T6J+EiOC+UwVhFKypgiEKLtXvWM7dsDO7CsPLCn8=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 7596A1C01F9;
	Tue, 20 Jan 2026 09:28:08 -0500 (EST)
Message-ID: <b03e802fce29c90bbc4342e7254c3adb9f48bbf7.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in
 pm8001_find_tag
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Chengfeng Ye <dg573847474@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang
	 <jinpu.wang@cloud.ionos.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2026 09:28:07 -0500
In-Reply-To: <CAAo+4rX8HT_3zKEQ3vULN-B8StnwsT-7DQPoFCOedZLrMngASQ@mail.gmail.com>
References: <20260117101948.297411-1-dg573847474@gmail.com>
	 <ae5cae8b3c4e71cf23b6f48453797ac48bea5914.camel@HansenPartnership.com>
	 <CAAo+4rUkmuOruVVVNYePyfqu5OgxUxWupEBwvJg7Aus3g7WDqA@mail.gmail.com>
	 <d7040eecadcc3557c04c27f0c74ce40b2885c311.camel@HansenPartnership.com>
	 <CAAo+4rX8HT_3zKEQ3vULN-B8StnwsT-7DQPoFCOedZLrMngASQ@mail.gmail.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-01-20 at 12:39 +0800, Chengfeng Ye wrote:
> > > Sorry that I might miss something as I am not very familiar with
> > > the code. But I also notice the find_tag() function is also
> > > invoked inside the abort function (and invoked before the
> > > completion).
> >=20
> > This is part of the problem, though: you're apparently using some
> > tool looking for data races in an ancient driver but most of what
> > you find isn't significant and costs us review cycles to check.
>=20
> Sorry indeed for the extra efforts caused. I am implementing an
> experimental tool to check for concurrency issues. I didn't mean to
> bother you on purpose (but apologize if it did happen), as I just
> like to report some potential issues and improve the security of the
> codebase by fixing them.

But this too is a problem: fixes aren't free.  In fact a portion of the
patches sold as a bug fix eventually turn out to introduce a bug ...
and that new bug is one we didn't have before.  This is just a sad
consequence of the fact that all code produced by humans contains bugs.
The longer code is used, the more chance the bugs are found and the
less buggy it becomes (even with the bug fixes introducing bugs).  So
for really old drivers we assume most of the significant bugs have been
found and we try not to perturb the code base to avoid introducing new
bugs that, given the small and decreasing user base, will take ages to
find and eliminate.

On the scale of serious problems in older drivers, theoretical data
races that cause a crash don't rank highly simply because if the race
window were significant we'd already have seen it (the detection signal
is obvious and users aren't shy about reporting driver crashes). That
makes the probability of encountering the issue in the field way lower
than the probability that any fix will introduce a new bug.  So the
balance of risks argues against applying any fix.

Regards,

James

