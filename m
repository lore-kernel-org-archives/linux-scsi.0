From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Mon, 13 Jan 2014 15:30:07 -0500
Message-ID: <20140113203007.GA3480@mtj.dyndns.org>
References: <20140108005607.GB29556@linux.intel.com>
 <20140111191315.GC3257@mtj.dyndns.org>
 <20140113195544.GA13900@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140113195544.GA13900@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, rjw@rjwysocki.net
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Jan 13, 2014 at 11:55:44AM -0800, Todd E Brandt wrote:
> I see your point, why have two paths if one will do. The only thing that
> worries me is that the PM resume from hibernate function doesn't have
> an error handler. What happens when it tries to read the image from swap
> and the disk is still spinning up? The scsi layer has an error handler so

The request gets blocked on EH.

> it just keeps retrying every few seconds, but the PM core reads directly
> from the swap disk's block device.

Why would that matter?  Resume is handled by EH.  While EH is in
progress, all commands are blocked.  Am I missing something?

> > So, can't just everything become async?  Are there cases where we
> > *need* synchronous PM behaviors?
> 
> I think suspend still needs to be synchronous, because the PM core needs
> to be sure that the disks are actually spun down before it can attempt
> to shut the system down. I'm adding Raphael to the thread. Raphael, is 
> this correct?

Yeah, we definitely should wait for suspend to complete before
entering suspend state.  I was referring to the resume path.

Thanks.

-- 
tejun
