From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Sat, 14 Jul 2007 09:06:10 +1000
Message-ID: <1184367971.6059.268.camel@localhost.localdomain>
References: <20070704132212.726923000@pademelon.sonytel.be>
	<20070704132346.591348000@pademelon.sonytel.be>
	<1184331741.3402.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <1184331741.3402.13.camel@localhost.localdomain>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-07-13 at 09:02 -0400, James Bottomley wrote:
> On Wed, 2007-07-04 at 15:22 +0200, Geert Uytterhoeven wrote:
> > +                       kaddr = kmap_atomic(sgpnt->page, KM_USER0);
> > +                       if (!kaddr)
> > +                               return -1;
> > +                       len = sgpnt->length;
> > +                       if ((req_len + len) > buflen) {
> > +                               active = 0;
> > +                               len = buflen - req_len;
> > +                       }
> > +                       memcpy(kaddr + sgpnt->offset, buf + req_len,
> > len);
> > +                       kunmap_atomic(kaddr, KM_USER0);
> 
> This isn't a SCSI objection, but this sequence appears several times in
> this driver.  It's wrong for a non-PIPT architecture (and I believe the
> PS3 is VIPT) because you copy into the kernel alias for the page, which
> dirties the line in the cache of that alias (the user alias cache line
> was already invalidated).  However, unless you flush the kernel alias to
> main memory, the user could read stale data.  The way this is supposed
> to be done is to do a 

Nah, we have no cache aliasing on ppc, at least not that matter here and
not on cell.

Ben.
