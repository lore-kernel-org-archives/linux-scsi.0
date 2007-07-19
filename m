From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Thu, 19 Jul 2007 02:17:52 -0700
Message-ID: <20070719021752.35cb7daa.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.529280000@pademelon.sonytel.be>
	<20070718164351.a92ec032.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
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
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 19 Jul 2007 11:02:07 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Wed, 18 Jul 2007, Andrew Morton wrote:
> > > +struct ps3rom_private {
> > > +	struct ps3_storage_device *dev;
> > > +	struct scsi_cmnd *curr_cmd;
> > > +};
> > > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > > +
> > 
> > Someone should invent a keyboard which delivers an electric shock when the
> > operator types "#define".   In the meanwhile, I get to do the honours.
> > 
> > Please don't implement in a macro anything which can be implemented in C.
> 
> All I needed was a shorthand to access driver_data, for both read and write
> access (you cannot do the latter with C, unless you decouple read and write).

Oh dear.

	ps3rom_priv(dev) = host;

that's 'orrid.  We have an identifier pretending to be a function, only we
go and treat it as an lvalue.

I mean, C code should look like C code, and the above just doesn't.

Sigh.
