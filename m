From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] scsi-ml: adds queue_depth ramp up
	code
Date: Fri, 16 Oct 2009 11:16:20 -0700
Message-ID: <1255716980.21038.24.camel@vi2.jf.intel.com>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
	<20091016004700.22451.42962.stgit@vifc.jf.intel.com>
	<20091016092912.GA7199@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20091016092912.GA7199-VuU8Q2ydlaqCpDFQwvYvMTJtLkR7yuzc@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Christof Schmitt <christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-10-16 at 11:29 +0200, Christof Schmitt wrote:
> On Thu, Oct 15, 2009 at 05:47:00PM -0700, Vasu Dev wrote:
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 7b1e20f..3379da6 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -331,6 +331,42 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
> >  	}
> >  }
> > 
> > +static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
> > +{
> > +	struct scsi_host_template *sht = sdev->host->hostt;
> > +	struct scsi_device *tmp_sdev;
> > +
> > +	if (!sht->change_queue_depth ||
> > +	    sdev->queue_depth == sdev->max_queue_depth)
> > +		return;
> [...]
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -251,6 +251,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
> >  	sdev->model = scsi_null_device_strs;
> >  	sdev->rev = scsi_null_device_strs;
> >  	sdev->host = shost;
> > +	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
> >  	sdev->id = starget->id;
> >  	sdev->lun = lun;
> >  	sdev->channel = starget->channel;
> > @@ -312,6 +313,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
> >  		}
> >  	}
> > 
> > +	sdev->max_queue_depth = sdev->queue_depth;
> > +
> >  	return sdev;
> 
> Running this patches series with the zfcp device driver increases the
> queue_depth beyond the maximum. The problem is that after slave_alloc,
> the queue_depth is 1 from cmd_per_lun and this is the value used for
> max_queue_depth.
> 

I see, I missed this case to update max_queue_depth since libfc is not
using slave_configure.

> zfcp then adjust the queue_depth and tagging in slave_configure. Now,
> the queue_depth is 32 and the max_queue_depth is still 1. And the
> check for sdev->queue_depth == sdev->max_queue_depth is never true.
> 
> What is the best way to solve this? Move the initial assignment of
> max_queue_depth to be called after the call to slave_configure? And/or

Move should work fine unless I'm missing any case where slave_configure
won't be called on new sdev alloc or max_queue_depth could change after
calling slave_configure also, apart from sysfs.

I've already added code to update this on qdepth change via sysfs. Am I
missing any other case ?

> adjust the check above to sdev->queue_depth >= sdev->max_queue_depth?
> 

Adding check this way will work as safe guard in case any place left
updating max_queue_depth but that would be bug. I'll change check as
suggested above.
	
	Thanks
	Vasu

> --
> Christof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
