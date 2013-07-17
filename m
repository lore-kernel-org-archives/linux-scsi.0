From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Wed, 17 Jul 2013 18:19:10 +0200
Message-ID: <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
 <20130522170305.GD9563@kernel.dk>
 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 16, 2013 at 02:38:03PM -0700, Nicholas A. Bellinger wrote:
> [    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
> [    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5
> 
> OK, so INQUIRY response payload is looking as expected here.

Yep. It is not on the top of my head, but I remember something like INQUIRYs
are emulated and thus do not have payload.

> [    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
> [    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
> [    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks
> 
> Strange..  READ_CAPACITY appears to be returning a payload as zeros..?

Yep. Because blk_execute_rq() does not put the proper callback and data do
not get copied from sg's to bounce buffer. That is why I tried to use
blk_mq_execute_rq() instead. Once I do that, data start getting read and
booting stops elsewhere.

Of course, I was suspecting that change alone is not valid and wondered
about the status of scsi-mq in the first place, and if more changes are
coming.

So I it turns out "req->errors + req->resid_len" issue (you described
earlier) needs to be addressed before going forward with libata (only?).

> Not sure why yet some control CDBs are getting back the expected
> payload, while others are returning zeros..

Bio buffers do not get updated from callback.

> Also, looking at the included stack back-trace:

[...]

Thanks a lot for these and other your comments, Nicholas!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
