From: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable
 build warning
Date: Mon, 3 Sep 2007 02:19:59 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709030211040.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n> <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
 <46DB1BDF.4090100@garzik.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1586562954-1188766100=:29617"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35524 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXIBUg4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Sep 2007 16:36:56 -0400
In-Reply-To: <46DB1BDF.4090100@garzik.org>
Content-ID: <alpine.LFD.0.999.0709030219380.29617@enigma.security.iitk.ac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1586562954-1188766100=:29617
Content-Type: TEXT/PLAIN; CHARSET=iso-2022-jp
Content-ID: <alpine.LFD.0.999.0709030219381.29617@enigma.security.iitk.ac.in>



On Sun, 2 Sep 2007, Jeff Garzik wrote:
> 
> Satyam Sharma wrote:
> > drivers/scsi/dc395x.c: In function ‘dc395x_init_one’:
> > drivers/scsi/dc395x.c:4272: warning: ‘ptr’ may be used uninitialized in this
> > function
> > 
> > has been verified to be a bogus warning. Let's shut it up.
> > 
> > Signed-off-by: Satyam Sharma <satyam@infradead.org>
> > 
> > ---
> > 
> >  drivers/scsi/dc395x.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c~fix	2007-09-02
> > 20:57:51.000000000 +0530
> > +++ linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c	2007-09-02
> > 21:10:49.000000000 +0530
> > @@ -4269,7 +4269,7 @@ static int __devinit adapter_sg_tables_a
> >  	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
> >  	int srb_idx = 0;
> >  	unsigned i = 0;
> > -	struct SGentry *ptr;
> > +	struct SGentry * uninitialized_var(ptr);
> 
> For things like this, we need to see (perhaps a separate email in the same
> thread) your build details:  config, arch, compiler version, etc.

I'll post the info as a reply to the first mail in this series. I have
fairly recent gcc (4.1.1) and I don't see us dropping support for it in
the next few years.

> I paid careful attention to my recent set of uninitialized_var() markers (now
> upstream), making sure that they persisted across several compiler versions,
> ensuring the warning was not a temporary optimizer bug quickly remedied.
> 
> I hope to encourage similar diligence in others :)  These markers have the
> very-real potential downside of hiding bugs, so they should be used sparingly.

Well, uninitialized_var() is definitely more greppable than "= 0" which
code all over does all the time :-) Anyway, the point is that the
warnings are bogus anyway (hence maintainers Cc:'ed so that they can
confirm if I arrived at the conclusion correctly) /and/ that
uninitialized_var() stands out sorely, so I don't see bugs getting
"hidden" at all -- in fact I did find two bugs during this process, and
fixed them accordingly.

Thanks,

Satyam
--464262402-1586562954-1188766100=:29617--
