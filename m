From: Paul Wagland <paul@wagland.net>
Subject: Re: megaraid /proc under kernel 2.6.2
Date: Mon, 16 Feb 2004 01:18:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076890712.2943.276.camel@morsel.kungfoocoder.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uLJgzWV7NgpJzQ/EPF6e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.xs4all.nl ([194.109.24.12]:64007 "EHLO
	smtp-out2.xs4all.nl") by vger.kernel.org with ESMTP id S265258AbUBPASh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 19:18:37 -0500
In-Reply-To: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: hch@infradead.org


--=-uLJgzWV7NgpJzQ/EPF6e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi again, further information to add....

On Sun, 2004-02-15 at 23:41, Paul Wagland wrote:
> the board. So, I am assuming that mega_create_proc_entry() is called.
> The first thing that this does is to call (effectively)
> proc_mkdir("hba0", mega_proc_dir_entry); The only way that this can fail
> to create /proc/megaraid/hba0 (as far as I can see) is if
> mega_proc_dir_entry is null. The only way that it can be null, is if
> megaraid_probe_one() is called before megaraid_init(), since the
> megaraid directory is created.

After adding some printk's to figure out what was going on, I am
officially confused. I added this line:

printk(KERN_WARNING "megaraid: trying to proc_mkdir index:%d, parent:%p, pr=
ocdir:%s\n",index, parent, string);

to mega_create_proc_entry() which gives this response when booting the
kernel and loading the module:

megaraid: trying to proc_mkdir index:0, parent:00000000, procdir:hba0

Now, the problem is that this means that the following lines:

	controller_proc_dir_entry =3D
		adapter->controller_proc_dir_entry =3D proc_mkdir(string, parent);

	if(!controller_proc_dir_entry) {
		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
		return;
	}

should print a warning and return. Well, it may or may not be returning,
but the "proc_mkdir failed" never turns up. But, if you pass NULL into
proc_mkdir as the parent, then it will return NULL as a result, or at
least it will as far as I can tell.

So, why is that message not turning up?

I have not looked any further into the missing driver references
problem, hopefully someone else will know what that problem is :-)

Cheers,
Paul

--=-uLJgzWV7NgpJzQ/EPF6e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAMAxYtch0EvEFvxURAi1pAJ4hkI3PLrRNWL8VyzrWQ0faAYmSIACfQqXY
N8z4spbKRSieMze6aSgMRpI=
=wD+3
-----END PGP SIGNATURE-----

--=-uLJgzWV7NgpJzQ/EPF6e--

