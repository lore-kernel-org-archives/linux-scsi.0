From: Kipp Aldrich <kippa@tributary.com>
Subject: Re: Error handling on FC devices
Date: Tue, 4 Dec 2012 09:56:55 -0600
Message-ID: <50BE1D47.5020903@tributary.com>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de> <50B78715.2060109@emulex.com> <50B89C2D.8030108@suse.de> <50B8E4AC.8@cs.wisc.edu> <50BC517E.4090208@suse.de> <94D0CD8314A33A4D9D801C0FE68B40294CD03A65@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:46736 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2LDQCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 11:02:08 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294CD03A65@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/03/2012 04:52 PM, Elliott, Robert (Server Storage) wrote:
> 
>> Well, looking at QLogic and Emulex both emulate a bus reset with a
>> loop over each target and invoke a target reset there.
>> I somewhat fail to see the rationale behind it, other than emulating
>> the bus reset behaviour on SPI.
>> Given that the original target reset already failed (otherwise we
>> wouldn't be doing a bus reset), I doubt a _second_ target reset
>> will lead to a different result.
>>
>> So invoking REMOVE I_T NEXUS here can only improve matters :-)
>>
>> I'm all for renaming bus_reset, though :-)
>>
> 
> Since modern storage fabrics don't really have a "bus" to reset any more, a bolder approach of getting rid of bus_reset might be warranted.
> 

This is exactly what we do now. We modify drivers to disable bus_resets. It is dangerous, and disruptive, to reliable data storage,
especially on SANs. At least make it optional to enable it, disable it by default. Bus resets can destroy or lose customer data, for
goodness sake. Any commercial vendor using linux with these drivers that doesn't disable bus resets is risking their customer's data.

Really, how early '80s to have bus_reset. Time to move on.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAlC+HUcACgkQeGqeAAwqIi147wCcDHEMmyr9m+umifJAbEDGns04
B4gAniGcrjM110cbX9/Ki/3e+jZO4d1o
=IRk4
-----END PGP SIGNATURE-----
