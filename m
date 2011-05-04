From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to ensure commands don't get lost.
Date: Wed, 04 May 2011 13:28:21 -0400
Message-ID: <10639.1304530101@localhost>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com>
            <20110504125212.GC5997@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304530101_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 04 May 2011 07:52:12 CDT."
             <20110504125212.GC5997@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Tomas Henzl <thenzl@redhat.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1304530101_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 07:52:12 CDT, scameron@beardog.cce.hp.com said:
> On Wed, May 04, 2011 at 01:15:50PM +0200, Tomas Henzl wrote:
> > On 05/03/2011 09:58 PM, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

> > >  	dev_dbg(&h->pdev->dev, "Sending %x, tag = %x\n", c->busaddr,
> > >  		c->Header.Tag.lower);
> > >  	writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
> > > +	(void) readl(h->vaddr + SA5_REQUEST_PORT_OFFSET);

> I just put it there to make it clear that it ignoring the return of readl is 
> done intentionally, not accidentally.  If this goes against some coding convention,
> whatever, I'm not super attached to the (void), but I did put it there on purpose,
> and would have done it in cciss as well, had I thought of it at the time.

This probably needs a comment like
	/* don't care - dummy read just to force write posting to chipset */
or similar.  I'm assuming it's just functioning as a barrier-type flush of some sort?




--==_Exmh_1304530101_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwYy1cC3lWbTT17ARAtBTAJ99nLBal+gVKChT+db9zUyukiTruQCePk/d
zfMU7pRV2aHY12MlQIiuoL8=
=qqQi
-----END PGP SIGNATURE-----

--==_Exmh_1304530101_7352P--
