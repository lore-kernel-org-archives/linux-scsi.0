From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] SCSI: fcoe: convert to use BUS_ATTR_WO
Date: Sat, 26 Jan 2019 11:39:06 +0100
Message-ID: <20190126103906.GA9483@kroah.com>
References: <20190122142735.GB18225@kroah.com>
 <3e91c991-8090-405a-58cf-0686e9a82a51@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e91c991-8090-405a-58cf-0686e9a82a51@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 26, 2019 at 11:26:47AM +0100, Hannes Reinecke wrote:
> On 1/22/19 3:27 PM, Greg Kroah-Hartman wrote:
> > We are trying to get rid of BUS_ATTR() and the usage of that in the fcoe
> > driver can be trivially converted to use BUS_ATTR_WO(), so use that
> > instead.
> > 
> > Cc: Johannes Thumshirn <jth@kernel.org>
> > Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > v2: Made simpler with wrapper functions to call the "real" show/store
> >      functions, thanks to James for the idea.
> >      Removed the EXPORT_SYMBOL() removal line, that belongs in a separate
> >      patch
> > 
> >   drivers/scsi/fcoe/fcoe_sysfs.c | 15 +++++++++++++--
> >   1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
> > index 5c8310bade61..c3dcbdc3aa64 100644
> > --- a/drivers/scsi/fcoe/fcoe_sysfs.c
> > +++ b/drivers/scsi/fcoe/fcoe_sysfs.c
> > @@ -671,8 +671,19 @@ static const struct device_type fcoe_fcf_device_type = {
> >   	.release = fcoe_fcf_device_release,
> >   };
> > -static BUS_ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store);
> > -static BUS_ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store);
> > +static ssize_t ctlr_create_store(struct bus_type *bus, const char *buf,
> > +				 size_t count)
> > +{
> > +	return fcoe_ctlr_create_store(bus, buf, count);
> > +}
> > +static BUS_ATTR_WO(ctlr_create);
> > +
> > +static ssize_t ctlr_destroy_store(struct bus_type *bus, const char *buf,
> > +				  size_t count)
> > +{
> > +	return fcoe_ctlr_destroy_store(bus, buf, count);
> > +}
> > +static BUS_ATTR_WO(ctlr_destroy);
> >   static struct attribute *fcoe_bus_attrs[] = {
> >   	&bus_attr_ctlr_create.attr,
> > 
> Why not renaming the functions and drop the wrapper?

I did that in v1 of this patch, but people complained I was messing up
their function namespace :)

thanks,

greg k-h
