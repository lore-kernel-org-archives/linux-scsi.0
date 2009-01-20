From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Tue, 20 Jan 2009 07:45:33 -0500
Message-ID: <4975C76D.9020208@novell.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>	 <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com>	 <20090114163557.11e097f2.akpm@linux-foundation.org>	 <20090115012147.GW29283@parisc-linux.org>	 <20090114180431.f4a96543.akpm@linux-foundation.org>	 <1232028766.5966.10.camel@localhost.localdomain>	 <20090115094442.b6394544.akpm@linux-foundation.org>	 <20090115180052.GG29283@parisc-linux.org> <1232043287.21980.65.camel@localhost.localdomain> <496F8421.3070703@novell.com> <CAC4B8726E86A142B27A9E9A2F2F12479D4403CE@rrsmsx505.amr.corp.intel.com> <BC02C49EEB98354DBA7F5DD76F2A9E8003175EB45B@azsmsx501.amr.corp.intel.com> <4970CE79.1080002@novell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1D8037201D5825D038EA98D2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44724 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZATMmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 07:42:39 -0500
In-Reply-To: <4970CE79.1080002@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Steven Rostedt <srostedt@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "Kleen, Andi" <andi.kleen@intel.com>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>, "Chilukuri, Harita" <harita.chilukuri@intel.com>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "Wang, Peter Xihong" <peter.xihong.wang@intel.com>, "Nueckel, Hubert" <hubert.nueckel@intel.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1D8037201D5825D038EA98D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
>
> Then, email the contents of /sys/kernel/debug/tracing/trace to me
>
>
>  =20

[ Chinang has performed the trace as requested, but replied with a
reduced CC to avoid spamming people with a large file.  This is
restoring the original list]


Ma, Chinang wrote:
> Hi Gregory,
> Trace in attachment. I trim down the distribution list. As the attachme=
nt is quite big.
>
> Thanks,
> -Chinang
>  =20
Hi Chinang,

  Thank you very much for taking the time to do this.  I have analyzed
the trace: I do not see any smoking gun w.r.t. the theory that we are
over IPI'ing the system.  There were holes in the data due to trace
limitations that rendered some of the data inconclusive.  However, the
places where we did not run into trace limitations looked like
everything was functioning as designed.

That being said, I do see that you have a ton of prio 48(ish) threads
that are over-straining the RT push logic.  The interesting thing here
is I recently pushed some patches to tip that have potential to help you
here.  Could you try your test using the sched/rt branch from -tip?=20
Here is a clone link, for your convenience:

git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git sched=
/rt

For this run, do _not_ use the trace patch/config.  I just want to see
if you observe performance improvements with OLTP configured for RT prio
when compared to historic rt-push/pull based kernels (including HEAD on
linus.git, as tested in the last run)

Thanks!
-Greg



--------------enig1D8037201D5825D038EA98D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl1x20ACgkQlOSOBdgZUxl9DgCeMOkzM1OfIV5ALA2L9PvO05Gz
G9AAn3CuAYh1/BNgv/fYwgwNa/O4nOEt
=I2KJ
-----END PGP SIGNATURE-----

--------------enig1D8037201D5825D038EA98D2--
