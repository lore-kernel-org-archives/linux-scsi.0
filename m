From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 15:46:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031144653.GE6549@suse.de>
References: <20021031131824.GA6549@suse.de> <20021031144103.103D286E73@primary.mx.nitric.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031144103.103D286E73@primary.mx.nitric.com>
List-Id: linux-scsi@vger.kernel.org
To: merlin <merlin@merlin.org>
Cc: Badari Pulavarty <badari@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Oct 31 2002, merlin wrote:
> r/axboe@suse.de/2002.10.31/14:18:24
> >On Wed, Oct 30 2002, merlin wrote:
> >> Hi Badari,
> >> 
> >> I grabbed 2.5.45 and added the printks you describe.. The kernel
> >> dies before the syslog is written and I don't have a serial device
> >> to try capturing the output there, but this is what I scribbled
> >> down:
> >> 
> >>   ...lots of stuff ...
> >>   home: clean
> >>   made a new seg: 1 (c18adc70, 4096, 0)
> >>   Loop: brvprv: c18adc70 bvec:c18ad838 offset:0 length:4096
> >>   made a new seg: 2 (c18ad838, 4096, 0)
> >>   returning segs: 2
> >>   Incorrect number of segments after building list
> >>   counted 2, received 1
> >>   ...some stuff...
> >> 
> >> Things went on for a few more messages before the kernel died
> >> a death.
> >> 
> >> It's an SMP box so the seg stuff that precedes the error may
> >> be unrelated; I don't have a good enough grasp to be sure. I
> >> guess an interesting value to know might be max_segment_size.
> >> 
> >> Half tempted to try a non-SMP build, just to see. Each time I
> >> do this, I get a bit more (recoverable) fs damage, but still..
> >
> >SMP should not make a difference. Does this patch make a difference?
> 
> Same error I'm afraid; ``Incorrect number of segments after building list
> counted 2, received 1'' follows shortly by kernel panic..

in drivers/scsi/aic7xxx/aic7xxx_linux_host.h:83, change
ENABLE_CLUSTERING to DISABLE_CLUSTERING and repeat the test, please.

-- 
Jens Axboe

