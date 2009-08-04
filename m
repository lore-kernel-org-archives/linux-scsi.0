From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] lpfc: Read buffer overflow
Date: Tue, 04 Aug 2009 00:31:18 +0000
Message-ID: <1249345878.3943.240.camel@mulgrave.site>
References: <4A754999.90208@gmail.com> <4A76FC0D.7080005@emulex.com>
	 <20090803164223.6aa6555b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36042 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757AbZHDAbX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 20:31:23 -0400
In-Reply-To: <20090803164223.6aa6555b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Smart <James.Smart@Emulex.Com>, roel.kluin@gmail.com, linux-scsi@vger.kernel.org

On Mon, 2009-08-03 at 16:42 -0700, Andrew Morton wrote:
> On Mon, 3 Aug 2009 11:02:37 -0400
> James Smart <James.Smart@Emulex.Com> wrote:
> 
> > Roel Kluin wrote:
> > > Check whether index is within bounds before testing the element.
> > >
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > ---
> > > diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
> > > index e0b4992..ade2df6 100644
> > > --- a/drivers/scsi/lpfc/lpfc_vport.c
> > > +++ b/drivers/scsi/lpfc/lpfc_vport.c
> > > @@ -762,7 +762,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
> > >  	int i;
> > >  	if (vports == NULL)
> > >  		return;
> > > -	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
> > > +	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
> > >  		scsi_host_put(lpfc_shost_from_vport(vports[i]));
> > >  	kfree(vports);
> > >  }
> >
> > NACK -  the vports array is created such that it is sized for 
> > phba->max_vports + 1.
> 
> (top-posting repaired so that I can feasibly reply to the email, dammit)
> 
> There's no need to allocate the extra slot in the vports array if we're
> also retaining its size.  I'd suggest that we merge Roel's patch and
> then reduce the size of vports[].

I'd suggest not:

jejb@mulgrave:~/git/linux-2.6/drivers/scsi/lpfc> git grep 'max_vports && vports'|wc -l
17

Assuming this secures agreement as a patch, I don't really want to wade
through another 16 patches for the remaining ones.  You definitely can't
reduce the vport array length until they're all fixed.

What I hear is that it's not a problem, but it's a possible
micro-optimisation.  Assuming the maintainer agrees, it's far better
just to fix everything at once.  However, I'm equally happy to leave it
as is since there's no actual problem given the allocation definition.

> What prevents the loop in lpfc_create_vport_work_array() from wandering
> off the end of vports[], btw?

We refuse to create any vports beyond this number ... the iterator
counts the number of created vports (it's actually a firmware limited
number, I believe).

James


