From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 10:42:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027084202.GD32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:61340 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262548AbUJ0RC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 13:02:56 -0400
Content-Disposition: inline
In-Reply-To: <20041027081713.GC32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-27T10:17:13, Lars Marowsky-Bree <lmb@suse.de> wrote:

> Using the new priority group initialization code (where we sent magic
> commands down to activate the newly switched-to PG) which Alasdair an=
d I
> are currently doing for the CLARiiON pampering and which provides a
> plugin-architecture to the dm-mpath system, you should be able to plu=
g
> in a hardware-specific handler for your system too.
>=20
> However, "relaxing" this check should likely also be a property of th=
e
> hardware plugin loaded; I'd not wish to have it relaxed in all
> scenarios.

-> have the hardware-specific plugin export a path_init() function whic=
h
is called the first time a path is added to the table (or even on
reinstate?).

In addition verifying the size and stuff it could also check that the
paths really (still) point to the same device (by storing the LUN WWN i=
n
the hw_handler context, for example), or that the path is setup
correctly for failover to work etc (of course, the list of things to
verify is a hw-specific issue). Paranoia is a good thing.


Mit freundlichen Gr=FC=DFen,
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
