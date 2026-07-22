Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE52E43BDA0
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734729; cv=none; b=ZaJROU+0CSnH+SskH1hjv93/n5OGGf/aYWa5ZWeRjMUJsRm0oDYVbI9+8H+Xp3YlqBh0IEw2EXoHgQN0C+zNjc7LMMe6FT22LmDoSwiWycEjVWw9FnaKLmYQsexo3wUEHPvwwtBUaiLgWKifgz93fTZ4MjgRnUJkBZAoQetC6Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734729; c=relaxed/simple;
	bh=KISgkJl+MCzGelmSNtGA0tEVHWBJ5lotjdmka1PaMmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNhm5oVpZ/79TPJ4bSWyecQci/srgJmsFuvHlXCwai8L0d0v0xhePq3FGHSrYMi/M3bnhw7DFBWcAvsjWWZiYkv8fElKUpUOZEW3ilzVDbM1BmDCNohjpLGsv5m7pAyQPT4Ne/vRYxmzmjdO19CYjajEhRol+3f+G00CbId0orw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7253880211;
	Wed, 22 Jul 2026 15:38:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 6B19432;
	Wed, 22 Jul 2026 15:38:44 +0000 (UTC)
Date: Wed, 22 Jul 2026 11:39:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH 
 <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, Chris Mason
 <clm@fb.com>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
Message-ID: <20260722113904.38fa087b@gandalf.local.home>
In-Reply-To: <96e5845db5e8e4f2d2253c2014b00d0db093ff21.camel@sipsolutions.net>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	<20260722042744.5C1B01F000E9@smtp.kernel.org>
	<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	<2026072224-moisture-gonad-409f@gregkh>
	<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
	<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
	<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
	<96e5845db5e8e4f2d2253c2014b00d0db093ff21.camel@sipsolutions.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 6B19432
X-Stat-Signature: shz7ohbz3qb6555czgngxnptye9pyg5c
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18zeszmkViJNf4SCj5aDvCQ59p+2uNrD8A=
X-HE-Tag: 1784734724-189888
X-HE-Meta: U2FsdGVkX1/MLTwQ9lgHj++8/oEQ3DAygXajcifG5JjWz9t+aABZFRvOKq5TBZ9Di7gEHiBaBiU1uJQC95QW7mLOxCzLU2Dnkau5+wBcT7f0gCReUNfWtr17D9qH1SITFsIHYIwNGIwpHq2WTKbzsOvsY7LIy+LTm8R0+DtPKGveU6Iu5Ie7Yz782XzG+55hrE9sSK+c6JEe/M7Qp/T/BlAHMMEu1rBwOL9vVzp4ufXCrUOEyUDAm1iTg8KQqWU0kTY/2T5awFjGtv2qlk+6fKX7lbQa4sGYlN0S//nl1wv5u9ZbLIWknpfSYw4XItczaY7YB9nZxWaFnl96ZfXwPrwMfKbs0vTiYSjzaNS2q0lU4lAtygWzu/v2e2jNiNn2

On Wed, 22 Jul 2026 16:25:03 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> There's also a risk thing - if you erroneously get a report for SCSI (as
> you did, IIUC) then you can opt out at that point and not worry about it
> again.
> 
> If we erroneously _don't_ get a report for something that didn't speak
> up because they're not on the list, didn't dare say anything, didn't pay
> attention, etc. then nobody ever knows until someone starts exploiting
> it?

I agree with Johannes here. It's one thing to get an annoying report that
says "You can be compromised by your hardware" when the hardware is
trusted. I have the same issue with boot parameters. But I rather opt-in
than have the case that I'm the odd one out where my hardware is not
trustworthy, but I don't know I have to take action to have it checked.

That is, getting a false positive tells you that you need to take action to
opt out (perhaps the report can say "if you trust the hardware go to <link>
to opt out of this message). But it's much worse if we let security issues
escape because the maintainer didn't opt-in. As there's nothing to tell the
maintainer they need to opt-in to begin with.

-- Steve
