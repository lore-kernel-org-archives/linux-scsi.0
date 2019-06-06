From: Gen Zhang <blackgod016574@gmail.com>
Subject: Re: [PATCH] sg: fix a double-fetch bug in sg_write()
Date: Thu, 6 Jun 2019 15:43:33 +0800
Message-ID: <20190606074333.GA7078@zhanggen-UX430UQ>
References: <20190531012704.GA4541@zhanggen-UX430UQ>
 <38bbd54f-d85b-e529-36ad-5c1809bb435f@suse.cz>
 <20190605153532.GA4051@zhanggen-UX430UQ>
 <2d322852-4861-929a-28ed-c4b41bea5ba6@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2d322852-4861-929a-28ed-c4b41bea5ba6@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: dgilbert@interlog.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 06, 2019 at 07:01:26AM +0200, Jiri Slaby wrote:
> On 05. 06. 19, 17:35, Gen Zhang wrote:
> > On Wed, Jun 05, 2019 at 08:41:11AM +0200, Jiri Slaby wrote:
> >> On 31. 05. 19, 3:27, Gen Zhang wrote:
> >>> In sg_write(), the opcode of the command is fetched the first time from 
> >>> the userspace by __get_user(). Then the whole command, the opcode 
> >>> included, is fetched again from userspace by __copy_from_user(). 
> >>> However, a malicious user can change the opcode between the two fetches.
> >>> This can cause inconsistent data and potential errors as cmnd is used in
> >>> the following codes.
> >>>
> >>> Thus we should check opcode between the two fetches to prevent this.
> >>>
> >>> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> >>> ---
> >>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >>> index d3f1531..a2971b8 100644
> >>> --- a/drivers/scsi/sg.c
> >>> +++ b/drivers/scsi/sg.c
> >>> @@ -694,6 +694,8 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
> >>>  	hp->flags = input_size;	/* structure abuse ... */
> >>>  	hp->pack_id = old_hdr.pack_id;
> >>>  	hp->usr_ptr = NULL;
> >>> +	if (opcode != cmnd[0])
> >>> +		return -EINVAL;
> >>>  	if (__copy_from_user(cmnd, buf, cmd_size))
> >>>  		return -EFAULT;
> >>
> >> You are sending the same patches like a broken machine. Please STOP this
> >> and give people some time to actually review your patches! (Don't expect
> >> replies in days.)
> >>
> > Thanks for your reply. I resubmitted this one after 8-day-no-reply. I 
> > don't judge whether this is a short time period or not. I politely hope
> > that you can reply more kindly.
> 
> There is no reason to be offended. I am just asking you to wait a bit
> more before reposting. 8 days is too few. My personal experience says to
> give patches like these something close to a month, esp. during the
> merge window. The issues are present for a long time, nobody hit them
> during that timeframe, so there is no reason to haste.
Thanks for your reply, and I will keep this in mind.
> 
> > I am just a PhD candidate. All I did is submitting patches, discussing 
> > with maintainers in accordance with linux community rules for academic papers.
> 
> Yes, despite I have no idea what "linux community rules for academic
> papers" are.

I mean, these patches come from a research project prototype. Submitting
patches, and getting it applied can be demonstrated in the experiment 
part of research paper.

Thanks
Gen
> 
> > I guess that you might be busy person and hope that submitting patches 
> > didn't bother you.
> 
> It does not bother me at all. Patches are welcome, but newcomers tend to
> send new versions of patches (or reposts) too quickly. It then leads to
> wasting time of people where one person comments on one version and the
> others don't see it and reply to some other.
> 
> thanks,
> -- 
> js
> suse labs
