From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency	problem
Date: Tue, 13 Dec 2005 17:39:38 -0800
Message-ID: <20051214013938.GB185272@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <439E0112.1030801@sgi.com> <439ECB2E.7070103@sgi.com> <1134485413.3356.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:53452 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030349AbVLNBjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 20:39:46 -0500
Content-Disposition: inline
In-Reply-To: <1134485413.3356.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Tue, Dec 13, 2005 at 08:50:13AM -0600, James Bottomley wrote:
> On Tue, 2005-12-13 at 07:22 -0600, Michael Reed wrote:
> > I believe the biggest issue with VISWS is that it appears to need
> > mmiowb() and we likely don't know how to implement it.  Hence, for
> > that platform, it would make sense to replace the mmiowb() with a
> > posting read.
> 
> Well, there's an easy way to tell ... the reason for the mmiowb in the
> qla1280 driver is supposed to be an SMP race, according to the
> description, so if it fails on UP as well there's something else going
> on here ...

The 320 was available with two CPUs, and though the post doesn't say
what this particular one had, it likely had two.  The original post
also indicated a problem with a two-cpu motherboard, though I don't
think that was the 320 (VisWS).

> I'm still suspicious because the mmiowb() in this driver replaced a
> posted write flush instruction, which altered the behaviour of the
> driver.  The qla1280 is just rare enough that it might have taken this
> long to notice ...

The 12160 is in most Altix machines and behaves just like a 1280.
If there were a problem with it in this context, we'd know about it.

I'm still betting on the old problem (time moves downward):

	cpu A	lock
		posted pio write X
		unlock
	cpu B	lock
		posted pio write Y
		unlock
	PCI bus retire pio write Y
		retire pio write X

The Qlogic architecture doesn't like this.

jeremy
