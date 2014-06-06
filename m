From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 6/7] mptfusion: combine fw_event_work and its event_data
Date: Fri, 6 Jun 2014 17:56:35 -0400
Message-ID: <20140606175635.6c4fd737@jlaw-desktop.mno.stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
	<1401900729-19855-1-git-send-email-joe.lawrence@stratus.com>
	<20140605093429.GG727@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o149.mxlogic.net ([208.65.145.82]:49635 "EHLO
	p02c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaFFV4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 17:56:51 -0400
In-Reply-To: <20140605093429.GG727@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Thu, 5 Jun 2014 02:34:29 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> > diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
> > index 57e86ab..c396483 100644
> > --- a/drivers/message/fusion/mptsas.h
> > +++ b/drivers/message/fusion/mptsas.h
> > @@ -110,7 +110,7 @@ struct fw_event_work {
> >  	MPT_ADAPTER	*ioc;
> >  	u32			event;
> >  	u8			retries;
> > -	u8			__attribute__((aligned(4))) event_data[1];
> > +	char			event_data[0] __aligned(4);
> >  };

Is this alignment necessary and if so, should it be more like:
  __attribute__ ((aligned (sizeof(unsigned long))))

> >  
> > -	sz = offsetof(struct fw_event_work, event_data) +
> > -	    sizeof(MpiEventDataSasDeviceStatusChange_t);
> > +	sz = sizeof(*fw_event) +
> > +		sizeof(MpiEventDataSasDeviceStatusChange_t);
> >  	fw_event = kzalloc(sz, GFP_ATOMIC);
> 
> Seems like there is no point in keeping the sz variable here and at
> the other occurances.  Not that it really matters, but if we make a pass
> over this code we might as well fix that up, too.
 
I'll take a look and post up a v2 next week, adding these to a v2
mpt2/mpt3 set.

Thanks,

-- Joe
