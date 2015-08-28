From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] scsi: fix scsi_error_handler vs. scsi_host_dev_release
 race
Date: Fri, 28 Aug 2015 17:17:24 +0200
Message-ID: <20150828151724.GH5301@dhcp22.suse.cz>
References: <1440699420-30499-1-git-send-email-mhocko@kernel.org>
 <1440773773.2202.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440773773.2202.9.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri 28-08-15 07:56:13, James Bottomley wrote:
[...]
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 6457a8a0db9c..2c0a817d5dbe 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -2169,8 +2169,11 @@ int scsi_error_handler(void *data)
> >  	 * We never actually get interrupted because kthread_run
> >  	 * disables signal delivery for the created thread.
> >  	 */
> > -	while (!kthread_should_stop()) {
> > +	while (true) {
> 
> Comment here, I think, please to avoid any other erroneous tidying
> attempts.  How about
> 
> /* 
>  * The sequence in kthread_stop() sets the stop flag first then 
>  * wakes the process.  To avoid missed wakeups, the task should always
>  * be in a non running state before the stop flag is checked
>  */
> 
> Otherwise this looks fine.

I do not have objections to the added comment.

-- 
Michal Hocko
SUSE Labs
