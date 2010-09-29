From: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Wed, 29 Sep 2010 22:20:56 +0200
Message-ID: <201009292220.56799.oliver@neukum.org>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <201009281513.53869.oliver@neukum.org> <20100929005413.GB4689@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100929005413.GB4689-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Am Mittwoch, 29. September 2010, 02:54:13 schrieb Matthew Wilcox:
> 
> [Could you trim a little when replying?]

Sorry.
> 
> On Tue, Sep 28, 2010 at 03:13:53PM +0200, Oliver Neukum wrote:
> > Am Dienstag, 28. September 2010, 12:14:56 schrieb Matthew Wilcox:
> > > +static void uas_do_work(struct work_struct *work)
> > > +{
> > > +	struct uas_cmd_info *cmdinfo;
> > > +	struct list_head list;
> > > +
> > > +	spin_lock_irq(&uas_work_lock);
> > > +	list_replace_init(&uas_work_list, &list);
> > > +	spin_unlock_irq(&uas_work_lock);
> > > +
> > > +	list_for_each_entry(cmdinfo, &list, list) {
> > > +		struct scsi_pointer *scp = (void *)cmdinfo;
> > > +		struct scsi_cmnd *cmnd = container_of(scp,
> > > +							struct scsi_cmnd, SCp);
> > > +		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
> > 
> > Deadlocky, use GFP_NOIO
> 
> ACK.  I thought I'd fixed this already.

Upon firther thought I think you need a dedicated work queue. Not only
need you use GFP_NOIO, but you need to make sure that no work scheduled
before your work on the same queue uses GFP_KERNEL.

> > > +	cmnd->result = sense_iu->status;
> > > +	if (sdev->current_cmnd)
> > > +		sdev->current_cmnd = NULL;
> > 
> > the condition is absolutely senseless
> 
> That's not true.  Avoiding dirtying a cacheline is important for
> performance.

This is subtle. Do you need to play compiler tricks here?

	Regards
		Oliver
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
