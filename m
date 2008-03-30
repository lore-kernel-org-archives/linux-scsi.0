From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 11/17] scsi: ch.c fix shadowed variable warnings
Date: Sun, 30 Mar 2008 11:43:40 -0700
Message-ID: <1206902620.6543.32.camel@brick>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
	 <1206897715.4224.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:58222 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYC3Sne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 14:43:34 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1581535wah.23
        for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2008 11:43:33 -0700 (PDT)
In-Reply-To: <1206897715.4224.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, 2008-03-30 at 12:21 -0500, James Bottomley wrote:
> On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > err shadows the array of errors in this driver, switch to ch_err
> > drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
> > drivers/scsi/ch.c:116:3: originally declared here
> > 
> > cmd shadows the argument to this function, switch to ch_cmd
> > drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
> > drivers/scsi/ch.c:596:20: originally declared here
> > 
> > Small code cleanup as well in if() statement.
> > 
> > [akpm@linux-foundation.org: coding-style fixes]
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/ch.c |   29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> > 
> > diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings drivers/scsi/ch.c
> > --- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings
> > +++ a/drivers/scsi/ch.c
> > @@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch,
> >  static int
> >  ch_init_elem(scsi_changer *ch)
> >  {
> > -	int err;
> > +	int ch_err;
> 
> This isn't really the correct fix, is it?  The driver stupidity is
> having a global (although static) variable called err which invites
> problems like this.  How about this fix?
> 

If you like that better, sure.

Harvey

