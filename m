From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
Date: Fri, 31 Mar 2017 16:12:29 +0200
Message-ID: <20170331141229.GB8141@kroah.com>
References: <20170331135030.GA24063@zipoli.ccur.kvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331135030.GA24063@zipoli.ccur.kvm>
Sender: stable-owner@vger.kernel.org
To: Joe Korty <joe.korty@ccur.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrey Grodzovsky <andrey2805@gmail.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Stable Mailing List <stable@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 31, 2017 at 09:50:30AM -0400, Joe Korty wrote:
> [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
> 
> commit 16236802bfecb1082144a48b7d6fa60997824662 upstream
> commit ffb58456589443ca572221fabbdef3db8483a779 upstream
> 
> Lockdep complains that the base level-only hctx->lock
> is being grabbed from interrupt level, at the time the
> mpt3sas driver initializes.  This is a result of two
> of three tightly interconnected mpt3sas bugfix patches
> having been backported into 4.4.  The previously two ported
> patches are:
> 
> > From: Andrey Grodzovsky <andrey2805@gmail.com>
> > Date: Thu, 10 Nov 2016 09:35:27 -0500
> > Subject: [PATCH] scsi: mpt3sas: Fix secure erase premature termination
> > Git-Commit: ffffc1ed47e76d13cafbc645792ca184331b3123
>   
> > From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> > Date: Thu, 17 Nov 2016 16:15:58 +0530
> > Subject: [PATCH] scsi: mpt3sas: Unblock device after controller reset
> > Git-Commit: 6eddf5c993dd9bf4efcf2509e4ca633b9441a66a
> 
> The missing third patch is attached below.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> 
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Sun, 1 Jan 2017 09:39:24 -0800
> > Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
> > Git-Commit: 16236802bfecb1082144a48b7d6fa60997824662
> 
> commit ffb58456589443ca572221fabbdef3db8483a779 upstream.
> 
> mpt3sas has a firmware failure where it can only handle one pass through
> ATA command at a time.  If another comes in, contrary to the SAT
> standard, it will hang until the first one completes (causing long
> commands like secure erase to timeout).  The original fix was to block
> the device when an ATA command came in, but this caused a regression
> with
> 
> commit 669f044170d8933c3d66d231b69ea97cb8447338
> Author: Bart Van Assche <bart.vanassche@sandisk.com>
> Date:   Tue Nov 22 16:17:13 2016 -0800
> 
>     scsi: srp_transport: Move queuecommand() wait code to SCSI core
> 
> So fix the original fix of the secure erase timeout by properly
> returning SAM_STAT_BUSY like the SAT recommends.  The original patch
> also had a concurrency problem since scsih_qcmd is lockless at that
> point (this is fixed by using atomic bitops to set and test the flag).
> 
> [mkp: addressed feedback wrt. test_bit and fixed whitespace]
> 
> Fixes: 18f6084a989ba1b (mpt3sas: Fix secure erase premature termination)
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Tested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I signed off on this patch?  When?  Where?

totall confused here,

greg k-h
