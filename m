From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 3/3] scsi_dh: rdac handler: Batch up MODE
	SELECTsand send few of them
Date: Thu, 07 May 2009 17:36:15 -0700
Message-ID: <1241742975.27327.3.camel@chandra-ubuntu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
	<20090428025248.11108.38596.sendpatchset@chandra-ubuntu>
	<4A02580A.2060704@cs.wisc.edu>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A02580A.2060704@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2009-05-06 at 22:39 -0500, Mike Christie wrote:
> Chandra Seetharaman wrote:
> >  }
> >  
> > -static int rdac_activate(struct scsi_device *sdev, activate_complete fn, void *data)
> > +static int queue_mode_select(struct scsi_device *sdev,
> > +				activate_complete fn, void *data)
> > +{
> > +	struct rdac_queue_data *qdata;
> > +	struct rdac_controller *ctlr;
> > +
> > +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
> 
> 
> I think you want to use GFP_NOIO or GFP_ATOMIC here. If GFP_NOIO can 
> block and screw up other devices using that multipathd workqueue struct 
> maybe GFP_ATOMIC would be best since we can have dm-mpath retry later.

Will do.

Thanks
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
