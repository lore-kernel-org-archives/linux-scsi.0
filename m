From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch 01/19] scsi: add __init/__exit macros to ibmvstgt.c
Date: Tue, 22 Dec 2009 10:46:44 -0600
Message-ID: <1261500404.2774.15.camel@mulgrave.site>
References: <200912220027.nBM0Rcrj005361@imap1.linux-foundation.org>
	 <200912220806.32904.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZLVQq4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2009 11:46:56 -0500
In-Reply-To: <200912220806.32904.PeterHuewe@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, trivial@kernel.org

On Tue, 2009-12-22 at 08:06 +0100, Peter Huewe wrote:
> Am Dienstag 22 Dezember 2009 01:27:38 schrieb akpm@linux-foundation.org:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > Add the __init and __exit macros to the module_init / module_exit
> > functions from drivers/scsi/ibmvscsi/ibmvstgt.c
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: James Bottomley <James.Bottomley@SteelEye.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/ibmvscsi/ibmvstgt.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff -puN
> >  drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgt
> > c drivers/scsi/ibmvscsi/ibmvstgt.c ---
> >  a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvst
> > gtc +++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
> > @@ -955,7 +955,7 @@ static struct srp_function_template ibmv
> >  	.it_nexus_response = ibmvstgt_it_nexus_response,
> >  };
> > 
> > -static int ibmvstgt_init(void)
> > +static int __init ibmvstgt_init(void)
> >  {
> >  	int err = -ENOMEM;
> > 
> > @@ -986,7 +986,7 @@ release_transport:
> >  	return err;
> >  }
> > 
> > -static void ibmvstgt_exit(void)
> > +static void __exit ibmvstgt_exit(void)
> >  {
> >  	printk("Unregister IBM virtual SCSI driver\n");
> > 
> > _
> > 
> 
> Hi,
> 
> this patch is floating around for almost half a year (2009/06/23) and I was 
> wondering if there is anything wrong with it, or why it doesn't get merged 
> upstream.

well, it still has to be tested.  I'd guess IBM is putting out other
fires, since it's really just cosmetic, even in terms of memory savings.

> I know the patch is really trivial and maybe not even worth this email, but in 
> my opinion every single line counts :)

Unfortunately, a significant number of problems tend to come via
"trivial" patches, so I'd like someone who knows the driver to look at
it.

> @James: Do you prefer if Jiri Kosina merges this one through his trivial tree?

It's not really my call ... it's Brian's

James


