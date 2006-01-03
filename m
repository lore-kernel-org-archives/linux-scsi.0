From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2.4 2/2] cpqfc: Reduce stack usage of 2 functions
Date: Tue, 3 Jan 2006 14:51:46 +0100
Message-ID: <200601031451.51852@bilbo.math.uni-mannheim.de>
References: <200601021244.40636@bilbo.math.uni-mannheim.de> <200601021305.38412@bilbo.math.uni-mannheim.de> <20060103102914.GA3760@dmt.cnet>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1704633.E9ltYaykrc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:65408 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751360AbWACNwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 08:52:04 -0500
In-Reply-To: <20060103102914.GA3760@dmt.cnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-scsi@vger.kernel.org

--nextPart1704633.E9ltYaykrc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Marcelo Tosatti wrote:
>On Mon, Jan 02, 2006 at 01:05:37PM +0100, Rolf Eike Beer wrote:
>> There are 2 function that do a lookup to the queue and buffer the result.
>> They only care about the first few bytes (to be exactly: 38*sizeof(u32)),
>> but they always pass a buffer of 2kB, which is located on the stack.
>>
>> This patch reduces this buffer to the really needed size and changes it's
>> type to the correct target type. The rest of the queue is still looked up
>> but the result is ignored (as it would anyway).
>>
>> There are also some small cleanups for the other arguments of
>> CpqTsGetSFQEntry(), which is the lookup function.

>Is there an evidence that the gratuitous stack usage is causing problems
> with an 8kB stack?
>
>In other ways, this looks more like an optimization than a serious bugfix?

I have no reports of this, but this proves nothing. But why waste one quart=
er=20
of the stack for nothing?

Eike

--nextPart1704633.E9ltYaykrc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDuoF3XKSJPmm5/E4RAurNAJoDt19miOcxo5YFHHTadDyEN4J+9gCfbBlJ
f0CmopCYUe5fqXe8fmzpNso=
=vC6e
-----END PGP SIGNATURE-----

--nextPart1704633.E9ltYaykrc--
