From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Thu, 28 Oct 2004 13:35:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041028113550.GS32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:56788 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S261948AbUJ1Ryg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2004 13:54:36 -0400
Content-Disposition: inline
In-Reply-To: <1098903759.12464.32.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-27T21:02:39, christophe varoqui <christophe.varoqui@free.fr>=
 wrote:

> > As a note, this is one mode the EMC CLARiiON arrays can also operat=
e in.
> > Even worse, they won't present the block device at all, just the SC=
SI
> > generic mode. However, for the CLARiiONs, they can be configured to
> > behave sanely and reply to a READ_CAPACITY too (just all I/O will b=
e
> > errored), if setting the failovermode to 1.
> >=20
> > I wonder whether your system can also be configured as such?
> Yes it could, but it's a controler wide setting.

Not per LUN? Too bad.

> Compatibility with other OS sharing the same controlers might impose
> this mode though. So I'd like to straight this situation up.

Then I think hardware-specific hooks in the dm-mpath are the way to go.
We already have them in place for the priority group initialization cod=
e
anyway, we can add them for anything else which needs them, like this
one.

> I wonder if it's not simpler just to remove the NOSTARTONADD flag on
> this devices in scsi_devinfo.c. I tested that and all the READ CAPACI=
TY
> succeed as expected (DEC HSG80 / COMPAQ HSV*).

As James points out, this won't be quite the thing to do.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
