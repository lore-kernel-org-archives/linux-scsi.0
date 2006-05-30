From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Tue, 30 May 2006 11:03:10 -0600
Message-ID: <20060530170310.GB1610@parisc-linux.org>
References: <890BF3111FB9484E9526987D912B261901BD99@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:13523 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932339AbWE3RDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 13:03:11 -0400
Content-Disposition: inline
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD99@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, __smail D?nmez <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>

On Tue, May 30, 2006 at 07:37:18AM -0600, Ju, Seokmann wrote:
> >   */
> > -static int __init
> > +static int __devinit
> >  megaraid_init_mbox(adapter_t *adapter)

> Thank you for pointing out a bug.
> However, in my opinion, I would rather to simply remove '__init' from the function.
> The function is just a sub function called by megaraid_probe_one which has '__devinit' tag.
> Please let me know if this is acceptable.
> I will submit a patch with proper change.

Why would you want to do that?  A subfunction of a __devinit function
should also be __devinit (unless it's alsoi used by something which
isn't __devinit, of course)
