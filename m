From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <fischer@linux-buechse.de>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before set
Date: Sun, 19 Feb 2006 00:31:51 +0100
Message-ID: <20060218233151.GA1985@linux-buechse.de>
References: <200602180209.k1I29meW030162@fire-2.osdl.org> <20060217211049.4368ff20.akpm@osdl.org> <20060218221039.GA3912@linux-buechse.de> <20060218141423.7d741859.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:13510 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S932282AbWBRXdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 18:33:02 -0500
Content-Disposition: inline
In-Reply-To: <20060218141423.7d741859.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

Hi Andrew,

On Sat, Feb 18, 2006 at 14:14:23 -0800, Andrew Morton wrote:
> >  Fix below.
=20
> Thanks.
=20
> Could we please have a more complete description of this change?  It'=
s
> obviosly doing more than fixing a used-uninitialised bug..

After fixing the problem in question, I discoved that the driver still
didn't work with the pcmcia card I picked up.  run/is_complete was
sometimes not called at all or called multiple times on one interrupt.

I'm not really sure why (or why that worked before).  It's now ensured
that run() is only added to the task queue once per interrupt (by
protecting 'service' with spinlocks).

Additionally interrupt sharing didn't seem to work as the interrupt
handler didn't check if a interrupt condition was at all pending.


In short:
- change interface of the reset functions from Scsi_Cmnd to Scsi_Host. =
=20
- add functions with the original interface and rename the new
  functions to reflect the new interface.
- call these from the pcmcia driver, thereby avoiding the need to
  construct a (broken) Scsi_Cmnd from a Scsi_Host.
- just run the bh if the interrupt is from the controller and if so
  ensure that it's only called once per interrupt.


J=FCrgen
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
