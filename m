From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] scsi: libfc: fix null pointer dereference on a null
 lport
Date: Fri, 12 Jul 2019 12:43:52 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1907121243220.3900@hadrien>
References: <20190702091835.13629-1-colin.king@canonical.com> <14c9e345-dd98-63e7-5ba2-679f10760fe6@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1695843507-1562928232=:3900"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14c9e345-dd98-63e7-5ba2-679f10760fe6@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--8323329-1695843507-1562928232=:3900
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Fri, 12 Jul 2019, Hannes Reinecke wrote:

> On 7/2/19 11:18 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Currently if lport is null then the null lport pointer is dereference
> > when printing out debug via the FC_LPORT_DB macro. Fix this by using
> > the more generic FC_LIBFC_DBG debug macro instead that does not use
> > lport.
> >
> > Addresses-Coverity: ("Dereference after null check")
> > Fixes: 7414705ea4ae ("libfc: Add runtime debugging with debug_logging module parameter")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/scsi/libfc/fc_exch.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> > index 025cd2ff9f65..c477fadbf504 100644
> > --- a/drivers/scsi/libfc/fc_exch.c
> > +++ b/drivers/scsi/libfc/fc_exch.c
> > @@ -2591,8 +2591,8 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
> >
> >  	/* lport lock ? */
> >  	if (!lport || lport->state == LPORT_ST_DISABLED) {
> > -		FC_LPORT_DBG(lport, "Receiving frames for an lport that "
> > -			     "has not been initialized correctly\n");
> > +		FC_LIBFC_DBG("Receiving frames for an lport that "
> > +			     "has not been initialized correctly\n");

If the code is being changed, perhaps the string could be put onto one
line as well.

julia

> >  		fc_frame_free(fp);
> >  		return;
> >  	}
> >
> Reviewed-by: Hannes Reinecke <hare@suse.com>
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
> HRB 21284 (AG Nürnberg)
>
--8323329-1695843507-1562928232=:3900--
