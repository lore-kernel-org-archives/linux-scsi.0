From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Delete trailing full stop
Date: Fri, 18 Nov 2005 06:20:48 -0700
Message-ID: <20051118132048.GI17171@parisc-linux.org>
References: <20051117181343.GD17171@parisc-linux.org> <437D77C2.3000908@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49040 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750892AbVKRNUt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 08:20:49 -0500
Content-Disposition: inline
In-Reply-To: <437D77C2.3000908@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 18, 2005 at 04:42:10PM +1000, Douglas Gilbert wrote:
> Matthew Wilcox wrote:
> > None of the other domain validation messages have a trailing full stop,
> > so I don't see why this one should.
> 
> Speaking of domain validation messages I have noticed
> that either the sym53c8xx driver or scsi_transport_spi is
> getting noisier in this area.

Definitely the sym2 driver's fault.

>  target0:0:3: Beginning Domain Validation
>  target0:0:3: asynchronous.
>  target0:0:3: wide asynchronous.
>  target0:0:3: Domain Validation skipping write tests
>  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>  target0:0:3: Ending Domain Validation
>  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>  last message repeated 2 times
> sdb: Spinning up disk....<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>  last message repeated 7 times
(etc)
> 
> Surely one "FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)"
> message is sufficient?

Absolutely.  Let's see why it's happening.  That message is displayed by
spi_display_xfer_agreement() which is called from three places in sym2.
However, because DT is set, it must be called from sym_setpprot() [1].
That's only called in a way which would cause this message from
sym_ppr_nego_check(), which is only called from sym_ppr_nego(), which is 
only called when receiving a PPR message.

Now, what I don't know is why the device keeps sending us a PPR message.
Do we keep sending it a PPR message?  Can you turn on negotiation
debugging (echo setdebug nego >/proc/scsi/sym53c8xx/0) and send me the
results?

[1] SDTR and WDTR clear DT.  So it must be in response to a PPR message.
