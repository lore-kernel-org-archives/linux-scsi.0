From: Gen Zhang <blackgod016574@gmail.com>
Subject: Re: [PATCH] sg: fix a double-fetch bug in sg_write()
Date: Wed, 5 Jun 2019 23:35:32 +0800
Message-ID: <20190605153532.GA4051@zhanggen-UX430UQ>
References: <20190531012704.GA4541@zhanggen-UX430UQ>
 <38bbd54f-d85b-e529-36ad-5c1809bb435f@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38bbd54f-d85b-e529-36ad-5c1809bb435f@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: dgilbert@interlog.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 05, 2019 at 08:41:11AM +0200, Jiri Slaby wrote:
> On 31. 05. 19, 3:27, Gen Zhang wrote:
> > In sg_write(), the opcode of the command is fetched the first time from 
> > the userspace by __get_user(). Then the whole command, the opcode 
> > included, is fetched again from userspace by __copy_from_user(). 
> > However, a malicious user can change the opcode between the two fetches.
> > This can cause inconsistent data and potential errors as cmnd is used in
> > the following codes.
> > 
> > Thus we should check opcode between the two fetches to prevent this.
> > 
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > ---
> > diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> > index d3f1531..a2971b8 100644
> > --- a/drivers/scsi/sg.c
> > +++ b/drivers/scsi/sg.c
> > @@ -694,6 +694,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
> >  	hp->flags = input_size;	/* structure abuse ... */
> >  	hp->pack_id = old_hdr.pack_id;
> >  	hp->usr_ptr = NULL;
> > +	if (opcode != cmnd[0])
> > +		return -EINVAL;
> >  	if (__copy_from_user(cmnd, buf, cmd_size))
> >  		return -EFAULT;
> 
> You are sending the same patches like a broken machine. Please STOP this
> and give people some time to actually review your patches! (Don't expect
> replies in days.)
> 
Thanks for your reply. I resubmitted this one after 8-day-no-reply. I 
don't judge whether this is a short time period or not. I politely hope
that you can reply more kindly.

I am just a PhD candidate. All I did is submitting patches, discussing 
with maintainers in accordance with linux community rules for academic papers.

I guess that you might be busy person and hope that submitting patches 
didn't bother you.

Thanks
Gen
> I already commented on this apparently broken one earlier...
> 
> thanks,
> -- 
> js
> suse labs
