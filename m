From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4 0/6] Avoid that scsi-mq and dm-mq queue processing
 stalls sporadically
Date: Wed, 12 Apr 2017 18:11:25 +0000
Message-ID: <1492020683.2764.9.camel@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
         <20170412105538.GB22576@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170412105538.GB22576@bblock-ThinkPad-W530>
Content-Language: en-US
Content-ID: <E88146B2A7FCEF45B3641CD1783FD8AC@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-12 at 12:55 +0200, Benjamin Block wrote:
> On Fri, Apr 07, 2017 at 11:16:48AM -0700, Bart Van Assche wrote:
> > The six patches in this patch series fix the queue lockup I reported
> > recently on the linux-block mailing list. Please consider these patches
> > for inclusion in the upstream kernel.
>=20
> just out of curiosity. Is this maybe related to similar stuff happening
> when CPUs are hot plugged - at least in that the stack gets stuck? Like
> in this thread here:
> https://www.mail-archive.com/linux-block@vger.kernel.org/msg06057.html
>=20
> Would be interesting, because we recently saw similar stuff happening.

Hello Benjamin,

My proposal is to repeat that test with Jens' for-next branch. If the issue
still occurs with that tree then please check the contents of
/sys/kernel/debug/block/*/mq/*/{dispatch,*/rq_list}. That will allow to
determine whether or not any block layer requests are still pending. If
running the command below resolves the deadlock then it means that a
trigger to run a block layer queue is still missing somewhere:

for a in /sys/kernel/debug/block/*/mq/state; do echo run >$a;=A0done

See also git://git.kernel.dk/linux-block.git.

Bart.=
