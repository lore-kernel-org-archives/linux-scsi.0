From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 23:01:53 -0500
Message-ID: <1190779313.8707.42.camel@localhost.localdomain>
References: <20070926025608.GA3899@parisc-linux.org>
	 <46F9D328.4030801@garzik.org>
	 <1190778353.8707.29.camel@localhost.localdomain>
	 <20070925092106U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47074 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1749667AbXIZEB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 00:01:56 -0400
In-Reply-To: <20070925092106U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jeff@garzik.org, matthew@wil.cx, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 2007-09-26 at 12:55 +0900, FUJITA Tomonori wrote:
> On Tue, 25 Sep 2007 22:45:53 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2007-09-25 at 23:34 -0400, Jeff Garzik wrote:
> > > Matthew Wilcox wrote:
> > > > On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
> > > >> Are there any const-ness worries for scsi_host_template, or plans for 
> > > >> the future?  I do not see any other examples of the host template 
> > > >> members getting modified.
> > > > 
> > > > Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> > > > I've come across trawling the horrible unmaintained drivers.  I'd love
> > > > to see scsi_host_template become const, but it's not happening any time
> > > > soon, and we can address this little piece when the time comes.
> > > 
> > > Well, sure, the driver is the owner of that memory.
> > > 
> > > We're talking about common code.
> > > 
> > > If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.
> > 
> > Well, I don't like mucking with the template either.
> > 
> > This whole mess is generated basically because the zero default of the
> > template should be treated as initiator.  How about this, which makes
> > that manifest?
> 
> But how can we handle dual-mode drivers?
> 
> luce:/sys/class/scsi_host/host0$ cat supported_mode
> Initiator, Target
> 
> 
> The values are not enumerated. They are like FC_PORT_ROLE.

Any driver that does other than the default INITIATOR has to set it in
the template.  The code only defaults zero (which is what the templates
get if its unset) to MODE_INITIATOR.

James


