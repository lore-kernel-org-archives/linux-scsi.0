From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Wed, 26 Sep 2007 13:10:47 +0900
Message-ID: <20070925093611I.tomof@acm.org>
References: <1190778353.8707.29.camel@localhost.localdomain>
	<20070925092106U.tomof@acm.org>
	<1190779313.8707.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:38082 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXIZELJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 00:11:09 -0400
In-Reply-To: <1190779313.8707.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: tomof@acm.org, jeff@garzik.org, matthew@wil.cx, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Tue, 25 Sep 2007 23:01:53 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-09-26 at 12:55 +0900, FUJITA Tomonori wrote:
> > On Tue, 25 Sep 2007 22:45:53 -0500
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > On Tue, 2007-09-25 at 23:34 -0400, Jeff Garzik wrote:
> > > > Matthew Wilcox wrote:
> > > > > On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
> > > > >> Are there any const-ness worries for scsi_host_template, or plans for 
> > > > >> the future?  I do not see any other examples of the host template 
> > > > >> members getting modified.
> > > > > 
> > > > > Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> > > > > I've come across trawling the horrible unmaintained drivers.  I'd love
> > > > > to see scsi_host_template become const, but it's not happening any time
> > > > > soon, and we can address this little piece when the time comes.
> > > > 
> > > > Well, sure, the driver is the owner of that memory.
> > > > 
> > > > We're talking about common code.
> > > > 
> > > > If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.
> > > 
> > > Well, I don't like mucking with the template either.
> > > 
> > > This whole mess is generated basically because the zero default of the
> > > template should be treated as initiator.  How about this, which makes
> > > that manifest?
> > 
> > But how can we handle dual-mode drivers?
> > 
> > luce:/sys/class/scsi_host/host0$ cat supported_mode
> > Initiator, Target
> > 
> > 
> > The values are not enumerated. They are like FC_PORT_ROLE.
> 
> Any driver that does other than the default INITIATOR has to set it in
> the template.  The code only defaults zero (which is what the templates
> get if its unset) to MODE_INITIATOR.

Oh yeah, the patch is fine.

I just wanted to say that supported_mode/active_mode are designed not
to be enumerated and we can't just set INITIATOR to zero and TARGET to
non-zero.
