From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 09:08:23 -0600
Message-ID: <52EFB0E7.3000504@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:4023 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaBCPIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 10:08:25 -0500
In-Reply-To: <52EFB06C.8010101@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, =?windows-1252?Q?=22Kai_M=E4kisara_?= =?windows-1252?Q?=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/3/2014 9:06 AM, Hannes Reinecke wrote:

> That's due to udev. Udev is getting events for each device it should create
> a device node for. So for 'st' it'll get a series of events for 'stX', and
> another series of events for 'nstX'. Udev will treat each of these events
> separately, with distinct worker programs handling them. Each of those
> workers run fully asynchronous and cannot access information from other
> workers.

	So whats wrong with the simple solution? You throw the ones for st away, and
create the st handles from the nst worker.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS77DnAAoJEL5i86xrzcy7j+cH/24oncr+DN1yZ4ReXk3i8QHx
LpI83UgP9EAvvcHJb5Op3IQtojccda1rYmecMS8qLYV0IX33lJg6UXbhkNS/skkR
gFbPdsD/27JqJZvCU02U+ET0zfO5XH833UCRKOsqoA/GMeikLAaUKPV5t65eyCHh
Qy4CYr4Gve9AxMhV9n00IdadOL5NoH/aO+Qb916zeJ2dUng5TUDqQ3WzdlQQdhD5
ObReHBnTBXlsWQdZL2VakP6gEX2ijiZ09GOIeSf1rKz/974OAudmzLsVjF4BwqTA
5JzqQXezYO2CZ8zkiuCCuiuXEwjv3f62rCuqzi5lQByFGDpvJNMZDAU9GjTn9Z8=
=ELYk
-----END PGP SIGNATURE-----
