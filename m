From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 4/7 cleanup/consolidate code in scsi_request_fn
Date: Tue, 25 Mar 2003 16:58:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325165822.A1383@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com> <3E80CB02.8010909@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E80CB02.8010909@splentec.com>; from luben@splentec.com on Tue, Mar 25, 2003 at 04:32:50PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2003 at 04:32:50PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:

> > +static inline int scsi_check_sdev(struct request_queue *q,
> > +				  struct scsi_device *sdev)
> 
> scsi_check_sdev: clearly every function is C does a check, or a computation,
> or a modificaiton, or some permutation of those.  So this name is too trivial
> and doesn't mean what the function does.
> 
> Further more since the function outcome is logical in nature, i.e. it does
> NOT return an error code, you can can return 1 on success, and 0 on fault.
> 
> How about this:
> /**
>   * scsi_dev_ok2queue:  Return non-zero if we can queue to the
>   * device, else 0.
>   */

I don't care much one way or the other, but I don't like ok2queue.

I was using sdev to distinguish the name from struct dev and functions
related to struct dev. We already have the confusing names scsi_device_get
and scsi_get_device - one for a "get" of a scsi_device one to get a
struct dev given a scsi_host. And then the shost naming matches sdev.

Anyway, the following are fine with me:
	scsi_dev_ready, scsi_host_ready
	scsi_sdev_ready, scsi_shost_ready

> > +static inline int scsi_check_shost(struct request_queue *q,
> > +				   struct Scsi_Host *shost,
> > +				   struct scsi_device *sdev)
> 
> Abosulutely the same story here, as above.
> 
> scsi_host_ok2queue() -- please do not use ``shost'' in function names,
> ``host'' I think is descriptive enough.

-- Patrick Mansfield
