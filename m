From: valdis.kletnieks@vt.edu
Subject: Re: [PATCH] scsi: eata: drop VLA in reorder()
Date: Mon, 12 Mar 2018 02:36:38 -0400
Message-ID: <134937.1520836598@turing-police.cc.vt.edu>
References: <1520802418-17284-1-git-send-email-s.mesoraca16@gmail.com>
 <20180312030834.GC8631@eros>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1520836598_3502P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-12418-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Valdis Kletnieks <valdis@vt.edu>
In-Reply-To: <20180312030834.GC8631@eros>
To: "Tobin C. Harding" <tobin@apporbit.com>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dario Ballabio <ballabio_dario@emc.com>, Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, kernelnewbies@kernelnewbies.org
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1520836598_3502P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Mar 2018 14:08:34 +1100, "Tobin C. Harding" said:

> removal patch that 768 was a lot of stack space.  That comment did,
> however say 'deep in some transfer call chain'.  I don't know what a
> 'transfer call chain' (the transfer bit) is but is there some heuristic
> we can use to know how deep is deep?  Or more to the point, is there some
> heuristic we can use to know what is an acceptable amount of stack space
> to use?

The canonical "why we put kernel stacks on a diet" configuration:

Imagine a bunch of ISCSI targets - with IPSec wrapping the connection.
Arranged into a software RAID5. With LVM. With encryption on the LV.  With XFS
on the encrypted LV.  And then the in-kernel sharing it out over NFS. With
more IPSec wrapping the  NFS TCP connection.

Oh, and I/O interrupts, just for fun.  And most of all of that has to fit their *entire*
stack chain into 2 4K pages.  Suddenly, that 768 bytes is taking close to 10% of
*all* of the stack that all of that call chain has to share.

And I see that patch is against scsi/eata.c - which means it can plausibly end up
sharing that stack scenario above starting at 'software raid5'.

(For bonus points, the alert reader is invited to figure out which stack each of the
above actually ends up on.  No, it isn't split across enough stacks that taking
768 bytes out of any of them is acceptable.. :)

--==_Exmh_1520836598_3502P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWqYf9o0DS38y7CIcAQLwGwgAsbjEunB2hZFHsWdo75SIaBMf5iCRpt18
8TZdZJwgBLqT/6mndzwmwc4DynfPCoxsE+fNsfTcTumGNiqWiBVPKM9YQhCvkdu4
Iygpn6H23C6pgSzExzwNuGGstGyVh9fLsiLBiU07aFQA0ReINi9XZGZscrrDbO2T
cr4XIuJ0onTJX7367zOGBDNrFVfpO9ZJby7Zjy/1FL6XPg7IV6lUz4ciYAK2tcbv
0gb6AQdDSyz3BJcEorYoLc1wmdEBAiJ/UjGYL8c6V4O7jazhNl0pMn2HWuhupqKE
HhlMt5TyCpt6fHYgSQqiNPidq5fvmqWut4bKY3EZwRf8YKUMHgNeAQ==
=jNqk
-----END PGP SIGNATURE-----

--==_Exmh_1520836598_3502P--
