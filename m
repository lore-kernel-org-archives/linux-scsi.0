From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 11/17] scsi: ch.c fix shadowed variable warnings
Date: Sun, 30 Mar 2008 13:55:56 -0500
Message-ID: <1206903356.4224.87.camel@localhost.localdomain>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
	 <1206897715.4224.55.camel@localhost.localdomain>
	 <1206902620.6543.32.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50679 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYC3S4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 14:56:00 -0400
In-Reply-To: <1206902620.6543.32.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, 2008-03-30 at 11:43 -0700, Harvey Harrison wrote:
> On Sun, 2008-03-30 at 12:21 -0500, James Bottomley wrote:
> > On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > > From: Harvey Harrison <harvey.harrison@gmail.com>
> > > 
> > > err shadows the array of errors in this driver, switch to ch_err
> > > drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
> > > drivers/scsi/ch.c:116:3: originally declared here
> > > 
> > > cmd shadows the argument to this function, switch to ch_cmd
> > > drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
> > > drivers/scsi/ch.c:596:20: originally declared here
> > > 
> > > Small code cleanup as well in if() statement.
> > > 
> > > [akpm@linux-foundation.org: coding-style fixes]
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > ---
> > > 
> > >  drivers/scsi/ch.c |   29 +++++++++++++++--------------
> > >  1 file changed, 15 insertions(+), 14 deletions(-)
> > > 
> > > diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings drivers/scsi/ch.c
> > > --- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings
> > > +++ a/drivers/scsi/ch.c
> > > @@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch,
> > >  static int
> > >  ch_init_elem(scsi_changer *ch)
> > >  {
> > > -	int err;
> > > +	int ch_err;
> > 
> > This isn't really the correct fix, is it?  The driver stupidity is
> > having a global (although static) variable called err which invites
> > problems like this.  How about this fix?
> > 
> 
> If you like that better, sure.

Er, well it's not really a question of like; it's more a question of the
programming principle of reducing namespace pollution.

The more global something is (and you start with global headers, then
arch headers, then globally exported symbols, then subsystem symbols,
etc ...) the more polluting.  So, the only thing that should be allowed
to name something totally generic, like 'err' or 'ret' should be right
at the lowest level (i.e. unexported symbols of local functions).

Your patch was wrong because you changed the name of the lowest level
and left the actual polluting symbol in the next level up, thus inviting
another patch or function addition to do it all over again.  The correct
way to fix something like this is to rename the more globally polluting
symbol to make a clash far less likely.

James


