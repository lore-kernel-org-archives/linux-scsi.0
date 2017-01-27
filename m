From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
 V2
Date: Fri, 27 Jan 2017 01:15:58 +0000
Message-ID: <1485479738.2540.30.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
	<e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
	<1485474426.2540.25.camel@sandisk.com>
	<b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
	<1485477510.2540.27.camel@sandisk.com>
	<2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
Content-Language: en-US
Content-ID: <67826E1AA107DF458B3E91348A0CE3FC@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-01-26 at 17:41 -0700, Jens Axboe wrote:
> On 01/26/2017 05:38 PM, Bart Van Assche wrote:
> > I see similar behavior with the blk-mq-sched branch of
> > git://git.kernel.dk/linux-block.git (git commit ID 0efe27068ecf):
> > booting happens much slower than usual and I/O hangs if I run the
> > srp-test software.
> 
> Please don't run that, run for-4.11/block and merge it to master.
> Same behavior?

I have not yet had the chance to run the srp-test software against that
kernel. But I already see that booting takes more than ten times longer
than usual. Note: as far as I know the dm-mpath driver is not involved
in the boot process of my test system.

> > Regarding creating a similar dm setup: I hope that in the future it
> > will become possible to run the srp-test software without any special
> > hardware and with in-tree drivers. Today running the srp-test software
> > with in-tree drivers namely requires IB hardware. This is how to run the
> > srp-test software today with in-tree drivers:
> > * Find a system with at least two InfiniBand ports.
> > * Make sure that the appropriate IB driver in the kernel is enabled and
> >   also that LIO (CONFIG_TARGET_CORE=m and CONFIG_TCM_FILEIO=m), ib_srp,
> >   ib_srpt and dm-mpath are built as kernel modules.
> > * If none of the IB ports are connected to an IB switch, connect the
> >   two ports to each other and configure and start the opensm software
> >   such that the port states change from "Initializing" to "Active".
> > * Check with "ibstat | grep State: Active" that at least one port is
> >   in the active state.
> > * Configure multipathd as explained in
> >   https://github.com/bvanassche/srp-test/blob/master/README.md.
> > * Restart multipathd to make sure it picks up /etc/multipath.conf.
> > * Clone https://github.com/bvanassche/srp-test and start it as follows:
> >   srp-test/run_tests -t 02-mq
> 
> I can't run that. Any chance of a test case that doesn't require IB?

It is possible to run that test on top of the SoftRoCE driver. I will first
check myself whether the latest version of the SoftRoCE driver is stable
enough to run srp-test on top of it (see also
https://github.com/dledford/linux/commits/k.o/for-4.11).

Bart.
