From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Wed, 13 Feb 2013 13:52:43 -0600
Message-ID: <511BEF0B.4020302@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:14435 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759965Ab3BMTwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 14:52:51 -0500
In-Reply-To: <1360767971-947-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/13/2013 9:06 AM, Hannes Reinecke wrote:
> So add a new flag 'support_64bit_luns' to the scsi host and modify report
> lun scan to not check for max_luns during scanning if that flag is set.
> This will get rid of the

	Along these lines, I don't think the scsilun_to_int() and int_to_scsilun()
routines are correct for > 2^14  luns. SAM  4.6 defines bits 6,7 of byte zero
in the LU representation format as the address method. Which when set to 00b
limits it to 256 luns but the overflow into the bus ID probably works for some
devices.

	Those routines should probably select/detect an alternative address method
for luns > 256.

	Or am I missing something?







	




	
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRG+8LAAoJEL5i86xrzcy7SL4H/0vZvSuIVH+6yeN62XkKVzok
HBP9Wg9spmOX8ANgJp3KZnOuHSLpVXZTvRRbWpI57sX3UJRZ55nOeA8g75s1hWSp
yOrTQZZodD6/uA6QOdVQgqRCrpZ/jKuARHHlZzULnDRV4/eSrLCpU6CRHFviHxLE
SkgAAJtQwXMRn3PM8QuzzdJ68tIvVZTW/8r795wV0NxI+AlCM51s/PoPWZxq5tNK
tiYbTcRHdh14N4jC6or/hT1r8VdkWEKLhSMLRBVu1wmVIxrdFtoyOqR4CEGwq2vt
HaL9L8Te4bmmxN20/Bu593KUymMMndvFDm9OGEuZzcjXdEJp3pauXO8fyhwJrFw=
=E2w/
-----END PGP SIGNATURE-----
