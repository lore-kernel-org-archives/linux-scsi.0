From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bugme-new] [Bug 6092] New:
	drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before
	set
Date: Sun, 19 Feb 2006 08:27:17 -0600
Message-ID: <1140359237.3103.9.camel@mulgrave.il.steeleye.com>
References: <200602180209.k1I29meW030162@fire-2.osdl.org>
	 <20060217211049.4368ff20.akpm@osdl.org>
	 <20060218221039.GA3912@linux-buechse.de>
	 <20060218141423.7d741859.akpm@osdl.org>
	 <20060218233151.GA1985@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31131 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932564AbWBSO1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 09:27:22 -0500
In-Reply-To: <20060218233151.GA1985@linux-buechse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "=?ISO-8859-1?Q?J=FCrgen?= E. Fischer" <fischer@linux-buechse.de>
Cc: Andrew Morton <akpm@osdl.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2006-02-19 at 00:31 +0100, J=C3=BCrgen E. Fischer wrote:
> - just run the bh if the interrupt is from the controller and if so
>   ensure that it's only called once per interrupt.

This is the bit that looks like the actual fix.  It basically uses
service as a flag to debounce the interrupt.

This:

>         HOSTDATA(shpnt)->in_intr++;
> =20
> +       if( HOSTDATA(shpnt)->service=3D=3D0 )  {
> +               DO_UNLOCK(flags);
> +               return;
> +       }

Looks a bit wrong.  If that ever triggered, you'd exit your task handle=
r
with in_intr raised, which would cause a panic the next time
is_complete() was called.

The driver still seems to have an awful lot of locking confusion betwee=
n
the host lock and its own internal lock (stored in the host structure).
I think there are several races and other nasties that could be cleaned
up simply by moving to using the host lock everywhere.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
