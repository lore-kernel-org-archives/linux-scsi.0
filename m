Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEA1184D;
	Sun,  7 Apr 2024 06:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712470573; cv=none; b=uz/dxrax4mr1AfOPEy7+iSfk5iNEKlKphIciX8NK5wdjLXxRht3HC0ODSGJniYKs+wWWN0ssIWeAvNE+fqj+Wd+cFUNkczEdUVWelWyU1CoTp2JKpxStG45FPkSt4Q0XIQZpaNgpSHX+KqOMst0iZZeZoV8P+w/nI+5wHtC7iXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712470573; c=relaxed/simple;
	bh=4JR4gU9/R1FHNfnsbBkUcbItC6g0bxKrpbGJYEYfhWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyGofyGJMmYTNABZF6DJIFphFGzcmMO9qQibDAarURb6jm5YEetKg890QeDukYlsS1A5u112bGTAU5CvKaUa69750cnV4sMSwzTDhHcheIJOZL1FPwuvoQi0cZwdXV/6ZUFhlEqFIwMzk2OIqHCHEl7zGYxNOnwnHs+GSsxHSCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=IxYx4FUL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=e7W4fPwS; arc=none smtp.client-ip=66.111.4.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="IxYx4FUL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="e7W4fPwS"
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailout.nyi.internal (Postfix) with ESMTP id 3AC945C005A;
	Sun,  7 Apr 2024 02:16:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Sun, 07 Apr 2024 02:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1712470570;
	 x=1712556970; bh=JEk39uRPAoWfc5DoeHTKEuGid0eaG1D4d9g3dwMxXEw=; b=
	IxYx4FULUMKZC+WWzz95i/9VjNphS0lp/Kflj9S0fkP0QDA3WQI0kgIyKhpB1N/2
	ioffGvTktMAFtqeyArzyDvKjxDoHyUOD9Qdsa8Z9+DfBvZpf0hTswXyVd/qbcQN7
	/s9eRldrPV2E12BhYHmkLPHtb0RQqcOQc5r9Nf/eKQwKYi8qtwuxR1/x/wFf7evu
	4IN6mdZYf8A8pN8NDcS2BdK1FSBk8mQyMrqJCVD0uBYc/VTRBgjHP+0blT7YGy2C
	gJvOalyBMzgM28VYroMkQ+Scsh3DgvtP+V/UwK0oEKI64bOtuSWjZa6b4BVHSXzn
	CeeIWf1iGylU8TyF4r9q0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1712470570; x=
	1712556970; bh=JEk39uRPAoWfc5DoeHTKEuGid0eaG1D4d9g3dwMxXEw=; b=e
	7W4fPwSqbm1XUfGU3DqKQiD8ULVEkl9PP91bvgtkvC2YxBgd46xVKOL5rASAJpxx
	gmL42bivepJOKZ24BCc844550j1a4IDQfwy6ie2/zGN/J3R8benG0e/qu6qK+SSG
	oI9sSbJNBOETdGDYA4KWmjWGGdrXkVlynT5c5mbaFJaNmcviU61Lr2+IoiDfEdtJ
	Yf4vcDj3hCYmWAq3ZkaCRXAEinKrop6u1r6gHD1DqiMbw5GWNyngCggYoWBm5u1X
	aDuzf6RI5jA5VAC7RDf1XkHFTn+kO8daJpTDDwF2CRgdzJ5LgdDghVBYjwd/mcCW
	9yWuabSE9hPieBbpYcA7w==
X-ME-Sender: <xms:KToSZvrS85a42OxsHK5Gy4qLhCdoBAwqPGGLMcs7iENIZCieDVq5sw>
    <xme:KToSZpqMy-ek5vsAymnj2GIXGedNHK0u3G4kSmN6tPaUHq_xw0HpXMVgARWWfIHec
    bUrlWEbOCz_Hw>
X-ME-Received: <xmr:KToSZsORVbNYTiSBxXGLiSd0NjOYBT3RxM7ZONWARifL0tPjrkV7fhArQBw-ZBIzQZfZNu6BxT7XIITPi02OEikATvYJ0r0VLFPFCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudegfedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnheple
    etveehgfelleejleeikeeljeeuieekffegteejveejueelgfevhfeiieejieetnecuffho
    mhgrihhnpeekuddrihhtpdektddrihhtpdhkvghrnhgvlhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:KjoSZi6uC_sTPGSEDqr5Q8exUfXVIkvf5Bdu4rH7AEw6KgUgUvqO5w>
    <xmx:KjoSZu5BIhVJPR6Y6A7PGPXRV9TmiC0b87KXUP1QnR2llE3aG4X9xQ>
    <xmx:KjoSZqiCIHOzjohjaFyUlTQ-7HJjxLcpLgHSrHi93N0H2YzLUfOxYA>
    <xmx:KjoSZg4juM_gA_hTojAbO_x2dyCb8wQGO5Uwgn43FhigU5tm4cVKVQ>
    <xmx:KjoSZhLCQdjC4F6JNwkhSVA9h6bWtRR45FzKEGJz5moaEATbOZRI04yOuhqS>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Apr 2024 02:16:09 -0400 (EDT)
Date: Sun, 7 Apr 2024 08:16:06 +0200
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-parisc <linux-parisc@vger.kernel.org>,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Broken Domain Validation in 6.1.84+
Message-ID: <2024040722-seminar-policy-72d8@gregkh>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
 <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
 <6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
 <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
 <189127aefff8abdabd41312663ee58c06de9de87.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <189127aefff8abdabd41312663ee58c06de9de87.camel@HansenPartnership.com>

On Sat, Apr 06, 2024 at 02:51:36PM -0400, James Bottomley wrote:
> [cc stable to see if they have any ideas about fixing this]
> On Sat, 2024-04-06 at 12:16 -0400, John David Anglin wrote:
> > On 2024-04-06 11:06 a.m., James Bottomley wrote:
> > > On Sat, 2024-04-06 at 10:30 -0400, John David Anglin wrote:
> > > > On 2024-04-05 3:36 p.m., Bart Van Assche wrote:
> > > > > On 4/4/24 13:07, John David Anglin wrote:
> > > > > > On 2024-04-04 12:32 p.m., Bart Van Assche wrote:
> > > > > > > Can you please help with verifying whether this kernel warn
> > > > > > > ing is only triggered by the 6.1 stable kernel series or
> > > > > > > whether it is also
> > > > > > > triggered by a vanilla kernel, e.g. kernel v6.8? That will 
> > > > > > > tell us whether we 
> > > > > > > need to review the upstream changes or the backp
> > > > > > > orts on the v6.1 branch.
> > > > > > Stable kernel v6.8.3 is okay.
> > > > > Would it be possible to bisect this issue on the linux-6.1.y
> > > > > branch? That probably will be faster than reviewing all
> > > > > backports
> > > > > of SCSI patches on that branch.
> > > > The warning triggers with v6.1.81.  It doesn't trigger with
> > > > v6.1.80.
> > > It's this patch:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=cf33e6ca12d814e1be2263cb76960d0019d7fb94
> > > 
> > > The specific problem being that the update to scsi_execute doesn't
> > > set the sense_len that the WARN_ON is checking.
> > > 
> > > This isn't a problem in mainline because we've converted all uses
> > > of scsi_execute.  Stable needs to either complete the conversion or
> > > back out the inital patch. This change depends on the above change:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=b73dd5f9997279715cd450ee8ca599aaff2eabb9
> > 
> > Thus, more than just the initial patch needs to be backed out.
> 
> OK, so the reason the bad patch got pulled in is because it's a
> precursor of this fixes tagged backport:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=b73dd5f9997279715cd450ee8ca599aaff2eabb9
> 
> Which is presumably the other patch you had to back out to fix the
> issue.
> 
> The problem is that Mike's series updating and then removing
> scsi_execute() went into the tree as one series, so no-one notice the
> first patch had this bug because the buggy routine got removed at the
> end of the series.  This also means there's nothing to fix and backport
> in upstream.
> 
> The bug is also more widely spread than simply domain validation,
> because every use of scsi_execute in the current stable tree will trip
> this.
> 
> I'm not sure what the best fix is.  I can certainly come up with a one
> line fix for stable adding the missing length in the #define, but it
> can't come from upstream as stated above.  We could back the two
> patches out then do a stable specific fix for the UAS problem (I don't
> think we can leave the UAS patch backed out because the problem was
> pretty serious).
> 
> What does stable want to do?

We want to do whatever is in Linus's tree if at all possible.  Or revert
anything we applied that we shouldn't have.  Either one is fine with us,
just let us know what to do here.

thanks,

greg k-h
