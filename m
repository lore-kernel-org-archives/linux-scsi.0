From: Doug Ledford <dledford@redhat.com>
Subject: Re: [hch@infradead.org: Re: [PATCH] fix 2.5 scsi queue depth setting]
Date: Wed, 6 Nov 2002 16:20:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106212040.GI22177@redhat.com>
References: <20021106210542.A32241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021106210542.A32241@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 09:05:42PM +0000, Christoph Hellwig wrote:
> On Wed, Nov 06, 2002 at 03:50:50PM -0500, Doug Ledford wrote:
> > if(sdev->hostdata)
> >   kfree(sdev->hostdata);
> 
> kfree(NULL) is fine, btw..

Yeah, but the existence of a non-NULL pointer can also be used to protect 
against other possible bogus operations (in the case of my driver it isn't 
needed, but I wouldn't begin to assume no other driver would) in the event 
that slave_detach() is ever called twice.

> > sdev->hostdata = NULL;
> > 
> > after the slave_detach call.  The other option is to slightly refine the 
> > slave_attach/slave_detach API to specificy that if your attach routine 
> > allocates and hangs memory off of sdev->hostdata, then you *must* 
> > implement a slave_detach() routine and you must free said memory yourself 
> > (and NULL out the pointer to be safe).
> 
> I'm all for the second option, but I don't think we should specify the
> NULLing out, the device will go away anyway.

Hmmm...I thought this was being done on upper level de-attachment, which 
doesn't always imply device removal.  I'm not sure the device is going 
away in all cases....

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
