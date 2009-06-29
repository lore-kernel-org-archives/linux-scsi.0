From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 18:13:41 +0200
Message-ID: <20090629161341.GB3657@mother.pipebreaker.pl>
References: <20090629130835.GA3657@mother.pipebreaker.pl> <20090629133431.GM5480@parisc-linux.org> <20090629134602.GN5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 193-34-3-65.chelmnet.pl ([193.34.3.65]:59359 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZF2QNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 12:13:40 -0400
Content-Disposition: inline
In-Reply-To: <20090629134602.GN5480@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, tomek@pipebreaker.pl

On Mon, Jun 29, 2009 at 07:46:03AM -0600, Matthew Wilcox wrote:
> > 
> > It's possible the aic7xxx hardware does support 16 byte commands.  If so,
> > this is an easy fix.  If it doesn't, you could try replacing the card
> > with one that does (for example, the LSI 8xx and 10xx cards all support
> > 16 byte commands).
> 
> The aic79xx is a little more tricky ... it seems it has different cases to
> support 12, 16 and >16 byte CDBs, but it's not clear that the >16 byte CDB case is implemented.  Let's be conservative for now and bump it up to 16 bytes instead of 32.
> 
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 75b2331..3853f33 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c


  Thanks for the patch, I will rebuild driver and test tomorrow.


-- 
Tomasz Torcz                "Funeral in the morning, IDE hacking
xmpp: zdzichubg@chrome.pl    in the afternoon and evening." - Alan Cox

