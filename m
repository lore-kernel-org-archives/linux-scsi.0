From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi/osst.c: remove unncessary casting of kmalloc.
Date: Sat, 16 Jan 2010 09:46:08 -0600
Message-ID: <1263656768.2851.93.camel@mulgrave.site>
References: <503939f4cfd0b8c362a2f5a103285f8dc330b99a.1263651173.git.tfransosi@gmail.com>
	 <4B51DCBF.9090902@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab0APPqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jan 2010 10:46:19 -0500
In-Reply-To: <4B51DCBF.9090902@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sat, 2010-01-16 at 16:35 +0100, Stefan Richter wrote:
> Thiago Farina wrote:
> > --- a/drivers/scsi/osst.c
> > +++ b/drivers/scsi/osst.c
> > @@ -5842,9 +5842,8 @@ static int osst_probe(struct device *dev)
> >  	/* if this is the first attach, build the infrastructure */
> >  	write_lock(&os_scsi_tapes_lock);
> >  	if (os_scsi_tapes == NULL) {
> > -		os_scsi_tapes =
> > -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> > -				   GFP_ATOMIC);
> > +		os_scsi_tapes = kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> > +					GFP_ATOMIC);
> >  		if (os_scsi_tapes == NULL) {
> >  			write_unlock(&os_scsi_tapes_lock);
> >  			printk(KERN_ERR "osst :E: Unable to allocate array for OnStream SCSI tapes.\n");
> 
> Since you update the style of this kmalloc usage, you could at the same
> time change the sizeof expression to sizeof(* os_scsi_tapes).

Actually, no, please don't do any of this without explicitly checking
with the maintainer (Willem).  We allow fairly loose rein in style for
individual drivers so random minor style changes aren't accepted without
explicit maintainer ack.  For unmaintained files, I also tend to err on
the side of trying not to alter the file unless necessary, so again it
has to be more than just a minor style problem.

For major and reasonable stye changes in unmaintained drivers, an md5sum
of the output code is necessary (verifying it to be the same as the
previous code) unless you can do some testing.

> There is a lot more that could be renovated around os_scsi_tapes, and
> osst in general (GFP_ATOMIC allocations in a device probe?  Fixed
> maximum number of devices?  BKL usage?), but whether it'd be worth the
> effort I don't know.

So this would be a more worthwhile update.  *however* changes along
these lines would actually need to be tested, so someone needs to verify
they work somehow.

James


