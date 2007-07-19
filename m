From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Thu, 19 Jul 2007 02:10:45 -0700
Message-ID: <20070719021045.c0b994ca.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 19 Jul 2007 10:57:53 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> 	Hi Andrew,
> 
> On Wed, 18 Jul 2007, Andrew Morton wrote:
> > On Mon, 16 Jul 2007 18:15:40 +0200
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > 
> > > Add a Disk Storage Driver for the PS3:
> > 
> > Your patchset significantly hits powerpc, scsi and block.  So who gets to
> > merge this?  Jens?  James?  Paul?
> > 
> > Me, I guess ;)
> 
> As Paul is on holidays, please take it.

OK.

> The PS3 storage driver core support is
> already in mainline, but the actual drivers aren't, as Paul was waiting for
> acks from the maintainers.
> 
> BTW, do you prefer incremental patches for the comments below, or an update of
> the full patchset?

Incremental is preferred, but I convert replacement patches into
incremental patches at about 10Hz nowadays.  Whatever's easier.

(Actually, if it's a replacement patch then only I get to see the
incremental patch, and the incremental patch is more reviewer-friendly).

> I didn't have much choice, as most of it was static and I don't need the full
> libata core anyway.
> 
> If I would factor it out, any good suggestion where to put the factored out
> code?

Take it up with Jeff, please.  If you're keen.  It isn't a lot of code.

> 
> > > +static int ps3disk_remove(struct ps3_system_bus_device *_dev)
> > > +{
> > > +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> > > +	struct ps3disk_private *priv = ps3disk_priv(dev);
> > > +
> > > +	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
> > > +		    &ps3disk_mask);
> > 
> > I see no locking here which makes this __clear_bit and the above __set_bit
> > non-racy?
> 
> Were .probe()/.remove() made concurrent again? I thought that idea was dropped
> because it caused too many problems?

I don't _think_ there's any global exclusion on ->probe calls.  For a
particular driver instance it's hard to see how these thigns can run
concurrently, dunno.  I guess two hotunplugs coud happen concurrently.
