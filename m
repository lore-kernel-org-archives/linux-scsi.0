From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH RESEND] Eliminate extra 'out_free' label from fcoe_init
 function
Date: Sat, 3 Jun 2017 05:35:38 +0300
Message-ID: <20170603023537.gv5c763tmmxr445y@mwanda>
References: <8e1e75c4-3a80-00c3-2697-37fb1c86f7a1@redhat.com>
 <593161A9.9000100@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <593161A9.9000100@bfs.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: walter harms <wharms@bfs.de>
Cc: mgandhi@redhat.com, Johannes Thumshirn <jth@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 02, 2017 at 03:01:29PM +0200, walter harms wrote:
> 
> 
> Am 02.06.2017 14:39, schrieb Milan P. Gandhi:
> > Simplify the check for return code of fcoe_if_init routine
> > in fcoe_init function such that we could eliminate need for
> > extra 'out_free' label and duplicate mutex_unlock statement.
> > 
> > Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> > ---
> >  drivers/scsi/fcoe/fcoe.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > index ea21e7b..a2cf3d0 100644
> > --- a/drivers/scsi/fcoe/fcoe.c
> > +++ b/drivers/scsi/fcoe/fcoe.c
> > @@ -2523,14 +2523,13 @@ static int __init fcoe_init(void)
> >  	fcoe_dev_setup();
> >  
> >  	rc = fcoe_if_init();
> > +	mutex_unlock(&fcoe_config_mutex);
> > +
> >  	if (rc)
> > -		goto out_free;
> > +		goto out_destroy;
> >  
> > -	mutex_unlock(&fcoe_config_mutex);
> >  	return 0;
> >  
> if you do that, why not
> if (!rc) return 0;

Gar...  No.  Please don't get creative with the last if statement.

regards,
dan carpenter

