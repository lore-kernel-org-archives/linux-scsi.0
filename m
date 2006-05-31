From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Wed, 31 May 2006 06:30:29 -0600
Message-ID: <20060531123029.GF1610@parisc-linux.org>
References: <890BF3111FB9484E9526987D912B261901BD9C@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48058 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964970AbWEaMab (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 08:30:31 -0400
Content-Disposition: inline
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD9C@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, __smail D?nmez <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>

On Tue, May 30, 2006 at 11:11:59AM -0600, Ju, Seokmann wrote:
> > Why would you want to do that?  A subfunction of a __devinit function
> > should also be __devinit (unless it's alsoi used by something which
> > isn't __devinit, of course)
> For similar reason as you pointed out, I thought it would be good to remove (unless it is required) the tag so that it can be called by any functions in the driver if needed be.

If it turns out you want to call it from elsewhere in the driver, you
should remove the __devinit tag at that time.

> I don't have enough knowledge on the topic, unfortunately. Is it hardly required to have the tag on all sub-functions called in the function?
> If so, there are couple of other sub-functions need to have the tag.

It's not required, but it is a good idea.  Marking the function as
__devinit allows the function to be discarded when we know it can't be
called again (an infrequent case these days, to be sure, but one the
embedded people are grateful for).
