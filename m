From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 3.10 141/319] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Mon, 6 Feb 2017 23:26:23 +0100
Message-ID: <20170206222623.GA4769@1wt.eu>
References: <1486322541-8206-1-git-send-email-w@1wt.eu>
 <1486322541-8206-42-git-send-email-w@1wt.eu>
 <ae8ffc4f86c5af1caf97dfa9a6493443@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ae8ffc4f86c5af1caf97dfa9a6493443@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux@roeck-us.net, Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sathya,

On Mon, Feb 06, 2017 at 09:21:44AM -0700, Sathya Prakash Veerichetty wrote:
> Willy,
> I think this patch had a problem and later modified to a different
> blocking mechanism.  Could you please pull in the latest change for this?

Much appreciated, thanks. I've checked and found the patch you're
talking about :

  commit ffb58456589443ca572221fabbdef3db8483a779
  Author: James Bottomley <James.Bottomley@HansenPartnership.com>
  Date:   Sun Jan 1 09:39:24 2017 -0800

    scsi: mpt3sas: fix hang on ata passthrough commands
    
    mpt3sas has a firmware failure where it can only handle one pass through
    ATA command at a time.  If another comes in, contrary to the SAT
    standard, it will hang until the first one completes (causing long
    commands like secure erase to timeout).  The original fix was to block
    the device when an ATA command came in, but this caused a regression
    with
    
    commit 669f044170d8933c3d66d231b69ea97cb8447338
    Author: Bart Van Assche <bart.vanassche@sandisk.com>
    Date:   Tue Nov 22 16:17:13 2016 -0800
    
        scsi: srp_transport: Move queuecommand() wait code to SCSI core
    
    So fix the original fix of the secure erase timeout by properly
    returning SAM_STAT_BUSY like the SAT recommends.  The original patch
    also had a concurrency problem since scsih_qcmd is lockless at that
    point (this is fixed by using atomic bitops to set and test the flag).
    
    [mkp: addressed feedback wrt. test_bit and fixed whitespace]
    
    Fixes: 18f6084a989ba1b (mpt3sas: Fix secure erase premature termination)
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reported-by: Ingo Molnar <mingo@kernel.org>
    Tested-by: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

We don't have the referenced commit above in 3.10 so we should be safe.
Additionally I checked that neither 4.4 nor 3.12 have them either, so
that makes me feel confident that we can skip it in 3.10 as well.

Thanks!
Willy
