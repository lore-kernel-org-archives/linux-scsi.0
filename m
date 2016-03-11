From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] scsi_dh_alua: uninitialized variable in alua_check_vpd()
Date: Fri, 11 Mar 2016 14:19:09 +0300
Message-ID: <20160311111909.GE5273@mwanda>
References: <20160311101756.GA9384@mwanda>
 <56E2A2F6.30308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E2A2F6.30308@suse.de>
Sender: kernel-janitors-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 11, 2016 at 11:50:30AM +0100, Hannes Reinecke wrote:
> On 03/11/2016 11:17 AM, Dan Carpenter wrote:
> > The pg_updated variable is support to be set to zero at the start but
> > it is uninitialized.
> > 
> > Fixes: cb0a168cb6b8 ('scsi_dh_alua: update 'access_state' field')
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> > index 5bcdf8d..e4f6174 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > @@ -332,7 +332,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
> >  {
> >  	int rel_port = -1, group_id;
> >  	struct alua_port_group *pg, *old_pg = NULL;
> > -	bool pg_updated;
> > +	bool pg_updated = 0;
> >  	unsigned long flags;
> >  
> >  	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> > 
> I'd prefer 'pg_updated = false'.
> Not that we trip over a static code analyser here :-)

Duh...  Sorry about that.

regards,
dan carpenter

