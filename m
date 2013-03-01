From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 1 Mar 2013 09:27:00 -0600
Message-ID: <5130C8C4.3020501@tributary.com>
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>  <5130ACBE.8080300@interlog.com> <1362150419.2384.29.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:56170 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3CAP1M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 10:27:12 -0500
In-Reply-To: <1362150419.2384.29.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/1/2013 9:06 AM, James Bottomley wrote:

>> The results were "interesting", there are some really strange things that
>> happen in some of the LLD error paths. Its obvious that error injection
>> is not part of testing many of them, and what at first glance should be a
>> fairly straightforward error can create quite a mess. So anyone sending
>> any kind of reset (especially without the ESCALATE flag which tends to 
>> isolate the error handling) to the LLD's should be aware that behavior 
>> between them can vary significantly.
>> 
> So the patch does seem to have dangerous side effects.

	Those are due to "bugs" in the LLD's that actually are there regardless of
that patch. For example the lpfc patch I posted a couple days ago, fixes the
LPFC driver so that it actually checks the return status from the task
management IOCB's being sent to the firmware. As it stands the reset paths in
the lpfc driver always return SUCCESS independently of the status of any
aborts, resets, being sent as part of the reset handlers. This is completely
non obvious at first glance at the code.


	This means that the error handling behavior of lpfc is significantly
different (and not necessarily better) than the zfcp and qlogic drivers I also
tested.

	I didn't find any cases where this patch makes the problem worse, in fact in
general the behavior is significantly better.


	

	


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRMMjEAAoJEL5i86xrzcy7qrsH/3l0hz22pp/QJsZ2XJghpH/s
L8c1m5h9mTvSMFUtFIQoLkclHgJcVkTs7aeHLeEFxzZ5vEPPbuieLkr78s5Z3iVa
99LuuIMKSPZWpgohSVL0xsaaDftc4xVQ09MuuLWNeTxNZvKGRUalyVDLoPthSEwz
MXKNng6K1IqBe+u1mS+QhfAqNS5EVOI3gx34XIa0rm81jEKNeVpIF9qU0pCuJnNs
4QeYH+66hK+ILVyRyn+qsdjg8vT5xccaGw1DUbEzxz2QATKP0HOPG+dnlyzPkb4r
12UvBtHqT6+QRFeBe+sdgWRCwszaOOTjH18kMMUZaJJB3EaCV3dJsVESMO4K0GI=
=IueP
-----END PGP SIGNATURE-----
