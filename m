From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Hard disk S3 resume time optimization
Date: Thu, 16 May 2013 15:44:41 -0700
Message-ID: <20130516224441.GA14875@mtj.dyndns.org>
References: <11E08D716F0541429B7042699DD5C1A16B97B58D@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11E08D716F0541429B7042699DD5C1A16B97B58D@FMSMSX103.amr.corp.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Brandt, Todd E" <todd.e.brandt@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "arjan@linux.intel.com" <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

First of all, if at all possible, please try to fill the message to 80
columns, preferably a bit narrower than that.  Most email clients can
do it without you knowing.

> [The Problem]
> The vast majority of time spent in S3 resume is consumed by the ATA
> subsystem as it resumes the computer's hard drives. For large hard
> disks this time can be upwards of 10 seconds, which makes S3
> suspend/resume too costly to use frequently. This time needs to be
> reduced. I've written a blog entry describing the details at this
> url:
> https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-worst-offender

Yeah, this sucks.  Years back, there were several releases in which
libata implemented its own supsend / resume mechanism mostly from the
exception handler, which was fully asynchronous.  It later got
reimplemented in terms of SCSI suspend/resume and lost that, which is
a bummer.

> [Proposed Solution]
> I've implemented a potential solution in this patch, which
> effectively reduces total resume time from multiple seconds to less
> than 700ms. The idea is to allow the ATA/SCSI subsystems to resume
> asynchronously without blocking system resume completion. The
> dpm_resume call currently waits for all asynchronous devices to
> finish resuming before it gives control back to the user. But in the
> case of ATA/SCSI we can give control back immediately, since the
> hard disks won't be needed immediately in lieu of RAM and cache.

Yeap.

So, while I agree about the problem and the solution seems to be
headed the right way of making SCSI suspend/resume asynchronous,
what's going on with patch splitting, submission format and comments?
Please read up on patch submission (there gotta be enough people in
OSTC to point you to the right direction) and retry.

Thanks.

-- 
tejun
