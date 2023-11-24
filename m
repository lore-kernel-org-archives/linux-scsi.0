Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022931720;
	Fri, 24 Nov 2023 16:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L60ux02M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C7AC433C7;
	Fri, 24 Nov 2023 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700843109;
	bh=vz2zgekRERvzIcolWYRkH/DuOG/ehsYPRdrpMBVZqGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L60ux02MLoOnGxe6YwcEu4PG8a0uszd+POyFNJ/n+jWatpAWs+qeF/KMAs8G/03qV
	 Ui5AX4KzUYubOs5C/3t3158rF6o54rTUjiAZ3f8zIPZWcL8Za90PW4tfRFKwIuABSj
	 xX4S1O7J3lulZQo/lstDnD5IfJ0gdzrs6E7J7vak=
Date: Fri, 24 Nov 2023 16:25:07 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sagar Biradar <sagar.biradar@microchip.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Linux kernel regressions list <regressions@lists.linux.dev>,
	Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Gilbert Wu <gilbert.wu@microchip.com>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: scsi regression that after months is still not addressed and now
 bothering 6.1.y users, too
Message-ID: <2023112456-disinfect-undoing-b5ef@gregkh>
References: <c6ff53dc-a001-48ee-8559-b69be8e4db81@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ff53dc-a001-48ee-8559-b69be8e4db81@leemhuis.info>

On Tue, Nov 21, 2023 at 10:50:57AM +0100, Thorsten Leemhuis wrote:
> * @SCSI maintainers: could you please look into below please?
> 
> * @Stable team: you might want to take a look as well and consider a
> revert in 6.1.y (yes, I know, those are normally avoided, but here it
> might make sense).
> 
> Hi everyone!
> 
> TLDR: I noticed a regression (Adaptec 71605z with aacraid sometimes
> hangs for a while) that was reported months ago already but is still not
> fixed. Not only that, it apparently more and more users run into this
> recently, as the culprit was recently integrated into 6.1.y; I wonder if
> it would be best to revert it there, unless a fix for mainline comes
> into reach soon.
> 
> Details:
> 
> Quite a few machines with Adaptec controllers seems to hang for a few
> tens of seconds to a few minutes before things start to work normally
> again for a while:
> https://bugzilla.kernel.org/show_bug.cgi?id=217599
> 
> That problem is apparently caused by 9dc704dcc09eae ("scsi: aacraid:
> Reply queue mapping to CPUs based on IRQ affinity") [v6.4-rc7]. That
> commit despite a warning of mine to Sasha recently made it into 6.1.53
> -- and that way apparently recently reached more users recently, as
> quite a few joined that ticket.
> 
> The culprit is authored by Sagar Biradar who unless I missed something
> never replied even once to the ticket or earlier mails about it. Lore
> has no messages from him since early June.
> 
> Hannes Reinecke at least tried to fix it a few weeks ago (many thx), but
> that didn't work out (see the ticket for details). Since then things
> look stalled again, which is, ehh, unfortunate when it comes to
> regressions.

I am loath to revert a stable patch that has been there for so long as
any upgrade will just cause the same bug to show back up.  Why can't we
just revert it in Linus's tree now and I'll take that revert in the
stable trees as well?

thanks,

greg k-h
