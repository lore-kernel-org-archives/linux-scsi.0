From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lpfc: Read buffer overflow
Date: Mon, 3 Aug 2009 16:42:23 -0700
Message-ID: <20090803164223.6aa6555b.akpm@linux-foundation.org>
References: <4A754999.90208@gmail.com>
	<4A76FC0D.7080005@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932329AbZHCXm0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 19:42:26 -0400
In-Reply-To: <4A76FC0D.7080005@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: roel.kluin@gmail.com, linux-scsi@vger.kernel.org

On Mon, 3 Aug 2009 11:02:37 -0400
James Smart <James.Smart@Emulex.Com> wrote:

> Roel Kluin wrote:
> > Check whether index is within bounds before testing the element.
> >
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
> > index e0b4992..ade2df6 100644
> > --- a/drivers/scsi/lpfc/lpfc_vport.c
> > +++ b/drivers/scsi/lpfc/lpfc_vport.c
> > @@ -762,7 +762,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
> >  	int i;
> >  	if (vports == NULL)
> >  		return;
> > -	for (i = 0; vports[i] != NULL && i <= phba->max_vports; i++)
> > +	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
> >  		scsi_host_put(lpfc_shost_from_vport(vports[i]));
> >  	kfree(vports);
> >  }
>
> NACK -  the vports array is created such that it is sized for 
> phba->max_vports + 1.

(top-posting repaired so that I can feasibly reply to the email, dammit)

There's no need to allocate the extra slot in the vports array if we're
also retaining its size.  I'd suggest that we merge Roel's patch and
then reduce the size of vports[].

What prevents the loop in lpfc_create_vport_work_array() from wandering
off the end of vports[], btw?

