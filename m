From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 6/6] dm rq: Avoid that request processing stalls
 sporadically
Date: Tue, 11 Apr 2017 16:26:46 +0000
Message-ID: <1491928005.2654.6.camel@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
         <20170407181654.27836-7-bart.vanassche@sandisk.com>
         <20170411160958.GA19222@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170411160958.GA19222@redhat.com>
Content-Language: en-US
Content-ID: <3A541B615660094D9434EBEC4BE62014@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-11 at 12:09 -0400, Mike Snitzer wrote:
> This has no place in dm-mq (or any blk-mq
> driver).  If it is needed it should be elevated to blk-mq core to
> trigger blk_mq_delay_run_hw_queue() when BLK_MQ_RQ_QUEUE_BUSY is
> returned from blk_mq_ops' .queue_rq.

Hello Mike,

If the blk-mq core would have to figure out whether or not a queue is no
longer busy without any cooperation from the blk-mq driver all the blk-mq
core could do is to attempt to rerun that queue from time to time. But at
which intervals should the blk-mq core check whether or not a queue is stil=
l
busy? Would it be possible to choose intervals at which to check the queue
state that work well for all block drivers? Consider e.g. at the dm-mpath
driver. multipath_busy() returns true as long as path initialization is in
progress. Path initialization can take a long time. The (indirect) call to
blk_mq_run_queue() from pg_init_done() resumes request processing immediate=
ly
after path initialization has finished. Sorry but I don't think it is possi=
ble
to invent an algorithm for the blk-mq core that guarantees not only that a
queue is rerun as soon as it is no longer busy but also that avoids that
plenty of CPU cycles are wasted by the blk-mq core for checking whether a
queue is no longer busy.

Bart.=
