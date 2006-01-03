From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2.4 2/2] cpqfc: Reduce stack usage of 2 functions
Date: Tue, 3 Jan 2006 15:28:39 +0100
Message-ID: <200601031528.45529@bilbo.math.uni-mannheim.de>
References: <200601021244.40636@bilbo.math.uni-mannheim.de> <200601031451.51852@bilbo.math.uni-mannheim.de> <20060103115955.GA5288@dmt.cnet>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5508098.SGPMqCxv0P";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:54229 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751432AbWACO27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 09:28:59 -0500
In-Reply-To: <20060103115955.GA5288@dmt.cnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

--nextPart5508098.SGPMqCxv0P
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 3. Januar 2006 12:59 schrieben Sie:
>On Tue, Jan 03, 2006 at 02:51:46PM +0100, Rolf Eike Beer wrote:
>> Marcelo Tosatti wrote:
>> >On Mon, Jan 02, 2006 at 01:05:37PM +0100, Rolf Eike Beer wrote:
>> >> There are 2 function that do a lookup to the queue and buffer the
>> >> result. They only care about the first few bytes (to be exactly:
>> >> 38*sizeof(u32)), but they always pass a buffer of 2kB, which is locat=
ed
>> >> on the stack.
>> >>
>> >> This patch reduces this buffer to the really needed size and changes
>> >> it's type to the correct target type. The rest of the queue is still
>> >> looked up but the result is ignored (as it would anyway).
>> >>
>> >> There are also some small cleanups for the other arguments of
>> >> CpqTsGetSFQEntry(), which is the lookup function.
>> >
>> >Is there an evidence that the gratuitous stack usage is causing problems
>> > with an 8kB stack?
>> >
>> >In other ways, this looks more like an optimization than a serious
>> > bugfix?
>>
>> I have no reports of this, but this proves nothing. But why waste one
>> quarter of the stack for nothing?
>
>My point is that v2.4 is into deep maintenance mode, which means that only
>critical bug fixes get merged into the tree.

Doesn't "ugly like hell" count as critical? *g*

>I'm not against the patch per se.

I've looked on it. Both of the functions with the 2k+ stack usage are calle=
d=20
from interrupt handler, one directly and one from the other. The stack usag=
e=20
at this point is little above 4k plus everything that is needed to call the=
=20
interrupt handler. I don't know if this must be considered harmful.

Eike

--nextPart5508098.SGPMqCxv0P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDuoodXKSJPmm5/E4RAvs+AKCVyL+WOELMtY7f/everbjQAEu0HACeKvcg
Z8D8nqrZDE7qKnCzZS6Ztp8=
=nO1U
-----END PGP SIGNATURE-----

--nextPart5508098.SGPMqCxv0P--
