From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ses: Fix problems with simple enclosures
Date: Wed, 09 Dec 2015 10:15:40 -0800
Message-ID: <1449684940.2226.21.camel@HansenPartnership.com>
References: <1449594031.2219.9.camel@HansenPartnership.com>
	 <56685FEE.9030208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54780 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbbLISPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 13:15:42 -0500
In-Reply-To: <56685FEE.9030208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Andrea Gelmini <andrea.gelmini@gelma.net>, "Ewan D. Milne" <emilne@redhat.com>

On Wed, 2015-12-09 at 18:07 +0100, Tomas Henzl wrote:
> On 8.12.2015 18:00, James Bottomley wrote:
> > Simple enclosure implementations (mostly USB) are allowed to return only
> > page 8 to every diagnostic query.  That really confuses our
> > implementation because we assume the return is the page we asked for and
> > end up doing incorrect offsets based on bogus information leading to
> > accesses outside of allocated ranges.  Fix that by checking the page
> > code of the return and giving an error if it isn't the one we asked for.
> > This should fix reported bugs with USB storage by simply refusing to
> > attach to enclosures that behave like this.  It's also good defensive
> > practise now that we're starting to see more USB enclosures.
> 
> Ideally this patch also fixes all callers so they evaluate the return value
> from ses_recv_diag. That is missed in ses_enclosure_data_process
> and ses_get_page2_descriptor.

Well, it wouldn't be a bug fix and it's strictly not necessary.  in
ses_intf_add() we won't attach if the initial retrieve of page 2 fails.
That means we already have an old copy.  So if there's a failure in
ses_get_page2_descriptor() then we're just working from old data.
Essentially there's nothing else we could do (except perhaps log the
problem).

James

> -tms 
> 
> >
> > Reported-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >
> > ---
> >
> > diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> > index dcb0d76..7d9cec5 100644
> > --- a/drivers/scsi/ses.c
> > +++ b/drivers/scsi/ses.c
> > @@ -84,6 +84,7 @@ static void init_device_slot_control(unsigned char *dest_desc,
> >  static int ses_recv_diag(struct scsi_device *sdev, int page_code,
> >  			 void *buf, int bufflen)
> >  {
> > +	int ret;
> >  	unsigned char cmd[] = {
> >  		RECEIVE_DIAGNOSTIC,
> >  		1,		/* Set PCV bit */
> > @@ -92,9 +93,26 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
> >  		bufflen & 0xff,
> >  		0
> >  	};
> > +	unsigned char recv_page_code;
> >  
> > -	return scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
> > +	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
> >  				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
> > +	if (unlikely(!ret))
> > +		return ret;
> > +
> > +	recv_page_code = ((unsigned char *)buf)[0];
> > +
> > +	if (likely(recv_page_code == page_code))
> > +		return ret;
> > +
> > +	/* successful diagnostic but wrong page code.  This happens to some
> > +	 * USB devices, just print a message and pretend there was an error */
> > +
> > +	sdev_printk(KERN_ERR, sdev,
> > +		    "Wrong diagnostic page; asked for %d got %u\n",
> > +		    page_code, recv_page_code);
> > +
> > +	return -EINVAL;
> >  }
> >  
> >  static int ses_send_diag(struct scsi_device *sdev, int page_code,
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



