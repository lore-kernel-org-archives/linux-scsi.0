From: Jens Axboe <axboe@suse.de>
Subject: Re: Max IO size
Date: Thu, 1 Aug 2002 10:45:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020801084547.GA12715@suse.de>
References: <20020801002238.88172.qmail@web14001.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020801002238.88172.qmail@web14001.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 31 2002, Mukul Kotwani wrote:
> Hello!
> Couple of other questions..forgot to ask in the
> previous email!
> 
> 1) When we do 512 byte sequential reads, the mid
> level( or someone else) seems to be combining the
> requests and sending them down as one big 60k+
> request. Can this combining of requests be disabled
> somehow?

not the mid layer, it's the block layer doing that for you. you can
limit the size of each i/o with the max_sectors part of the scsi host
template.

> 2) If we do 512k IOs, the mid layer seems to be
> breaking it up into 64 k chunks. The Scatter gather
> size is set to 240, so there is no reason for it to
> break it up. Is there something I am missing? Or is
> there a tunable I can set to increase the IO size sent
> down to the low level driver?

again, the mid layer does not do any combining or breaking up of i/o
requests. the block layer will assemble requests according to the rules
set for it, these rules you control with the host template settings.
these are things like max size, max segments, max segment size, etc.

> 3) What exactly does the max_sectors in the host
> structure do?

see above :-)

-- 
Jens Axboe

