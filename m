From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Fri, 28 May 2004 11:18:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528091825.GA17960@devserv.devel.redhat.com>
References: <40B6F16B.6070909@cs.wisc.edu> <1085732140.2782.14.camel@laptop.fenrus.com> <40B70137.70106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56779 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266013AbUE1JSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 05:18:32 -0400
Content-Disposition: inline
In-Reply-To: <40B70137.70106@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 28, 2004 at 02:07:03AM -0700, Mike Christie wrote:
> I agree with you, and I do not have a good answer. When the system is 
> failing
> memory allocations it is difficult to do a lot of things. I was thinking 
> that
> in such an extreme situation that it would be acceptable for events to fail.
> Would it be better to have the API set a timer and retry at a later time? I 
> was
> thinking you could end up with a long backlog of events that may be 
> worthless
> by the time the system can allocate memory - which is why I put in the
> mempool (I know that they are not magic and will fail too though). I am open
> to ideas.

well what would suck is if userspace only sees a last "loop down"
event but then never sees the final "loop up".

The problem is that the memory allocation issue is more critical here than
in typical code, simply because on loop down you may not be able to do IO to
your swap device/filesystem to free memory.

Maybe we need to do a spare allocated event that is ONLY used for "eh the
queue overflowed, assume all state is lost, rediscover everything". That way
userland CAN know about the loss of state, and perform full
discovery/recovery.



--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAtwPhxULwo51rQBIRAuDWAJ97l5aQXThhViBI8oxWdXQbsamF4QCgjB/a
Pt18bB8mSmliDBExQgA92AE=
=1DqF
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
