From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 10:17:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027081713.GC32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:60316 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262501AbUJ0RC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 13:02:56 -0400
Content-Disposition: inline
In-Reply-To: <1098833278.4914.24.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-27T01:27:57, christophe varoqui <christophe.varoqui@free.fr>=
 wrote:

Hi christophe, let's see when I can flush this answer out of my e-mail
cache - German trains really need WLAN hotspots ;-)

> Some SAN hardware present for a same LUN a bunch of valid paths and  =
a
> bunch ghost paths. In my case, the ghosts responds to standard INQUIR=
Y
> (EVPD 0x83, 0x80, ...) but the READ_CAPACITY fails :

As a note, this is one mode the EMC CLARiiON arrays can also operate in=
=2E
Even worse, they won't present the block device at all, just the SCSI
generic mode. However, for the CLARiiONs, they can be configured to
behave sanely and reply to a READ_CAPACITY too (just all I/O will be
errored), if setting the failovermode to 1.

I wonder whether your system can also be configured as such?

> Now when I want to map a multipath target over those two paths, the
> device-mapper faithfully rejects saying /dev/sdw is too small for a
> 213338334 blocks devmap.
>=20
> So what is the correct way to treat this situation ?
>=20
> 1) make the /sys/block/*/size attribute writable
> 2) resurrect a BLKSETSIZE ioctl
> 3) make device-mapper less strict, and hope we can fix the size by a
> device rescan when it get activated
> 4) sell the culprit hardware

Personally I would opt for 4), but 3) is the likely path to solve this.

Using the new priority group initialization code (where we sent magic
commands down to activate the newly switched-to PG) which Alasdair and =
I
are currently doing for the CLARiiON pampering and which provides a
plugin-architecture to the dm-mpath system, you should be able to plug
in a hardware-specific handler for your system too.

However, "relaxing" this check should likely also be a property of the
hardware plugin loaded; I'd not wish to have it relaxed in all
scenarios.


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
